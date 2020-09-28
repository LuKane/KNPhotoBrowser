![image](https://raw.githubusercontent.com/LuKane/KNImageResource/master/PhotoBrower/KNPhotoBrower.png)

<a href="https://img.shields.io/cocoapods/v/KNPhotoBrowser.svg"><img src="https://img.shields.io/cocoapods/v/KNPhotoBrowser.svg"></a>
<a href="http://cocoadocs.org/docsets/KNPhotoBrowser"><img 
src="https://img.shields.io/cocoapods/p/KNPhotoBrowser.svg?style=flat"></a>

# KNPhotoBrowser
[中文](https://github.com/LuKane/KNPhotoBrowser/blob/master/README_Chinese.md) | [English](https://github.com/LuKane/KNPhotoBrowser/blob/master/README.md)

##### most like photo or video browser of `Wechat(TX)` and `Weibo(Sina)` in China
##### if you get any function to add, just contact me by E-mail. Welcome to Star 


![image](https://github.com/LuKane/KNImageResource/blob/master/PhotoBrower/PhotoBrower.gif?raw=true)
![image](https://github.com/LuKane/KNImageResource/blob/master/PhotoBrower/collectionView.gif?raw=true)
![image](https://github.com/LuKane/KNImageResource/blob/master/PhotoBrower/scrollView.gif?raw=true)
![image](https://github.com/LuKane/KNImageResource/blob/master/PhotoBrower/tableView.gif?raw=true)
![image](https://github.com/LuKane/KNImageResource/blob/master/PhotoBrower/photoBrowser-IMVideo.gif?raw=true)
![image](https://github.com/LuKane/KNImageResource/blob/master/PhotoBrower/PhotoBrower_Pan.gif?raw=true)


## Update content
- [x] browser has been recoded , turn the `UIView` to the `UIViewController`
- [x] adapt `iPhoneX`、`iPhoneXS`、`iPhoneXR`、`iPhoneXS_Max`
- [x] perfect adapt the rotate of the Screen,try on the real iPhone or iPad
- [x] photoBrowser for IM (like `Wechat` chat session)
- [x] photoBrowser add prefetch image API (2019/3/13)
- [x] photoBrowser add panGesture to dismiss or cancel(2019/4/16)
- [x] video player is ready to use (location video and net video) (2019/7/30)
- [x] swipe  video player is done!  
- [x] when photobrowser contain video ,then hide pagecontrol whatever you need or not pageControl
- [x] add custom control as you wish
- [x] video player contain autoplay api now
- [x] video player add quick play api
- [x] all alert or toast will be down by delegate function
- [x] add custom is followed with photoBrowser to dismiss or show 
- [x] add animated image to browser in Demo

## 1.Function describe and Point
* 1.depend `SDWebImage(5.0)`
* 2.load nine picture ,scrollView,tableView,chat session for IM 
* 3.most like photoBrowser of Wechat and Weibo in China
* 4.provide function which can delete and download image
* 5.provide quick play for video


## 2.How to use

### 1.init KNPhotoBrowser, set params
```
// 1.make every control as an object, put it into an array
KNPhotoItems *items = [[KNPhotoItems alloc] init];
items.url = [urlArr[i] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
items.sourceView = imageView;
// if current url is video type
// items.isVideo = true;
[self.itemsArr addObject:items];
```

```
// jump to the photobrowser --> you can see in the Demo 
KNPhotoBrowser *photoBrowser = [[KNPhotoBrowser alloc] init];
photoBrowser.itemsArr = [self.itemsArr copy];
photoBrowser.isNeedPageControl = true;
photoBrowser.isNeedPageNumView = true;
photoBrowser.isNeedRightTopBtn = true;
photoBrowser.isNeedPrefetch    = true;
photoBrowser.isNeedPictureLongPress = true;
photoBrowser.currentIndex = tap.view.tag;
[photoBrowser present];
```

### 2.provide Delegate --> KNPhotoBrowserDelegate
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

### 3.provide function of dismiss
```
// maybe you never use it
[_photoBrowser dismiss];
```

### 4.API
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

## By the way
* 1.Currently, It just be used in nine picure ,scrollView, tableView , chat session for IM 
* 2.if you find any bug, just contact me, it will be perfect by each other
* 3.perfect adapt `iPhone` `iPad`
* 4.perfect adapt the `rotate of the Screen` like `Wechat` and `Weibo`
* 5.if you get any idea, just contact me! Thanks
