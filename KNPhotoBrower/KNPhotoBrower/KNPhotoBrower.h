//
//  KNPhotoBrower.h
//  KNPhotoBrower
//
//  Created by LuKane on 16/8/18.
//  Copyright © 2016年 LuKane. All rights reserved.
//

/**
 *  如果 bug ,希望各位在 github 上通过'邮箱' 或者直接 issue 指出, 谢谢
 *  github地址 :https://github.com/LuKane/KNPhotoBrower
 *  目前 KNPhotoBrower 九宫格图片样式 , collectionView , ScrollView 样式 . 支持 删除功能 -- >KNPhotoBrower.m中的operationBtnIBAction方法中查看
 */


#import <UIKit/UIKit.h>

@interface KNPhotoItems : NSObject

/**
 *  如果是网络图片,则设置url.不设置 sourceImage
 */
@property (nonatomic, copy  ) NSString *url;

/**
 *  如果加载 本地图片, url 则不可以赋值,
 */
@property (nonatomic, strong) UIImage *sourceImage;

@property (nonatomic, strong) UIView *sourceView;

@end

@protocol KNPhotoBrowerDelegate <NSObject>

@optional
/* PhotoBrower 即将消失 */
- (void)photoBrowerWillDismiss;

/* PhotoBrower 右上角按钮的点击 */
- (void)photoBrowerRightOperationActionWithIndex:(NSInteger)index;

/* PhotoBrower 保存图片是否成功 */
- (void)photoBrowerWriteToSavedPhotosAlbumStatus:(BOOL)success;

/* PhotoBrower 删除图片成功后返回-- > 相对 Index */
- (void)photoBrowerRightOperationDeleteImageSuccessWithRelativeIndex:(NSInteger)index;
/* PhotoBrower 删除图片成功后返回-- > 绝对 Index */
- (void)photoBrowerRightOperationDeleteImageSuccessWithAbsoluteIndex:(NSInteger)index;

@end

@interface KNPhotoBrower : UIView
/**
 *  当前图片的下标
 */
@property (nonatomic, assign) NSInteger currentIndex;
/**
 *  存放图片的模型 :url && UIView
 */
@property (nonatomic, strong) NSArray *itemsArr;
/**
 *  存放 ActionSheet 弹出框的内容 :NSString类型
 */
@property (nonatomic, strong) NSMutableArray *actionSheetArr;
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

/**
 *  为 collectionView 循环利用所 提供的 父控件
 */
@property (nonatomic, weak  ) UIView *sourceViewForCellReusable;

/**
 *  为 collectionView 没有 展现出来的 image 做准备(Demo中会写出 如何使用) --> 类似 自己朋友圈中的图片浏览
 *  所有url的数组 --> 为 collectionView 所做的全部 url 数组 (如果这个参数设置有数据, 那么就当 collectionView 处理)
 */
@property (nonatomic, strong) NSArray *dataSourceUrlArr;

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
