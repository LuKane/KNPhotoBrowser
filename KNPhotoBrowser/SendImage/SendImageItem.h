//
//  SendImageItem.h
//  KNPhotoBrowser
//
//  Created by LuKane on 2019/12/30.
//  Copyright © 2019 LuKane. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@protocol SendImageItemDelegate <NSObject>

- (void)sendImageItemDidClick:(NSInteger)index;
- (void)sendImageItemDeleteClick:(NSInteger)index;

@end

@interface SendImageItem : UIView

@property (nonatomic,strong) UIImage *image;
@property (nonatomic,weak  ) UIImageView *iconView;

@property (nonatomic,weak  ) id<SendImageItemDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
