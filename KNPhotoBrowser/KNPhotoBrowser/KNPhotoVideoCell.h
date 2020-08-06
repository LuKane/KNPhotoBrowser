//
//  KNPhotoVideoCell.h
//  KNPhotoBrowser
//
//  Created by LuKane on 2019/6/11.
//  Copyright © 2019 LuKane. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KNPhotoAVPlayerView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol KNPhotoVideoCellDelegate <NSObject>

/// avplayer will dismmiss
- (void)photoVideoAVPlayerDismiss;

/// avplayer long press
/// @param longPress press
- (void)photoVideoAVPlayerLongPress:(UILongPressGestureRecognizer *)longPress;

@end

@interface KNPhotoVideoCell : UICollectionViewCell

- (void)playerWithURL:(NSString *)url placeHolder:(UIImage *_Nullable)placeHolder;

- (void)playerWillEndDisplay;

@property (nonatomic,assign) BOOL isNeedAutoPlay;
@property (nonatomic,weak  ) KNPhotoAVPlayerView *playerView;
@property (nonatomic,weak  ) id<KNPhotoVideoCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
