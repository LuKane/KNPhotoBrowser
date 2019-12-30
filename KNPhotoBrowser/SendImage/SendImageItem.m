//
//  SendImageItem.m
//  KNPhotoBrowser
//
//  Created by LuKane on 2019/12/30.
//  Copyright © 2019 LuKane. All rights reserved.
//

#import "SendImageItem.h"



@implementation SendImageItem {
    UIImageView *_deleteView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews{
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:self.bounds];
    iconView.userInteractionEnabled = true;
    [iconView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconViewDidClick)]];
    [self addSubview:iconView];
    _iconView = iconView;
    
    UIImageView *deleteView = [[UIImageView alloc] initWithFrame:CGRectMake(iconView.frame.size.width - 10, -10, 20, 20)];
    deleteView.layer.cornerRadius = 10;
    deleteView.clipsToBounds = true;
    deleteView.backgroundColor = [UIColor redColor];
    [deleteView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteViewDidClick)]];
    deleteView.userInteractionEnabled = true;
    [iconView addSubview:deleteView];
    _deleteView = deleteView;
}

- (void)iconViewDidClick{
    if ([_delegate respondsToSelector:@selector(sendImageItemDidClick:)]) {
        [_delegate sendImageItemDidClick:self.tag];
    }
}

- (void)deleteViewDidClick{
    if ([_delegate respondsToSelector:@selector(sendImageItemDeleteClick:)]) {
        [_delegate sendImageItemDeleteClick:self.tag];
    }
}

@end
