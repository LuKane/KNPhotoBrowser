//
//  CustomSourceView1.m
//  KNPhotoBrowser
//
//  Created by LuKane on 2021/5/23.
//  Copyright © 2021 LuKane. All rights reserved.
//

#import "CustomSourceView1.h"

@implementation CustomSourceView1

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews{
    UILabel *l = [[UILabel alloc] initWithFrame:self.bounds];
    [self addSubview:l];
    
    UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
    b.frame = self.bounds;
    [self addSubview:b];
    
    CustomSourceImageView1 *imgView = [[CustomSourceImageView1 alloc] initWithFrame:self.bounds];
    self.imgView = imgView;
    [self addSubview:imgView];
}

@end
