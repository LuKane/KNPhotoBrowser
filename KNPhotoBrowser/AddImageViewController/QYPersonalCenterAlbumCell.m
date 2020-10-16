//
//  QYPersonalCenterAlbumCell.m
//  QiYue
//
//  Created by jmcl on 2020/9/12.
//  Copyright © 2020 jmcl. All rights reserved.
//

#import "QYPersonalCenterAlbumCell.h"



@interface QYPersonalCenterAlbumCell()
@property(nonatomic,strong)UIImageView *addIconView; //默认隐藏

@end

@implementation QYPersonalCenterAlbumCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self =  [super initWithFrame:frame]) {
        
        self.backgroundColor = UIColor.clearColor;
        self.layer.cornerRadius = 4;
        self.clipsToBounds = YES;
        
        self.imageIconView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        self.imageIconView.backgroundColor = UIColor.clearColor;
        self.imageIconView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.imageIconView];
        
        
        self.addIconView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        self.addIconView.backgroundColor = UIColor.clearColor;
        self.addIconView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.addIconView];
        self.addIconView.hidden = YES;
        self.addIconView.image = [UIImage imageNamed:@"personal_add_icon"];
        
    

    }
    return self;
}

-(void)setIsHiddenAddIcon:(BOOL)isHiddenAddIcon{
    _isHiddenAddIcon = isHiddenAddIcon;
    self.addIconView.hidden = _isHiddenAddIcon;
}

@end
