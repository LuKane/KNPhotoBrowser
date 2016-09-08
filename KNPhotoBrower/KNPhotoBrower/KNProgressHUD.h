//
//  KNProgressHUD.h
//  KNPhotoBrower
//
//  Created by LuKane on 16/8/17.
//  Copyright © 2016年 LuKane. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface KNProgressHUD : UIView

/**
 *  显示加载圈
 *
 *  @param superView 父控件
 *  @param animated  是否 动画显出入
 *
 *  @return 加载圈本身
 */
+ (instancetype)showHUDAddTo:(UIView *)superView animated:(BOOL)animated;

/**
 *  加载圈的 整体 颜色
 */
@property (nonatomic, strong) UIColor *HUDColor;

/**
 *  扇形颜色 ,默认为 白色
 */
@property (nonatomic, strong) UIColor *sectorColor;

/**
 *  边框颜色 , 默认为 白色
 */
@property (nonatomic, strong) UIColor *sectorBoldColor;

/**
 *  进度 , 范围 :0.f ~ 1.f
 */
@property (nonatomic, assign) CGFloat progress;

/**
 *  消失
 */
- (void)dismiss;

@end
