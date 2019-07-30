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

typedef void(^PhotoDownLoadBlock)(KNPhotoDownloadState downloadState ,float prgress);

@interface KNPhotoDownloadMgr : NSObject <NSURLSessionDelegate>

/**
 download video
 
 @param item current item
 @param downloadBlock block
 */
- (void)downloadVideoWithItems:(KNPhotoItems *)item downloadBlock:(PhotoDownLoadBlock)downloadBlock;

@end

NS_ASSUME_NONNULL_END
