//
//  KNPhotoAVPlayerActionView.m
//  KNPhotoBrowser
//
//  Created by LuKane on 2019/6/14.
//  Copyright © 2019 LuKane. All rights reserved.
//

#import "KNPhotoAVPlayerActionView.h"
#import "KNPhotoBrowserPch.h"
#import <objc/runtime.h>
#import "KNPhotoBrowserConfig.h"

@interface KNPhotoAVPlayerActionView()

/**
 stop || play view
 */
@property (nonatomic,weak  ) UIImageView *pauseImgView;

/**
 dismiss view
 */
@property (nonatomic,weak  ) UIImageView *dismissImgView;

/**
 loading view
 */
@property (nonatomic,strong) UIActivityIndicatorView *indicatorView;

@end

@implementation KNPhotoAVPlayerActionView {
    BOOL _isTempDismissImgViewHidden;
}

- (UIActivityIndicatorView *)indicatorView{
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [_indicatorView setHidesWhenStopped:true];
    }
    return _indicatorView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:UIColor.clearColor];
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionViewDidClick)]];
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews{
    
    NSBundle *bundle = [NSBundle bundleForClass:NSClassFromString(@"KNPhotoBrowser")];
    
    // 1.stop || play imageView
    UIImageView *pauseImgView = [[UIImageView alloc] init];
    
    if ([KNPhotoBrowserConfig share].pauseImage != NULL) {
        pauseImgView.image = [KNPhotoBrowserConfig share].pauseImage;
    }else {
        if(UIScreen.mainScreen.scale < 3) {
            [pauseImgView setImage:[UIImage imageNamed:@"KNPhotoBrowser.bundle/playCenter@2x" inBundle:bundle compatibleWithTraitCollection:nil]];
        }else {
            [pauseImgView setImage:[UIImage imageNamed:@"KNPhotoBrowser.bundle/playCenter@3x" inBundle:bundle compatibleWithTraitCollection:nil]];
        }
    }
    
    [pauseImgView setUserInteractionEnabled:true];
    [pauseImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pauseImageViewDidClick)]];
    [self addSubview:pauseImgView];
    _pauseImgView = pauseImgView;
    
    // 2.dismiss imageView
    UIImageView *dismissImgView = [[UIImageView alloc] init];
    [dismissImgView setUserInteractionEnabled:true];
    [dismissImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissImageViewDidClick)]];
    if(UIScreen.mainScreen.scale < 3) {
        [dismissImgView setImage:[UIImage imageNamed:@"KNPhotoBrowser.bundle/dismiss@2x" inBundle:bundle compatibleWithTraitCollection:nil]];
    }else {
        [dismissImgView setImage:[UIImage imageNamed:@"KNPhotoBrowser.bundle/dismiss@3x" inBundle:bundle compatibleWithTraitCollection:nil]];
    }
    [dismissImgView setHidden:true];
    [self addSubview:dismissImgView];
    _dismissImgView = dismissImgView;
    
    _isTempDismissImgViewHidden = true;
    
    // 3.loading imageView
    [self addSubview:self.indicatorView];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _pauseImgView.frame     = CGRectMake((self.frame.size.width - 80) * 0.5, (self.frame.size.height - 80) * 0.5, 80, 80);
    
    
    CGFloat y = 25;
    CGFloat x = 10;
    if(PBDeviceHasBang){
        y = 45;
        x = 20;
    }
    
    if(!isPortrait){
        y = 15;
        x = 35;
    }
    _dismissImgView.frame   = CGRectMake(x, y, 20, 20);
    _indicatorView.frame    = CGRectMake((self.frame.size.width - 30) * 0.5, (self.frame.size.height - 30) * 0.5, 30, 30);
}

- (void)pauseImageViewDidClick{
    
    if (_pauseImgView.hidden == false) {
        _pauseImgView.hidden = true;
    }
    
    if ([_delegate respondsToSelector:@selector(photoAVPlayerActionViewPauseOrStop)]) {
        [_delegate photoAVPlayerActionViewPauseOrStop];
    }
}

- (void)dismissImageViewDidClick{
    if ([_delegate respondsToSelector:@selector(photoAVPlayerActionViewDismiss)]) {
        [_delegate photoAVPlayerActionViewDismiss];
    }
}

- (void)actionViewDidClick{
    
    _isTempDismissImgViewHidden = !_isTempDismissImgViewHidden;
    
    if(_isNeedVideoDismissButton) { [_dismissImgView setHidden:!_dismissImgView.hidden]; }
    
    if ([_delegate respondsToSelector:@selector(photoAVPlayerActionViewDidClickIsHidden:)]) {
        [_delegate photoAVPlayerActionViewDidClickIsHidden:_isTempDismissImgViewHidden];
    }
}

/**
 avPlayerActionView need hidden or not
 */
- (void)avplayerActionViewNeedHidden:(BOOL)isHidden{
    if (isHidden == true) {
        _isTempDismissImgViewHidden = true;
        if (_isNeedVideoDismissButton) { [_dismissImgView setHidden:true]; }
        [_indicatorView setHidden:true];
        [_pauseImgView setHidden:true];
    }else {
        [_pauseImgView setHidden:false];
    }
}
/**
 is need to hidden PauseImgView
 */
- (void)photoAVPlayerActionViewNeedHiddenPauseImgView:(BOOL)isHidden{
    [_pauseImgView setHidden:isHidden];
}

- (void)setIsBuffering:(BOOL)isBuffering{
    _isBuffering = isBuffering;
    if (isBuffering) {
        [_indicatorView startAnimating];
    }else{
        [_indicatorView stopAnimating];
    }
}

- (void)setIsPlaying:(BOOL)isPlaying{
    _isPlaying = isPlaying;
    [_pauseImgView setHidden:isPlaying];
}

- (void)setIsDownloading:(BOOL)isDownloading{
    _isDownloading = isDownloading;
    [_pauseImgView setHidden:isDownloading];
}

- (void)setIsNeedVideoDismissButton:(BOOL)isNeedVideoDismissButton {
    _isNeedVideoDismissButton = isNeedVideoDismissButton;
    if (isNeedVideoDismissButton == false) { [_dismissImgView setHidden:true];}
}

@end
