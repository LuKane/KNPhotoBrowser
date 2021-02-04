//
//  KNPhotoAVPlayerView.h
//  KNPhotoBrowser
//
//  Created by LuKane on 2019/6/14.
//  Copyright © 2019 LuKane. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

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
 is or not need Video placeHolder
 */
@property (nonatomic,assign) BOOL isNeedVideoPlaceHolder;

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
 if video has played ,even though one seconds : TRUE
 */
@property (nonatomic,assign) BOOL isBeginPlayed;

/**
 delegate
 */
@property (nonatomic,weak  ) id<KNPhotoAVPlayerViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
