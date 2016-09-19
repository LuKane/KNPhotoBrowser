//
//  CollectionViewCell.h
//  KNPhotoBrower
//
//  Created by LuKane on 16/9/19.
//  Copyright © 2016年 LuKane. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CollectionViewModel;

@interface CollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) CollectionViewModel *model;

@property (nonatomic, strong) UIImageView *iconView;

@end
