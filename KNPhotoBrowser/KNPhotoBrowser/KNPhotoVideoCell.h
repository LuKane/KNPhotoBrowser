//
//  KNPhotoVideoCell.h
//  KNPhotoBrowser
//
//  Created by LuKane on 2019/6/11.
//  Copyright © 2019 LuKane. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KNPhotoAVPlayerView.h"
#import "KNPhotoLocateAVPlayerView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol KNPhotoVideoCellDelegate <NSObject>

/// avplayer will dismmiss
- (void)photoVideoAVPlayerDismiss;

/// avplayer long press
/// @param longPress press
- (void)photoVideoAVPlayerLongPress:(UILongPressGestureRecognizer *)longPress;

@end

@interface KNPhotoVideoCell : UICollectionViewCell

/// play video on line with photoItems and placeHolder's image
/// @param photoItems photoItems
/// @param placeHolder placeHolder image
- (void)playerOnLinePhotoItems:(KNPhotoItems *)photoItems placeHolder:(UIImage *_Nullable)placeHolder;

/// play video by download first with photoItems and placeHolder's image
/// @param photoItems photoItems
/// @param placeHolder placeHolder image
- (void)playerLocatePhotoItems:(KNPhotoItems *)photoItems placeHolder:(UIImage *_Nullable)placeHolder;

- (void)playerWillEndDisplay;

@property (nonatomic,assign) BOOL isNeedAutoPlay;
@property (nonatomic,assign) BOOL isNeedVideoPlaceHolder;

@property (nonatomic,weak  ) KNPhotoAVPlayerView *onlinePlayerView;
@property (nonatomic,weak  ) KNPhotoLocateAVPlayerView *locatePlayerView;
@property (nonatomic,weak  ) KNProgressHUD *progressHUD;

@property (nonatomic,weak  ) id<KNPhotoVideoCellDelegate> delegate;

@property (nonatomic,assign) UIViewContentMode presentedMode;

@end

NS_ASSUME_NONNULL_END
