//
//  KNAnimatedImage.m
//  KNPhotoBrowser
//
//  Created by LuKane on 2020/3/12.
//  Copyright © 2020 LuKane. All rights reserved.
//  copy it with FLAnimatedImage

#import "KNAnimatedImage.h"
#import "KNPhotoBrowserProxy.h"

#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>

#ifndef BYTE_SIZE
    #define BYTE_SIZE 8 // byte size in bits
#endif

#define MEGABYTE (1024 * 1024)

const NSTimeInterval kKNAnimatedImageDelayTimeIntervalMinimum = 0.02;


typedef NS_ENUM(NSUInteger, KNAnimatedImageDataSizeCategory) {
    KNAnimatedImageDataSizeCategoryAll = 10,       // All frames permanently in memory (be nice to the CPU)
    KNAnimatedImageDataSizeCategoryDefault = 75,   // A frame cache of default size in memory (usually real-time performance and keeping low memory profile)
    KNAnimatedImageDataSizeCategoryOnDemand = 250, // Only keep one frame at the time in memory (easier on memory, slowest performance)
    KNAnimatedImageDataSizeCategoryUnsupported     // Even for one frame too large, computer says no.
};

typedef NS_ENUM(NSUInteger, KNAnimatedImageFrameCacheSize) {
    KNAnimatedImageFrameCacheSizeNoLimit = 0,                // 0 means no specific limit
    KNAnimatedImageFrameCacheSizeLowMemory = 1,              // The minimum frame cache size; this will produce frames on-demand.
    KNAnimatedImageFrameCacheSizeGrowAfterMemoryWarning = 2, // If we can produce the frames faster than we consume, one frame ahead will already result in a stutter-free playback.
    KNAnimatedImageFrameCacheSizeDefault = 5                 // Build up a comfy buffer window to cope with CPU hiccups etc.
};

@interface KNAnimatedImage()

@property (nonatomic, assign, readonly) NSUInteger frameCacheSizeOptimal; // The optimal number of frames to cache based on image size & number of frames; never changes
@property (nonatomic, assign, readonly, getter=isPredrawingEnabled) BOOL predrawingEnabled; // Enables predrawing of images to improve performance.
@property (nonatomic, assign) NSUInteger frameCacheSizeMaxInternal; // Allow to cap the cache size e.g. when memory warnings occur; 0 means no specific limit (default)
@property (nonatomic, assign) NSUInteger requestedFrameIndex; // Most recently requested frame index
@property (nonatomic, assign, readonly) NSUInteger posterImageFrameIndex; // Index of non-purgable poster image; never changes
@property (nonatomic, strong, readonly) NSMutableDictionary *cachedFramesForIndexes;
@property (nonatomic, strong, readonly) NSMutableIndexSet *cachedFrameIndexes; // Indexes of cached frames
@property (nonatomic, strong, readonly) NSMutableIndexSet *requestedFrameIndexes; // Indexes of frames that are currently produced in the background
@property (nonatomic, strong, readonly) NSIndexSet *allFramesIndexSet; // Default index set with the full range of indexes; never changes
@property (nonatomic, assign) NSUInteger memoryWarningCount;
@property (nonatomic, strong, readonly) dispatch_queue_t serialQueue;
@property (nonatomic, strong, readonly) __attribute__((NSObject)) CGImageSourceRef imageSource;

// The weak proxy is used to break retain cycles with delayed actions from memory warnings.
// We are lying about the actual type here to gain static type checking and eliminate casts.
// The actual type of the object is `FLWeakProxy`.
@property (nonatomic, strong, readonly) KNAnimatedImage *weakProxy;

@end

static NSHashTable *allAnimatedImagesWeak;

@implementation KNAnimatedImage

#pragma mark - Accessors
#pragma mark Public

