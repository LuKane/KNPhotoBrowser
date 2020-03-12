//
//  KNAnimatedImage.h
//  KNPhotoBrowser
//
//  Created by LuKane on 2020/3/12.
//  Copyright © 2020 LuKane. All rights reserved.
//  copy it with FLAnimatedImage

#import <Foundation/Foundation.h>
#import "KNAnimatedImageView.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

extern const NSTimeInterval kKNAnimatedImageDelayTimeIntervalMinimum;

@interface KNAnimatedImage : NSObject

@property (nonatomic, strong, readonly) UIImage *posterImage;
@property (nonatomic, assign, readonly) CGSize size;

@property (nonatomic, assign, readonly) NSUInteger loopCount;
@property (nonatomic, strong, readonly) NSDictionary *delayTimesForIndexes;
@property (nonatomic, assign, readonly) NSUInteger frameCount;
@property (nonatomic, assign, readonly) NSUInteger frameCacheSizeCurrent;
@property (nonatomic, assign) NSUInteger frameCacheSizeMax;

- (UIImage *)imageLazilyCachedAtIndex:(NSUInteger)index;

+ (CGSize)sizeForImage:(id)image;

- (instancetype)initWithAnimatedGIFData:(NSData *)data;
- (instancetype)initWithAnimatedGIFData:(NSData *)data optimalFrameCacheSize:(NSUInteger)optimalFrameCacheSize predrawingEnabled:(BOOL)isPredrawingEnabled NS_DESIGNATED_INITIALIZER;
+ (instancetype)animatedImageWithGIFData:(NSData *)data;

@property (nonatomic, strong, readonly) NSData *data;


@end

NS_ASSUME_NONNULL_END
