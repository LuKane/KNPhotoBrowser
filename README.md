![image](https://upload-images.jianshu.io/upload_images/1693073-222e76b529bc5f9e.png)

<a href="https://img.shields.io/cocoapods/v/KNPhotoBrowser.svg"><img src="https://img.shields.io/cocoapods/v/KNPhotoBrowser.svg"></a>
<a href="http://cocoadocs.org/docsets/KNPhotoBrowser"><img 
src="https://img.shields.io/cocoapods/p/KNPhotoBrowser.svg?style=flat"></a>

# KNPhotoBrowser
[中文](https://github.com/LuKane/KNPhotoBrowser/blob/master/README_Chinese.md) | [English](https://github.com/LuKane/KNPhotoBrowser/blob/master/README.md)

##### most like photo or video browser of `Wechat(TX)` and `Weibo(Sina)` in China
##### if you get any function to add, just contact me by E-mail. Welcome to Star 

![image](https://upload-images.jianshu.io/upload_images/1693073-aa996299e74d04b8.gif)
![image](https://upload-images.jianshu.io/upload_images/1693073-3c8632a1c5413564.gif)
![image](https://upload-images.jianshu.io/upload_images/1693073-5db630d194aaba91.gif)
![image](https://upload-images.jianshu.io/upload_images/1693073-c4b3c40b49899a2a.gif)
![image](https://upload-images.jianshu.io/upload_images/1693073-934ff5b95e03083c.gif)


## Update content
- [x] photoBrowser has been coded by `UIViewController` 
- [x] ready for `iPhoneX`、`iPhoneXS`、`iPhoneXR`、`iPhoneXS_Max`、`iPhone12Mini`、`iPhone12`、`iPhonePro_Max`
- [x] perfect adapt for rotate of the Screen , try it on the real device
- [x] panGesture to dismiss or cancel
- [x] prefetch image with API
- [x] locate and net GIF is ready use
- [x] video player is ready to use( locate and net video)
- [x] video swipe function is ready to use
- [x] video player contain autoplay API
- [x] video player add quick play API
- [x] custom control on the photoBrowser 
- [x] custom is followed with photoBrowser to dismiss or show 
- [x] all alert or toast will be down by delegate function

## 1.Function describe and Point
* 1.depend `SDWebImage(5.0)`, if need locate gif, depend `SDWebImage(5.8.3)`
* 2.most like photoBrowser of Wechat and Weibo in China
* 3.provide function which can delete and download image or video
* 4.custom control as you wish


## 2.How to use

### 1.init KNPhotoBrowser, set params
```
// 1.make every control as an object, put it into an array
KNPhotoItems *items = [[KNPhotoItems alloc] init];
items.url = [urlArr[i] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
items.sourceView = imageView;
// if current url is video type
// items.isVideo = true;
// if current image is locate gif
// itemM.isLocateGif = true;
[self.itemsArr addObject:items];
```
### 2.present , custom control as you wish

```
KNPhotoBrowser *photoBrowser = [[KNPhotoBrowser alloc] init];
photoBrowser.itemsArr = [self.itemsArr copy];
photoBrowser.isNeedPageNumView = true;
photoBrowser.isNeedRightTopBtn = true;
photoBrowser.isNeedPictureLongPress = true;
photoBrowser.isNeedPanGesture = true;
photoBrowser.isNeedPrefetch = true;
photoBrowser.isNeedAutoPlay = true;
photoBrowser.currentIndex = tap.view.tag;
photoBrowser.delegate = self;
[photoBrowser present];
```

### 3.provide Delegate --> KNPhotoBrowserDelegate
```
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

```

### 4.provide function of dismiss

```
// maybe you never use it
[_photoBrowser dismiss];
```

### 5.API
```
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
 is or not need pageNumView , default is false
 */
@property (nonatomic,assign) BOOL  isNeedPageNumView;

/**
 is or not need pageControl , default is false (but if photobrowser contain video,then hidden)
 */
@property (nonatomic,assign) BOOL  isNeedPageControl;

/**
 is or not need RightTopBtn , default is false
 */
@property (nonatomic,assign) BOOL  isNeedRightTopBtn;

/**
 is or not need PictureLongPress , default is false
 */
@property (nonatomic,assign) BOOL  isNeedPictureLongPress;

/**
 is or not need prefetch image, maxCount is 8 (KNPhotoBrowserPch.h)
 */
@property (nonatomic,assign) BOOL  isNeedPrefetch;

/**
 is or not need pan Gesture, default is false
 */
@property (nonatomic,assign) BOOL  isNeedPanGesture;

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
@param animated need animated or not, with photoBrowser present
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

```

## How to install 
```
pod 'KNPhotoBrowser'

// terminal : cd ~(current path)
pod install or pod update

```

## By the way
* 1.Currently, It just be used in nine picure ,scrollView, tableView , chat session for IM 
* 2.if you find any bug, just contact me, it will be perfect by each other
* 3.perfect adapt `iPhone` `iPad`
* 4.perfect adapt the `rotate of the Screen` like `Wechat` and `Weibo`
* 5.if you get any idea, just contact me! Thanks
