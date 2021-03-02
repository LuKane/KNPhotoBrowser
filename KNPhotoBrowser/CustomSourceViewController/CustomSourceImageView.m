//
//  CustomSourceImageView.m
//  KNPhotoBrowser
//
//  Created by LuKane on 2021/3/1.
//  Copyright © 2021 LuKane. All rights reserved.
//

#import "CustomSourceImageView.h"

@implementation CustomSourceImageView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupSubView];
    }
    return self;
}

- (void)setupSubView{
    
    UILabel *l = [[UILabel alloc] initWithFrame:self.bounds];
    [self addSubview:l];
    
    _imgV = [[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:_imgV];
    
    UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
    b.userInteractionEnabled = false;
    b.frame = self.bounds;
    [self addSubview:b];
}

@end