// This is the definite value the frame cache needs to size itself to.
- (NSUInteger)frameCacheSizeCurrent
{
    NSUInteger frameCacheSizeCurrent = self.frameCacheSizeOptimal;
    
    // If set, respect the caps.
    if (self.frameCacheSizeMax > KNAnimatedImageFrameCacheSizeNoLimit) {
        frameCacheSizeCurrent = MIN(frameCacheSizeCurrent, self.frameCacheSizeMax);
    }
    
    if (self.frameCacheSizeMaxInternal > KNAnimatedImageFrameCacheSizeNoLimit) {
        frameCacheSizeCurrent = MIN(frameCacheSizeCurrent, self.frameCacheSizeMaxInternal);
    }
    
    return frameCacheSizeCurrent;
}


- (void)setFrameCacheSizeMax:(NSUInteger)frameCacheSizeMax
{
    if (_frameCacheSizeMax != frameCacheSizeMax) {
        
        // Remember whether the new cap will cause the current cache size to shrink; then we'll make sure to purge from the cache if needed.
        BOOL willFrameCacheSizeShrink = (frameCacheSizeMax < self.frameCacheSizeCurrent);
        
        // Update the value
        _frameCacheSizeMax = frameCacheSizeMax;
        
        if (willFrameCacheSizeShrink) {
            [self purgeFrameCacheIfNeeded];
        }
    }
}


#pragma mark Private

- (void)setFrameCacheSizeMaxInternal:(NSUInteger)frameCacheSizeMaxInternal
{
    if (_frameCacheSizeMaxInternal != frameCacheSizeMaxInternal) {
        
        // Remember whether the new cap will cause the current cache size to shrink; then we'll make sure to purge from the cache if needed.
        BOOL willFrameCacheSizeShrink = (frameCacheSizeMaxInternal < self.frameCacheSizeCurrent);
        
        // Update the value
        _frameCacheSizeMaxInternal = frameCacheSizeMaxInternal;
        
        if (willFrameCacheSizeShrink) {
            [self purgeFrameCacheIfNeeded];
        }
    }
}


#pragma mark - Life Cycle

+ (void)initialize
{
    if (self == [KNAnimatedImage class]) {
        // UIKit memory warning notification handler shared by all of the instances
        allAnimatedImagesWeak = [NSHashTable weakObjectsHashTable];
        
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidReceiveMemoryWarningNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
            // UIKit notifications are posted on the main thread. didReceiveMemoryWarning: is expecting the main run loop, and we don't lock on allAnimatedImagesWeak
            NSAssert([NSThread isMainThread], @"Received memory warning on non-main thread");
            // Get a strong reference to all of the images. If an instance is returned in this array, it is still live and has not entered dealloc.
            // Note that KNAnimatedImages can be created on any thread, so the hash table must be locked.
            NSArray *images = nil;
            @synchronized(allAnimatedImagesWeak) {
                images = [[allAnimatedImagesWeak allObjects] copy];
            }
            // Now issue notifications to all of the images while holding a strong reference to them
            [images makeObjectsPerformSelector:@selector(didReceiveMemoryWarning:) withObject:note];
        }];
    }
}


- (instancetype)init{
    KNAnimatedImage *animatedImage = [self initWithAnimatedGIFData:nil];
    return animatedImage;
}

- (instancetype)initWithAnimatedGIFData:(NSData *)data{
    return [self initWithAnimatedGIFData:data optimalFrameCacheSize:0 predrawingEnabled:YES];
}

