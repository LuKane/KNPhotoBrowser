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

#ifndef PBViewWidth
    #define PBViewWidth  self.view.bounds.size.width
#endif

#ifndef PBViewHeight
    #define PBViewHeight self.view.bounds.size.height
#endif

#define PBDeviceHasBang \
({\
    BOOL hasBang = false;\
    if (@available(iOS 11.0, *)) {\
        hasBang = [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom;\
    }\
    (hasBang);\
})

/// Portrait
#ifndef isPortrait
    #define isPortrait ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown)
#endif


#define PhotoBrowserAnimateTime 0.3

// define SDWebImagePrefetcher max number
#define PhotoBrowserPrefetchNum     8


