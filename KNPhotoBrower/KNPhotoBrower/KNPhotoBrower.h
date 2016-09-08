//
//  KNPhotoBrower.h
//  KNPhotoBrower
//
//  Created by LuKane on 16/8/18.
//  Copyright © 2016年 LuKane. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KNPhotoBrowerDelegate <NSObject>

@optional
/* PhotoBrower 即将消失 */
- (void)photoBrowerWillDismiss;

/* PhotoBrower 右上角按钮的点击 */
- (void)photoBrowerRightOperationActionWithIndex:(NSInteger)index;

/* PhotoBrower 保存图片是否成功 */
- (void)photoBrowerWriteToSavedPhotosAlbumStatus:(BOOL)success;

@end

@interface KNPhotoBrower : UIView
/**
 *  展示图的父控件
 */
@property (nonatomic, strong) UIView *sourceView;
/**
 *  当前图片的下标
 */
@property (nonatomic, assign) NSInteger currentIndex;
/**
 *  存放图片的数组 :url
 */
@property (nonatomic, strong) NSArray *imageArr;
/**
 *  是否需要右上角的按钮. Default is YES;
 */
@property (nonatomic, assign) BOOL isNeedRightTopBtn;
/**
 *  是否需要 顶部 1 / 9 控件 ,Default is YES
 */
@property (nonatomic, assign) BOOL isNeedPageNumView;
/**
 *  是否需要 底部 UIPageControl, Default is NO
 */
@property (nonatomic, assign) BOOL isNeedPageControl;

@property (nonatomic, weak  ) id<KNPhotoBrowerDelegate> delegate;

/**
 *  展现
 */
- (void)present;
/**
 *  消失
 */
- (void)dismiss;


@end
