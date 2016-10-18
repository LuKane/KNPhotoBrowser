//
//  KNPhotoBrowerImageView.h
//  KNPhotoBrower
//
//  Created by LuKane on 16/8/17.
//  Copyright © 2016年 LuKane. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^SingleTapBlock)();
typedef void(^LongPressBlock)();

@interface KNPhotoBrowerImageView : UIView

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, copy  ) SingleTapBlock singleTapBlock;
@property (nonatomic, copy  ) LongPressBlock longPressBlock;

- (void)sd_ImageWithUrl:(NSURL *)url placeHolder:(UIImage *)placeHolder;

- (void)reloadFrames;

@end
