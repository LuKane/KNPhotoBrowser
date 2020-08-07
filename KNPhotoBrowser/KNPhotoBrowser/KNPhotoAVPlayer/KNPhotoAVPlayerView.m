//
//  KNPhotoAVPlayerView.m
//  KNPhotoBrowser
//
//  Created by LuKane on 2019/6/14.
//  Copyright © 2019 LuKane. All rights reserved.
//

#import "KNPhotoAVPlayerView.h"
#import "KNPhotoAVPlayerActionBar.h"

@interface KNPhotoAVPlayerView ()<KNPhotoAVPlayerActionViewDelegate,KNPhotoAVPlayerActionBarDelegate>

@property (nonatomic,strong) AVPlayerItem   *item;

@property (nonatomic,strong) AVPlayer       *player;
@property (nonatomic,weak  ) KNPhotoAVPlayerActionBar   *actionBar;

@property (nonatomic,assign) BOOL  isPlaying;
@property (nonatomic,assign) BOOL  isGetAllPlayItem;
@property (nonatomic,assign) BOOL  isAddObserver;

@property (nonatomic,strong) id timeObserver;

@property (nonatomic,assign) BOOL isDragging;
@property (nonatomic,assign) BOOL isEnterBackground;

@end

@implementation KNPhotoAVPlayerView

- (UIView *)playerBgView{
    if (!_playerBgView) {
        _playerBgView = [[UIView alloc] init];
    }
    return _playerBgView;
}

/**
 placeHolderImageView for temp image
 
 @return imageView
 */
- (UIImageView *)placeHolderImgView{
    if (!_placeHolderImgView) {
        _placeHolderImgView = [[UIImageView alloc] init];
        [_placeHolderImgView setContentMode:UIViewContentModeScaleAspectFit];
    }
    return _placeHolderImgView;
}

/**
 player view

 @return view
 */
- (UIView *)playerView{
    if (!_playerView) {
        _playerView = [[UIView alloc] init];
        [_playerView setBackgroundColor:UIColor.clearColor];
    }
    return _playerView;
}

/**
 remove time observer
 */
- (void)removeTimeObserver{
    if (self.timeObserver && _player ) {
        @try{
            [_player removeTimeObserver:self.timeObserver];
            self.timeObserver = nil;
        }@catch(id anException){
        
        }
    }
}

/**
 remove AVPlayer and actionView
 */
- (void)removeAVPlayerAndActionView{
    _player = nil;
    [_playerLayer removeFromSuperlayer];
    [_playerView removeFromSuperview];
    [_actionBar removeFromSuperview];
    [_actionView removeFromSuperview];
    _playerLayer = nil;
    _playerView  = nil;
    _actionView  = nil;
    _actionBar   = nil;
}

/**
 Add observer for active or not
 */
- (void)addObserverForAppActive{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
}

/****************************** == Line == ********************************/

/**
 set url and placeHolder for player

 @param url url
 @param placeHolder placeHolder for temp image
 */
- (void)playerWithURL:(NSString *)url placeHolder:(UIImage *)placeHolder{
    _url = url;
    _placeHolder = placeHolder;
    
    [self addObserverForAppActive];
    
    AVAudioSession * session  = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    
    [self removeItemObserver];
    if (_player) {
        [self removeTimeObserver];
        [self removeAVPlayerAndActionView];
    }
    
    _isPlaying = false;
    
    if ([_url hasPrefix:@"http"]) {
        _item = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:_url]];
    } else {
        _item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:_url]];
    }
    
    [self setupPlayer:true];
    [self setupActionView];
    [self videoDidPlayToEndTime];
}

/// set is need auto play
/// @param isNeedAutoPlay param
- (void)setIsNeedAutoPlay:(BOOL)isNeedAutoPlay{
    _isNeedAutoPlay = isNeedAutoPlay;
    if (_isNeedAutoPlay == true) {
        [self photoAVPlayerActionViewPauseOrStop];
    }
}

/**
 reset avplayer
 */