- (instancetype)initWithAnimatedGIFData:(NSData *)data optimalFrameCacheSize:(NSUInteger)optimalFrameCacheSize predrawingEnabled:(BOOL)isPredrawingEnabled{
    // Early return if no data supplied!
    BOOL hasData = ([data length] > 0);
    if (!hasData) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        // Do one-time initializations of `readonly` properties directly to ivar to prevent implicit actions and avoid need for private `readwrite` property overrides.
        
        // Keep a strong reference to `data` and expose it read-only publicly.
        // However, we will use the `_imageSource` as handler to the image data throughout our life cycle.
        _data = data;
        _predrawingEnabled = isPredrawingEnabled;
        
        // Initialize internal data structures
        _cachedFramesForIndexes = [[NSMutableDictionary alloc] init];
        _cachedFrameIndexes = [[NSMutableIndexSet alloc] init];
        _requestedFrameIndexes = [[NSMutableIndexSet alloc] init];

        // Note: We could leverage `CGImageSourceCreateWithURL` too to add a second initializer `-initWithAnimatedGIFContentsOfURL:`.
        _imageSource = CGImageSourceCreateWithData((__bridge CFDataRef)data,
                                                   (__bridge CFDictionaryRef)@{(NSString *)kCGImageSourceShouldCache: @NO});
        // Early return on failure!
        if (!_imageSource) {
            return nil;
        }
        
        // Early return if not GIF!
        CFStringRef imageSourceContainerType = CGImageSourceGetType(_imageSource);
        BOOL isGIFData = UTTypeConformsTo(imageSourceContainerType, kUTTypeGIF);
        if (!isGIFData) {
            return nil;
        }
        
        // Get `LoopCount`
        // Note: 0 means repeating the animation indefinitely.
        // Image properties example:
        // {
        //     FileSize = 314446;
        //     "{GIF}" = {
        //         HasGlobalColorMap = 1;
        //         LoopCount = 0;
        //     };
        // }
        NSDictionary *imageProperties = (__bridge_transfer NSDictionary *)CGImageSourceCopyProperties(_imageSource, NULL);
        _loopCount = [[[imageProperties objectForKey:(id)kCGImagePropertyGIFDictionary] objectForKey:(id)kCGImagePropertyGIFLoopCount] unsignedIntegerValue];
        
        // Iterate through frame images
        size_t imageCount = CGImageSourceGetCount(_imageSource);
        NSUInteger skippedFrameCount = 0;
        NSMutableDictionary *delayTimesForIndexesMutable = [NSMutableDictionary dictionaryWithCapacity:imageCount];
        for (size_t i = 0; i < imageCount; i++) {
            @autoreleasepool {
                CGImageRef frameImageRef = CGImageSourceCreateImageAtIndex(_imageSource, i, NULL);
                if (frameImageRef) {
                    UIImage *frameImage = [UIImage imageWithCGImage:frameImageRef];
                    // Check for valid `frameImage` before parsing its properties as frames can be corrupted (and `frameImage` even `nil` when `frameImageRef` was valid).
                    if (frameImage) {
                        // Set poster image
                        if (!self.posterImage) {
                            _posterImage = frameImage;
                            // Set its size to proxy our size.
                            _size = _posterImage.size;
                            // Remember index of poster image so we never purge it; also add it to the cache.
                            _posterImageFrameIndex = i;
                            [self.cachedFramesForIndexes setObject:self.posterImage forKey:@(self.posterImageFrameIndex)];
                            [self.cachedFrameIndexes addIndex:self.posterImageFrameIndex];
                        }
                        
                        // Get `DelayTime`
                        // Note: It's not in (1/100) of a second like still falsely described in the documentation as per iOS 8 (rdar://19507384) but in seconds stored as `kCFNumberFloat32Type`.
                        // Frame properties example:
                        // {
                        //     ColorModel = RGB;
                        //     Depth = 8;
                        //     PixelHeight = 960;
                        //     PixelWidth = 640;
                        //     "{GIF}" = {
                        //         DelayTime = "0.4";
                        //         UnclampedDelayTime = "0.4";
                        //     };
                        // }
                        
                        NSDictionary *frameProperties = (__bridge_transfer NSDictionary *)CGImageSourceCopyPropertiesAtIndex(_imageSource, i, NULL);
                        NSDictionary *framePropertiesGIF = [frameProperties objectForKey:(id)kCGImagePropertyGIFDictionary];
                        
                        // Try to use the unclamped delay time; fall back to the normal delay time.
                        NSNumber *delayTime = [framePropertiesGIF objectForKey:(id)kCGImagePropertyGIFUnclampedDelayTime];
                        if (!delayTime) {
                            delayTime = [framePropertiesGIF objectForKey:(id)kCGImagePropertyGIFDelayTime];
                        }
                        // If we don't get a delay time from the properties, fall back to `kDelayTimeIntervalDefault` or carry over the preceding frame's value.
                        const NSTimeInterval kDelayTimeIntervalDefault = 0.1;
                        if (!delayTime) {
                            if (i == 0) {
                                delayTime = @(kDelayTimeIntervalDefault);
                            } else {
                                delayTime = delayTimesForIndexesMutable[@(i - 1)];
                            }
                        }
                        // Support frame delays as low as `kKNAnimatedImageDelayTimeIntervalMinimum`, with anything below being rounded up to `kDelayTimeIntervalDefault` for legacy compatibility.
                        // To support the minimum even when rounding errors occur, use an epsilon when comparing. We downcast to float because that's what we get for delayTime from ImageIO.
                        if ([delayTime floatValue] < ((float)kKNAnimatedImageDelayTimeIntervalMinimum - FLT_EPSILON)) {
                            delayTime = @(kDelayTimeIntervalDefault);
                        }
                        delayTimesForIndexesMutable[@(i)] = delayTime;
                    } else {
                        skippedFrameCount++;
                    }
                    CFRelease(frameImageRef);
                } else {
                    skippedFrameCount++;
                }
            }
        }
        _delayTimesForIndexes = [delayTimesForIndexesMutable copy];
        _frameCount = imageCount;
        
        if (self.frameCount == 0) {
            return nil;
        } else if (self.frameCount == 1) {
            
        } else {
            // We have multiple frames, rock on!
        }
        
        // If no value is provided, select a default based on the GIF.
        if (optimalFrameCacheSize == 0) {
            // Calculate the optimal frame cache size: try choosing a larger buffer window depending on the predicted image size.
            // It's only dependent on the image size & number of frames and never changes.
            CGFloat animatedImageDataSize = CGImageGetBytesPerRow(self.posterImage.CGImage) * self.size.height * (self.frameCount - skippedFrameCount) / MEGABYTE;
            if (animatedImageDataSize <= KNAnimatedImageDataSizeCategoryAll) {
                _frameCacheSizeOptimal = self.frameCount;
            } else if (animatedImageDataSize <= KNAnimatedImageDataSizeCategoryDefault) {
                // This value doesn't depend on device memory much because if we're not keeping all frames in memory we will always be decoding 1 frame up ahead per 1 frame that gets played and at this point we might as well just keep a small buffer just large enough to keep from running out of frames.
                _frameCacheSizeOptimal = KNAnimatedImageFrameCacheSizeDefault;
            } else {
                // The predicted size exceeds the limits to build up a cache and we go into low memory mode from the beginning.
                _frameCacheSizeOptimal = KNAnimatedImageFrameCacheSizeLowMemory;
            }
        } else {
            // Use the provided value.
            _frameCacheSizeOptimal = optimalFrameCacheSize;
        }
        // In any case, cap the optimal cache size at the frame count.
        _frameCacheSizeOptimal = MIN(_frameCacheSizeOptimal, self.frameCount);
        
        // Convenience/minor performance optimization; keep an index set handy with the full range to return in `-frameIndexesToCache`.
        _allFramesIndexSet = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(0, self.frameCount)];
        
        // See the property declarations for descriptions.
        _weakProxy = (id)[KNPhotoBrowserProxy weakProxyForObject:self];
        
        // Register this instance in the weak table for memory notifications. The NSHashTable will clean up after itself when we're gone.
        // Note that KNAnimatedImages can be created on any thread, so the hash table must be locked.
        @synchronized(allAnimatedImagesWeak) {
            [allAnimatedImagesWeak addObject:self];
        }
    }
    return self;
}


