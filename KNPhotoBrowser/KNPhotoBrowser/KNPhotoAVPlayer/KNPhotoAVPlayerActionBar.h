//
//  KNPhotoAVPlayerActionBar.h
//  KNPhotoBrowser
//
//  Created by LuKane on 2019/6/14.
//  Copyright © 2019 LuKane. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol KNPhotoAVPlayerActionBarDelegate <NSObject>

@optional
/**
 actionBar pause or stop btn did click
 
 @param isNeedPlay isNeedPlay
 */
- (void)photoAVPlayerActionBarClickWithIsPlay:(BOOL)isNeedPlay;

/**
 actionBar begin to move
 */
- (void)photoAVPlayerActionBarBeginChange;

/**
 actionBar value has changed by slider
 
 @param value value
 */
- (void)photoAVPlayerActionBarChangeValue:(float)value;

@end

@interface KNPhotoAVPlayerActionBar : UIView

/**
 current play time of the video
 */
@property (nonatomic,assign) float  currentTime;

/**
 duration of the video
 */
@property (nonatomic,assign) float  allDuration;

@property (nonatomic,weak  ) id<KNPhotoAVPlayerActionBarDelegate> delegate;

/**
 setter or getter of isPlaying of ActionBar
 */
@property (nonatomic,assign) BOOL  isPlaying;

/**
 reset all information of ActionBar
 */
- (void)resetActionBarAllInfo;

@end

NS_ASSUME_NONNULL_END
