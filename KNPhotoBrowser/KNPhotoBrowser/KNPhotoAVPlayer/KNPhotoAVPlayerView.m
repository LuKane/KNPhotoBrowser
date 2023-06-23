//
//  KNPhotoAVPlayerView.m
//  KNPhotoBrowser
//
//  Created by LuKane on 2019/6/14.
//  Copyright © 2019 LuKane. All rights reserved.
//

#import "KNPhotoAVPlayerView.h"
#import "KNPhotoAVPlayerActionBar.h"
#import "KNPhotoAVPlayerActionView.h"
#import "KNPhotoBrowserPch.h"

@interface KNPhotoAVPlayerView ()<KNPhotoAVPlayerActionViewDelegate,KNPhotoAVPlayerActionBarDelegate>

@property (nonatomic,strong) AVPlayer       *player;
@property (nonatomic,strong) AVPlayerItem   *item;

@property (nonatomic,strong) KNPhotoAVPlayerActionView *actionView;
@property (nonatomic,strong) KNPhotoAVPlayerActionBar  *actionBar;

@property (nonatomic,copy  ) NSString *url;
@property (nonatomic,strong) UIImage *placeHolder;

@property (nonatomic,strong) id timeObserver;

@property (nonatomic,assign) BOOL isPlaying;
@property (nonatomic,assign) BOOL isDragging;
@property (nonatomic,assign) BOOL isEnterBackground;
@property (nonatomic,assign) BOOL isAddObserver;
@property (nonatomic,assign) BOOL videoIsSwiping; // current video player is swiping?

@end

@implementation KNPhotoAVPlayerView {
    float _allDuration;
}

- (KNPhotoAVPlayerActionView *)actionView{
    if (!_actionView) {
        _actionView = [[KNPhotoAVPlayerActionView alloc] init];
        [_actionView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(photoAVPlayerActionViewDidLongPress:)]];
        _actionView.delegate = self;
        _actionView.isBuffering = false;
        _actionView.isPlaying = false;
    }
    return _actionView;
}
- (KNPhotoAVPlayerActionBar *)actionBar{
    if (!_actionBar) {
        _actionBar = [[KNPhotoAVPlayerActionBar alloc] init];
        _actionBar.backgroundColor = [UIColor colorWithRed:45/255.0 green:45/255.0 blue:45/255.0 alpha:1.];
        _actionBar.delegate = self;
        _actionBar.isPlaying = false;
        _actionBar.hidden = true;
    }
    return _actionBar;
}

- (UIView *)playerBgView{
    if (!_playerBgView) {
        _playerBgView = [[UIView alloc] init];
    }
    return _playerBgView;
}
- (UIView *)playerView{
    if (!_playerView) {
        _playerView = [[UIView alloc] init];
        _playerView.backgroundColor = UIColor.blackColor;
    }
    return _playerView;
}
- (UIImageView *)placeHolderImgView{
    if (!_placeHolderImgView) {
        _placeHolderImgView = [[UIImageView alloc] init];
        _placeHolderImgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _placeHolderImgView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.player = [AVPlayer playerWithPlayerItem:_item];
        self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
        [self.playerView.layer addSublayer:_playerLayer];
        
        [self.playerBgView addSubview:self.placeHolderImgView];
        [self.playerBgView addSubview:self.playerView];
        
        [self addSubview:self.playerBgView];
        [self addSubview:self.actionView];
        BOOL isNeedCustomActionBar = [KNPhotoBrowserConfig share].isNeedCustomActionBar;
        if (isNeedCustomActionBar == false) {
            [self addSubview:self.actionBar];
        }
    }
    return self;
}

- (void)playerOnLinePhotoItems:(KNPhotoItems *)photoItems placeHolder:(UIImage *_Nullable)placeHolder{
    
    _allDuration = 0.0;
    
    [self removePlayerItemObserver];
    [self removeTimeObserver];
    [self addObserverAndAudioSession];
    
    _url = photoItems.url;
    _placeHolder = placeHolder;
    
    if (placeHolder) {
        _placeHolderImgView.image = placeHolder;
    }
    
    if ([photoItems.url hasPrefix:@"http"]) {
        _item = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:photoItems.url]];
    }else {
        _item = [AVPlayerItem playerItemWithAsset:[AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:_url] options:nil]];
    }
    
    _item.canUseNetworkResourcesForLiveStreamingWhilePaused = true;
    [self.player replaceCurrentItemWithPlayerItem:_item];
    
    [_actionView avplayerActionViewNeedHidden:false];
    
    _isEnterBackground = _isAddObserver = _isDragging = _isPlaying = false;
    
    [self addPlayerItemObserver];
    
    /// default rate
    _player.rate = 1.0;
    
    [_player pause];
}

