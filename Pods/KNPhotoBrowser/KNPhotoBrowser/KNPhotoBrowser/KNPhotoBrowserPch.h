//
//  KNPhotoBrowser.h
//  KNPhotoBrowser
//
//  Created by LuKane on 16/8/18.
//  Copyright © 2016年 LuKane. All rights reserved.
//

/**
 *  如果 bug ,希望各位在 github 上通过'邮箱' 或者直接 issue 指出, 谢谢
 *  github地址 : https://github.com/LuKane/KNPhotoBrowser
 *  项目会越来越丰富,也希望大家一起来增加功能 , 欢迎 Star
 */

#ifndef ScreenWidth
    #define ScreenWidth [UIScreen mainScreen].bounds.size.width
#endif

#ifndef ScreenHeight
    #define ScreenHeight [UIScreen mainScreen].bounds.size.height
#endif

#define iPhoneX  ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : false)
#define iPhoneXR ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828 , 1792), [[UIScreen mainScreen] currentMode].size) : false)
#define iPhoneXs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242 , 2688), [[UIScreen mainScreen] currentMode].size) : false)


#define PhotoShowPlaceHolderImageColor [UIColor blackColor]

#define PhotoSaveImageSuccessMessage  @"保存成功!!"
#define PhotoSaveImageFailureMessage  @"保存失败!!"
#define PhotoSaveImageMessageTime    2
#define PhotoSaveImageFailureReason  @"图片需要下载完成"

#define PhotoSaveVideoFailureMessage  @"视频下载失败"
#define PhotoSaveVideoSuccessMessage  @"视频下载成功"
#define PhotoSaveVideoFailureReason   @"视频无法下载"

#define isPortrait ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown)

#define PhotoPlaceHolderDefaultColor [UIColor grayColor]

// pic max zoom num
#define PhotoBrowserImageMaxScale   2.f
// pic min zoom out num
#define PhotoBrowserImageMinScale   1.f

#define PhotoBrowserAnimateTime 0.3

// define SDWebImagePrefetcher max number
#define PhotoBrowserPrefetchNum     8

#import "UIView+PBExtesion.h"

