//
//  KNPhotoImageCell.m
//  KNPhotoBrowser
//
//  Created by LuKane on 2018/12/14.
//  Copyright © 2018 LuKane. All rights reserved.
//

#import "KNPhotoImageCell.h"
#import "KNProgressHUD.h"

@implementation KNPhotoImageCell{
    KNProgressHUD *_progressHUD;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupImageView];
    }
    return self;
}

- (void)setupImageView{
    // 1.photoBrowerView
    KNPhotoBrowserImageView *photoBrowerView = [[KNPhotoBrowserImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _photoBrowerImageView = photoBrowerView;
    [self.contentView addSubview:photoBrowerView];
    
    // single tap
    __weak typeof(self) weakself = self;
    photoBrowerView.singleTap = ^{
        if (weakself.singleTap) {
            weakself.singleTap();
        }
    };
    
    // long press
    photoBrowerView.longPressTap = ^{
        if (weakself.longPressTap) {
            weakself.longPressTap();
        }
    };
    
    // 2.progressHUD
    KNProgressHUD *progressHUD = [[KNProgressHUD alloc] initWithFrame:(CGRect){{([UIScreen mainScreen].bounds.size.width - 40) * 0.5,([UIScreen mainScreen].bounds.size.height - 40) * 0.5},{40,40}}];
    _progressHUD = progressHUD;
    [self.contentView addSubview:progressHUD];
}

- (void)imageWithUrl:(NSString *)url
         placeHolder:(UIImage *)placeHolder
           photoItem:(nonnull KNPhotoItems *)photoItem{
    [_photoBrowerImageView imageWithUrl:[NSURL URLWithString:url]
                            progressHUD:_progressHUD
                            placeHolder:placeHolder
                              photoItem:photoItem];
}

- (void)setPresentedMode:(UIViewContentMode)presentedMode {
    _presentedMode = presentedMode;
    _photoBrowerImageView.imageView.contentMode = self.presentedMode;
}

- (void)prepareForReuse{
    [super prepareForReuse];
    [_photoBrowerImageView.scrollView setZoomScale:1.f animated:false];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [_photoBrowerImageView.scrollView setZoomScale:1.f animated:false];
    _photoBrowerImageView.frame = self.bounds;
    _progressHUD.center = self.contentView.center;
}

@end
