//
//  KNPhotoAVPlayerView.h
//  KNPhotoBrowser
//
//  Created by LuKane on 2019/6/14.
//  Copyright © 2019 LuKane. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "KNPhotoPlayerProtocol.h"
#import "KNPhotoBrowser.h"

@class KNPhotoAVPlayerActionBar;

NS_ASSUME_NONNULL_BEGIN

@interface KNPhotoAVPlayerView : UIView

/// create locate player with photoItems
/// @param photoItems photoItem
/// @param placeHolder placeHolder image
- (void)playerOnLinePhotoItems:(KNPhotoItems *)photoItems placeHolder:(UIImage *_Nullable)placeHolder;

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
@property (nonatomic,assign) BOOL isSoloAmbient;

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
