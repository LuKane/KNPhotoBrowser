//
//  NineSquareModel.h
//  KNPhotoBrower
//
//  Created by LuKane on 16/9/18.
//  Copyright © 2016年 LuKane. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NineSquareUrlModel : NSObject

// 为 网络图片
@property (nonatomic, copy  ) NSString *url;

// 为 本地图片
@property (nonatomic, strong) UIImage *img;

@end

@interface NineSquareModel : NSObject

@property (nonatomic, copy  ) NSString *title;

// 存放 上面的那个model
@property (nonatomic, strong) NSMutableArray *urlArr;

@end

