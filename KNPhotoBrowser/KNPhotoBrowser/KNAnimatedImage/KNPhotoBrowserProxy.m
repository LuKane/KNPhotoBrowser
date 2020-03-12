//
//  KNPhotoBrowserProxy.m
//  KNPhotoBrowser
//
//  Created by LuKane on 2020/3/12.
//  Copyright © 2020 LuKane. All rights reserved.
//  

#import "KNPhotoBrowserProxy.h"

@interface KNPhotoBrowserProxy()

@property (nonatomic, weak) id target;

@end

@implementation KNPhotoBrowserProxy

+ (instancetype)weakProxyForObject:(id)targetObject{
    KNPhotoBrowserProxy *weakProxy = [KNPhotoBrowserProxy alloc];
    weakProxy.target = targetObject;
    return weakProxy;
}

- (id)forwardingTargetForSelector:(SEL)selector{
    return _target;
}

- (void)forwardInvocation:(NSInvocation *)invocation{
    void *nullPointer = NULL;
    [invocation setReturnValue:&nullPointer];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector{
    return [NSObject instanceMethodSignatureForSelector:@selector(init)];
}


@end
