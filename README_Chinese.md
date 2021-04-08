![image](https://upload-images.jianshu.io/upload_images/1693073-222e76b529bc5f9e.png)

[![CocoaPods](http://img.shields.io/cocoapods/v/KNPhotoBrowser.svg?style=flat)](http://cocoapods.org/?q=KNPhotoBrowser)&nbsp;![CocoaPods](http://img.shields.io/cocoapods/p/KNPhotoBrowser.svg?style=flat)&nbsp;[![Support](https://img.shields.io/badge/support-iOS%2010%2B%20-blue.svg?style=flat)](https://www.apple.com/nl/ios/)&nbsp;

# KNPhotoBrowser

[中文](https://github.com/LuKane/KNPhotoBrowser/blob/master/README_Chinese.md) | [English](https://github.com/LuKane/KNPhotoBrowser/blob/master/README.md)

##### 微信 && 微博 图片||视频 浏览器
⭐️⭐️⭐️⭐️⭐️⭐️⭐️ 有任何需要增加的功能,请直接邮箱联系我.欢迎点赞,谢谢 ⭐️⭐️⭐️⭐️⭐️⭐️⭐️

![image](https://upload-images.jianshu.io/upload_images/1693073-aa996299e74d04b8.gif)![image](https://upload-images.jianshu.io/upload_images/1693073-3c8632a1c5413564.gif)![image](https://upload-images.jianshu.io/upload_images/1693073-5db630d194aaba91.gif)![image](https://upload-images.jianshu.io/upload_images/1693073-c4b3c40b49899a2a.gif)![image](https://upload-images.jianshu.io/upload_images/1693073-934ff5b95e03083c.gif)

## 内容 
| 描述 | 状态|
| ------------- | ------------ |
| UIViewController | &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;√ |
| 适配屏幕旋转 | &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;√ |
| 适配 `iPhone5`~`iPhone12Pro_Max` | &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;√ |
| 本地图片和网络图片  | &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;√ |
| 本地视频和网络视频  | &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;√ |
| 拖拽消失和拖拽取消 [**API**]  | &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;√ |
| 预加载图片 [**API**]  | &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;√ |
| 视频自动播放 [**API**]  | &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;√ |
| 视频倍速播放 [**API**]  | &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;√ |
| 自定义控件展示 [**API**]  | &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;√ |
| 自定义控件展示, 以及跟随浏览器动态显示 [**API**]  | &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;√ |
| 自定义数据源控件 [**API**]  | &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;√ |
| 所有操作都通过代理回调执行 [**Delegate**]  | &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;√ |

## 一.功能描述及要点
* 1.依赖 `SDWebImage(5.0)`, 若需要本地gif图, 则依赖 `SDWebImage(5.8.3)`
* 2.图片展示和视频播放已经可以使用
* 3.下载图片和下载适配至相册
* 4.自定义控件
* 5.自动管图片和视频还没有实现
## 二.方法调用

### (1).初始化相应的参数
```objc
// 1.make every control as an object, put it into an array
KNPhotoItems *items = [[KNPhotoItems alloc] init];
items.url = @"http://xxxxxxxx/xxx.png";
items.sourceView = imageView;
// if current url is video type
// items.isVideo = true;
// if current image is locate gif
// itemM.isLocateGif = true;
[self.itemsArr addObject:items];
```

### (2).创建KNPhotoBrowser

```objc
KNPhotoBrowser *photoBrowser = [[KNPhotoBrowser alloc] init];
photoBrowser.itemsArr = [self.itemsArr copy];
photoBrowser.currentIndex = tap.view.tag;

/// photoBrowser will present
[photoBrowser present];

/// photoBrowser will dismiss
/// [photoBrowser dismiss];
```

### (3).提供代理方法 --> KNPhotoBrowserDelegate
##### 浏览器消失
```objc
/// photoBrowser will dismiss with currentIndex
- (void)photoBrowser:(KNPhotoBrowser *)photoBrowser willDismissWithIndex:(NSInteger)index;
```
##### 浏览器右上角按钮点击
```objc
/// photoBrowser right top button did click with currentIndex (you can custom you right button, but if you custom your right button, that you need implementate your target action)
- (void)photoBrowser:(KNPhotoBrowser *)photoBrowser rightBtnOperationActionWithIndex:(NSInteger)index;
```

### 4.组件: KNPhotoItems
##### items 的基本参数
```objc
/// if it is network image,  set `url` , do not set `sourceImage`
@property (nonatomic,copy  ) NSString *url;

/// if it is locate image, set `sourceImage`, do not set `url`
@property (nonatomic,strong) UIImage *sourceImage;

/// sourceView is current control to show image or video.
/// 1. if the sourceView is kind of `UIImageView` or `UIButton` , just only only only set the `sourceView`.
/// 2. if the sourceView is the custom view , set the `sourceView`, but do not forget set `sourceLinkArr` && `sourceLinkProperyName`.
@property (nonatomic,strong) UIView *sourceView;
```
##### 自定义数据源view
```objc
@property (nonatomic,strong) NSArray<NSString *> *sourceLinkArr;

/**
 eg:
    if the lastObject is kind of  UIImageView ,  the `sourceLinkProperyName` is `image`
    if the lastObject is kind of  UIButton ,  the `sourceLinkProperyName` is `currentBackgroundImage` or `currentImage`
 */

/// the property'name of the  sourceLinkArr lastObject
@property (nonatomic,copy  ) NSString *sourceLinkProperyName;

```

## 3.如何安装 
```objc
pod 'KNPhotoBrowser'

// terminal : cd ~(current path)
pod install or pod update

```

## 补充
* 1.目前适配 九宫格,scrollView,tableView, IM类型, 视频播放类型
* 2.如果bug, 希望大家给个issue,一起努力改好
* 3.完美适配 `iPhone` `iPad` 
* 4.完美适配 `横竖屏` : 模仿微信和微博
* 5.有需要增加的功能, 请您通过邮箱或者QQ联系我!
