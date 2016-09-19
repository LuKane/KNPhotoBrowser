//
//  KNWaterflowLayout.h
//  test
//
//  Created by LuKane on 15/7/6.
//  Copyright (c) 2015年 LuKane. All rights reserved.
//  网络找的类 ->这边只是 修改了前缀.. 但还挺好使用

#import <UIKit/UIKit.h>

@class KNWaterflowLayout;

@protocol KNWaterflowLayoutDelegate <NSObject>
- (CGFloat)waterflowLayout:(KNWaterflowLayout *)waterflowLayout heightForItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth;

@optional
/**
 *  返回四边的间距, 默认是UIEdgeInsetsMake(10, 10, 10, 10)
 */
- (UIEdgeInsets)insetsInWaterflowLayout:(KNWaterflowLayout *)waterflowLayout;
/**
 *  返回最大的列数, 默认是3
 */
- (int)maxColumnsInWaterflowLayout:(KNWaterflowLayout *)waterflowLayout;
/**
 *  返回每行的间距, 默认是10
 */
- (CGFloat)rowMarginInWaterflowLayout:(KNWaterflowLayout *)waterflowLayout;
/**
 *  返回每列的间距, 默认是10
 */
- (CGFloat)columnMarginInWaterflowLayout:(KNWaterflowLayout *)waterflowLayout;
@end

@interface KNWaterflowLayout : UICollectionViewLayout
@property (nonatomic, weak) id<KNWaterflowLayoutDelegate> delegate;
@end
