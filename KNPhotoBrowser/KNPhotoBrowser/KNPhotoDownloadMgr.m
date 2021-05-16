//
//  KNPhotoDownloadMgr.m
//  KNPhotoBrowser
//
//  Created by LuKane on 2019/7/29.
//  Copyright © 2019 LuKane. All rights reserved.
//

#import "KNPhotoDownloadMgr.h"
#import <CommonCrypto/CommonDigest.h>

@interface KNPhotoDownloadMgr(){
    NSURLSessionDownloadTask *_downloadTask;
}

@property (nonatomic,copy  ) PhotoDownLoadBlock downloadBlock;
@property (nonatomic,strong) KNPhotoItems *item;
@property (nonatomic,strong) KNPhotoItems *tempItem;

@end

@implementation KNPhotoDownloadMgr

static KNPhotoDownloadMgr *_mgr = nil;

+ (instancetype)shareInstance{
    if (_mgr == nil) {
        _mgr = [[KNPhotoDownloadMgr alloc] init];
    }
    return _mgr;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _mgr = [super allocWithZone:zone];
    });
    return _mgr;
}

- (id)copyWithZone:(NSZone *)zone{
    return self;
}

- (id)mutableCopyWithZone:(NSZone *)zone{
    return self;
}

- (instancetype)init{
    if (self = [super init]) {
        _filePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, true) lastObject] stringByAppendingPathComponent:@"KNPhotoBrowserData"];
    }
    return self;
}

- (void)downloadVideoWithPhotoItems:(KNPhotoItems *)photoItems downloadBlock:(PhotoDownLoadBlock)downloadBlock{
    if (photoItems.url == nil) {
        return;
    }
    
    if (_tempItem == photoItems) {
        _downloadBlock(KNPhotoDownloadStateRepeat,0.0);
        return;
    }
    
    _item          = [[KNPhotoItems alloc] init];
    _item.url      = photoItems.url;
    
    _tempItem      = photoItems;
    _downloadBlock = downloadBlock;
    
    [self cancelTask];
    
    if (photoItems.isVideo == true) {
        NSURL *url = [NSURL URLWithString:photoItems.url];
        if ([url.scheme containsString:@"http"]) {
            [self startDownLoadWithURL:url.absoluteString];
        }
    }else {
        _downloadBlock(KNPhotoDownloadStateUnknow,0.0);
    }
}

/// cancel all download task
- (void)cancelTask{
    _item.downloadState = KNPhotoDownloadStateFailure;
    [_downloadTask cancel];
}

- (void)startDownLoadWithURL:(NSString *)url{
    if (_item.downloadState == KNPhotoDownloadStateDownloading) return;
    
    _item.downloadState = KNPhotoDownloadStateDownloading;
    _item.downloadProgress = 0.0;
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    _downloadTask = [session downloadTaskWithURL:[NSURL URLWithString:url]];
    [_downloadTask resume];
}
#pragma mark - NSURLSession Delegate --> NSURLSessionTaskDelegate
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    CGFloat progress = (CGFloat)totalBytesWritten / (CGFloat)totalBytesExpectedToWrite;
    
    if (progress < 0) progress = 0;
    if (progress > 1) progress = 1;
    
    _item.downloadProgress = progress;
    _item.downloadState = KNPhotoDownloadStateDownloading;
    if (_downloadBlock) {
//        NSLog(@"%lld-%lld == > %f",totalBytesWritten,totalBytesExpectedToWrite,progress);
        _downloadBlock(KNPhotoDownloadStateDownloading,progress);
    }
}
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error {
    _item.downloadState = KNPhotoDownloadStateSuccess;
    _item.downloadProgress = 1.0;
    if (error) {
        _item.downloadState = KNPhotoDownloadStateFailure;
        _item.downloadProgress = 0.0;
    }
    if (_downloadBlock) {
        _downloadBlock(_item.downloadState,_item.downloadProgress);
    }
    _tempItem = nil;
}
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    
    NSString *file = [_filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",[self md5:_item.url.lastPathComponent.stringByDeletingPathExtension],_item.url.pathExtension]];
    
    [[NSFileManager defaultManager] copyItemAtURL:location toURL:[NSURL fileURLWithPath:file] error:nil];
}

- (NSString *)md5:(NSString *)str{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

@end

@implementation KNPhotoDownloadFileMgr

- (instancetype)init{
    if (self = [super init]) {
        _filePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, true) lastObject] stringByAppendingPathComponent:@"KNPhotoBrowserData"];
    }
    return self;
}

/// check is contain video or not
- (BOOL)startCheckIsExistVideo:(KNPhotoItems *)photoItems {
    if (photoItems == nil || photoItems.url == nil) {
        return false;
    }
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    BOOL isDir = false;
    BOOL existed = [fileMgr fileExistsAtPath:_filePath isDirectory:&isDir];
    
    if (!(isDir && existed)) {
        [fileMgr createDirectoryAtPath:_filePath withIntermediateDirectories:true attributes:nil error:nil];
        return false;
    }else {
        NSString *path = [_filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",[self md5:photoItems.url.lastPathComponent.stringByDeletingPathExtension],photoItems.url.pathExtension]];
        return [fileMgr fileExistsAtPath:path];
    }
}

/// get video filepath , but it must download before
- (NSString *)startGetFilePath:(KNPhotoItems *)photoItems {
    NSString *path = [_filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",[self md5:photoItems.url.lastPathComponent.stringByDeletingPathExtension],photoItems.url.pathExtension]];
    return path;
}

- (NSString *)md5:(NSString *)str{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

/// remove video by photoItems
/// @param photoItems photoItems
- (void)removeVideoByPhotoItems:(KNPhotoItems *)photoItems{
    if (photoItems == nil) {
        return;
    }
    [self removeVideoByURLString:photoItems.url];
}

/// remove video by url string
/// @param urlString url string
- (void)removeVideoByURLString:(NSString *)urlString{
    if (urlString == nil) {
        return;
    }
    if ([urlString stringByReplacingOccurrencesOfString:@" " withString:@""].length == 0) {
        return;
    }
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    BOOL isDir = false;
    BOOL existed = [fileMgr fileExistsAtPath:_filePath isDirectory:&isDir];
    
    if ((isDir && existed)) {
        NSError *err;
        NSString *path = [_filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",[self md5:urlString.lastPathComponent.stringByDeletingPathExtension],urlString.pathExtension]];
        [fileMgr removeItemAtPath:path error:&err];
    }
}

/// remove all video
- (void)removeAllVideo{
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:_filePath];
    for (NSString *fileName in enumerator) {
        [[NSFileManager defaultManager] removeItemAtPath:[_filePath stringByAppendingPathComponent:fileName] error:nil];
    }
}

@end

