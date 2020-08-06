//
//  KNPhotoAVPlayerView.h
//  KNPhotoBrowser
//
//  Created by LuKane on 2019/6/14.
//  Copyright © 2019 LuKane. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "KNPhotoAVPlayerActionView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol KNPhotoAVPlayerViewDelegate <NSObject>

/**
 avplayer dimiss
 */
- (void)photoAVPlayerViewDismiss;
/**
 avplayer long press
 */
- (void)photoAVPlayerLongPress:(UILongPressGestureRecognizer *)longPress;

@end

@interface KNPhotoAVPlayerView : UIView

/**
 create observe player with url ,ready to play
 
 @param url url
 @param placeHolder placeHolder image
 */
- (void)playerWithURL:(NSString *)url
          placeHolder:(UIImage *_Nullable)placeHolder;

/**
 reset avplayer
 */
- (void)videoPlayerWillReset;

/**
 swipe player by hand
 */
- (void)videoWillSwipe;

/**
 set player rate
 */
- (void)videoPlayerSetRate:(CGFloat)rate;

/**
auto play when you need
 */
@property (nonatomic,assign) BOOL isNeedAutoPlay;

/**
 player view
 */
@property (nonatomic,strong,nullable) UIView *playerView;

/**
 player background view (as locate current location for swipe)
 */
@property (nonatomic,strong,nullable) UIView *playerBgView;

/**
 placeHolder imageView
*/
@property (nonatomic,strong,nullable) UIImageView *placeHolderImgView;

/**
 current url
 */
@property (nonatomic,copy  ) NSString *url;

/**
 placeHolder image for temp image of current url
 */
@property (nonatomic,strong) UIImage *placeHolder;

/**
 layer of player
 */
@property (nonatomic,strong,nullable) AVPlayerLayer  *playerLayer;

/**
 actionView : (pause | start | slider) and longPress
 */
@property (nonatomic,weak,nullable  ) KNPhotoAVPlayerActionView  *actionView;

@property (nonatomic,weak  ) id<KNPhotoAVPlayerViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
