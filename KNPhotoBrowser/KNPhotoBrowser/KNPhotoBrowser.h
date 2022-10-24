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
    KNPhotoDownloadStateDownloading,
    KNPhotoDownloadStateSuccess,
    KNPhotoDownloadStateFailure,
    KNPhotoDownloadStateRepeat,
    KNPhotoDownloadStateSaveFailure,
    KNPhotoDownloadStateSaveSuccess
};

/****************************** == KNPhotoItems == ********************************/

@interface KNPhotoItems : NSObject

/// if it is network image or (net or locate video),  set `url` , do not set `sourceImage`
@property (nonatomic,copy  ) NSString *url;

/// if it is locate image, set `sourceImage`, do not set `url`
@property (nonatomic,strong) UIImage *sourceImage;

/// is locate gif image or not, default is false.
/// if is locate gif image, set it true.
/// if is network gif image or video, do not set it
@property (nonatomic,assign) BOOL isLocateGif;

/// sourceView is current control to show image or video.
/// 1. if the sourceView is kind of `UIImageView` or `UIButton` , just only only only set the `sourceView`.
/// 2. if the sourceView is the custom view , set the `sourceView`, but do not forget set `sourceLinkArr` && `sourceLinkProperyName`.
@property (nonatomic,strong) UIView *sourceView;

/**
 eg:
    CustomSourceView2 *superV = [[CustomSourceView2 alloc] init];
    [xxxView addsubView: superV];
        
    CustomSourceImageView2 *superV1 = [[CustomSourceImageView2 alloc] init];
    [superV addsubView: superV1];
        
    SDAnimatedImageView *imgV = [[SDAnimatedImageView alloc] init];
    [superV1 addsubView: imgV];
        
    NSMutableArray *arr = [NSMutableArray array];
    [arr addObject:@"CustomSourceImageView2"];
    [arr addObject:@"SDAnimatedImageView"];
        
    items.sourceLinkArr = [arr copy];
 */

/// Class of sourceView' s  subview (if set sourceLinkArr , then must set sourceLinkProperyName when it's not `UIImageView` or `UIButton`)
@property (nonatomic,strong) NSArray<NSString *> *sourceLinkArr;

/**
 eg:
    if the lastObject is kind of  UIImageView ,  the `sourceLinkProperyName` is `image`
    if the lastObject is kind of  UIButton ,  the `sourceLinkProperyName` is `currentBackgroundImage` or `currentImage`
 */

/// the property'name of the  sourceLinkArr lastObject
@property (nonatomic,copy  ) NSString *sourceLinkProperyName;

/// is video or not, defalut is false
@property (nonatomic,assign) BOOL isVideo;

/// when `isVideo` is true, and the video is net type, try to set videoPlaceHolderImageUrl, it is like the placeHolderImage of the net video
@property (nonatomic,copy  ) NSString *videoPlaceHolderImageUrl;

/// video is downloading or other state, default is unknow
@property (nonatomic,assign) KNPhotoDownloadState downloadState;

/// video is downloading, current progress
@property (nonatomic,assign) float downloadProgress;

@end

@interface UIDevice(PBExtension)
/// device judge did have auth of Album
/// @param authorBlock callBack
+ (void)deviceAlbumAuth:(void (^)(BOOL isAuthor))authorBlock;

/// device shake
+ (void)deviceShake;

@end

/****************************** == KNPhotoBrowserDelegate == ********************************/

@protocol KNPhotoBrowserDelegate <NSObject>

@optional
/// photoBrowser will dismiss with currentIndex
/// @param photoBrowser browser
/// @param index current index
- (void)photoBrowser:(KNPhotoBrowser *)photoBrowser willDismissWithIndex:(NSInteger)index;

/// photoBrowser right top button did click with currentIndex (you can custom you right button, but if you custom your right button, that you need implementate your target action)
/// @param photoBrowser browser
/// @param index current index
- (void)photoBrowser:(KNPhotoBrowser *)photoBrowser rightBtnOperationActionWithIndex:(NSInteger)index;

/// photoBrowser image long press (image or gif) with currentIndex
/// @param photoBrowser photoBrowser
/// @param index current index
- (void)photoBrowser:(KNPhotoBrowser *)photoBrowser imageLongPressWithIndex:(NSInteger)index;

/// photoBrowser remove image or video source with relative index
/// @param photoBrowser browser
/// @param relativeIndex relative index
- (void)photoBrowser:(KNPhotoBrowser *)photoBrowser removeSourceWithRelativeIndex:(NSInteger)relativeIndex;

/// photoBrowser remove image or video source with absolute index
/// @param photoBrowser browser
/// @param absoluteIndex absolute index
- (void)photoBrowser:(KNPhotoBrowser *)photoBrowser removeSourceWithAbsoluteIndex:(NSInteger)absoluteIndex;

/// photoBrowser scroll to current Index
/// @param photoBrowser browser
/// @param index current index
- (void)photoBrowser:(KNPhotoBrowser *)photoBrowser scrollToLocateWithIndex:(NSInteger)index;

/// photoBrowser did long press with gestureRecognizer and index
/// @param photoBrowser browser
/// @param longPress gesture Recognize
/// @param index current index
- (void)photoBrowser:(KNPhotoBrowser *)photoBrowser videoLongPress:(UILongPressGestureRecognizer *)longPress index:(NSInteger)index;

