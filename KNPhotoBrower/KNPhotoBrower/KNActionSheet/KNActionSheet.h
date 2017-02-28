//
//  KNActionSheeth
//  KNActionSheet
//
//  Created by LuKane on 16/9/5.
//  Copyright © 2016年 LuKane. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ActionBlock)(NSInteger buttonIndex);

@interface KNActionSheet : UIView

/**
 弹出层

 @param cancelTitle 取消功能的文字
 @param otherTitleArr 其他功能的文字 数组
 @param ActionBlock 回调
 @return 弹出层本身
 */
- (instancetype)initWithCancelTitle:(NSString *)cancelTitle
                      otherTitleArr:(NSArray  *)otherTitleArr
                        actionBlock:(ActionBlock)ActionBlock;

/**
 弹出层 + 销毁

 @param cancelTitle 取消功能的文字
 @param destructiveTitle 标红 的文字
 @param otherTitleArr 其他功能的文字 数组
 @param ActionBlock 回调
 @return 弹出层本身
 */
- (instancetype)initWithCancelTitle:(NSString *)cancelTitle
                   destructiveTitle:(NSString *)destructiveTitle
                      otherTitleArr:(NSArray  *)otherTitleArr
                        actionBlock:(ActionBlock)ActionBlock;

/**
 弹出层 + 销毁 + 销毁下标

 @param cancelTitle 取消功能的文字
 @param destructiveTitle 标红 的文字
 @param destructiveIndex 标红 的文字 的下标
 @param otherTitleArr 其他功能的文字 数组
 @param ActionBlock 回调
 @return 弹出层本身
 */
- (instancetype)initWithCancelTitle:(NSString *)cancelTitle
                   destructiveTitle:(NSString *)destructiveTitle
                   destructiveIndex:(NSInteger )destructiveIndex
                      otherTitleArr:(NSArray  *)otherTitleArr
                        actionBlock:(ActionBlock)ActionBlock;


- (void)show;
- (void)dismiss;

@end
