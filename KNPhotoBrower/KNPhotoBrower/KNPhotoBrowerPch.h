//
//  KNPhotoBrower.h
//  KNPhotoBrower
//
//  Created by LuKane on 16/8/18.
//  Copyright © 2016年 LuKane. All rights reserved.
//

/**
 *  如果 bug ,希望各位在 github 上通过'邮箱' 或者直接 issue 指出, 谢谢
 *  github地址 : https://github.com/LuKane/KNPhotoBrower
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

#define PhotoSaveImageSuccessMessage  @"^_^ 保存成功!!"
#define PhotoSaveImageFailureMessage @"/(ㄒoㄒ)/~~ 保存失败!!"
#define PhotoSaveImageMessageTime    2
#define PhotoSaveImageFailureReason  @"图片需要下载完成"

#define IsPortrait ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown)

// pic max zoom num
#define PhotoBrowerImageMaxScale   2.f
// pic min zoom out num
#define PhotoBrowerImageMinScale   1.f

#import "UIView+PBExtesion.h"

