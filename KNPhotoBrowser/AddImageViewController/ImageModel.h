//
//  ImageModel.h
//  KNPhotoBrowser
//
//  Created by jmcl on 2020/10/14.
//  Copyright © 2020 LuKane. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageModel : NSObject

@property(nonatomic,strong)UIImage *image;

@property(nonatomic,copy)NSString *path;

/// 1图片 2gif 3视频
@property(nonatomic,assign)NSInteger type;


@end

NS_ASSUME_NONNULL_END
