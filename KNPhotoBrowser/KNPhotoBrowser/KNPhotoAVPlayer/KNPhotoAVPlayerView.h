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
 player view
 */
@property (nonatomic,strong,nullable) UIView *playerView;

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

@property (nonatomic,weak  ) id<KNPhotoAVPlayerViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