+ (instancetype)animatedImageWithGIFData:(NSData *)data
{
    KNAnimatedImage *animatedImage = [[KNAnimatedImage alloc] initWithAnimatedGIFData:data];
    return animatedImage;
}


- (void)dealloc
{
    if (_weakProxy) {
        [NSObject cancelPreviousPerformRequestsWithTarget:_weakProxy];
    }
    
    if (_imageSource) {
        CFRelease(_imageSource);
    }
}


#pragma mark - Public Methods

// See header for more details.
// Note: both consumer and producer are throttled: consumer by frame timings and producer by the available memory (max buffer window size).
- (UIImage *)imageLazilyCachedAtIndex:(NSUInteger)index
{
    // Early return if the requested index is beyond bounds.
    // Note: We're comparing an index with a count and need to bail on greater than or equal to.
    if (index >= self.frameCount) {
        return nil;
    }
    
    // Remember requested frame index, this influences what we should cache next.
    self.requestedFrameIndex = index;
    
    // Quick check to avoid doing any work if we already have all possible frames cached, a common case.
    if ([self.cachedFrameIndexes count] < self.frameCount) {
        // If we have frames that should be cached but aren't and aren't requested yet, request them.
        // Exclude existing cached frames, frames already requested, and specially cached poster image.
        NSMutableIndexSet *frameIndexesToAddToCacheMutable = [self frameIndexesToCache];
        [frameIndexesToAddToCacheMutable removeIndexes:self.cachedFrameIndexes];
        [frameIndexesToAddToCacheMutable removeIndexes:self.requestedFrameIndexes];
        [frameIndexesToAddToCacheMutable removeIndex:self.posterImageFrameIndex];
        NSIndexSet *frameIndexesToAddToCache = [frameIndexesToAddToCacheMutable copy];
        
        // Asynchronously add frames to our cache.
        if ([frameIndexesToAddToCache count] > 0) {
            [self addFrameIndexesToCache:frameIndexesToAddToCache];
        }
    }
    
    // Get the specified image.
    UIImage *image = self.cachedFramesForIndexes[@(index)];
    
    // Purge if needed based on the current playhead position.
    [self purgeFrameCacheIfNeeded];
    
    return image;
}


