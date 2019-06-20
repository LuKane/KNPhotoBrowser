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

/**
 actionBar pause or stop btn did click

 @param isNeedPlay isNeedPlay
 */
- (void)photoAVPlayerActionBarClickWithIsPlay:(BOOL)isNeedPlay;

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

@property (nonatomic,assign) BOOL  isPlaying;

@end

NS_ASSUME_NONNULL_END
