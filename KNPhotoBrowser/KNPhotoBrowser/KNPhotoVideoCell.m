//
//  KNPhotoVideoCell.m
//  KNPhotoBrowser
//
//  Created by LuKane on 2019/6/11.
//  Copyright © 2019 LuKane. All rights reserved.
//

#import "KNPhotoVideoCell.h"
#import "KNProgressHUD.h"

@interface KNPhotoVideoCell()<KNPhotoPlayerViewDelegate>

@end

@implementation KNPhotoVideoCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        KNPhotoAVPlayerView *playerView = [[KNPhotoAVPlayerView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [playerView setDelegate:self];
        [self.contentView addSubview:playerView];
        _onlinePlayerView = playerView;
        
        KNPhotoLocateAVPlayerView *locatePlayerView = [[KNPhotoLocateAVPlayerView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [locatePlayerView setDelegate:self];
        [self.contentView addSubview:locatePlayerView];
        _locatePlayerView = locatePlayerView;
        
        KNProgressHUD *progressHUD = [[KNProgressHUD alloc] initWithFrame:(CGRect){{([UIScreen mainScreen].bounds.size.width - 40) * 0.5,([UIScreen mainScreen].bounds.size.height - 40) * 0.5},{40,40}}];
        [self.contentView addSubview:progressHUD];
        _progressHUD = progressHUD;
    }
    return self;
}

- (void)playerOnLinePhotoItems:(KNPhotoItems *)photoItems placeHolder:(UIImage * _Nullable)placeHolder {
    _onlinePlayerView.isSoloAmbient = _isSoloAmbient;
    [_onlinePlayerView playerOnLinePhotoItems:photoItems placeHolder:placeHolder];
    _onlinePlayerView.hidden = false;
    _locatePlayerView.hidden = true;
    _progressHUD.hidden = true;
    
    if ([self.delegate respondsToSelector:@selector(photoVideoAVPlayerCustomActionBar)]) {
        [_onlinePlayerView playerCustomActionBar:[self.delegate photoVideoAVPlayerCustomActionBar]];
    }
}
- (void)playerLocatePhotoItems:(KNPhotoItems *)photoItems placeHolder:(UIImage *)placeHolder {
    _locatePlayerView.isSoloAmbient = _isSoloAmbient;
    [_locatePlayerView playerLocatePhotoItems:photoItems progressHUD:_progressHUD placeHolder:placeHolder];
    _locatePlayerView.hidden = false;
    _onlinePlayerView.hidden = true;
    _progressHUD.hidden = true;
    
    if ([self.delegate respondsToSelector:@selector(photoVideoAVPlayerCustomActionBar)]) {
        [_locatePlayerView playerCustomActionBar:[self.delegate photoVideoAVPlayerCustomActionBar]];
    }
}

- (void)setPresentedMode:(UIViewContentMode)presentedMode {
    _presentedMode = presentedMode;
    _onlinePlayerView.placeHolderImgView.contentMode = self.presentedMode;
    _locatePlayerView.placeHolderImgView.contentMode = self.presentedMode;
}

- (void)playerWillEndDisplay{
    [_onlinePlayerView playerWillReset];
    [_locatePlayerView playerWillReset];
}

/// setter
- (void)setIsNeedAutoPlay:(BOOL)isNeedAutoPlay {
    _isNeedAutoPlay = isNeedAutoPlay;
    if (isNeedAutoPlay == true) {
        if (_onlinePlayerView.isHidden == false) {
            [_onlinePlayerView setIsNeedAutoPlay:true];
        }
        if (_locatePlayerView.isHidden == false) {
            [_locatePlayerView setIsNeedAutoPlay:true];
        }
    }
}
/// setter
- (void)setIsNeedVideoPlaceHolder:(BOOL)isNeedVideoPlaceHolder {
    _isNeedVideoPlaceHolder = isNeedVideoPlaceHolder;
    _onlinePlayerView.isNeedVideoPlaceHolder = isNeedVideoPlaceHolder;
    _locatePlayerView.isNeedVideoPlaceHolder = isNeedVideoPlaceHolder;
}
/// setter
- (void)setIsNeedVideoDismissButton:(BOOL)isNeedVideoDismissButton {
    _isNeedVideoDismissButton = isNeedVideoDismissButton;
    _onlinePlayerView.isNeedVideoDismissButton = isNeedVideoDismissButton;
    _locatePlayerView.isNeedVideoDismissButton = isNeedVideoDismissButton;
}
/// setter
- (void)setIsNeedLoopPlay:(BOOL)isNeedLoopPlay {
    _isNeedLoopPlay = isNeedLoopPlay;
    _onlinePlayerView.isNeedLoopPlay = isNeedLoopPlay;
    _locatePlayerView.isNeedLoopPlay = isNeedLoopPlay;
}
/// setter
- (void)setIsNeedVideoTapToDismiss:(BOOL)isNeedVideoTapToDismiss {
    _isNeedVideoTapToDismiss = isNeedVideoTapToDismiss;
    _onlinePlayerView.isNeedVideoTapToDismiss = isNeedVideoTapToDismiss;
    _locatePlayerView.isNeedVideoTapToDismiss = isNeedVideoTapToDismiss;
}

/// delegate function
- (void)photoPlayerViewDismiss{
    [_onlinePlayerView playerWillReset];
    [_locatePlayerView playerWillReset];
    if ([_delegate respondsToSelector:@selector(photoVideoAVPlayerDismiss)]) {
        [_delegate photoVideoAVPlayerDismiss];
    }
}
/// delegate function
- (void)photoPlayerLongPress:(UILongPressGestureRecognizer *)longPress{
    if ([_delegate respondsToSelector:@selector(photoVideoAVPlayerLongPress:)]) {
        [_delegate photoVideoAVPlayerLongPress:longPress];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _onlinePlayerView.frame = self.bounds;
    _locatePlayerView.frame = self.bounds;
    _progressHUD.center = self.contentView.center;
}

@end
