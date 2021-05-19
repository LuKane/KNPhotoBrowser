//
//  NineSquareCell.h
//  KNPhotoBrowser
//
//  Created by LuKane on 2021/5/18.
//  Copyright © 2021 LuKane. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NineSquareModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NineSquareCell : UITableViewCell

@property (nonatomic,strong) NineSquareModel *squareM;
@property (nonatomic,assign) BOOL isLocate;

+ (instancetype)nineSquareCell:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
