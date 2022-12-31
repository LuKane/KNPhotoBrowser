//
//  KNPhotoAVPlayerActionView.h
//  KNPhotoBrowser
//
//  Created by LuKane on 2019/6/14.
//  Copyright © 2019 LuKane. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol KNPhotoAVPlayerActionViewDelegate <NSObject>

@optional
/**
 actionView's Pause imageView
 */
- (void)photoAVPlayerActionViewPauseOrStop;

/**
 actionView's dismiss imageView
 */
- (void)photoAVPlayerActionViewDismiss;

/**
 actionView
 */
- (void)photoAVPlayerActionViewDidClickIsHidden:(BOOL)isHidden;

/**
 is need to hidden PauseImgView
 */
- (void)photoAVPlayerActionViewNeedHiddenPauseImgView:(BOOL)isHidden;

@end

@interface KNPhotoAVPlayerActionView : UIView

/**
 avPlayerActionView need hidden or not
 */
- (void)avplayerActionViewNeedHidden:(BOOL)isHidden;

@property (nonatomic,weak  ) id<KNPhotoAVPlayerActionViewDelegate> delegate;

/**
 player is buffering or not
 */
@property (nonatomic,assign) BOOL  isBuffering;

/**
 current player is playing
 */
@property (nonatomic,assign) BOOL  isPlaying;

/**
 * current player is downloading
 */
@property (nonatomic,assign) BOOL isDownloading;

/**
 * is need leftTop dismiss button
 */
@property (nonatomic,assign) BOOL isNeedVideoDismissButton;

@end

NS_ASSUME_NONNULL_END
