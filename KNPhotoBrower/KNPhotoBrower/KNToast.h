//
//  KNToast.h
//  test
//
//  Created by LuKane on 16/9/5.
//  Copyright © 2016年 LuKane. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KNToast : UIView

+ (instancetype)shareToast;

- (void)initWithText:(NSString *)text;
- (void)initWithText:(NSString *)text offSetY:(CGFloat)offsetY;

- (void)initWithText:(NSString *)text duration:(NSInteger)duration;
- (void)initWithText:(NSString *)text duration:(NSInteger)duration offSetY:(CGFloat)offsetY;

@end
