//
//  KNPhotoBrowserProxy.h
//  KNPhotoBrowser
//
//  Created by LuKane on 2020/3/12.
//  Copyright © 2020 LuKane. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KNPhotoBrowserProxy : NSProxy

+ (instancetype)weakProxyForObject:(id)targetObject;

@end

NS_ASSUME_NONNULL_END