/// download image or video  success or failure or failure reason call back. [If video player is download by auto, it can use delegate. it is only use function `removeImageOrVideoOnPhotoBrowser` can use this delegate]
/// @param photoBrowser photoBrowser
/// @param state state
/// @param progress progress
/// @param photoItemRe relative photoItem
/// @param photoItemAb absolute photoItem
- (void)photoBrowser:(KNPhotoBrowser *)photoBrowser
               state:(KNPhotoDownloadState)state
            progress:(float)progress
   photoItemRelative:(KNPhotoItems *)photoItemRe
   photoItemAbsolute:(KNPhotoItems *)photoItemAb;

/// photoBrowser will layout subviews
- (void)photoBrowserWillLayoutSubviews;

@end

/****************************** == KNPhotoBrowser == ********************************/

@interface KNPhotoBrowser : UIViewController

/// current Index
@property (nonatomic,assign) NSInteger currentIndex;

/// itemsArr contain KNPhotoItems : url | sourceView.....
@property (nonatomic,strong) NSArray<KNPhotoItems *> *itemsArr;

/// delegate
@property (nonatomic,weak  ) id<KNPhotoBrowserDelegate> delegate;

/// image' control animated mode , default is `UIViewContentModeScaleToFill`
@property (nonatomic,assign) UIViewContentMode animatedMode;

/// image' control presented mode , default is `UIViewContentModeScaleAspectFit`
@property (nonatomic,assign) UIViewContentMode presentedMode;

/// when source image && image && video is not ready,  create one image with color to holder, default is UIColor.clear
@property (nonatomic,strong) UIColor *placeHolderColor;

/// is or not need pageNumView , default is false
@property (nonatomic,assign) BOOL isNeedPageNumView;

/// is or not need pageControl , default is false (but if photobrowser contain video,then hidden)
@property (nonatomic,assign) BOOL isNeedPageControl;

/// is or not need pageControl has target to change value , default is false (it is based on `isNeedPageControl`)
@property (nonatomic,assign) BOOL isNeedPageControlTarget;

/// is or not need RightTopBtn , default is false
@property (nonatomic,assign) BOOL isNeedRightTopBtn;

/// is or not need image or video longPress , default is false.
/// image long press : delegate function `photoBrowser: imageLongPressWithIndex:`.
/// video long press : delegate function `photoBrowser: videoLongPress: index:`.
@property (nonatomic,assign) BOOL isNeedLongPress;

/// is or not need prefetch image, maxCount is 8 (KNPhotoBrowserPch.h)
@property (nonatomic,assign) BOOL isNeedPrefetch;

/// is or not need pan Gesture, default is false
@property (nonatomic,assign) BOOL isNeedPanGesture;

/// is or not need auto play video, default is false
@property (nonatomic,assign) BOOL isNeedAutoPlay;

/// is or not need online play video, default is false [That means auto download video first]
@property (nonatomic,assign) BOOL isNeedOnlinePlay;

/// is or not solo ambient, default is true `AVAudioSessionCategorySoloAmbient`. If set false ,that will be `AVAudioSessionCategoryAmbient`
@property (nonatomic,assign) BOOL isSoloAmbient;

/// the `numView` & `pageControl` & `operationBtn` is or not need follow photoBrowser , default is false.
/// when touch photoBrowser, they will be hidden.
/// when you cancel, they will be showed.
/// when dismiss the photoBrowser immediately, they will be hidden immediately.
@property (nonatomic,assign) BOOL isNeedFollowAnimated;

/// remove current image or video on photobrowser
- (void)removeImageOrVideoOnPhotoBrowser;

/// download photo or video to Album, but it must be authed at first
- (void)downloadImageOrVideoToAlbum;

/// player's rate immediately to use, default is 1.0 , range is [0.5 <= rate <= 2.0]
- (void)setImmediatelyPlayerRate:(CGFloat)rate;

/**
you can use the next function, use the `- (void)createOverlayViewArrOnTopView: animated: followAnimated:`
*/
- (void)createCustomViewArrOnTopView:(NSArray<UIView *> *)customViewArr
                            animated:(BOOL)animated
                      followAnimated:(BOOL)followAnimated;

/**
create overlay view on the topView(photoBrowser controller's view)
for example: create a scrollView on the photoBrowser controller's view, when photoBrowser has scrolled , you can use delegate's function to do something you want
delegate's function: 'photoBrowser:scrollToLocateWithIndex:(NSInteger)index'
'CustomViewController' in Demo, you can see it how to use
@param overlayViewArr overlayViewArr
@param animated need animated or not, with photoBrowser present
@param followAnimated need animated or not for follow photoBrowser
*/
- (void)createOverlayViewArrOnTopView:(NSArray<UIView *> *)overlayViewArr
                             animated:(BOOL)animated
                       followAnimated:(BOOL)followAnimated;

/// photoBrowser will present.
/// if `which is already presenting`, use the `- (void)present:(UIViewController *)controller` to instead
- (void)present;

 /*
 by the way , you alse can present as you wish, like:
 [controller presentViewController:photoBrowser animated:false completion:^{
  
 }];
  */

/// photoBrowser will present base on current controller
/// @param controller current controller
- (void)presentOn:(UIViewController *)controller;

/// photoBrowser dismiss
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
