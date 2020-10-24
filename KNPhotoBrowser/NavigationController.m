//
//  NavigationController.m
//  KNPhotoBrowser
//
//  Created by LuKane on 2018/12/19.
//  Copyright © 2018 LuKane. All rights reserved.
//

#import "NavigationController.h"

@interface NavigationController ()

@end

@implementation NavigationController

- (BOOL)shouldAutorotate{
    return true;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

// Presentation推出支持的屏幕旋转
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

@end