// Only called once from `-imageLazilyCachedAtIndex` but factored into its own method for logical grouping.
- (void)addFrameIndexesToCache:(NSIndexSet *)frameIndexesToAddToCache
{
    // Order matters. First, iterate over the indexes starting from the requested frame index.
    // Then, if there are any indexes before the requested frame index, do those.
    NSRange firstRange = NSMakeRange(self.requestedFrameIndex, self.frameCount - self.requestedFrameIndex);
    NSRange secondRange = NSMakeRange(0, self.requestedFrameIndex);
    
    // Add to the requested list before we actually kick them off, so they don't get into the queue twice.
    [self.requestedFrameIndexes addIndexes:frameIndexesToAddToCache];
    
    // Lazily create dedicated isolation queue.
    if (!self.serialQueue) {
        _serialQueue = dispatch_queue_create("com.flipboard.framecachingqueue", DISPATCH_QUEUE_SERIAL);
    }
    
    // Start streaming requested frames in the background into the cache.
    // Avoid capturing self in the block as there's no reason to keep doing work if the animated image went away.
    KNAnimatedImage * __weak weakSelf = self;
    dispatch_async(self.serialQueue, ^{
        // Produce and cache next needed frame.
        void (^frameRangeBlock)(NSRange, BOOL *) = ^(NSRange range, BOOL *stop) {
            // Iterate through contiguous indexes; can be faster than `enumerateIndexesInRange:options:usingBlock:`.
            for (NSUInteger i = range.location; i < NSMaxRange(range); i++) {
                UIImage *image = [weakSelf imageAtIndex:i];
                // The results get returned one by one as soon as they're ready (and not in batch).
                // The benefits of having the first frames as quick as possible outweigh building up a buffer to cope with potential hiccups when the CPU suddenly gets busy.
                if (image && weakSelf) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        weakSelf.cachedFramesForIndexes[@(i)] = image;
                        [weakSelf.cachedFrameIndexes addIndex:i];
                        [weakSelf.requestedFrameIndexes removeIndex:i];
                    });
                }
            }
        };
        
        [frameIndexesToAddToCache enumerateRangesInRange:firstRange options:0 usingBlock:frameRangeBlock];
        [frameIndexesToAddToCache enumerateRangesInRange:secondRange options:0 usingBlock:frameRangeBlock];
    });
}


