//
//  KNPhotoBaseCell.h
//  KNPhotoBrowser
//
//  Created by LuKane on 2018/12/14.
//  Copyright © 2018 LuKane. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KNPhotoBrowserImageView.h"
#import "KNProgressHUD.h"

#import "KNPhotoBrowerLocateGifImageView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^PhotoBrowerSingleTap)(void);
typedef void(^PhotoBrowerLongPressTap)(void);

typedef void(^LocateGifSingleTap)(void);
typedef void(^LocateGifLongPressTap)(void);

@interface KNPhotoBaseCell : UICollectionViewCell

- (void)sd_ImageWithUrl:(NSString *)url placeHolder:(UIImage *)placeHolder;

@property (nonatomic,strong) KNPhotoBrowserImageView *photoBrowerImageView;
@property (nonatomic,copy  ) PhotoBrowerSingleTap singleTap;
@property (nonatomic,copy  ) PhotoBrowerLongPressTap longPressTap;

@end


/// 展示本地gif图数据cell
@interface KNPhotoOfLocateGifBaseCell : UICollectionViewCell

@property(nonatomic,strong)KNPhotoBrowerLocateGifImageView *gifImageView;

@property (nonatomic,copy  ) LocateGifSingleTap gifSingleTap;
@property (nonatomic,copy  ) LocateGifLongPressTap gifLongPressTap;

@end

NS_ASSUME_NONNULL_END
