//
//  KNPhotoBrowerCell.h
//  KNPhotoBrower
//
//  Created by LuKane on 16/8/18.
//  Copyright © 2016年 LuKane. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KNPhotoBrowerImageView.h"

typedef void(^SingleTap)();

@interface KNPhotoBrowerCell : UICollectionViewCell

- (void)sd_ImageWithUrl:(NSString *)url placeHolder:(UIImage *)placeHolder;

@property (nonatomic, copy  ) SingleTap singleTap;

@property (nonatomic, strong) KNPhotoBrowerImageView *photoBrowerImageView;

@end
