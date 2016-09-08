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

- (instancetype)initWithCancelBtnTitle:(NSString *)cancelBtnTitle
                destructiveButtonTitle:(NSString *)destructiveBtnTitle
                     otherBtnTitlesArr:(NSArray *)otherBtnTitlesArr
                           actionBlock:(ActionBlock)ActionBlock;

- (void)show;
- (void)dismiss;

@end
