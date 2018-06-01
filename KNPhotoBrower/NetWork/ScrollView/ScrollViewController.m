//
//  ScrollViewController.m
//  KNPhotoBrower
//
//  Created by LuKane on 16/9/18.
//  Copyright © 2016年 LuKane. All rights reserved.
//

#import "ScrollViewController.h"
#import "UIImageView+WebCache.h"
#import "KNPhotoBrower.h"

@interface ScrollViewController ()<UIScrollViewDelegate,KNPhotoBrowerDelegate>

@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, strong) NSMutableArray *itemsArr;

@end

@implementation ScrollViewController

- (instancetype)init{
    if (self = [super init]) {
        NSArray *urlArr = @[
                            @"https://wx3.sinaimg.cn/thumbnail/9bbc284bgy1frtdh1idwkj218g0rs7li.jpg",
                            @"http://ww2.sinaimg.cn/thumbnail/642beb18gw1ep3629gfm0g206o050b2a.gif",
                            @"http://ww2.sinaimg.cn/thumbnail/677febf5gw1erma104rhyj20k03dz16y.jpg",
                            @"https://wx3.sinaimg.cn/thumbnail/9bbc284bgy1frtdgoa9xxj218g0rsaon.jpg",
                            @"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr1xydcj20gy0o9q6s.jpg",
                            @"http://ww2.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr39ht9j20gy0o6q74.jpg",
                            @"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr3xvtlj20gy0obadv.jpg",
                            @"https://wx2.sinaimg.cn/mw690/9bbc284bgy1frtdht9q6mj21hc0u0hdt.jpg",
                            @"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr57tn9j20gy0obn0f.jpg"
                            ];
        self.dataArr = [urlArr mutableCopy];
    }
    return self;
}

- (NSMutableArray *)itemsArr{
    if (!_itemsArr) {
        _itemsArr = [NSMutableArray array];
    }
    return _itemsArr;
}

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"ScrollView(网络)";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setupScrollView];
}

- (void)setupScrollView{
    
    CGFloat y = 10;
    CGFloat width = 180;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, width + y * 2)];
    [scrollView setDelegate:self];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    [scrollView setShowsVerticalScrollIndicator:NO];
    [scrollView setContentSize:(CGSize){(width + y * 2) * self.dataArr.count,0}];
    [scrollView setBackgroundColor:[UIColor orangeColor]];
    [self.view addSubview:scrollView];
    
    for (NSInteger i = 0; i < self.dataArr.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView setUserInteractionEnabled:YES];
        [imageView setBackgroundColor:[UIColor grayColor]];
        [imageView setTag:i];
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewIBAction:)]];
        CGFloat x = (y * 2 + width) * i + 10;
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.dataArr[i]] placeholderImage:nil];
        imageView.frame = CGRectMake(x, y, width, width);
        [scrollView addSubview:imageView];
        
        KNPhotoItems *items = [[KNPhotoItems alloc] init];
        items.url = [self.dataArr[i] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
        items.sourceView = imageView;
        [self.itemsArr addObject:items];
    }
}

- (void)imageViewIBAction:(UITapGestureRecognizer *)tap{
    KNPhotoBrower *photoBrower = [[KNPhotoBrower alloc] init];
    photoBrower.itemsArr = [_itemsArr copy];
    photoBrower.currentIndex = tap.view.tag;
    [photoBrower setDelegate:self];
    [photoBrower present];
}


/*************************** == Delegate == ************************/
/* PhotoBrower 即将消失 */
- (void)photoBrowerWillDismiss{
    NSLog(@"Will Dismiss");
}

/* PhotoBrower 右上角按钮的点击 */
- (void)photoBrowerRightOperationActionWithIndex:(NSInteger)index{
    NSLog(@"operation:%zd",index);
}

/**
 *  删除当前图片
 *
 *  @param index 相对 下标
 */
- (void)photoBrowerRightOperationDeleteImageSuccessWithRelativeIndex:(NSInteger)index{
    NSLog(@"delete-Relative:%zd",index);
}

/**
 *  删除当前图片
 *
 *  @param index 绝对 下标
 */
- (void)photoBrowerRightOperationDeleteImageSuccessWithAbsoluteIndex:(NSInteger)index{
    NSLog(@"delete-Absolute:%zd",index);
}

/* PhotoBrower 保存图片是否成功 */
- (void)photoBrowerWriteToSavedPhotosAlbumStatus:(BOOL)success{
    NSLog(@"saveImage:%zd",success);
}

@end