+ (CGSize)sizeForImage:(id)image
{
    CGSize imageSize = CGSizeZero;
    
    // Early return for nil
    if (!image) {
        return imageSize;
    }
    
    if ([image isKindOfClass:[UIImage class]]) {
        UIImage *uiImage = (UIImage *)image;
        imageSize = uiImage.size;
    } else if ([image isKindOfClass:[KNAnimatedImage class]]) {
        KNAnimatedImage *animatedImage = (KNAnimatedImage *)image;
        imageSize = animatedImage.size;
    } else {

    }
    
    return imageSize;
}


#pragma mark - Private Methods
#pragma mark Frame Loading

- (UIImage *)imageAtIndex:(NSUInteger)index
{
    // It's very important to use the cached `_imageSource` since the random access to a frame with `CGImageSourceCreateImageAtIndex` turns from an O(1) into an O(n) operation when re-initializing the image source every time.
    CGImageRef imageRef = CGImageSourceCreateImageAtIndex(_imageSource, index, NULL);

    // Early return for nil
    if (!imageRef) {
        return nil;
    }

    UIImage *image = [UIImage imageWithCGImage:imageRef];
    CFRelease(imageRef);
    
    // Loading in the image object is only half the work, the displaying image view would still have to synchronosly wait and decode the image, so we go ahead and do that here on the background thread.
    if (self.isPredrawingEnabled) {
        image = [[self class] predrawnImageFromImage:image];
    }
    
    return image;
}


#pragma mark Frame Caching

- (NSMutableIndexSet *)frameIndexesToCache
{
    NSMutableIndexSet *indexesToCache = nil;
    // Quick check to avoid building the index set if the number of frames to cache equals the total frame count.
    if (self.frameCacheSizeCurrent == self.frameCount) {
        indexesToCache = [self.allFramesIndexSet mutableCopy];
    } else {
        indexesToCache = [[NSMutableIndexSet alloc] init];
        
        // Add indexes to the set in two separate blocks- the first starting from the requested frame index, up to the limit or the end.
        // The second, if needed, the remaining number of frames beginning at index zero.
        NSUInteger firstLength = MIN(self.frameCacheSizeCurrent, self.frameCount - self.requestedFrameIndex);
        NSRange firstRange = NSMakeRange(self.requestedFrameIndex, firstLength);
        [indexesToCache addIndexesInRange:firstRange];
        NSUInteger secondLength = self.frameCacheSizeCurrent - firstLength;
        if (secondLength > 0) {
            NSRange secondRange = NSMakeRange(0, secondLength);
            [indexesToCache addIndexesInRange:secondRange];
        }
        // Double check our math, before we add the poster image index which may increase it by one.
        if ([indexesToCache count] != self.frameCacheSizeCurrent) {
            
        }
        
        [indexesToCache addIndex:self.posterImageFrameIndex];
    }
    
    return indexesToCache;
}


- (void)purgeFrameCacheIfNeeded
{
    // Purge frames that are currently cached but don't need to be.
    // But not if we're still under the number of frames to cache.
    // This way, if all frames are allowed to be cached (the common case), we can skip all the `NSIndexSet` math below.
    if ([self.cachedFrameIndexes count] > self.frameCacheSizeCurrent) {
        NSMutableIndexSet *indexesToPurge = [self.cachedFrameIndexes mutableCopy];
        [indexesToPurge removeIndexes:[self frameIndexesToCache]];
        [indexesToPurge enumerateRangesUsingBlock:^(NSRange range, BOOL *stop) {
            // Iterate through contiguous indexes; can be faster than `enumerateIndexesInRange:options:usingBlock:`.
            for (NSUInteger i = range.location; i < NSMaxRange(range); i++) {
                [self.cachedFrameIndexes removeIndex:i];
                [self.cachedFramesForIndexes removeObjectForKey:@(i)];
                // Note: Don't `CGImageSourceRemoveCacheAtIndex` on the image source for frames that we don't want cached any longer to maintain O(1) time access.
            }
        }];
    }
}


