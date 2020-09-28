![image](https://raw.githubusercontent.com/LuKane/KNImageResource/master/PhotoBrower/KNPhotoBrower.png)

<a href="https://img.shields.io/cocoapods/v/KNPhotoBrowser.svg"><img src="https://img.shields.io/cocoapods/v/KNPhotoBrowser.svg"></a>
<a href="http://cocoadocs.org/docsets/KNPhotoBrowser"><img 
src="https://img.shields.io/cocoapods/p/KNPhotoBrowser.svg?style=flat"></a>

# KNPhotoBrowser 

[中文](https://github.com/LuKane/KNPhotoBrowser/blob/master/README_Chinese.md) | [English](https://github.com/LuKane/KNPhotoBrowser/blob/master/README.md)

##### 微信 && 微博 图片||视频 浏览器
⭐️⭐️⭐️⭐️⭐️⭐️⭐️ 有任何需要增加的功能,请直接邮箱联系我.欢迎点赞,谢谢 ⭐️⭐️⭐️⭐️⭐️⭐️⭐️
![image](https://github.com/LuKane/KNImageResource/blob/master/PhotoBrower/PhotoBrower.gif?raw=true)
![image](https://github.com/LuKane/KNImageResource/blob/master/PhotoBrower/collectionView.gif?raw=true)
![image](https://github.com/LuKane/KNImageResource/blob/master/PhotoBrower/scrollView.gif?raw=true)
![image](https://github.com/LuKane/KNImageResource/blob/master/PhotoBrower/tableView.gif?raw=true)
![image](https://github.com/LuKane/KNImageResource/blob/master/PhotoBrower/photoBrowser-IMVideo.gif?raw=true)
![image](https://github.com/LuKane/KNImageResource/blob/master/PhotoBrower/PhotoBrower_Pan.gif?raw=true)

## 内容 
- [x] 浏览器大改版, 将之前的 `UIView` 改成 `UIViewController`
- [x] 适配 `iPhoneX`、`iPhoneXS`、`iPhoneXR`、`iPhoneXS_Max`
- [x] 完美适配 屏幕旋转 , 请在真机上测试 旋转功能
- [x] 新增IM 聊天时 图片浏览器功能(2019/2/2)
- [x] 新增 图片预加载的功能 (2019/3/13)
- [x] 新增图片 拖拽 消失 或 回显的功能(2019/4/16)
- [x] 新增视频播放功能(本地视频和网络视频)(2019/7/30)
- [x] 视频播放增加了拖动 消失和 返回的功能
- [x] 当浏览器中包含 视频播放时, 无论设置是否隐藏pageControl ,都得隐藏
- [x] 增加多个自定义控件
- [x] 视频播放增加 自动播放的API
- [x] 视频播放增加 长按速放(0.5~2.0)
- [x] 所有弹出框和提示语都 通过代理方法回调
- [x] 增加自定义控件 是否随着 photoBrowser一起动画消失和显示
- [x] 增加Demo中默认动图 进行 动画浏览

## 一.功能描述及要点
* 1.依赖 `SDWebImage(5.0)`
* 2.加载九宫格图片,scrollView,tableView, IM类型
* 3.高仿 微信和微博 图片||视频 浏览效果,显示和回显动画
* 4.提供删除图片和下载图片||视频等功能
* 5.提供长按倍速播放视频的功能

## 二.方法调用

### 1.创建KNPhotoBrowser,并传入相应的参数
```
// 1.每个控件都弄成一个对象, 放入一个数组中
KNPhotoItems *items = [[KNPhotoItems alloc] init];
items.url = [urlArr[i] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
items.sourceView = imageView;
// 如果当前url是本地||网络视频
// items.isVideo = true;

[self.itemsArr addObject:items];
```

```
// 直接跳入 图片浏览器 --> 详情请看Demo
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
### 2.提供代理方法 --> KNPhotoBrowserDelegate
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

### 3.提供 消失方法
```
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

## 补充
* 1.目前适配 九宫格,scrollView,tableView, IM类型, 视频播放类型
* 2.如果bug, 希望大家给个issue,一起努力改好
* 3.完美适配 `iPhone` `iPad` 
* 4.完美适配 `横竖屏` : 模仿微信和微博
* 5.有需要增加的功能, 请您通过邮箱或者QQ联系我!
