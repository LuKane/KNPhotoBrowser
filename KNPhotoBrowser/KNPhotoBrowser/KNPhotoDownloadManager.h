//
//  KNPhotoDownloadManager.h
//  KNPhotoBrowser
//
//  Created by LuKane on 2019/7/19.
//  Copyright © 2019 LuKane. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger ,PhotoDownloadState) {
    PhotoDownloadStateUnknow,
    PhotoDownloadStateSuccess,
    PhotoDownloadStateFailure,
    PhotoDownloadStateDownloading
};

typedef void(^PhotoDownLoadBlock)(PhotoDownloadState downloadState);
typedef void(^PhotoDownLoadProgressBlock)(float progress);

@interface KNPhotoDownloadManager : NSObject <NSURLSessionDelegate>

/**
 download video

 @param videoURL videoURL locate || network 的url
 @param downloadBlock download state
 @param progressBlock download progress
 */
- (void)downloadVideoWithVideoURL:(NSString *)videoURL downloadState:(PhotoDownLoadBlock)downloadBlock progress:(PhotoDownLoadProgressBlock)progressBlock;

@end

NS_ASSUME_NONNULL_END
