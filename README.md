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
* 1.browser has been recoded , turn the `UIView` to the `UIViewController`
* 2.adapt `iPhoneX`、`iPhoneXS`、`iPhoneXR`、`iPhoneXS_Max`
* 3.perfect adapt the rotate of the Screen,try on the real iPhone or iPad
* 4.photoBrowser for IM (like `Wechat` chat session)
* 5.photoBrowser add prefetch image API (2019/3/13)
* 6.photoBrowser add panGesture to dismiss or cancel(2019/4/16)
* 7.video player is ready to use (location video and net video) (2019/7/30)
* 8.swipe  video player is done!  
* 9.when photobrowser contain video ,then hide pagecontrol whatever you need or not pageControl
* 10. pod 1.1.1 -> add KNPhotoBrowser to the cocoapods
* 11. pod 1.1.2 -> add custom View on photoBrowser 



## 1.Function describe and Point
* 1.Depend `SDWebImage(5.0)` and `FLAnimatedImage`
* 2.load nine picture ,scrollView,tableView,chat session for IM 
* 3.most like photoBrowser of Wechat and Weibo in China
* 4.provide function which can delete and download image
* 5.the other type's Demo will be upload soon


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
/* PhotoBrowser will dismiss */
- (void)photoBrowserWillDismiss;
/* PhotoBrowser right top btn show and ActionSheet will click with Index */
- (void)photoBrowserRightOperationActionWithIndex:(NSInteger)index;
/* PhotoBrowser save pic is success or not */
- (void)photoBrowserWriteToSavedPhotosAlbumStatus:(BOOL)success;
/* PhotoBrowser delete image --> relative index */
- (void)photoBrowserRightOperationDeleteImageSuccessWithRelativeIndex:(NSInteger)index;
/* PhotoBrowser delete image --> absolute Index */
- (void)photoBrowserRightOperationDeleteImageSuccessWithAbsoluteIndex:(NSInteger)index;
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
is or not need pan Gesture, Default is false
*/
@property (nonatomic,assign) BOOL  isNeedPanGesture;

/**
PhotoBrowser show
*/
- (void)present;

/**
PhotoBrowser dismiss
*/
- (void)dismiss;
```

### 5.Most important point : strong link will lead to the photobrowser never destroy when it dismiss
```
// about ActionSheet, if you use it with much code, just let the `self` become `weakSelf` 
__weak typeof(self) weakSelf = self;
KNActionSheet *actionSheet = [[KNActionSheet alloc] initWithCancelTitle:nil otherTitleArr:self.actionSheetArr.copy actionBlock:^(NSInteger buttonIndex) {
if([weakSelf.delegate respondsToSelector:@selector(photoBrowserRightOperationActionWithIndex:)]){
[weakSelf.delegate photoBrowserRightOperationActionWithIndex:buttonIndex];
}
}];
[actionSheet show];

```

## By the way
* 1.Currently, It just be used in nine picure ,scrollView, tableView , chat session for IM 
* 2.if you find any bug, just contact me, it will be perfect by each other
* 3.perfect adapt `iPhone` `iPad`
* 4.perfect adapt the `rotate of the Screen` like `Wechat` and `Weibo`
