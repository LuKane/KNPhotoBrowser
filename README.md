# KNPhotoBrower
高仿 微博 图片浏览器

![image](https://github.com/LuKane/KNImageResource/blob/master/PhotoBrower.gif)

##一.功能描述及要点
* 1.加载网络九宫格图片
* 2.SDWebImage下载图片,KNProgressHUD显示加载进度
* 3.高仿微博,显示动画,KNToast提示

##二.方法调用
### 1.创建KNPhotoBrower,并传入相应的参数
```
KNPhotoBrower *photoBrower = [[KNPhotoBrower alloc] init];
photoBrower.imageArr = [_urlArray copy]; // 图片URL的数组
photoBrower.currentIndex = tap.view.tag;// 当前点击的哪个图片
photoBrower.sourceView = _view; // 所有图片的 父控件
[photoBrower present];// 显示
```
### 2.提供代理方法 --> KNPhotoBrowerDelegate
```
/* PhotoBrower 即将消失 */
- (void)photoBrowerWillDismiss;
/* PhotoBrower 右上角按钮的点击 */
- (void)photoBrowerRightOperationActionWithIndex:(NSInteger)index;
/* PhotoBrower 保存图片是否成功 */
- (void)photoBrowerWriteToSavedPhotosAlbumStatus:(BOOL)success;

```
### 3.提供 消失方法
```
[_photoBrower dissmiss];
```

### 4.设置 参数
```
/**
 *  是否需要右上角的按钮. Default is YES;
 */
@property (nonatomic, assign) BOOL isNeedRightTopBtn;
/**
 *  是否需要 顶部 1 / 9 控件 ,Default is YES
 */
@property (nonatomic, assign) BOOL isNeedPageNumView;
/**
 *  是否需要 底部 UIPageControl, Default is NO
 */
@property (nonatomic, assign) BOOL isNeedPageControl;
```

## 补充
* 1.目前适合 九宫格样式
* 2.如果有bug, 请在Github上通过 '邮箱' 或者 直接issue ,我会尽快修改
* 3.后期会提供适合 'collectionView' , 'scrollView' 等相应功能
