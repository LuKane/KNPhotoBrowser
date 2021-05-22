//
//  IMTableViewCell.h
//  KNPhotoBrowser
//
//  Created by LuKane on 2021/5/21.
//  Copyright © 2021 LuKane. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMModel.h"
#import <SDAnimatedImageView.h>

NS_ASSUME_NONNULL_BEGIN

@protocol IMTableViewCellDelegate <NSObject>

- (void)imageViewDidClick:(IMModel *)imModel;

@end

@interface IMTableViewCell : UITableViewCell

+ (instancetype)imTableViewCell:(UITableView *)tableView;

@property (nonatomic,strong) IMModel *imModel;
@property (nonatomic,weak  ) SDAnimatedImageView *imgView;

@property (nonatomic,weak  ) id<IMTableViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
