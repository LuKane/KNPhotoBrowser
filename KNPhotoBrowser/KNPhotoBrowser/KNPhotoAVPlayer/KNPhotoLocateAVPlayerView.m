//
//  KNPhotoLocateAVPlayerView.m
//  KNPhotoBrowser
//
//  Created by LuKane on 2021/5/12.
//  Copyright © 2021 LuKane. All rights reserved.
//

#import "KNPhotoLocateAVPlayerView.h"
#import "KNPhotoAVPlayerActionBar.h"
#import "KNPhotoAVPlayerActionView.h"
#import "KNPhotoBrowserPch.h"
#import "KNProgressHUD.h"
#import "KNReachability.h"

@interface KNPhotoLocateAVPlayerView()<KNPhotoAVPlayerActionViewDelegate,KNPhotoAVPlayerActionBarDelegate>

@property (nonatomic,strong) AVPlayer       *player;
@property (nonatomic,strong) AVPlayerItem   *item;

@property (nonatomic,strong) KNPhotoAVPlayerActionView *actionView;
@property (nonatomic,strong) KNPhotoAVPlayerActionBar  *actionBar;

@property (nonatomic,copy  ) NSString *url;
@property (nonatomic,strong) UIImage *placeHolder;

@property (nonatomic,strong) id timeObserver;

@property (nonatomic,assign) BOOL isPlaying;
@property (nonatomic,assign) BOOL isGetAllPlayItem;
@property (nonatomic,assign) BOOL isDragging;
@property (nonatomic,assign) BOOL isEnterBackground;
@property (nonatomic,assign) BOOL isAddObserver;
@property (nonatomic,assign) BOOL videoIsSwiping; // current video player is swiping?

@property (nonatomic,strong) KNPhotoDownloadMgr *downloadMgr;
@property (nonatomic,strong) KNPhotoItems *photoItems;
@property (nonatomic,weak  ) KNProgressHUD *progressHUD;
@property (nonatomic,copy  ) PhotoDownLoadBlock downloadBlock;
@end

@implementation KNPhotoLocateAVPlayerView


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
        _playerView.backgroundColor = UIColor.clearColor;
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
        [self addSubview:self.actionBar];
        
        _downloadBlock = nil;
    }
    return self;
}

