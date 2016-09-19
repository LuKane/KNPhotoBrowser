//
//  CollectionViewCell.m
//  KNPhotoBrower
//
//  Created by LuKane on 16/9/19.
//  Copyright © 2016年 LuKane. All rights reserved.
//

#import "CollectionViewCell.h"
#import "CollectionViewModel.h"
#import "UIImageView+WebCache.h"

@interface CollectionViewCell()

@property (nonatomic,assign) BOOL  didUpdateConstraints;

@end


@implementation CollectionViewCell



- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIImageView *iconView= [[UIImageView alloc] init];
        iconView.backgroundColor = [UIColor grayColor];
        [iconView setUserInteractionEnabled:YES];
        self.iconView = iconView;
        self.iconView.translatesAutoresizingMaskIntoConstraints = false;
        [self.contentView addSubview:self.iconView];
        // 更新布局
        [self updateConstraints];
    }
    return self;
}

- (void)setModel:(CollectionViewModel *)model{
    _model = model;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:nil];
}

- (void)updateConstraints {
    if (_didUpdateConstraints == false) {
        NSLayoutConstraint *iconViewT = [NSLayoutConstraint constraintWithItem:self.iconView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:0];
        NSLayoutConstraint *iconViewL = [NSLayoutConstraint constraintWithItem:self.iconView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
        NSLayoutConstraint *iconViewWidth = [NSLayoutConstraint constraintWithItem:self.iconView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
        NSLayoutConstraint *iconViewHeight = [NSLayoutConstraint constraintWithItem:self.iconView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeHeight multiplier:1 constant:0];
        [self.contentView addConstraints:@[iconViewT,iconViewL,iconViewWidth,iconViewHeight]];
        self.didUpdateConstraints = true;
    }
    [super updateConstraints];
}

@end

