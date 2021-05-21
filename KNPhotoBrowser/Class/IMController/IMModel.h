//
//  IMModel.h
//  KNPhotoBrowser
//
//  Created by LuKane on 2021/5/21.
//  Copyright © 2021 LuKane. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMModel : NSObject

@property (nonatomic,copy  ) NSString *url;
@property (nonatomic,assign) BOOL isVideo;
@property (nonatomic,copy  ) NSString *videoPlaceHolderUrl;
@property (nonatomic,assign) BOOL isLeft;

/// image or video's width / height
@property (nonatomic,assign) CGFloat rate;

@end

NS_ASSUME_NONNULL_END
