//
//  KNPhotoBrowerCell.h
//  KNPhotoBrower
//
//  Created by LuKane on 16/8/18.
//  Copyright © 2016年 LuKane. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SingleTap)();
typedef void(^LongPress)();

@interface KNPhotoBrowerCell : UICollectionViewCell

- (void)sd_ImageWithUrl:(NSString *)url placeHolder:(UIImage *)placeHolder;

@property (nonatomic, copy  ) SingleTap singleTap;
@property (nonatomic, copy  ) LongPress longPress;

@end
