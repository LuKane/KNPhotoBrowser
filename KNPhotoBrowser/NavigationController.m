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

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait && UIInterfaceOrientationLandscapeLeft && UIInterfaceOrientationLandscapeRight;
}

@end
