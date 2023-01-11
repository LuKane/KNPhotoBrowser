//
//  KNPhotoBrowserConfig.h
//  KNPhotoBrowser
//
//  Created by LuKane on 2023/1/11.
//  Copyright © 2023 LuKane. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KNPhotoBrowserConfig : NSObject<NSCopying, NSMutableCopying>

/// is need custom bar, default is false
@property (nonatomic,assign) BOOL isNeedCustomActionBar;

+ (instancetype)share;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
