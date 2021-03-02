//
//  CustomSourceView2.m
//  KNPhotoBrowser
//
//  Created by LuKane on 2021/3/2.
//  Copyright © 2021 LuKane. All rights reserved.
//

#import "CustomSourceView2.h"

@implementation CustomSourceView2

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupSubView];
    }
    return self;
}

- (void)setupSubView{
    
    UILabel *l = [[UILabel alloc] initWithFrame:self.bounds];
    [self addSubview:l];
    
    UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
    b.frame = self.bounds;
    [self addSubview:b];
    
    _imgV = [[CustomSourceImageView2 alloc] initWithFrame:self.bounds];
    [self addSubview:_imgV];
}

@end
