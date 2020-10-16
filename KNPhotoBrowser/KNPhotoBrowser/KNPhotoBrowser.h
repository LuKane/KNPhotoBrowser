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
#import <AVFoundation/AVFoundation.h>
#import "KNActionSheet.h"
@class KNPhotoBrowser;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, KNPhotoDownloadState) {
    KNPhotoDownloadStateUnknow,
    KNPhotoDownloadStateSuccess,
    KNPhotoDownloadStateFailure,
    KNPhotoDownloadStateDownloading
};

typedef NS_ENUM(NSInteger, KNPhotoShowState) {
    KNPhotoShowImageSuccess,        // download image success
    KNPhotoShowImageFailure,        // download image failure
    KNPhotoShowImageFailureUnknow,  // the reason of download image failure
    
    KNPhotoShowVideoSuccess,        // download video success
    KNPhotoShowVideoFailure,        // download video failure
    KNPhotoShowVideoFailureUnknow   // the reason of download video failure
};

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

/**
 is video of not, default is false
 */
@property (nonatomic,assign) BOOL  isVideo;

/**
 video is downloading or other state, Default is unknow
 */
@property (nonatomic,assign) KNPhotoDownloadState  downloadState;

/**
 video is downloading, current progress
 */
@property (nonatomic,assign) float  downloadProgress;

@end

@interface UIDevice(PBExtension)

/**
 judge is have auth of Album
 
 @param authorBlock block
 */
+ (void)deviceAlbumAuth:(void (^)(BOOL isAuthor))authorBlock;

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
 photoBrowser right top button did click
 */
- (void)photoBrowserRightOperationAction;

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
- (void)photoBrowserWriteToSavedPhotosAlbumStatus:(BOOL)success DEPRECATED_MSG_ATTRIBUTE("use delegate function photoBrowserToast:photoBrower:photoItemRelative:photoItemAbsolute:  instead");

@optional
/**
 download video with progress
 @param progress current progress
 */
- (void)photoBrowserDownloadVideoWithProgress:(CGFloat)progress;

@optional
/**
 photoBrowser scroll to current index
 @param index current index
 */
- (void)photoBrowserScrollToLocateWithIndex:(NSInteger)index;

@optional
/// photoBrowser did long press
/// @param photoBrowser photobrowser
/// @param longPress long press gestureRecognizer
- (void)photoBrowser:(KNPhotoBrowser *)photoBrowser longPress:(UILongPressGestureRecognizer *)longPress;

@optional
/// download image or video  success | failure | failure reason call back
/// @param photoBrowser toast on photoBrower.view
/// @param state state
/// @param photoItemRe relative photoItem
/// @param photoItemAb absolute photoItem
- (void)photoBrowser:(KNPhotoBrowser *)photoBrowser
               state:(KNPhotoShowState)state
   photoItemRelative:(KNPhotoItems *)photoItemRe
   photoItemAbsolute:(KNPhotoItems *)photoItemAb;

@optional
/**
 photoBrowser will layout subviews
 */
- (void)photoBrowserWillLayoutSubviews;

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
 Delegate
 */
@property (nonatomic,weak  ) id<KNPhotoBrowserDelegate> delegate;

/**
 is or not need pageNumView , Default is false
 */
@property (nonatomic,assign) BOOL  isNeedPageNumView;

/**
 is or not need pageControl , Default is false (but if photobrowser contain video,then hidden)
 */
@property (nonatomic,assign) BOOL  isNeedPageControl;

/**
 is or not need RightTopBtn , Default is false
 */
@property (nonatomic,assign) BOOL  isNeedRightTopBtn;

/**
 is or not need PictureLongPress , Default is false
 */
@property (nonatomic,assign) BOOL  isNeedPictureLongPress;

/**
 is or not need prefetch image, maxCount is 8 (KNPhotoBrowserPch.h)
 */
@property (nonatomic,assign) BOOL  isNeedPrefetch;

/**
 is or not need pan Gesture, Default is false
 */
@property (nonatomic,assign) BOOL  isNeedPanGesture;

/**
 is or not need auto play video, Default is false
 */