- (void)videoPlayerWillReset{
    [self removeTimeObserver];
    if (_player) {
        [_player pause];
        _isPlaying = false;
    }
}

/**
 swipe player by hand
 */
- (void)videoWillSwipe{
    [_actionView avplayerActionViewNeedHidden:true];
    [_actionBar setHidden:true];
}

/**
 set player rate
 */
- (void)videoPlayerSetRate:(CGFloat)rate{
    if (_isPlaying == false) {
        return;
    }
    
    _player.rate = rate;
}

/**
 setup player
 
 @param isNeedRecreate is or not need reset placeHolder
 */
- (void)setupPlayer:(BOOL)isNeedRecreate{
    _player = [AVPlayer playerWithPlayerItem:_item];
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    [self.playerView.layer addSublayer:_playerLayer];
    [self addSubview:self.playerBgView];
    
    if (_placeHolder && isNeedRecreate) {
        [self.placeHolderImgView setImage:_placeHolder];
        [self.playerBgView addSubview:self.placeHolderImgView];
    }
    
    [self.playerBgView addSubview:self.playerView];
}

/**
 setup actionView and actionBar
 */
- (void)setupActionView{
    
    KNPhotoAVPlayerActionView *actionView = [[KNPhotoAVPlayerActionView alloc] init];
    [actionView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(photoAVPlayerActionViewDidLongPress:)]];
    [actionView setDelegate:self];
    [actionView setIsBuffering:false];
    [actionView setIsPlaying:false];
    [self addSubview:actionView];
    _actionView = actionView;
    
    KNPhotoAVPlayerActionBar *actionBar = [[KNPhotoAVPlayerActionBar alloc] init];
    [actionBar setBackgroundColor:[UIColor colorWithRed:45/255.0 green:45/255.0 blue:45/255.0 alpha:1]];
    [actionBar setDelegate:self];
    [actionBar setHidden:true];
    
    [self addSubview:actionBar];
    _actionBar = actionBar;
}

/**
 add item of player observer
 */
- (void)addItemObserver{
    if (_item) {
        [_item addObserver:self forKeyPath:@"status"            options:NSKeyValueObservingOptionNew context:nil];
        [_item addObserver:self forKeyPath:@"loadedTimeRanges"  options:NSKeyValueObservingOptionNew context:nil];
        _isAddObserver = true;
    }
    
    __weak typeof(self) weakself = self;
    
    [self removeTimeObserver];
    
    self.timeObserver = [_player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        __strong typeof(weakself) strongself = weakself;
        if (CMTimeGetSeconds(time) == strongself.actionBar.allDuration) {
            if (strongself.actionBar.allDuration != 0) {
                [strongself videoDidPlayToEndTime];
            }
            strongself.actionBar.currentTime = 0;
        }else{
            if (strongself.isDragging == true) {
                strongself.isDragging = false;
                return;
            }
            strongself.actionBar.currentTime = CMTimeGetSeconds(time);
        }
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(videoDidPlayToEndTime)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:nil];
}

/**
 remove item of player observer
 */
