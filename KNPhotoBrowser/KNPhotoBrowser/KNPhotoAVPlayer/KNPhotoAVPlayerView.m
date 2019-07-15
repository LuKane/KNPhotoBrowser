//
//  KNPhotoAVPlayerView.m
//  KNPhotoBrowser
//
//  Created by LuKane on 2019/6/14.
//  Copyright © 2019 LuKane. All rights reserved.
//

#import "KNPhotoAVPlayerView.h"
#import "KNPhotoAVPlayerActionView.h"

@interface KNPhotoAVPlayerView ()<KNPhotoAVPlayerActionViewDelegate,KNPhotoAVPlayerViewDelegate>

@property (nonatomic,strong) AVPlayer       *player;
@property (nonatomic,strong) AVPlayerItem   *item;

@property (nonatomic,weak  ) KNPhotoAVPlayerActionView  *actionView;

@property (nonatomic,strong) id timeObserver;

@end

@implementation KNPhotoAVPlayerView

- (UIView *)playerView{
    if (!_playerView) {
        _playerView = [[UIView alloc] initWithFrame:self.bounds];
        [_playerView setBackgroundColor:UIColor.clearColor];
    }
    return _playerView;
}

- (void)playerWithURL:(NSString *)url placeHolder:(UIImage *)placeHolder{
    _url = url;
    _placeHolder = placeHolder;
    [self setupAVPlayer];
}

- (void)setupAVPlayer{
    self.item = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:_url]];
    self.player = [AVPlayer playerWithPlayerItem:self.item];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    [self.playerView.layer addSublayer:self.playerLayer];
    [self addSubview:self.playerView];
    
    KNPhotoAVPlayerActionView *actionView = [[KNPhotoAVPlayerActionView alloc] initWithFrame:self.bounds];
    [actionView setDelegate:self];
    [actionView setIsBuffering:false];
    [actionView setIsPlaying:false];
    [self addSubview:actionView];
    _actionView = actionView;
}

- (void)addItemObserver{
    if (_item) {
        [_item addObserver:self
                forKeyPath:@"status"
                   options:NSKeyValueObservingOptionNew
                   context:nil];
        [_item addObserver:self
                forKeyPath:@"loadedTimeRanges"
                   options:NSKeyValueObservingOptionNew
                   context:nil];
    }
    
    self.timeObserver = [_player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        NSLog(@"time:%f",CMTimeGetSeconds(time));
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(videoDidPlayToEndTime)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:nil];
}

- (void)removeItemObserver{
    if (_item) {
        [_item removeObserver:self forKeyPath:@"status" context:nil];
        [_item removeObserver:self forKeyPath:@"loadedTimeRanges" context:nil];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if (![object isKindOfClass:[AVPlayerItem class]]) return;
    
    if ([keyPath isEqualToString:@"status"]) {
        if (_player.currentItem.status == AVPlayerStatusReadyToPlay) {
            [_player play];
            [_actionView setIsPlaying:true];
            [_actionView setIsBuffering:false];
        }else{
            NSLog(@"status: other");
        }
    }
}

- (void)videoPlayerWillReset{
    
}

- (void)videoDidPlayToEndTime{
    if (_player) {
        __weak typeof(self) weakself = self;
        [_player seekToTime:CMTimeMake(1, 1) completionHandler:^(BOOL finished) {
            if (finished) {
                [weakself.actionView setIsPlaying:false];
            }
        }];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.playerLayer.frame  = self.bounds;
    self.playerView.frame   = self.bounds;
    self.actionView.frame   = self.bounds;
}

- (void)photoAVPlayerActionViewDismiss{
    if ([_delegate respondsToSelector:@selector(photoAVPlayerViewDismiss)]) {
        [_delegate photoAVPlayerViewDismiss];
    }
}

- (void)photoAVPlayerActionViewPauseOrStop{
    [self addItemObserver];
    [_actionView setIsPlaying:true];
}

- (void)dealloc{
    NSLog(@"avplayer is dealloc");
    if (_player && self.timeObserver) {
        [_player removeTimeObserver:self.timeObserver];
        self.timeObserver = nil;
    }
    [self removeItemObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
