//
//  NineSquareCell.h
//  KNPhotoBrowser
//
//  Created by LuKane on 16/9/18.
//  Copyright © 2016年 LuKane. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NineSquareModel;

@interface NineSquareCell : UITableViewCell

+ (instancetype)nineSquareCellWithTableView:(UITableView *)tableView;

@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, strong) NineSquareModel *squareM;

@end
