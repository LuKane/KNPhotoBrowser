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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
}

- (BOOL)shouldAutorotate{
    return false;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

@end