- (void)growFrameCacheSizeAfterMemoryWarning:(NSNumber *)frameCacheSize
{
    self.frameCacheSizeMaxInternal = [frameCacheSize unsignedIntegerValue];
    
    // Schedule resetting the frame cache size max completely after a while.
    const NSTimeInterval kResetDelay = 3.0;
    [self.weakProxy performSelector:@selector(resetFrameCacheSizeMaxInternal) withObject:nil afterDelay:kResetDelay];
}


- (void)resetFrameCacheSizeMaxInternal
{
    self.frameCacheSizeMaxInternal = KNAnimatedImageFrameCacheSizeNoLimit;
}


#pragma mark System Memory Warnings Notification Handler

- (void)didReceiveMemoryWarning:(NSNotification *)notification
{
    self.memoryWarningCount++;
    
    // If we were about to grow larger, but got rapped on our knuckles by the system again, cancel.
    [NSObject cancelPreviousPerformRequestsWithTarget:self.weakProxy selector:@selector(growFrameCacheSizeAfterMemoryWarning:) object:@(KNAnimatedImageFrameCacheSizeGrowAfterMemoryWarning)];
    [NSObject cancelPreviousPerformRequestsWithTarget:self.weakProxy selector:@selector(resetFrameCacheSizeMaxInternal) object:nil];
    
    self.frameCacheSizeMaxInternal = KNAnimatedImageFrameCacheSizeLowMemory;
    
    // Schedule growing larger again after a while, but cap our attempts to prevent a periodic sawtooth wave (ramps upward and then sharply drops) of memory usage.
    //
    // [mem]^     (2)   (5)  (6)        1) Loading frames for the first time
    //   (*)|      ,     ,    ,         2) Mem warning #1; purge cache
    //      |     /| (4)/|   /|         3) Grow cache size a bit after a while, if no mem warning occurs
    //      |    / |  _/ | _/ |         4) Try to grow cache size back to optimum after a while, if no mem warning occurs
    //      |(1)/  |_/   |/   |__(7)    5) Mem warning #2; purge cache
    //      |__/   (3)                  6) After repetition of (3) and (4), mem warning #3; purge cache
    //      +---------------------->    7) After 3 mem warnings, stay at minimum cache size
    //                            [t]
    //                                  *) The mem high water mark before we get warned might change for every cycle.
    //
    const NSUInteger kGrowAttemptsMax = 2;
    const NSTimeInterval kGrowDelay = 2.0;
    if ((self.memoryWarningCount - 1) <= kGrowAttemptsMax) {
        [self.weakProxy performSelector:@selector(growFrameCacheSizeAfterMemoryWarning:) withObject:@(KNAnimatedImageFrameCacheSizeGrowAfterMemoryWarning) afterDelay:kGrowDelay];
    }
    
    // Note: It's not possible to get the level of a memory warning with a public API: http://stackoverflow.com/questions/2915247/iphone-os-memory-warnings-what-do-the-different-levels-mean/2915477#2915477
}


#pragma mark Image Decoding

