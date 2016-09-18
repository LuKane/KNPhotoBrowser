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

@property (nonatomic, copy  ) NSString *url;
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
