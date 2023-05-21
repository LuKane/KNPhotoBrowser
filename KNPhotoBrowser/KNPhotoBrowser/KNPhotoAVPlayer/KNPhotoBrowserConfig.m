//
//  KNPhotoBrowserConfig.m
//  KNPhotoBrowser
//
//  Created by LuKane on 2023/1/11.
//  Copyright © 2023 LuKane. All rights reserved.
//

#import "KNPhotoBrowserConfig.h"

@implementation KNPhotoBrowserConfig

static KNPhotoBrowserConfig *_instance;
static dispatch_once_t onceToken;

+ (instancetype)share {
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init];
    });
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self share];
}

- (id)copyWithZone:(NSZone *)zone {
    return _instance;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return _instance;
}

@end