- (void)playerCustomActionBar:(KNPhotoAVPlayerActionBar *)customBar {
    BOOL isNeedCustomActionBar = [KNPhotoBrowserConfig share].isNeedCustomActionBar;
    if (isNeedCustomActionBar == false) { return; }
    
    if (customBar == nil) { return; }
    
    [_actionBar removeFromSuperview];
    _actionBar = customBar;
    _actionBar.delegate = self;
    _actionBar.isPlaying = false;
    _actionBar.hidden = true;
    _actionBar.allDuration = CMTimeGetSeconds(_player.currentItem.duration);
    _actionBar.currentTime = _allDuration;
    [self addSubview:_actionBar];
    
    [self layoutSubviews];
}

- (void)addObserverAndAudioSession{
    // AudioSession setting
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:true error:nil];
    if(_isSoloAmbient == true) {
        [session setCategory:AVAudioSessionCategorySoloAmbient error:nil];
    }else {
        [session setCategory:AVAudioSessionCategoryAmbient error:nil];
    }
    
    // Notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
}

/// notification function
- (void)applicationWillResignActive{
    _isEnterBackground = true;
    if (_isPlaying) [self photoAVPlayerActionBarClickWithIsPlay:false];
}

/// remove item observer
- (void)removePlayerItemObserver{
    if (_item && _isAddObserver) {
        [_item removeObserver:self forKeyPath:@"status"                 context:nil];
        [_item removeObserver:self forKeyPath:@"loadedTimeRanges"       context:nil];
        [_item removeObserver:self forKeyPath:@"playbackBufferEmpty"    context:nil];
        [_item removeObserver:self forKeyPath:@"playbackLikelyToKeepUp" context:nil];
        _isAddObserver = false;
    }
}
/// add item observer
- (void)addPlayerItemObserver{
    if (_item) {
        [_item addObserver:self forKeyPath:@"status"                 options:NSKeyValueObservingOptionNew context:nil];
        [_item addObserver:self forKeyPath:@"loadedTimeRanges"       options:NSKeyValueObservingOptionNew context:nil];
        [_item addObserver:self forKeyPath:@"playbackBufferEmpty"    options:NSKeyValueObservingOptionNew context:nil];
        [_item addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
        _isAddObserver = true;
    }
    
    __weak typeof(self) weakself = self;
    self.timeObserver = [_player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        weakself.isBeginPlayed = true;
        __strong typeof(weakself) strongself = weakself;
        if (CMTimeGetSeconds(time) == strongself.actionBar.allDuration) {
            if (strongself.actionBar.allDuration != 0) {
                [strongself videoDidPlayToEndTime];
            }
            strongself.actionBar.currentTime = 0;
        }else{
            if (strongself.isDragging == false) {
                strongself.actionBar.currentTime = CMTimeGetSeconds(time);
            }
        }
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(videoDidPlayToEndTime)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:nil];
}

/// remove time observer
- (void)removeTimeObserver{
    if (_timeObserver && _player) {
        @try {
            [_player removeTimeObserver: _timeObserver];
        } @catch (NSException *exception) {
            
        } @finally {
            _timeObserver = nil;
        }
    }
}

- (void)videoDidPlayToEndTime{
    
    __weak typeof(self) weakself = self;
    
    if (_isNeedLoopPlay == true) {
        [_player seekToTime:CMTimeMake(1, 1) completionHandler:^(BOOL finished) {
            if (finished) {
                weakself.actionBar.currentTime = 0;
                weakself.actionBar.isPlaying = false;
                weakself.actionView.isPlaying = false;
                weakself.isPlaying = false;
                [weakself.actionView avplayerActionViewNeedHidden:weakself.videoIsSwiping];
                [weakself photoAVPlayerActionViewPauseOrStop];
            }
        }];
        return;
    }
    
    _isPlaying = false;
    if (_player) {
         if (_player.currentItem.status == AVPlayerStatusReadyToPlay) {
            [_player seekToTime:CMTimeMake(1, 1) completionHandler:^(BOOL finished) {
                if (finished) {
                    weakself.actionBar.currentTime = 0;
                    weakself.actionBar.isPlaying = false;
                    weakself.actionView.isPlaying = false;
                    [weakself.actionView avplayerActionViewNeedHidden:weakself.videoIsSwiping];
                }
            }];
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if (object != self.item) return;
    
    if (_isEnterBackground) return;
    
    if ([keyPath isEqualToString:@"status"]) { // play
        if (_player.currentItem.status == AVPlayerStatusReadyToPlay) {
            _actionView.isBuffering = false;
        }
    }else if ([keyPath isEqualToString:@"loadedTimeRanges"]) { // buffering
        float duration = CMTimeGetSeconds(_player.currentItem.duration);
        _actionBar.allDuration = duration;
        _allDuration = duration;
    }else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) { // empty
        _actionView.isBuffering = true;
    }else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) { // full
        _actionView.isBuffering = false;
        if (_isPlaying == true) {
            [_player play];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

/// function
- (void)playerWillReset{
    [_player pause];
    _isPlaying = false;
    [self removeTimeObserver];
    [self removePlayerItemObserver];
}
- (void)playerWillSwipe{
    [_actionView avplayerActionViewNeedHidden:true];
    _actionBar.hidden = true;
    _videoIsSwiping = true;
}

- (void)playerWillSwipeCancel {
    _videoIsSwiping = false;
    if (_actionBar.currentTime == 0) {
        [_actionView avplayerActionViewNeedHidden:false];
    }
}

- (void)playerRate:(CGFloat)rate{
    if (_isPlaying == false) {
        return;
    }
    
    _player.rate = rate;
}

/// setter
- (void)setIsNeedAutoPlay:(BOOL)isNeedAutoPlay {
    _isNeedAutoPlay = isNeedAutoPlay;
    if (isNeedAutoPlay) {
        _actionView.isBuffering = true;
        [self photoAVPlayerActionViewPauseOrStop];
    }
}
- (void)setIsNeedVideoPlaceHolder:(BOOL)isNeedVideoPlaceHolder{
    _isNeedVideoPlaceHolder = isNeedVideoPlaceHolder;
    self.placeHolderImgView.hidden = !isNeedVideoPlaceHolder;
}
- (void)setIsNeedVideoDismissButton:(BOOL)isNeedVideoDismissButton {
    _isNeedVideoDismissButton = isNeedVideoDismissButton;
    _actionView.isNeedVideoDismissButton = isNeedVideoDismissButton;
}
- (void)photoAVPlayerActionViewDidLongPress:(UILongPressGestureRecognizer *)longPress{
    if (_isPlaying == false) {
        return;
    }
    if ([_delegate respondsToSelector:@selector(photoPlayerLongPress:)]) {
        [_delegate photoPlayerLongPress:longPress];
    }
}

/// delegate
/**
 actionView's Pause imageView
 */
- (void)photoAVPlayerActionViewPauseOrStop{
    _isEnterBackground = false;
    if (_isPlaying == false) {
        [_player play];
        _actionBar.isPlaying = true;
        _actionView.isPlaying = true;
    }else {
        [_player pause];
        _actionView.isPlaying = false;
        _actionBar.isPlaying = false;
    }
    _isPlaying = !_isPlaying;
}
- (void)photoAVPlayerActionViewDismiss{
    if ([_delegate respondsToSelector:@selector(photoPlayerViewDismiss)]) {
        [_delegate photoPlayerViewDismiss];
    }
}
- (void)photoAVPlayerActionViewDidClickIsHidden:(BOOL)isHidden{
    [_actionBar setHidden:isHidden];
}
- (void)photoAVPlayerActionBarClickWithIsPlay:(BOOL)isNeedPlay{
    if (isNeedPlay) {
        [_player play];
        _actionView.isPlaying = true;
        _actionBar.isPlaying = true;
        _isPlaying = true;
    }else {
        [_player pause];
        _actionView.isPlaying = false;
        _actionBar.isPlaying = false;
        _isPlaying = false;
    }
}
- (void)photoAVPlayerActionBarBeginChange{
    _isDragging = true;
}
- (void)photoAVPlayerActionBarChangeValue:(float)value{
    __weak typeof(self) weakself = self;
    [_player seekToTime:CMTimeMake(value, 1) toleranceBefore:CMTimeMake(1, 1000) toleranceAfter:CMTimeMake(1, 1000) completionHandler:^(BOOL finished) {
        if (finished == true) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                weakself.isDragging = false;
            });
        }
    }];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.playerBgView.frame = CGRectMake(10, 0, self.frame.size.width - 20, self.frame.size.height);
    self.playerView.frame   = self.playerBgView.bounds;
    self.playerLayer.frame  = self.playerView.bounds;
    self.actionView.frame   = self.playerBgView.frame;
    self.placeHolderImgView.frame  = self.playerBgView.bounds;
    
    if (PBDeviceHasBang) {
        self.actionBar.frame = CGRectMake(15, self.frame.size.height - 70, self.frame.size.width - 30, 40);
    }else {
        self.actionBar.frame = CGRectMake(15, self.frame.size.height - 50, self.frame.size.width - 30, 40);
    }
}

- (void)dealloc{
    [self removeObserverAndAudioSesstion];
    if (_player && self.timeObserver) {
        [_player removeTimeObserver:self.timeObserver];
        self.timeObserver = nil;
    }
}

- (void)removeObserverAndAudioSesstion{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[AVAudioSession sharedInstance] setActive:false withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
}

@end