- (void)playerLocatePhotoItems:(KNPhotoItems *)photoItems progressHUD:(KNProgressHUD *)progressHUD placeHolder:(UIImage *_Nullable)placeHolder{
    
    [self cancelDownloadMgrTask];
    
    [self removePlayerItemObserver];
    [self removeTimeObserver];
    [self addObserverAndAudioSession];
    
    _downloadBlock = nil;
    
    _url = photoItems.url;
    _placeHolder = placeHolder;
    _progressHUD = progressHUD;
    _photoItems  = photoItems;
    
    _downloadMgr = [[KNPhotoDownloadMgr alloc] init];
    
    if (placeHolder) {
        _placeHolderImgView.image = placeHolder;
    }
    
    _item = nil;
    
    if ([photoItems.url hasPrefix:@"http"]) {
        
        KNPhotoDownloadFileMgr *fileMgr = [[KNPhotoDownloadFileMgr alloc] init];
        if ([fileMgr startCheckIsExistVideo:photoItems]) {
            progressHUD.hidden = true;
            _actionView.isBuffering = true;
            
            NSString *filePath = [fileMgr startGetFilePath:photoItems];
            _item = [AVPlayerItem playerItemWithAsset:[AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:filePath] options:nil]];
        }
    }else {
        progressHUD.hidden = true;
        _actionView.isBuffering = true;
        _item = [AVPlayerItem playerItemWithAsset:[AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:_url] options:nil]];
    }
    
    _item.canUseNetworkResourcesForLiveStreamingWhilePaused = true;
    [self.player replaceCurrentItemWithPlayerItem:_item];
    
    [_actionView avplayerActionViewNeedHidden:false];
    
    _isEnterBackground = _isAddObserver = _isDragging = _isPlaying = false;
    
    if (_item != nil) [self addPlayerItemObserver];
    
    /// default rate
    _player.rate = 1.0;
    
    [_player pause];
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
        [_item removeObserver:self forKeyPath:@"status" context:nil];
        [_item removeObserver:self forKeyPath:@"loadedTimeRanges" context:nil];
        _isAddObserver = false;
    }
}
/// add item observer
- (void)addPlayerItemObserver{
    if (_item) {
        [_item addObserver:self forKeyPath:@"status"           options:NSKeyValueObservingOptionNew context:nil];
        [_item addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
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
    _isGetAllPlayItem = false;
    _isPlaying = false;
    if (_player) {
        __weak typeof(self) weakself = self;
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
            _placeHolderImgView.hidden = true;
        }
        _actionView.isBuffering = false;
    }else if ([keyPath isEqualToString:@"loadedTimeRanges"]) { // buffering
        if (!_isGetAllPlayItem) {
            _isGetAllPlayItem = true;
            _actionBar.allDuration = CMTimeGetSeconds(_player.currentItem.duration);
        }
        _actionView.isBuffering = false;
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
    _progressHUD.hidden = true;
    _videoIsSwiping = true;
}
/// AVPlayer will cancel swipe
- (void)playerWillSwipeCancel{
    KNPhotoDownloadFileMgr *fileMgr = [[KNPhotoDownloadFileMgr alloc] init];
    if ([self.photoItems.url hasPrefix:@"http"]) {
        if ([fileMgr startCheckIsExistVideo:self.photoItems] == false && _progressHUD.progress != 1.0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(PhotoBrowserAnimateTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self->_progressHUD.hidden = false;
            });
        }else {
            _progressHUD.hidden = true;
        }
    }else {
        _progressHUD.hidden = true;
    }
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
/// when dismiss, should cancel download task first
- (void)cancelDownloadMgrTask{
    if (_downloadMgr) [_downloadMgr cancelTask];
}
/// playerdownload
/// @param downloadBlock download callBack
- (void)playerDownloadBlock:(PhotoDownLoadBlock)downloadBlock{
    _downloadBlock = downloadBlock;
}

/// setter
- (void)setIsNeedAutoPlay:(BOOL)isNeedAutoPlay {
    _isNeedAutoPlay = isNeedAutoPlay;
    if (isNeedAutoPlay) {
        [self photoAVPlayerActionViewPauseOrStop];
    }
}
- (void)setIsNeedVideoPlaceHolder:(BOOL)isNeedVideoPlaceHolder{
    _isNeedVideoPlaceHolder = isNeedVideoPlaceHolder;
    self.placeHolderImgView.hidden = !isNeedVideoPlaceHolder;
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
    KNPhotoDownloadFileMgr *fileMgr = [[KNPhotoDownloadFileMgr alloc] init];
    if ([_photoItems.url hasPrefix:@"http"] == true && [fileMgr startCheckIsExistVideo:_photoItems] == false) {
        if (![[KNReachability reachabilityForInternetConnection] isReachable]) { // no network
            [_progressHUD setHidden:true];
            return;
        }
        _actionView.isDownloading = true;
        [_progressHUD setHidden:false];
        [_progressHUD setProgress:0.0];
        __weak typeof(self) weakself = self;
        [_downloadMgr downloadVideoWithPhotoItems:_photoItems downloadBlock:^(KNPhotoDownloadState downloadState, float progress) {
            [weakself.progressHUD setProgress:progress];
            if (downloadState == KNPhotoDownloadStateSuccess) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    KNPhotoDownloadFileMgr *manager = [[KNPhotoDownloadFileMgr alloc] init];
                    NSString *filePath = [manager startGetFilePath:weakself.photoItems];
                    weakself.item = [AVPlayerItem playerItemWithAsset:[AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:filePath] options:nil]];
                    weakself.item.canUseNetworkResourcesForLiveStreamingWhilePaused = true;
                    [weakself.player replaceCurrentItemWithPlayerItem:weakself.item];
                    [weakself.player play];
                    weakself.player.muted = true;
                    
                    weakself.progressHUD.progress = 1.0;
                    
                    weakself.isPlaying = true;
                    weakself.actionBar.isPlaying = true;
                    weakself.actionView.isBuffering = true;
                    weakself.actionView.isPlaying = true;
                    [weakself addPlayerItemObserver];
                });
            }
            if (downloadState == KNPhotoDownloadStateUnknow || downloadState == KNPhotoDownloadStateFailure) {
                [weakself.progressHUD setProgress:0.0];
            }
            if (weakself.downloadBlock) {
                weakself.downloadBlock(downloadState, progress);
            }
        }];
    }else {
        _progressHUD.hidden = true;
        if (_isPlaying == false) {
            [_player play];
            _player.muted = true;
            _actionBar.isPlaying = true;
            _actionView.isPlaying = true;
        }else {
            [_player pause];
            _actionView.isPlaying = false;
            _actionBar.isPlaying = false;
        }
        
        _isPlaying = !_isPlaying;
    }
    _isEnterBackground = false;
}
- (void)photoAVPlayerActionViewDismiss{
    [self cancelDownloadMgrTask];
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
        _player.muted = true;
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
        self.actionBar.frame    = CGRectMake(15, self.frame.size.height - 70, self.frame.size.width - 30, 40);
    }else {
        self.actionBar.frame    = CGRectMake(15, self.frame.size.height - 50, self.frame.size.width - 30, 40);
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
