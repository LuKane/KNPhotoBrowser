//
//  KNPhotoLocateAVPlayerView.h
//  KNPhotoBrowser
//
//  Created by LuKane on 2021/5/12.
//  Copyright © 2021 LuKane. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "KNPhotoPlayerProtocol.h"
#import "KNPhotoBrowser.h"
#import "KNPhotoDownloadMgr.h"

@class KNProgressHUD;

NS_ASSUME_NONNULL_BEGIN

@interface KNPhotoLocateAVPlayerView : UIView

/// create locate player with photoItems
/// @param photoItems photoItems
/// @param progressHUD progressHUD
/// @param placeHolder placeHolder image
- (void)playerLocatePhotoItems:(KNPhotoItems *)photoItems progressHUD:(KNProgressHUD *)progressHUD placeHolder:(UIImage *_Nullable)placeHolder;

/// reset AVPlayer
- (void)playerWillReset;

/// AVPlayer will be swiped by hand
- (void)playerWillSwipe;

/// AVPlayer will cancel swipe
- (void)playerWillSwipeCancel;

/// AVPlayer play as rate
/// @param rate rate
- (void)playerRate:(CGFloat)rate;

/// custom actionbar
/// @param customBar actionbar
- (void)playerCustomActionBar:(KNPhotoAVPlayerActionBar *)customBar;

/// when dismiss, should cancel download task first
- (void)cancelDownloadMgrTask;

/// playerdownload
/// @param downloadBlock download callBack
- (void)playerDownloadBlock:(PhotoDownLoadBlock)downloadBlock;

/**
 * is or not need Video placeHolder
 */
@property (nonatomic,assign) BOOL isNeedVideoPlaceHolder;

/**
 * auto play when you need
 */
@property (nonatomic,assign) BOOL isNeedAutoPlay;

/**
 * player view
 */
@property (nonatomic,strong,nullable) UIView *playerView;

/**
 * player background view (as locate current location for swipe)
 */
@property (nonatomic,strong,nullable) UIView *playerBgView;

/**
 * placeHolder imageView
 */
@property (nonatomic,strong,nullable) UIImageView *placeHolderImgView;

/**
 * layer of player
 */
@property (nonatomic,strong,nullable) AVPlayerLayer *playerLayer;

/**
 * if video has played ,even though one seconds : TRUE
 */
@property (nonatomic,assign) BOOL isBeginPlayed;

/**
 * default is solo ambient : TRUE `AVAudioSessionCategorySoloAmbient`
 * if set false, that will be `AVAudioSessionCategoryAmbient`
 */
@property (nonatomic, assign) BOOL isSoloAmbient;

/**
 * the video player has leftTop's dismiss button
 * touch this button, photoBrowser will dismiss or popback, default is true
 */
@property (nonatomic,assign) BOOL isNeedVideoDismissButton;

/**
 * delegate
 */
@property (nonatomic,weak  ) id<KNPhotoPlayerViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
