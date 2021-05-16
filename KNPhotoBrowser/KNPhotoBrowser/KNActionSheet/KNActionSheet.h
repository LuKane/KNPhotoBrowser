//
//  KNActionSheet.h
//  test
//
//  Created by LuKane on 2019/12/18.
//  Copyright © 2019 LuKane. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ActionSheetBlock)(NSInteger buttonIndex);

@interface KNActionSheet : UIView

+ (KNActionSheet *)share;

- (instancetype)initWithTitle:(NSString *)title
                  cancelTitle:(NSString *)cancelTitle
                   titleArray:(NSMutableArray <NSString *> *)titleArray
                  actionSheetBlock:(ActionSheetBlock)sheetBlock;

- (instancetype)initWithTitle:(NSString *)title
                  cancelTitle:(NSString *)cancelTitle
                   titleArray:(NSMutableArray <NSString *> *)titleArray
             destructiveArray:(NSMutableArray <NSString *> *)destructiveArray
             actionSheetBlock:(ActionSheetBlock)sheetBlock;


- (instancetype)initWithTitle:(NSString *)title
                   titleColor:(nullable UIColor *)titleColor
                  cancelTitle:(NSString *)cancelTitle
                   titleArray:(NSMutableArray <NSString *> *)titleArray
             actionSheetBlock:(ActionSheetBlock)sheetBlock;

- (instancetype)initWithTitle:(NSString *)title
                   titleColor:(nullable UIColor *)titleColor
                  cancelTitle:(NSString *)cancelTitle
                   titleArray:(NSMutableArray <NSString *> *)titleArray
             destructiveArray:(NSMutableArray <NSString *> *)destructiveArray
             actionSheetBlock:(ActionSheetBlock)sheetBlock;

- (void)showOnView:(UIView *)view;
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
