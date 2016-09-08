//
//  ViewController.m
//  KNPhotoBrower
//
//  Created by LuKane on 16/8/16.
//  Copyright © 2016年 LuKane. All rights reserved.
//


#import "ViewController.h"
#import "UIImageView+WebCache.h"
#import "KNPhotoBrowerImageView.h"
#import "KNPhotoBrower.h"

@interface ViewController ()<KNPhotoBrowerDelegate>{
    BOOL     _ApplicationStatusIsHidden;
    UIView  *_view;
}

@property (nonatomic, strong) NSMutableArray *urlArray;
@property (nonatomic, strong) NSMutableArray *actionSheetArray; // 右上角弹出框的 选项 -->代理回调
@property (nonatomic, strong) KNPhotoBrower *photoBrower;

@end

@implementation ViewController

- (NSMutableArray *)actionSheetArray{
    if (!_actionSheetArray) {
        _actionSheetArray = [NSMutableArray array];
    }
    return _actionSheetArray;
}

- (NSMutableArray *)urlArray{
    if (!_urlArray) {
        _urlArray = [NSMutableArray array];
    }
    return _urlArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"KNPhotoBrower演示";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [[SDWebImageManager sharedManager].imageCache clearDisk];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    NSArray *urlArr = @[
                        @"http://ww4.sinaimg.cn/thumbnail/7f8c1087gw1e9g06pc68ug20ag05y4qq.gif",
                        @"http://ww2.sinaimg.cn/thumbnail/642beb18gw1ep3629gfm0g206o050b2a.gif",
                        @"http://ww2.sinaimg.cn/thumbnail/677febf5gw1erma104rhyj20k03dz16y.jpg",
                        @"http://ww4.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr1d0vyj20pf0gytcj.jpg",
                        @"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr1xydcj20gy0o9q6s.jpg",
                        @"http://ww2.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr39ht9j20gy0o6q74.jpg",
                        @"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr3xvtlj20gy0obadv.jpg",
                        @"http://ww4.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr4nndfj20gy0o9q6i.jpg",
                        @"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr57tn9j20gy0obn0f.jpg"
                        ];
    
    for (NSInteger i = 0; i < urlArr.count; i++) {
        NSString *url = urlArr[i];
        url =  [url stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
        [self.urlArray addObject:url];
    }
    
    CGFloat viewWidth = self.view.frame.size.width;
    
// 背景View =======================
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 100, viewWidth - 20, viewWidth - 20)];
    view.backgroundColor = [UIColor orangeColor];
    _view = view;
    [self.view addSubview:view];
    
// ActionSheet 右上角按钮的 选项, 如果有下载图片, 则按照 KNPhotoBrower.m文件中 operationBtnIBAction 中所写的注释去做
    self.actionSheetArray = [NSMutableArray array];
    [self.actionSheetArray addObject:@"第一个"];
    [self.actionSheetArray addObject:@"第二个"];
    [self.actionSheetArray addObject:@"第三个"];
    [self.actionSheetArray addObject:@"第四个"];
    
// 布局 九宫格
    for (NSInteger i = 0 ;i < urlArr.count; i ++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)]];
        imageView.tag = i;
        [imageView sd_setImageWithURL:urlArr[i] placeholderImage:nil];
        imageView.backgroundColor = [UIColor grayColor];
        CGFloat width = (view.frame.size.width - 40) / 3;
        NSInteger row = i / 3;
        NSInteger col = i % 3;
        CGFloat x = 10 + col * (10 + width);
        CGFloat y = 10 + row * (10 + width);
        imageView.frame = CGRectMake(x, y, width, width);
        [view addSubview:imageView];
    }
}

/****************************** == KNPhotoBrower 的 展现 == ********************************/
- (void)click:(UITapGestureRecognizer *)tap{
    KNPhotoBrower *photoBrower = [[KNPhotoBrower alloc] init];
    photoBrower.imageArr = [_urlArray copy];
    photoBrower.currentIndex = tap.view.tag;
    photoBrower.sourceView = _view; // 所有图片的 父控件
    
// 如果设置了 photoBrower中的 actionSheetArr 属性. 那么 isNeedRightTopBtn 就应该是默认 YES, 如果设置成NO, 这个actionSheetArr 属性就没有意义了
//    photoBrower.actionSheetArr = [self.actionSheetArray mutableCopy];
    
    [photoBrower present];
    
    _photoBrower = photoBrower;
    
    // 设置代理方法 --->可不写
    [photoBrower setDelegate:self];
    
    // 这里是 设置 状态栏的 隐藏 ---> 可不写
    _ApplicationStatusIsHidden = YES;
    [self setNeedsStatusBarAppearanceUpdate];
}

// 下面方法 是让 '状态栏' 在 PhotoBrower 显示的时候 消失, 消失的时候 显示 ---> 根据项目需求而定
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (BOOL)prefersStatusBarHidden{
    if(_ApplicationStatusIsHidden){
        return YES;
    }
    return NO;
}

#pragma mark - Delegate

/* PhotoBrower 即将消失 */
- (void)photoBrowerWillDismiss{
    NSLog(@"Will Dismiss");
    _ApplicationStatusIsHidden = NO;
    [self setNeedsStatusBarAppearanceUpdate];
}

/* PhotoBrower 右上角按钮的点击 */
- (void)photoBrowerRightOperationActionWithIndex:(NSInteger)index{
    NSLog(@"operation:%zd",index);
}

/* PhotoBrower 保存图片是否成功 */
- (void)photoBrowerWriteToSavedPhotosAlbumStatus:(BOOL)success{
    NSLog(@"saveImage:%zd",success);
}


@end
