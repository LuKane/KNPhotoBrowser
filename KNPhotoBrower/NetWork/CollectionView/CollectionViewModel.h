//
//  CollectionViewModel.h
//  KNPhotoBrower
//
//  Created by LuKane on 16/9/19.
//  Copyright © 2016年 LuKane. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CollectionViewModel : NSObject

@property (nonatomic, copy  ) NSString *url;// 图片url
@property (nonatomic, copy  ) NSString *width; // 宽度
@property (nonatomic, copy  ) NSString *height;// 高度

@property (nonatomic, strong) UIImage *img;

@end
