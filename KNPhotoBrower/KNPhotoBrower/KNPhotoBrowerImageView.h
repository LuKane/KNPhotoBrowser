//
//  KNPhotoBrowerImageView.h
//  KNPhotoBrower
//
//  Created by LuKane on 16/8/17.
//  Copyright © 2016年 LuKane. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLAnimatedImage.h"
@class KNProgressHUD;

typedef void(^SingleTapBlock)();
typedef void(^LongPressBlock)();

@interface KNPhotoBrowerImageView : UIView

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, copy  ) SingleTapBlock singleTapBlock;
@property (nonatomic, copy  ) LongPressBlock longPressBlock;

- (void)sd_ImageWithUrl:(NSURL *)url progressHUD:(KNProgressHUD *)progressHUD placeHolder:(UIImage *)placeHolder;


@end
