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
#define PhotoBrowerBrowerTime      0.2f
#define PhotoBrowerMargin          20.f

#define PhotoSaveImageSuccessMessage  @"^_^ 保存成功!!"
#define PhotoSaveImageFailureMessage @"/(ㄒoㄒ)/~~ 保存失败!!"
#define PhotoSaveImageMessageTime    2

#import "UIView+PBExtesion.h"