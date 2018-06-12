//
//  KNPch.h
//  KNPhotoBrower
//
//  Created by LuKane on 16/8/16.
//  Copyright © 2016年 LuKane. All rights reserved.
//

#ifndef ScreenWidth
    #define ScreenWidth [UIScreen mainScreen].bounds.size.width
#endif

#ifndef ScreenHeight
    #define ScreenHeight [UIScreen mainScreen].bounds.size.height
#endif

#define PhotoBrowerBackgroundAlpha 1.f
#define PhotoBrowerBrowerTime      .3f
#define PhotoBrowerMargin          20.f
#define PhotoBrowerTransformTime 0.2
#define iPhoneX (([[UIScreen mainScreen] bounds].size.height- 812)?(NO):(YES))

// 图片的最大放大倍数
#define PhotoBrowerImageMaxScale   2.f
// 图片的最小缩小倍数
#define PhotoBrowerImageMinScale   1.f

#define PhotoSaveImageSuccessMessage  @"^_^ 保存成功!!"
#define PhotoSaveImageFailureMessage @"/(ㄒoㄒ)/~~ 保存失败!!"
#define PhotoSaveImageMessageTime    2
#define PhotoSaveImageFailureReason  @"图片需要下载完成"
#define PhotoShowPlaceHolderImageColor [UIColor blackColor]
#define iPhoneX (([[UIScreen mainScreen] bounds].size.height- 812)?(NO):(YES))

// 是否是 左旋转
#define PhotoOrientationLandscapeIsLeft [UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft
// 是否是 竖直(正)
#define PhotoOrientationLandscapeIsPortrait [UIDevice currentDevice].orientation == UIDeviceOrientationPortrait
// 是否是 右旋转
#define PhotoOrientationLandscapeIsRight [UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight
// 是否是 竖直(反)
#define PhotoOrientationLandscapeIsPortraitUpsideDown [UIDevice currentDevice].orientation == UIDeviceOrientationPortraitUpsideDown
// 面部朝上
#define PhotoOrientationFaceUp [UIDevice currentDevice].orientation == UIDeviceOrientationFaceUp
// 面部朝下
#define PhotoOrientationFaceDown [UIDevice currentDevice].orientation == UIDeviceOrientationFaceDown
// 无法识别方向
#define PhotoOrientationUnknown [UIDevice currentDevice].orientation == UIDeviceOrientationUnknown

#import "UIView+PBExtesion.h"
