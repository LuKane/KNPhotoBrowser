//
//  KNPhotoDownloadManager.h
//  KNPhotoBrowser
//
//  Created by LuKane on 2019/7/19.
//  Copyright © 2019 LuKane. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KNPhotoBrowser.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^PhotoDownLoadBlock)(KNPhotoDownloadState downloadState);
typedef void(^PhotoDownLoadProgressBlock)(float progress);

@interface KNPhotoDownloadManager : NSObject <NSURLSessionDelegate>

/**
 download video

 @param item current Item
 @param videoURL videoURL locate || network 的url
 @param downloadBlock download state
 @param progressBlock download progress
 */
- (void)downloadVideoWithItem:(KNPhotoItems *)item videoURL:(NSString *)videoURL downloadState:(PhotoDownLoadBlock)downloadBlock progress:(PhotoDownLoadProgressBlock)progressBlock;

@end

NS_ASSUME_NONNULL_END
