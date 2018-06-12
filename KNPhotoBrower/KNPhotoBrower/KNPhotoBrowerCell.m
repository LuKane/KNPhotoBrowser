//
//  KNPhotoBrowerCell.m
//  KNPhotoBrower
//
//  Created by LuKane on 16/8/18.
//  Copyright © 2016年 LuKane. All rights reserved.
//

#import "KNPhotoBrowerCell.h"
#import "KNPch.h"
#import "KNProgressHUD.h"

@implementation KNPhotoBrowerCell{
    KNProgressHUD *_progressHUD;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setupImageView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupImageView];
    }
    return self;
}

- (void)setupImageView{
    __weak typeof(self) weakSelf = self;
    KNPhotoBrowerImageView *photoBrowerView = [[KNPhotoBrowerImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    photoBrowerView.singleTapBlock = ^(){
        if(weakSelf.singleTap){
            weakSelf.singleTap();
        }
    };
    
    photoBrowerView.longPressBlock = ^(){
        if(weakSelf.longPress){
            weakSelf.longPress();
        }
    };
    
    _photoBrowerImageView = photoBrowerView;
    [self.contentView addSubview:photoBrowerView];

    KNProgressHUD *progressHUD = [[KNProgressHUD alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    progressHUD.center = CGPointMake(self.contentView.center.x - 10, self.contentView.center.y);
    _progressHUD = progressHUD;
    [self.contentView addSubview:progressHUD];
}

- (void)sd_ImageWithUrl:(NSString *)url placeHolder:(UIImage *)placeHolder{
    [_photoBrowerImageView sd_ImageWithUrl:[NSURL URLWithString:url] progressHUD:_progressHUD placeHolder:placeHolder];
}

- (void)prepareForReuse{
    [_photoBrowerImageView.scrollView setZoomScale:1.f animated:NO];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if(PhotoOrientationLandscapeIsPortrait || PhotoOrientationLandscapeIsPortraitUpsideDown){
        _photoBrowerImageView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    }else{
        _photoBrowerImageView.frame = CGRectMake(0, 0, ScreenHeight, ScreenWidth);
        _photoBrowerImageView.center = self.contentView.center;
    }
    _progressHUD.center = CGPointMake(self.contentView.center.x - 10, self.contentView.center.y);
}

@end

