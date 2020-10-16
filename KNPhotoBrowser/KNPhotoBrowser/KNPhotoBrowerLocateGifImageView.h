//
//  KNPhotoBrowerLocateGifImageView.h
//  KNPhotoBrowser
//
//  Created by jmcl on 2020/10/15.
//  Copyright © 2020 LuKane. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDAnimatedImageView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^LocateGifSingleTap)(void);
typedef void(^LocateGifLongPressTap)(void);


@interface KNPhotoBrowerLocateGifImageView : UIView
// all base control that can scroll
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) SDAnimatedImageView *imageView;

// single tap
@property (nonatomic,copy  ) LocateGifSingleTap singleTap;
// longPress tap
@property (nonatomic,copy  ) LocateGifLongPressTap longPressTap;



@end








NS_ASSUME_NONNULL_END
