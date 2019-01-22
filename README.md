![image](https://raw.githubusercontent.com/LuKane/KNImageResource/master/PhotoBrower/KNPhotoBrower.png)

# KNPhotoBrower 

[中文](http://example.com/) | [英文](http://example.com/)

##### 微信 && 微博 图片浏览器

⭐️⭐️⭐️⭐️⭐️⭐️⭐️ 有任何需要增加的功能,请直接邮箱联系我.欢迎点赞,谢谢 ⭐️⭐️⭐️⭐️⭐️⭐️⭐️
![image](https://github.com/LuKane/KNImageResource/blob/master/PhotoBrower/PhotoBrower.gif?raw=true)
![image](https://github.com/LuKane/KNImageResource/blob/master/PhotoBrower/collectionView.gif?raw=true)
![image](https://github.com/LuKane/KNImageResource/blob/master/PhotoBrower/scrollView.gif?raw=true)
![image](https://github.com/LuKane/KNImageResource/blob/master/PhotoBrower/tableView.gif?raw=true)

## 更新内容 
* 1.图片浏览器大改版, 将之前的 `UIView` 改成 `UIViewController`
* 2.适配 `iPhoneX`、`iPhoneXS`、`iPhoneXR`、`iPhoneXS_Max`
* 3.完美适配 屏幕旋转, 解决 微信图片浏览器的回显问题


## 一.功能描述及要点
* 1.依赖 `SDWebImage(4.0)` 以及 `FLAnimatedImage`
* 2.加载九宫格图片
* 3.高仿 微信和微博 图片浏览效果,显示和回显动画
* 4.提供删除图片和下载图片等功能
* 5.其他类型Demo,会尽快增添进去

## 二.方法调用

### 1.创建KNPhotoBrower,并传入相应的参数
```
// 1.每个控件都弄成一个对象, 放入一个数组中
KNPhotoItems *items = [[KNPhotoItems alloc] init];
items.url = [urlArr[i] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
items.sourceView = imageView;
[self.itemsArr addObject:items];
```

```
// 直接跳入 图片浏览器 --> 详情请看Demo
KNPhotoBrower *photoBrower = [[KNPhotoBrower alloc] init];
photoBrower.itemsArr = [self.itemsArr copy];
photoBrower.isNeedPageControl = true;
photoBrower.isNeedPageNumView = true;
photoBrower.isNeedRightTopBtn = true;
photoBrower.isNeedPictureLongPress = true;
photoBrower.currentIndex = tap.view.tag;
[photoBrower present];
```
### 2.提供代理方法 --> KNPhotoBrowerDelegate
```
/* PhotoBrower 即将消失 */
- (void)photoBrowerWillDismiss;
/* PhotoBrower 右上角按钮, 弹出框的点击 */
- (void)photoBrowerRightOperationActionWithIndex:(NSInteger)index;
/* PhotoBrower 保存图片是否成功 */
- (void)photoBrowerWriteToSavedPhotosAlbumStatus:(BOOL)success;
/* PhotoBrower 删除图片成功后返回-- > 相对 Index */
- (void)photoBrowerRightOperationDeleteImageSuccessWithRelativeIndex:(NSInteger)index;
/* PhotoBrower 删除图片成功后返回-- > 绝对 Index */
- (void)photoBrowerRightOperationDeleteImageSuccessWithAbsoluteIndex:(NSInteger)index;

```

### 3.提供 消失方法
```
[_photoBrower dismiss];
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
PhotoBrower show
*/
- (void)present;

/**
PhotoBrower dismiss
*/
- (void)dismiss;
```

### 5.注意点 : 强引用会导致PhotoBrower 在dismiss时 无法销毁
```
[强烈要求将以下代码写到代理方法中去]关于弹出框的内容,可在KNPhotoBrower.m 的operationBtnIBAction 方法中增减 (注意:代码中会存在强引用,所以切记将 weakSelf写入,不然当浏览器消失的时候,会存在强引用,不走 dealloc 方法)

__weak typeof(self) weakSelf = self;
KNActionSheet *actionSheet = [[KNActionSheet alloc] initWithCancelTitle:nil otherTitleArr:self.actionSheetArr.copy actionBlock:^(NSInteger buttonIndex) {
if([weakSelf.delegate respondsToSelector:@selector(photoBrowerRightOperationActionWithIndex:)]){
[weakSelf.delegate photoBrowerRightOperationActionWithIndex:buttonIndex];
}
}];
[actionSheet show];

```

## 补充
* 1.目前适配 九宫格, 其他类型,这边会陆续增加
* 2.如果bug, 希望大家给个issue,一起努力改好
* 3.完美适配 `iPhone` `iPad` 
* 4.完美适配 `横竖屏` : 模仿微信和微博
