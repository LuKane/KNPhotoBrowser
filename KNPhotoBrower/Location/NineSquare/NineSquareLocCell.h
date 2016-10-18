//
//  NineSquareLocCell.h
//  KNPhotoBrower
//
//  Created by LuKane on 2016/10/18.
//  Copyright © 2016年 LuKane. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NineSquareModel;

@interface NineSquareLocCell : UITableViewCell

+ (instancetype)nineSquareLocCellWithTableView:(UITableView *)tableView;

@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, strong) NineSquareModel *squareM;

@end
