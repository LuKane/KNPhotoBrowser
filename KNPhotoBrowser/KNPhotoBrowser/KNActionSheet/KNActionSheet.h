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
 alert

 @param cancelTitle title of cancel
 @param otherTitleArr other title array
 @param ActionBlock call back
 @return alert
 */
- (instancetype)initWithCancelTitle:(NSString *)cancelTitle
                      otherTitleArr:(NSArray  *)otherTitleArr
                        actionBlock:(ActionBlock)ActionBlock;

/**
 alert  + destruction

 @param cancelTitle title of cancel
 @param destructiveTitle destructive title
 @param otherTitleArr other title array
 @param ActionBlock call back
 @return alert
 */
- (instancetype)initWithCancelTitle:(NSString *)cancelTitle
                   destructiveTitle:(NSString *)destructiveTitle
                      otherTitleArr:(NSArray  *)otherTitleArr
                        actionBlock:(ActionBlock)ActionBlock;

/**
 alert + destructive + index of destructive

 @param cancelTitle title of cancel
 @param destructiveTitle destructive title
 @param destructiveIndex destructive index
 @param otherTitleArr other title array
 @param ActionBlock call back
 @return alert
 */
- (instancetype)initWithCancelTitle:(NSString *)cancelTitle
                   destructiveTitle:(NSString *)destructiveTitle
                   destructiveIndex:(NSInteger )destructiveIndex
                      otherTitleArr:(NSArray  *)otherTitleArr
                        actionBlock:(ActionBlock)ActionBlock;


- (void)show;
- (void)dismiss;

@end
