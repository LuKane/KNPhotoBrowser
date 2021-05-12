//
//  KNPhotoImageCell.h
//  KNPhotoBrowser
//
//  Created by LuKane on 2018/12/14.
//  Copyright © 2018 LuKane. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KNPhotoBrowserImageView.h"
#import "KNProgressHUD.h"

@class KNPhotoItems;

NS_ASSUME_NONNULL_BEGIN

typedef void(^PhotoBrowerSingleTap)(void);
typedef void(^PhotoBrowerLongPressTap)(void);

@interface KNPhotoImageCell : UICollectionViewCell

/// set image with url
/// @param url url
/// @param placeHolder placeHolder image
/// @param photoItem curent photoItem
- (void)imageWithUrl:(NSString *)url placeHolder:(UIImage *)placeHolder photoItem:(KNPhotoItems *)photoItem;

@property (nonatomic,strong) KNPhotoBrowserImageView *photoBrowerImageView;
@property (nonatomic,copy  ) PhotoBrowerSingleTap singleTap;
@property (nonatomic,copy  ) PhotoBrowerLongPressTap longPressTap;

@property (nonatomic,assign) UIViewContentMode presentedMode;

@end

NS_ASSUME_NONNULL_END
