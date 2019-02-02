//
//  UIView+Extension.h

//
//  Created by apple on 14-10-7.
//  Copyright (c) 2014年 LUKHA_Lu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)

/**
 *  将当前的一个 point 转到 另一个View || window 上的 获得 CGPoint
 *
 *  @param point 当前点
 *  @param view  目标 View || window
 *
 *  @return 返回坐标点
 */
- (CGPoint)convertPoint:(CGPoint)point toViewOrWindow:(nullable UIView *)view;

/**
 *  将 一个View || window 上的点 转换到 当前View的 CGPoint
 *
 *  @param point 那个点
 *  @param view  来源 view || window
 *
 *  @return 返回坐标点
 */
- (CGPoint)convertPoint:(CGPoint)point fromViewOrWindow:(nullable UIView *)view;

/**
 *  将当前的一个 控件 转到 另一个 View || window 上的 获得 CGRect
 *
 *  @param rect 当前控件的 frame
 *  @param view 目标 View
 *
 *  @return 返回 Rect
 */
- (CGRect)convertRect:(CGRect)rect toViewOrWindow:(nullable UIView *)view;

/**
 *  将一个View || window 上的 控件 转到 当前View 获得 CGRect
 *
 *  @param rect 当前控件的 frame
 *  @param view 目标 View
 *
 *  @return 返回 Rect
 */
- (CGRect)convertRect:(CGRect)rect fromViewOrWindow:(nullable UIView *)view;

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat right; // 设置View X方向最后边的 位置的.x
@property (nonatomic, assign) CGFloat bottom;// 设置View Y方向最下边的 位置的.y
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;

@end
