![image](https://upload-images.jianshu.io/upload_images/1693073-222e76b529bc5f9e.png)

[![CocoaPods](http://img.shields.io/cocoapods/v/KNPhotoBrowser.svg?style=flat)](http://cocoapods.org/?q=KNPhotoBrowser)&nbsp;![CocoaPods](http://img.shields.io/cocoapods/p/KNPhotoBrowser.svg?style=flat)&nbsp;[![Support](https://img.shields.io/badge/support-iOS%209.0%2B%20-blue.svg?style=flat)](https://www.apple.com/nl/ios/)&nbsp;

# KNPhotoBrowser
[中文](https://github.com/LuKane/KNPhotoBrowser/blob/master/README_Chinese.md) | [English](https://github.com/LuKane/KNPhotoBrowser/blob/master/README.md)

#### most like photo or video browser of `Wechat(TX)` and `Weibo(Sina)` in China
#### if you get any function to add, just contact me by E-mail. Welcome to Star 


![image](https://upload-images.jianshu.io/upload_images/1693073-aa996299e74d04b8.gif)![image](https://upload-images.jianshu.io/upload_images/1693073-3c8632a1c5413564.gif)![image](https://upload-images.jianshu.io/upload_images/1693073-5db630d194aaba91.gif)![image](https://upload-images.jianshu.io/upload_images/1693073-c4b3c40b49899a2a.gif)![image](https://upload-images.jianshu.io/upload_images/1693073-934ff5b95e03083c.gif)

## Update content

| DESCRIPTION | STATUS|
| ------------- | ------------ |
| Base on UIViewController | &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;√ |
| Adapt for rotate of the screen, split screen of iPad | &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;√ |
| Adapt for `iPhone5`~`iPhone13Pro_Max` | &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;√ |
| Locate and net image and gif image  | &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;√ |
| Locate and net video  | &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;√ |
| PanGesture to dismiss or cancel [**API**]  | &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;√ |
| Prefetch image, max is 8 [**API**]  | &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;√ |
| Video player auto play [**API**]  | &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;√ |
| Video player times speed play [**API**]  | &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;√ |
| Video player support play online(no cache,no download) [**API**]  | &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;√ |
| Video player support play after download(it will search next time) [**API**]  | &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;√ |
| Show custom view on PhotoBrowser [**API**]  | &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;√ |
| Show custom view on PhotoBrowser, and set animated following photoBrowser [**API**]  | &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;√ |
| Before the photoBrowser show, all image control can be custom [**API**]  | &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;√ |
| All operation though the delegate [**Delegate**]  | &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;√ |

## 1.Before use, you need to know
* 1.depend `SDWebImage(5.0)`, if need locate gif image, depend `SDWebImage(5.8.3)`
* 2.image and video play is ready for use
* 3.download image or video is ready for use
* 4.custom control as you wish
* 5.auto manager image or video of download is finished

## 2.How to use

### (1).init base params
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
### (2).init PhotoBrowser

```objc
KNPhotoBrowser *photoBrowser = [[KNPhotoBrowser alloc] init];
photoBrowser.itemsArr = [self.itemsArr copy];
photoBrowser.currentIndex = tap.view.tag;

/// photoBrowser will present
[photoBrowser present];

/// photoBrowser will dismiss
/// [photoBrowser dismiss];
```

### (3).function's describe of delegate

##### photoBrowser will dismiss
```objc
/// photoBrowser will dismiss with currentIndex
- (void)photoBrowser:(KNPhotoBrowser *)photoBrowser willDismissWithIndex:(NSInteger)index;
```
##### photoBrowser right button did click
```objc
/// photoBrowser right top button did click with currentIndex (you can custom you right button, but if you custom your right button, that you need implementate your target action)
- (void)photoBrowser:(KNPhotoBrowser *)photoBrowser rightBtnOperationActionWithIndex:(NSInteger)index;
```
.....
### (4).component of browser : KNPhotoItems
##### base params of items
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
##### custom source View (it is very nice)
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

## 3.How to install 
```objc
pod 'KNPhotoBrowser'

// terminal : cd ~(current path)
pod install or pod update

```

## 5.By the way
* if you get any idea, just contact me! Thanks
