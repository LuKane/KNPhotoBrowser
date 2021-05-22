//
//  SendImageItem.m
//  KNPhotoBrowser
//
//  Created by LuKane on 2021/5/23.
//  Copyright © 2021 LuKane. All rights reserved.
//

#import "SendImageItem.h"

@implementation SendImageItem

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews{
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:imgView];
    self.imgView = imgView;
    
    UIImageView *deleteView = [[UIImageView alloc] initWithFrame:CGRectMake(imgView.frame.size.width - 12.5, -12.5, 25, 25)];
    deleteView.image = [UIImage imageNamed:@"sendImageDelete"];
    deleteView.layer.cornerRadius = 15;
    deleteView.clipsToBounds = true;
    [self addSubview:deleteView];
    
    imgView.userInteractionEnabled = true;
    deleteView.userInteractionEnabled = true;
    
    [imgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgViewDidClick)]];
    [deleteView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteViewDidClick)]];
}

- (void)imgViewDidClick{
    if ([_delegate respondsToSelector:@selector(sendImageItemImageViewDidClick:)]) {
        [_delegate sendImageItemImageViewDidClick:self.tag];
    }
}
- (void)deleteViewDidClick{
    if ([_delegate respondsToSelector:@selector(sendImageItemDeleteDidClick:)]) {
        [_delegate sendImageItemDeleteDidClick:self.tag];
    }
}

@end
