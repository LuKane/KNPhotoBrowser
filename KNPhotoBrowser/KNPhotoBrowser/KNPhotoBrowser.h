//
//  KNPhotoBrowser.h
//  KNPhotoBrowser
//
//  Created by LuKane on 16/8/18.
//  Copyright © 2016年 LuKane. All rights reserved.
//

/**
 *  如果 bug ,希望各位在 github 上通过'邮箱' 或者直接 issue 指出, 谢谢
 *  github地址 : https://github.com/LuKane/KNPhotoBrowser
 *  项目会越来越丰富,也希望大家一起来增加功能 , 欢迎 Star
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KNPhotoItems : NSObject

/**
 if is net image, just set 'url', do not set 'sourceImage'
 */
@property (nonatomic,copy  ) NSString *url;

/**
 if is locate image, just set 'sourceImage' , do not set 'url'
 */
@property (nonatomic,strong) UIImage *sourceImage;

/**
 current control
 */
@property (nonatomic,strong) UIView *sourceView;

@end

/****************************** == line == ********************************/

@protocol KNPhotoBrowserDelegate <NSObject>

@optional
/**
 photoBrowser will dismiss
 */
- (void)photoBrowserWillDismiss;

@optional
/**
 photoBrowser right top button did click, and actionSheet click with Index

 @param index actionSheet did click with Index
 */
- (void)photoBrowserRightOperationActionWithIndex:(NSInteger)index;

@optional
/**
 photoBrowser Delete image success with relative index
 
 @param index relative index
 */
- (void)photoBrowserRightOperationDeleteImageSuccessWithRelativeIndex:(NSInteger)index;

@optional
/**
 photoBrowser Delete image success with absolute index
 
 @param index absolute index
 */
- (void)photoBrowserRightOperationDeleteImageSuccessWithAbsoluteIndex:(NSInteger)index;

@optional
/**
 is success or not of save picture
 
 @param success is success
 */
- (void)photoBrowserWriteToSavedPhotosAlbumStatus:(BOOL)success;

@end

/****************************** == line == ********************************/

@interface KNPhotoBrowser : UIViewController

/**
 current select index
 */
@property (nonatomic,assign) NSInteger  currentIndex;

/**
 contain KNPhotoItems : url && UIView
 */
@property (nonatomic,strong) NSArray<KNPhotoItems *> *itemsArr;

/**
 contain ActionSheet alert contents ,which is belong NSString type
 */
@property (nonatomic,strong) NSArray<NSString *> *actionSheetArr;

/**
 is or not need pageNumView , Default is false
 */
@property (nonatomic,assign) BOOL  isNeedPageNumView;

/**
 is or not need pageControl , Default is false
 */
@property (nonatomic,assign) BOOL  isNeedPageControl;

/**
 is or not need RightTopBtn , Default is false
 */
@property (nonatomic,assign) BOOL  isNeedRightTopBtn;

/**
 is or not need PictureLongPress , Default is false
 */
@property (nonatomic, assign) BOOL isNeedPictureLongPress;

/**
 photoBrowser show
 */
- (void)present;

/**
 photoBrowser dismiss
 */
- (void)dismiss;

/**
 Delegate
 */
@property (nonatomic,weak  ) id<KNPhotoBrowserDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
