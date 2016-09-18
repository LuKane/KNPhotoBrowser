//
//  KNPhotoBrowerCell.m
//  KNPhotoBrower
//
//  Created by LuKane on 16/8/18.
//  Copyright © 2016年 LuKane. All rights reserved.
//

#import "KNPhotoBrowerCell.h"

@implementation KNPhotoBrowerCell


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
    photoBrowerView.singleTapBlock = ^(UITapGestureRecognizer *tap){
        if(weakSelf.singleTap){
            weakSelf.singleTap();
        }
    };
    _photoBrowerImageView = photoBrowerView;
    [self.contentView addSubview:photoBrowerView];
}

- (void)sd_ImageWithUrl:(NSString *)url placeHolder:(UIImage *)placeHolder{
//    [_photoBrowerImageView.scrollView setZoomScale:1.f animated:NO];
    [_photoBrowerImageView sd_ImageWithUrl:[NSURL URLWithString:url] placeHolder:placeHolder];
//    [_photoBrowerImageView reloadFrames];
}

- (void)dealloc{
    [_photoBrowerImageView.scrollView setZoomScale:1.f animated:NO];
}

@end

