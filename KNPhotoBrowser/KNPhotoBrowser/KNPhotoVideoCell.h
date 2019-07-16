//
//  KNPhotoVideoCell.h
//  KNPhotoBrowser
//
//  Created by LuKane on 2019/6/11.
//  Copyright © 2019 LuKane. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KNPhotoAVPlayer/KNPhotoAVPlayerView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol KNPhotoVideoCellDelegate <NSObject>

- (void)photoVideoAVPlayerDismiss;

@end

@interface KNPhotoVideoCell : UICollectionViewCell

- (void)playerWithURL:(NSString *)url placeHolder:(UIImage *_Nullable)placeHolder;

- (void)playerWillEndDisplay;

@property (nonatomic,weak  ) KNPhotoAVPlayerView *playerView;
@property (nonatomic,weak  ) id<KNPhotoVideoCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
