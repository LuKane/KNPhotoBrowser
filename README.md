# KNPhotoBrower
高仿 微博 图片浏览器

![image](https://github.com/LuKane/KNImageResource/blob/master/PhotoBrower.gif)

##一.功能描述及要点
* 1.加载网络九宫格图片,collectionView,scrollView
* 2.SDWebImage下载图片,KNProgressHUD显示加载进度
* 3.高仿微博,显示动画,KNToast提示

##二.方法调用
### 1.创建KNPhotoBrower,并传入相应的参数
```
// 每一个图片控件对象, 对一一对应 KNPhotoItems ,再将多个KNPhotoItems 对象放入数组
KNPhotoItems *items = [[KNPhotoItems alloc] init];
items.url = [urlArr[i] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
items.sourceView = imageView;

KNPhotoBrower *photoBrower = [[KNPhotoBrower alloc] init];
photoBrower.itemsArr = [_itemsArray copy];// KNPhotoItems对象的数组
photoBrower.currentIndex = tap.view.tag;// 当前点击的哪个图片
photoBrower.actionSheetArr = [self.actionSheetArray mutableCopy];//设置 ActionSheet的选项
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
[_photoBrower dismiss];
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
/**
 *  存放 ActionSheet 弹出框的内容 :NSString类型
 */
@property (nonatomic, strong) NSMutableArray *actionSheetArr;
```
### 5.关于弹出框的内容,可在KNPhotoBrower.m 的operationBtnIBAction 方法中增减
```
#pragma mark - 右上角 按钮的点击
- (void)operationBtnIBAction{
    __weak typeof(self) weakSelf = self;
    
    if(_actionSheetArr.count != 0){ // 如果是自定义的 选项
        
        KNActionSheet *actionSheet = [[KNActionSheet alloc] initWithCancelBtnTitle:nil destructiveButtonTitle:nil otherBtnTitlesArr:[_actionSheetArr copy] actionBlock:^(NSInteger buttonIndex) {
            
            // 让代理知道 是哪个按钮被点击了
            if([weakSelf.delegate respondsToSelector:@selector(photoBrowerRightOperationActionWithIndex:)]){
                [weakSelf.delegate photoBrowerRightOperationActionWithIndex:buttonIndex];
            }
            
#warning 如果传入的 ActionSheetArr 有下载图片这一选项. 则在这里调用和下面一样的方法 switch.....,如果没有下载图片,则通过代理方法去实现... 目前不支持删除功能
            
        }];
        [actionSheet show];
    }else{
        KNActionSheet *actionSheet = [[KNActionSheet alloc] initWithCancelBtnTitle:nil destructiveButtonTitle:nil otherBtnTitlesArr:@[@"保存图片",@"转发微博",@"赞"] actionBlock:^(NSInteger buttonIndex) {
            
            // 让代理知道 是哪个按钮被点击了
            if([weakSelf.delegate respondsToSelector:@selector(photoBrowerRightOperationActionWithIndex:)]){
                [weakSelf.delegate photoBrowerRightOperationActionWithIndex:buttonIndex];
            }
            
            switch (buttonIndex) {
                case 0:{
                    SDWebImageManager *mgr = [SDWebImageManager sharedManager];
                    KNPhotoItems *items = _itemsArr[_currentIndex];
                    if(![mgr diskImageExistsForURL:[NSURL URLWithString:items.url]]){
                        [[KNToast shareToast] initWithText:@"图片需要下载完成"];
                        return ;
                    }else{
                        UIImage *image = [[mgr imageCache] imageFromDiskCacheForKey:items.url];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
                        });
                    }
                }
                default:
                    break;
            }
        }];
        [actionSheet show];
    }
}
```

## 补充
* 1.目前适合 九宫格样式,collectionView,scrollView
* 2.如果有bug, 请在Github上通过 '邮箱' 或者 直接issue ,我会尽快修改