@property (nonatomic,assign) BOOL isNeedAutoPlay;

/**
 is or not need follow photoBrowser , Default is false
 when touch photoBrowser, the customView will be hidden
 when you cancel, the customView will be showed
 when dismiss the photoBrowser immediately, the customView will be hidden immediately
 */
@property (nonatomic,assign) BOOL isNeedFollowAnimated;

/**
 photoBrowser image download success toast message, default in KNPhotoBrowserPch
 */
@property (nonatomic,copy  ) NSString *photoBrowserImageSuccessMsg DEPRECATED_MSG_ATTRIBUTE("use delegate function photoBrowserToast:photoBrower:photoItemRelative:photoItemAbsolute: instead");
/**
photoBrowser image download failure toast message, default in KNPhotoBrowserPch
*/
@property (nonatomic,copy  ) NSString *photoBrowserImageFailureMsg DEPRECATED_MSG_ATTRIBUTE("use delegate function photoBrowserToast:photoBrower:photoItemRelative:photoItemAbsolute: instead");
/**
photoBrowser image download failure reason, default in KNPhotoBrowserPch
*/
@property (nonatomic,copy  ) NSString *photoBrowserImageFailureReason DEPRECATED_MSG_ATTRIBUTE("use delegate function photoBrowserToast:photoBrower:photoItemRelative:photoItemAbsolute: instead");
/**
photoBrowser video download success toast message, default in KNPhotoBrowserPch
*/
@property (nonatomic,copy  ) NSString *photoBrowserVideoSuccessMsg DEPRECATED_MSG_ATTRIBUTE("use delegate function photoBrowserToast:photoBrower:photoItemRelative:photoItemAbsolute: instead");
/**
photoBrowser image download failure toast message, default in KNPhotoBrowserPch
*/
@property (nonatomic,copy  ) NSString *photoBrowserVideoFailureMsg DEPRECATED_MSG_ATTRIBUTE("use delegate function photoBrowserToast:photoBrower:photoItemRelative:photoItemAbsolute: instead");
/**
photoBrowser image download failure reason, default in KNPhotoBrowserPch
*/
@property (nonatomic,copy  ) NSString *photoBrowserVideoFailureReason DEPRECATED_MSG_ATTRIBUTE("use delegate function photoBrowserToast:photoBrower:photoItemRelative:photoItemAbsolute: instead");

/**
 delete current photo or video
 */
- (void)deletePhotoAndVideo;

/**
 download photo or video to Album, but it must be authed at first
 */
- (void)downloadPhotoAndVideo;

/**
 player's rate immediately to use
 */
- (void)setImmediatelyPlayerRate:(CGFloat)rate;

/**
 create custom view on the topView(photoBrowser controller's view)
 for example: create a scrollView on the photoBrowser controller's view, when photoBrowser has scrolled , you can use delegate's function to do something you think
 delegate's function: 'photoBrowserScrollToLocateWithIndex:(NSInteger)index'
 'CustomViewController' in Demo, you can see it how to use
 @param customViewArr customViewArr
 @param animated need animated or not
 */
- (void)createCustomViewArrOnTopView:(NSArray<UIView *> *)customViewArr
                            animated:(BOOL)animated DEPRECATED_MSG_ATTRIBUTE("use createCustomViewArrOnTopView:animated:followAnimated instead!");

/**
create custom view on the topView(photoBrowser controller's view)
for example: create a scrollView on the photoBrowser controller's view, when photoBrowser has scrolled , you can use delegate's function to do something you think
delegate's function: 'photoBrowserScrollToLocateWithIndex:(NSInteger)index'
'CustomViewController' in Demo, you can see it how to use
@param customViewArr customViewArr
@param animated need animated or not
@param followAnimated need animated or not for follow photoBrowser
*/
- (void)createCustomViewArrOnTopView:(NSArray<UIView *> *)customViewArr
                            animated:(BOOL)animated
                      followAnimated:(BOOL)followAnimated;

/**
 photoBrowser show
 */
- (void)present;

/**
 photoBrowser dismiss
 */
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
