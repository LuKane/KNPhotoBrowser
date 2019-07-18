//
//  KNPhotoVideoCell.m
//  KNPhotoBrowser
//
//  Created by LuKane on 2019/6/11.
//  Copyright © 2019 LuKane. All rights reserved.
//

#import "KNPhotoVideoCell.h"

@interface KNPhotoVideoCell()<KNPhotoAVPlayerViewDelegate>

@end

@implementation KNPhotoVideoCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        KNPhotoAVPlayerView *playerView = [[KNPhotoAVPlayerView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [playerView setDelegate:self];
        [self.contentView addSubview:playerView];
        _playerView = playerView;
    }
    return self;
}
- (void)playerWithURL:(NSString *)url placeHolder:(UIImage *_Nullable)placeHolder{
    [_playerView playerWithURL:url placeHolder:placeHolder];
}

- (void)playerWillEndDisplay{
    [_playerView videoPlayerWillReset];
}

- (void)photoAVPlayerViewDismiss{
    if ([_delegate respondsToSelector:@selector(photoVideoAVPlayerDismiss)]) {
        [_delegate photoVideoAVPlayerDismiss];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _playerView.frame = self.bounds;
}

@end
