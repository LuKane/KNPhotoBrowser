//
//  IMTableViewCell.h
//  KNPhotoBrowser
//
//  Created by LuKane on 2019/2/1.
//  Copyright © 2019 LuKane. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IMModel;

NS_ASSUME_NONNULL_BEGIN

#ifndef ScreenWidth
    #define ScreenWidth [UIScreen mainScreen].bounds.size.width
#endif

#ifndef ScreenHeight
    #define ScreenHeight [UIScreen mainScreen].bounds.size.height
#endif


@protocol IMTableViewCellDelegate <NSObject>

- (void)reloadCellWithModel:(IMModel *)immModel;

- (void)imImageViewDidClick:(IMModel *)imModel;

@end

@interface IMTableViewCell : UITableViewCell

+ (instancetype)imTableViewCellWithTableView:(UITableView *)tableView;

@property (nonatomic,weak  ) UIImageView *picImgView;

@property (nonatomic,strong) IMModel *imModel;

@property (nonatomic,weak  ) id<IMTableViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
