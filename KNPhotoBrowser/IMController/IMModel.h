//
//  IMModel.h
//  KNPhotoBrowser
//
//  Created by LuKane on 2019/2/1.
//  Copyright © 2019 LuKane. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMModel : NSObject

@property (nonatomic,copy  ) NSString *url;
@property (nonatomic,strong) UIImage *locImage;
@property (nonatomic,assign) BOOL isLeft;
@property (nonatomic,assign) BOOL isVideo;

// width / height
@property (nonatomic,assign) CGFloat rate;

@property (nonatomic,assign) CGFloat  cellHeight;

@end

NS_ASSUME_NONNULL_END
