//
//  KNPhotoDownloadMgr.h
//  KNPhotoBrowser
//
//  Created by LuKane on 2019/7/29.
//  Copyright © 2019 LuKane. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KNPhotoBrowser.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^PhotoDownLoadBlock)(KNPhotoDownloadState downloadState, float progress);

@interface KNPhotoDownloadMgr: NSObject <NSURLSessionDelegate>

/// single
+ (instancetype)shareInstance;

/// default file path
/// [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, true) lastObject] stringByAppendingPathComponent:@"KNPhotoBrowserData"];
@property (nonatomic,copy, readonly) NSString *filePath;

/**
 download video, when finish it, it will be renamed!
 eg: url = "https://www.xxxxxx/xxxx/123.mp4"
     rename = "123" to MD5 encryption, and append ".mp4"
 
 @param photoItems current item
 @param downloadBlock block
 */
- (void)downloadVideoWithPhotoItems:(KNPhotoItems *)photoItems
                      downloadBlock:(PhotoDownLoadBlock)downloadBlock;

/// cancel all download task
- (void)cancelTask;

@end

@interface KNPhotoDownloadFileMgr: NSObject

/// default file path
/// [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, true) lastObject] stringByAppendingPathComponent:@"KNPhotoBrowserData"];
@property (nonatomic,copy, readonly) NSString *filePath;

/// check out filePath has contain current video or not
/// @param photoItems photoItems
- (BOOL)startCheckIsExistVideo:(KNPhotoItems *)photoItems;

/// get filePath of current video(filePath is like : "123" to MD5 encryption, and append ".mp4" )
/// @param photoItems photoItems
- (NSString *)startGetFilePath:(KNPhotoItems *)photoItems;

/// remove video by photoItems
/// @param photoItems photoItems
- (void)removeVideoByPhotoItems:(KNPhotoItems *)photoItems;

/// remove video by url string
/// @param urlString url string
- (void)removeVideoByURLString:(NSString *)urlString;

/// remove all video
- (void)removeAllVideo;

@end

NS_ASSUME_NONNULL_END