- (void)removeItemObserver{
    if (_item && _isAddObserver) {
        [_item removeObserver:self forKeyPath:@"status" context:nil];
        [_item removeObserver:self forKeyPath:@"loadedTimeRanges" context:nil];
        _isAddObserver = false;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if (object != self.item) return;
    
    if (_isEnterBackground) return;
    
    if ([keyPath isEqualToString:@"status"]) { // play
        if (_player.currentItem.status == AVPlayerStatusReadyToPlay) {
            [_player play];
            [_actionBar setIsPlaying:true];
            [_actionView setIsPlaying:true];
            [_actionView setIsBuffering:false];
        }
    }else if ([keyPath isEqualToString:@"loadedTimeRanges"]) { // buffering
        if (!_isGetAllPlayItem) {
            _isGetAllPlayItem = true;
            _actionBar.allDuration = CMTimeGetSeconds(_player.currentItem.duration);
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

/**
 current video is end
 */
- (void)videoDidPlayToEndTime{
    _isGetAllPlayItem = false;
    _isPlaying = false;
    if (_player) {
        __weak typeof(self) weakself = self;
        [_player seekToTime:CMTimeMake(1, 1) completionHandler:^(BOOL finished) {
            if (finished) {
                weakself.actionBar.currentTime = 0;
                [weakself.actionBar setIsPlaying:false];
                [weakself.actionView setIsPlaying:false];
            }
        }];
    }
}

/**
 app will resign active
 */
- (void)appWillResignActive{
    [self.player pause];
    [_actionBar setIsPlaying:false];
    [_actionView setIsPlaying:false];
    _isEnterBackground = true;
}

- (void)layoutSubviews{
    self.playerBgView.frame = CGRectMake(10, 0, self.frame.size.width - 20, self.frame.size.height);
    self.playerView.frame   = self.playerBgView.bounds;
    self.playerLayer.frame  = self.playerView.bounds;
    self.actionView.frame   = self.playerBgView.frame;
    self.placeHolderImgView.frame  = self.playerBgView.bounds;
    self.actionBar.frame    = CGRectMake(15, self.frame.size.height - 50, self.frame.size.width - 30, 40);
}

/****************************** == Delegate == ********************************/
- (void)photoAVPlayerActionViewPauseOrStop{
    _isEnterBackground = false;
    if (_isPlaying == false) {
        if (_player) {
            
            _isPlaying = true;
            
            if (_url == nil) return;
            
            [self removeItemObserver];
            if (_player) {
                [self removeAVPlayerAndActionView];
            }
            
            if ([_url hasPrefix:@"http"]) {
                _item = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:_url]];
            } else {
                _item = [AVPlayerItem playerItemWithAsset:[AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:_url] options:nil]];
            }
            [self setupPlayer:false];
            [self setupActionView];
            [self addItemObserver];
            
            [_actionBar setIsPlaying:false];
            [_actionView setIsPlaying:true];
            [_actionView setIsBuffering:true];
            
        }
    } else {
        [_player play];
        _isPlaying = true;
        [_actionBar setIsPlaying:true];
        [_actionView setIsPlaying:true];
        [_actionView setIsBuffering:false];
    }
}

/**
 avplayer will dismiss
 */
- (void)photoAVPlayerActionViewDismiss{
    if ([_delegate respondsToSelector:@selector(photoAVPlayerViewDismiss)]) {
        [_delegate photoAVPlayerViewDismiss];
    }
}
/**
 avplayer did long press
 */
- (void)photoAVPlayerActionViewDidLongPress:(UILongPressGestureRecognizer *)longPress{
    if (_isPlaying == false) {
        return;
    }
    if ([_delegate respondsToSelector:@selector(photoAVPlayerLongPress:)]) {
        [_delegate photoAVPlayerLongPress:longPress];
    }
}

/**
 avplayer hidden actionBar or not

 @param isHidden is need to Hidden
 */
- (void)photoAVPlayerActionViewDidClickIsHidden:(BOOL)isHidden{
    if (self.isPlaying) {
        [_actionBar setHidden:isHidden];
    }
}

/**
 actionBar click play or pause btn

 @param isNeedPlay current player is or not need to play
 */
- (void)photoAVPlayerActionBarClickWithIsPlay:(BOOL)isNeedPlay{
    if (isNeedPlay) {
        [_player play];
        _isPlaying = true;
        [_actionView setIsPlaying:true];
        [_actionBar setIsPlaying:true];
    }else {
        [_player pause];
        _isPlaying = false;
        [_actionView setIsPlaying:false];
        [_actionBar setIsPlaying:false];
    }
}

/**
 actionBar change value
 
 @param value value
 */
- (void)photoAVPlayerActionBarChangeValue:(float)value{
    _isDragging = true;
    [_player seekToTime:CMTimeMake(value, 1) completionHandler:^(BOOL finished) {
        if (finished) {
            
        }
    }];
}

- (void)dealloc{
    if (_player && self.timeObserver) {
        [_player removeTimeObserver:self.timeObserver];
        self.timeObserver = nil;
    }
    [self removeItemObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
