![image](https://upload-images.jianshu.io/upload_images/1693073-222e76b529bc5f9e.png)

<a href="https://img.shields.io/cocoapods/v/KNPhotoBrowser.svg"><img src="https://img.shields.io/cocoapods/v/KNPhotoBrowser.svg"></a>
<a href="http://cocoadocs.org/docsets/KNPhotoBrowser"><img 
src="https://img.shields.io/cocoapods/p/KNPhotoBrowser.svg?style=flat"></a>

# KNPhotoBrowser 

[中文](https://github.com/LuKane/KNPhotoBrowser/blob/master/README_Chinese.md) | [English](https://github.com/LuKane/KNPhotoBrowser/blob/master/README.md)

##### 微信 && 微博 图片||视频 浏览器
⭐️⭐️⭐️⭐️⭐️⭐️⭐️ 有任何需要增加的功能,请直接邮箱联系我.欢迎点赞,谢谢 ⭐️⭐️⭐️⭐️⭐️⭐️⭐️

![image](https://upload-images.jianshu.io/upload_images/1693073-138f5db5a76a3751.gif)
![image](https://upload-images.jianshu.io/upload_images/1693073-aa996299e74d04b8.gif)
![image](https://upload-images.jianshu.io/upload_images/1693073-3c8632a1c5413564.gif)
![image](https://upload-images.jianshu.io/upload_images/1693073-5db630d194aaba91.gif)
![image](https://upload-images.jianshu.io/upload_images/1693073-c4b3c40b49899a2a.gif)
![image](https://upload-images.jianshu.io/upload_images/1693073-934ff5b95e03083c.gif)

## 内容 
- [x] 浏览器编码为 `UIViewController`
- [x] 适配 `iPhoneX`、`iPhoneXS`、`iPhoneXR`、`iPhoneXS_Max`、`iPhone12Mini`、`iPhone12`、`iPhone12_Pro_Max`
- [x] 完美适配屏幕旋转, 请在真机上测试
- [x] 拖动消失或取消
- [x] 预加载图片
- [x] 加载本地gif图
- [x] 本地和网络视频播放器
- [x] 视频轻扫功能
- [x] 视频快放功能
- [x] 在浏览器上自定义控件
- [x] 自定义控件  跟着 浏览器一起动画消失和动画展示
- [x] 所有的弹出信息和操作 都通过代理方法操作

## 一.功能描述及要点
* 1.依赖 `SDWebImage(5.0)`
* 2.类似与微信和微博
* 3.提供控件操作并通过代理方法处理
* 4.自定义控件

## 二.方法调用

### 1.创建KNPhotoBrowser,并传入相应的参数
```
// 1.每个控件都弄成一个对象, 放入一个数组中
KNPhotoItems *items = [[KNPhotoItems alloc] init];
items.url = [urlArr[i] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
items.sourceView = imageView;
// 如果是视频
// items.isVideo = true;
// 如果是本地gif
// itemM.isLocateGif = true;
[self.itemsArr addObject:items];
```

### 2. present : 自定义控件

```
// 直接跳入 图片浏览器 --> 详情请看Demo
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
### 3.提供代理方法 --> KNPhotoBrowserDelegate
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

### 4.提供 消失方法
```
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

## 补充
* 1.目前适配 九宫格,scrollView,tableView, IM类型, 视频播放类型
* 2.如果bug, 希望大家给个issue,一起努力改好
* 3.完美适配 `iPhone` `iPad` 
* 4.完美适配 `横竖屏` : 模仿微信和微博
* 5.有需要增加的功能, 请您通过邮箱或者QQ联系我!
