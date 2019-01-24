//
//  KNProgressHUD.h
//  KNPhotoBrowser
//
//  Created by LuKane on 16/8/17.
//  Copyright © 2016年 LuKane. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KNProgressHUD : UIView

/**
 * load main color
 */
@property (nonatomic, strong) UIColor *HUDColor;

/**
 * color of sector , Default is White
 */
@property (nonatomic, strong) UIColor *sectorColor;

/**
 * color of section's layer, Default is white
 */
@property (nonatomic, strong) UIColor *sectorBoldColor;

/**
 * progress, range is from 0 to 1
 */
@property (nonatomic, assign) CGFloat progress;

@end
