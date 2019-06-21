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
 stop play current item
 */
- (void)stopPlay;

@property (nonatomic,copy  ) NSString *url;
@property (nonatomic,strong) UIImage *placeHolder;

@property (nonatomic,weak  ) id<KNPhotoAVPlayerViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END