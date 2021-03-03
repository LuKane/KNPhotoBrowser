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

/// this enum is for photoBrowser [ it likes  private ]
typedef NS_ENUM(NSInteger, KNPhotoDownloadState) {
    KNPhotoDownloadStateUnknow,
    KNPhotoDownloadStateSuccess,
    KNPhotoDownloadStateFailure,
    KNPhotoDownloadStateDownloading
};

/// this enum is for download status [ it likes public ]
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
 is locate gif image or not, default is false
 if is locate gif image , just set it true,
 if is net gif image, do not set it
 */
@property (nonatomic,assign) BOOL isLocateGif;

/**
  1. if the sourceView is kind of `UIImageView` or `UIButton` , just only only only set the `sourceView`
  2. if the sourceView is the custom view , set the `sourceView`, but do not forget set `sourceLinkArr` && `sourceLinkProperyName`
 */

/**
 sourceView: current control
 */
@property (nonatomic,strong) UIView *sourceView;

/**
 Class of sourceView' s  subview (if set sourceLinkArr , then must set sourceLinkProperyName when it's not `UIImageView` or `UIButton`)
 eg:
    CustomSuperView *superV = [[CustomSuperView alloc] init];
    [sourceV addsubView: superV];
            
    UIImageView *imgV = [[UIImageView alloc] init];
    [superV addsubView: imgV];
 
    NSMutableArray *arr = [NSMutableArray array];
    [arr addObject:@"CustomSourceImageView2"];
    [arr addObject:@"SDAnimatedImageView"];
 
    items.sourceLinkArr = [arr copy];
 */
@property (nonatomic,strong) NSArray<NSString *> *sourceLinkArr;

/**
 the property'name of the  sourceLinkArr lastObject
 eg:
    if the lastObject is kind of  UIImageView ,  the `sourceLinkProperyName` is `image`
    if the lastObject is kind of  UIButton ,  the `sourceLinkProperyName` is `currentBackgroundImage` or `currentImage`
 */
@property (nonatomic,copy  ) NSString *sourceLinkProperyName;

/**
 is video of not, default is false
 */
@property (nonatomic,assign) BOOL isVideo;

/**
 when `isVideo` is true, and the video is net type, try to set sourceVideoUrl, it is like the placeHolderImage of the net video
 */
@property (nonatomic,copy  ) NSString *sourceVideoUrl;

/**
 video is downloading or other state, default is unknow
 */
@property (nonatomic,assign) KNPhotoDownloadState downloadState;

/**
 video is downloading, current progress
 */
@property (nonatomic,assign) float downloadProgress;

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
 photoBrowser right top button did click, (you can custom you right button)
 */
- (void)photoBrowserRightOperationAction;

@optional
/**
 photoBrowser did long press (for the image or gif image)
 */
- (void)photoBrowserImageDidLongPress:(KNPhotoBrowser *)photoBrowser;

@optional
/**
 photoBrowser delete image success with relative index
 
 @param index relative index
 */
- (void)photoBrowserDeleteSourceSuccessWithRelativeIndex:(NSInteger)index;

@optional
/**
 photoBrowser delete image success with absolute index
 
 @param index absolute index
 */
- (void)photoBrowserDeleteSourceSuccessWithAbsoluteIndex:(NSInteger)index;

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
/// photoBrowser did long press for the video player
/// @param photoBrowser photobrowser
/// @param longPress long press gestureRecognizer
- (void)photoBrowser:(KNPhotoBrowser *)photoBrowser videoLongPress:(UILongPressGestureRecognizer *)longPress;

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
 delegate
 */
@property (nonatomic,weak  ) id<KNPhotoBrowserDelegate> delegate;

/**
  image' control animated mode , default is `UIViewContentModeScaleToFill`
 */
@property (nonatomic,assign) UIViewContentMode animatedMode;

/**
 image' control presented mode , default is `UIViewContentModeScaleAspectFit`
 */
@property (nonatomic,assign) UIViewContentMode presentedMode;

/**
 when source image && image && video is not ready,  create one image with color to holder
  default is UIColor.clear
 */
@property (nonatomic,strong) UIColor *placeHolderColor;

/**
 is or not need pageNumView , default is false
 */
@property (nonatomic,assign) BOOL isNeedPageNumView;

/**
 is or not need pageControl , default is false (but if photobrowser contain video,then hidden)
 */
@property (nonatomic,assign) BOOL isNeedPageControl;

/**
 is or not need RightTopBtn , default is false
 */
@property (nonatomic,assign) BOOL isNeedRightTopBtn;

/**
 is or not need PictureLongPress , default is false
 */
@property (nonatomic,assign) BOOL isNeedPictureLongPress;

/**
 is or not need prefetch image, maxCount is 8 (KNPhotoBrowserPch.h)
 */
@property (nonatomic,assign) BOOL isNeedPrefetch;

/**
 is or not need pan Gesture, default is false
 */
@property (nonatomic,assign) BOOL isNeedPanGesture;

/**
 is or not need auto play video, default is false
 */
@property (nonatomic,assign) BOOL isNeedAutoPlay;

/**
 is or not need follow photoBrowser , default is false
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
 player's rate immediately to use, default is 1.0 , range is [0.5 <= rate <= 2.0]
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
@param animated need animated or not, with photoBrowser present
@param followAnimated need animated or not for follow photoBrowser
*/
- (void)createCustomViewArrOnTopView:(NSArray<UIView *> *)customViewArr
                            animated:(BOOL)animated
                      followAnimated:(BOOL)followAnimated;

/// photoBrowser will present
/// if `which is already presenting`, use the `- (void)present:(UIViewController *)controller` to instead
- (void)present;

/* ====================== tip ======================== */
 /* by the way , you alse can present as you wish, like: */

 /*
 [controller presentViewController:photoBrowser animated:false completion:^{
 
 }];
  */
/* ====================== tip ======================== */

/// photoBrowser will present base on current controller
/// @param controller current controller
- (void)present:(UIViewController *)controller DEPRECATED_MSG_ATTRIBUTE("use delegate function presentOn: instead");

/// photoBrowser will present base on current controller
/// @param controller current controller
- (void)presentOn:(UIViewController *)controller;

/// photoBrowser dismiss
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
