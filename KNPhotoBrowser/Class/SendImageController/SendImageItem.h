//
//  SendImageItem.h
//  KNPhotoBrowser
//
//  Created by LuKane on 2021/5/23.
//  Copyright © 2021 LuKane. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SendImageItemDelegate <NSObject>

@optional
- (void)sendImageItemImageViewDidClick:(NSInteger)index;
- (void)sendImageItemDeleteDidClick:(NSInteger)index;

@end

@interface SendImageItem : UIView

@property (nonatomic,weak  ) id<SendImageItemDelegate> delegate;

@property (nonatomic,weak  ) UIImageView *imgView;

@end

NS_ASSUME_NONNULL_END
