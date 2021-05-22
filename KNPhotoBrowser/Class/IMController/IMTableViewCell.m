//
//  IMTableViewCell.m
//  KNPhotoBrowser
//
//  Created by LuKane on 2021/5/21.
//  Copyright © 2021 LuKane. All rights reserved.
//

#import "IMTableViewCell.h"
#import "UIView+Extension.h"
#import <UIImageView+WebCache.h>

#ifndef ScreenWidth
    #define ScreenWidth [UIScreen mainScreen].bounds.size.width
#endif

@interface IMTableViewCell()

@property (nonatomic,weak  ) UIView *iconView;

@end

@implementation IMTableViewCell

+ (instancetype)imTableViewCell:(UITableView *)tableView{
    static NSString *ID = @"IMTableViewCellID";
    IMTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[IMTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = UIColor.whiteColor;
        cell.contentView.backgroundColor = UIColor.whiteColor;
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupSubViews];
    }
    return self;
}
- (void)setupSubViews{
    UIView *iconView = [[UIView alloc] init];
    iconView.layer.cornerRadius = 25;
    iconView.layer.borderWidth = 0.4;
    iconView.layer.borderColor = UIColor.cyanColor.CGColor;
    iconView.frame = CGRectMake(20, 20, 50, 50);
    [self.contentView addSubview:iconView];
    self.iconView = iconView;
    
    SDAnimatedImageView *imgView = [[SDAnimatedImageView alloc] initWithFrame:CGRectMake(90, 20, 100, 100)];
    imgView.userInteractionEnabled = true;
    [imgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgViewDidClick)]];
    [self.contentView addSubview:imgView];
    self.imgView = imgView;
}

- (void)imgViewDidClick{
    if ([_delegate respondsToSelector:@selector(imageViewDidClick:)]) {
        [_delegate imageViewDidClick:_imModel];
    }
}

- (void)setImModel:(IMModel *)imModel{
    _imModel = imModel;
    
    if (imModel.isLeft == true) {
        _iconView.origin = CGPointMake(20, 20);
        _iconView.backgroundColor = [UIColor orangeColor];
        _imgView.frame = CGRectMake(90, 20, 100 * imModel.rate, 100);
    }else {
        _iconView.origin = CGPointMake(ScreenWidth - 20 - 50, 20);
        _iconView.backgroundColor = [UIColor lightGrayColor];
        _imgView.frame = CGRectMake(ScreenWidth - 100 * imModel.rate - 90, 20, 100 * imModel.rate, 100);
    }
    
    if ([imModel.url hasPrefix:@"http"]) {
        if (imModel.isVideo == true) {
            [_imgView sd_setImageWithURL:[NSURL URLWithString:imModel.videoPlaceHolderUrl]];
        }else {
            [_imgView sd_setImageWithURL:[NSURL URLWithString:imModel.url]];
        }
    }else {
        _imgView.image = [UIImage imageNamed:imModel.url];
    }
}

@end
