//
//  CustomViewController.m
//  KNPhotoBrowser
//
//  Created by LuKane on 2020/2/21.
//  Copyright © 2020 LuKane. All rights reserved.
//

#import "CustomViewController.h"
#import "KNPhotoBrowser.h"
#import <UIImageView+WebCache.h>

@interface CustomViewController ()<KNPhotoBrowserDelegate,UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) NSMutableArray *itemsArr;
@property (nonatomic,weak  ) KNPhotoBrowser *photoBrowser;

@property (nonatomic,weak  ) UIView *tempView;

@end

@implementation CustomViewController

- (NSMutableArray *)itemsArr{
    if (!_itemsArr) {
        _itemsArr = [NSMutableArray array];
    }
    return _itemsArr;
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        CGFloat y = 10;
        CGFloat width = 180;
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - (width + y * 2) , self.view.frame.size.width, width + y * 2)];
        _scrollView.scrollEnabled = false;
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = false;
        _scrollView.showsHorizontalScrollIndicator = false;
        _scrollView.backgroundColor = UIColor.clearColor;
        _scrollView.contentSize = CGSizeMake((self.view.frame.size.width + 20) * 9, 0);
        
        for (NSInteger i = 0; i < 9; i++) {
            UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width + 20) * i, 0,self.view.frame.size.width + 20, _scrollView.frame.size.height)];
            titleL.textColor = UIColor.whiteColor;
            titleL.numberOfLines = 0;
            titleL.textAlignment = NSTextAlignmentCenter;
            titleL.text = [NSString stringWithFormat:@"This is an example for customView:%zd index\nThis is an example for customView:%zd index\nThis is an example for customView:%zd index\nThis is an example for customView:%zd index",i,i,i,i];
            [_scrollView addSubview:titleL];
        }
        
    }
    return _scrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"自定义控件";
    self.view.backgroundColor = UIColor.orangeColor;
    
    [self setupBgView];
}

- (void)setupBgView{
    NSMutableArray *arr = [NSMutableArray array];
    [arr addObject:@"https://wx3.sinaimg.cn/thumbnail/9bbc284bgy1frtdh1idwkj218g0rs7li.jpg"];
    [arr addObject:@"http://ww2.sinaimg.cn/thumbnail/642beb18gw1ep3629gfm0g206o050b2a.gif"];
    [arr addObject:@"http://ww2.sinaimg.cn/thumbnail/677febf5gw1erma104rhyj20k03dz16y.jpg"];
    
    [arr addObject:@"https://wx3.sinaimg.cn/thumbnail/9bbc284bgy1frtdgoa9xxj218g0rsaon.jpg"];
    [arr addObject:@"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr1xydcj20gy0o9q6s.jpg"];
    [arr addObject:@"http://ww2.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr39ht9j20gy0o6q74.jpg"];
    
    [arr addObject:@"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr3xvtlj20gy0obadv.jpg"];
    [arr addObject:@"https://wx2.sinaimg.cn/mw690/9bbc284bgy1frtdht9q6mj21hc0u0hdt.jpg"];
    [arr addObject:@"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr57tn9j20gy0obn0f.jpg"];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 30, self.view.frame.size.width - 20, self.view.frame.size.width - 20)];
    bgView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:bgView];
    
    CGFloat width = (bgView.frame.size.width - 40) / 3;
    
    for (NSInteger i = 0; i < arr.count; i++) {
        NSInteger row = i / 3;
        NSInteger col = i % 3;
        CGFloat x = 10 + col * (10 + width);
        CGFloat y = 10 + row * (10 + width);
        UIImageView *imgItem = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, width)];
        imgItem.userInteractionEnabled = true;
        imgItem.tag = i;
        [imgItem addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgItemDidClick:)]];
        [imgItem sd_setImageWithURL:[NSURL URLWithString:arr[i]] placeholderImage:nil];
        imgItem.backgroundColor = [UIColor grayColor];
        [bgView addSubview:imgItem];
        
        KNPhotoItems *items = [[KNPhotoItems alloc] init];
        items.url = [arr[i] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
        items.sourceView = imgItem;
        [self.itemsArr addObject:items];
    }
}

- (void)imgItemDidClick:(UITapGestureRecognizer *)tap{
    KNPhotoBrowser *photoBrower = [[KNPhotoBrowser alloc] init];
    
    [photoBrower createCustomViewArrOnTopView:@[self.scrollView] animated:true];
    
    
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 90) * 0.5, 100, 90, 30)];
    tempView.backgroundColor = UIColor.lightGrayColor;
    [photoBrower createCustomViewArrOnTopView:@[tempView] animated:false];
    _tempView = tempView;
    
    photoBrower.itemsArr = [self.itemsArr mutableCopy];
    photoBrower.currentIndex = tap.view.tag;
    photoBrower.isNeedPageControl = true;
    photoBrower.isNeedPageNumView = true;
    photoBrower.isNeedRightTopBtn = true;
    photoBrower.isNeedPictureLongPress = true;
    [photoBrower present];
    photoBrower.delegate = self;
}

- (void)photoBrowserScrollToLocateWithIndex:(NSInteger)index{
    [self.scrollView setContentOffset:CGPointMake((self.view.frame.size.width + 20) * index, 0) animated:false];
}

- (void)photoBrowserWillDismiss{
    [self.scrollView setContentOffset:CGPointZero animated:false];
}

- (void)photoBrowserWillLayoutSubviews{
    
    CGFloat y = 10;
    CGFloat width = 180;
    
    // change scrollView contentSize by yourself
    
    _scrollView.frame = CGRectMake(0, self.view.frame.size.height - (width + y * 2) , self.view.frame.size.width, width + y * 2);
    _tempView.frame = CGRectMake((self.view.frame.size.width - 90) * 0.5, 100, 90, 30);
    
}

@end