// Decodes the image's data and draws it off-screen fully in memory; it's thread-safe and hence can be called on a background thread.
// On success, the returned object is a new `UIImage` instance with the same content as the one passed in.
// On failure, the returned object is the unchanged passed in one; the data will not be predrawn in memory though and an error will be logged.
// First inspired by & good Karma to: https://gist.github.com/steipete/1144242
+ (UIImage *)predrawnImageFromImage:(UIImage *)imageToPredraw
{
    // Always use a device RGB color space for simplicity and predictability what will be going on.
    CGColorSpaceRef colorSpaceDeviceRGBRef = CGColorSpaceCreateDeviceRGB();
    // Early return on failure!
    if (!colorSpaceDeviceRGBRef) {
        return imageToPredraw;
    }
    
    // Even when the image doesn't have transparency, we have to add the extra channel because Quartz doesn't support other pixel formats than 32 bpp/8 bpc for RGB:
    // kCGImageAlphaNoneSkipFirst, kCGImageAlphaNoneSkipLast, kCGImageAlphaPremultipliedFirst, kCGImageAlphaPremultipliedLast
    // (source: docs "Quartz 2D Programming Guide > Graphics Contexts > Table 2-1 Pixel formats supported for bitmap graphics contexts")
    size_t numberOfComponents = CGColorSpaceGetNumberOfComponents(colorSpaceDeviceRGBRef) + 1; // 4: RGB + A
    
    // "In iOS 4.0 and later, and OS X v10.6 and later, you can pass NULL if you want Quartz to allocate memory for the bitmap." (source: docs)
    void *data = NULL;
    size_t width = imageToPredraw.size.width;
    size_t height = imageToPredraw.size.height;
    size_t bitsPerComponent = CHAR_BIT;
    
    size_t bitsPerPixel = (bitsPerComponent * numberOfComponents);
    size_t bytesPerPixel = (bitsPerPixel / BYTE_SIZE);
    size_t bytesPerRow = (bytesPerPixel * width);
    
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageToPredraw.CGImage);
    // If the alpha info doesn't match to one of the supported formats (see above), pick a reasonable supported one.
    // "For bitmaps created in iOS 3.2 and later, the drawing environment uses the premultiplied ARGB format to store the bitmap data." (source: docs)
    if (alphaInfo == kCGImageAlphaNone || alphaInfo == kCGImageAlphaOnly) {
        alphaInfo = kCGImageAlphaNoneSkipFirst;
    } else if (alphaInfo == kCGImageAlphaFirst) {
        alphaInfo = kCGImageAlphaPremultipliedFirst;
    } else if (alphaInfo == kCGImageAlphaLast) {
        alphaInfo = kCGImageAlphaPremultipliedLast;
    }
    // "The constants for specifying the alpha channel information are declared with the `CGImageAlphaInfo` type but can be passed to this parameter safely." (source: docs)
    bitmapInfo |= alphaInfo;
    
    // Create our own graphics context to draw to; `UIGraphicsGetCurrentContext`/`UIGraphicsBeginImageContextWithOptions` doesn't create a new context but returns the current one which isn't thread-safe (e.g. main thread could use it at the same time).
    // Note: It's not worth caching the bitmap context for multiple frames ("unique key" would be `width`, `height` and `hasAlpha`), it's ~50% slower. Time spent in libRIP's `CGSBlendBGRA8888toARGB8888` suddenly shoots up -- not sure why.
    CGContextRef bitmapContextRef = CGBitmapContextCreate(data, width, height, bitsPerComponent, bytesPerRow, colorSpaceDeviceRGBRef, bitmapInfo);
    CGColorSpaceRelease(colorSpaceDeviceRGBRef);
    // Early return on failure!
    if (!bitmapContextRef) {
        return imageToPredraw;
    }
    
    // Draw image in bitmap context and create image by preserving receiver's properties.
    CGContextDrawImage(bitmapContextRef, CGRectMake(0.0, 0.0, imageToPredraw.size.width, imageToPredraw.size.height), imageToPredraw.CGImage);
    CGImageRef predrawnImageRef = CGBitmapContextCreateImage(bitmapContextRef);
    UIImage *predrawnImage = [UIImage imageWithCGImage:predrawnImageRef scale:imageToPredraw.scale orientation:imageToPredraw.imageOrientation];
    CGImageRelease(predrawnImageRef);
    CGContextRelease(bitmapContextRef);
    
    // Early return on failure!
    if (!predrawnImage) {
        return imageToPredraw;
    }
    
    return predrawnImage;
}


#pragma mark - Description

- (NSString *)description
{
    NSString *description = [super description];
    
    description = [description stringByAppendingFormat:@" size=%@", NSStringFromCGSize(self.size)];
    description = [description stringByAppendingFormat:@" frameCount=%lu", (unsigned long)self.frameCount];
    
    return description;
}


@end
