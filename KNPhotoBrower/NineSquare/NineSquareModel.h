//
//  NineSquareModel.h
//  KNPhotoBrower
//
//  Created by LuKane on 16/9/18.
//  Copyright © 2016年 LuKane. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NineSquareUrlModel : NSObject

@property (nonatomic, copy  ) NSString *url;

@end

@interface NineSquareModel : NSObject

@property (nonatomic, copy  ) NSString *title;

// 存放 上面的那个model
@property (nonatomic, strong) NSMutableArray *urlArr;

@end

