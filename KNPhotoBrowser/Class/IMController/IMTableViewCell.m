//
//  IMTableViewCell.m
//  KNPhotoBrowser
//
//  Created by LuKane on 2021/5/21.
//  Copyright © 2021 LuKane. All rights reserved.
//

#import "IMTableViewCell.h"
#import <SDAnimatedImageView.h>
#import "UIView+Extension.h"

@interface IMTableViewCell()

@property (nonatomic,weak  ) UIView *iconView;
@property (nonatomic,weak  ) SDAnimatedImageView *imgView;

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
    
    SDAnimatedImageView *imgView = [[SDAnimatedImageView alloc] initWithFrame:CGRectMake(90, 2, 100, 100)];
    imgView.userInteractionEnabled = true;
    [imgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgViewDidClick)]];
    [self.contentView addSubview:imgView];
    self.imgView = imgView;
    
    
    
}

- (void)imgViewDidClick{
    if ([_delegate respondsToSelector:@selector(imageViewDidClick)]) {
        [_delegate imageViewDidClick];
    }
}

@end
