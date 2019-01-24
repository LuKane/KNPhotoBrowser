//
//  KNPhotoBrowserNumView.m
//  KNPhotoBrowser
//
//  Created by LuKane on 16/9/2.
//  Copyright © 2016年 LuKane. All rights reserved.
//

#import "KNPhotoBrowserNumView.h"

@implementation KNPhotoBrowserNumView

- (instancetype)init{
    if (self = [super init]) {
        [self setFont:[UIFont boldSystemFontOfSize:20]];
        [self setTextColor:[UIColor whiteColor]];
        [self setTextAlignment:NSTextAlignmentCenter];
    }
    return self;
}

- (void)setCurrentNum:(NSInteger)currentNum totalNum:(NSInteger)totalNum{
    _currentNum = currentNum;
    _totalNum = totalNum;
    [self changeText];
}

- (void)changeText{
    self.text = [NSString stringWithFormat:@"%zd / %zd",_currentNum,_totalNum];
}

- (void)setCurrentNum:(NSInteger)currentNum{
    _currentNum = currentNum;
    [self changeText];
}

- (void)setTotalNum:(NSInteger)totalNum{
    _totalNum = totalNum;
    [self changeText];
}

@end
