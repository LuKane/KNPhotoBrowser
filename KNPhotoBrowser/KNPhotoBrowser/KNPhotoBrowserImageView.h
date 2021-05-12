//
//  KNPhotoBrowserImageView.h
//  KNPhotoBrowser
//
//  Created by LuKane on 16/8/17.
//  Copyright © 2016年 LuKane. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/SDAnimatedImageView.h>

@class KNProgressHUD;
@class KNPhotoItems;

typedef void(^PhotoBrowerSingleTap)(void);
typedef void(^PhotoBrowerLongPressTap)(void);

@interface KNPhotoBrowserImageView : UIView

// all base control that can scroll
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) SDAnimatedImageView *imageView;

// single tap
@property (nonatomic,copy  ) PhotoBrowerSingleTap singleTap;
// longPress tap
@property (nonatomic,copy  ) PhotoBrowerLongPressTap longPressTap;

/// set image with url
/// @param url url
/// @param progressHUD progressHUD
/// @param placeHolder placeHolder image
/// @param photoItem current photoItems
- (void)imageWithUrl:(NSURL *)url
         progressHUD:(KNProgressHUD *)progressHUD
         placeHolder:(UIImage *)placeHolder
           photoItem:(KNPhotoItems *)photoItem;

@end
