//
//  KNPhotoBrowserImageView.h
//  KNPhotoBrowser
//
//  Created by LuKane on 16/8/17.
//  Copyright © 2016年 LuKane. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KNProgressHUD;

typedef void(^PhotoBrowerSingleTap)(void);
typedef void(^PhotoBrowerLongPressTap)(void);


@interface KNPhotoBrowserImageView : UIView

// all base control that can scroll
@property (nonatomic, strong) UIScrollView *scrollView;
// single tap
@property (nonatomic,copy  ) PhotoBrowerSingleTap singleTap;
// longPress tap
@property (nonatomic,copy  ) PhotoBrowerLongPressTap longPressTap;

- (void)sd_ImageWithUrl:(NSURL *)url progressHUD:(KNProgressHUD *)progressHUD placeHolder:(UIImage *)placeHolder;

@end
