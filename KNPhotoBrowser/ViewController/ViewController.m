//
//  ViewController.m
//  KNPhotoBrowser
//
//  Created by LuKane on 2019/1/14.
//  Copyright © 2019 LuKane. All rights reserved.
//

#import "ViewController.h"
#import "KNPhotoBrowser.h"
#import "KNToast.h"
#import "UIImageView+WebCache.h"

@interface ViewController ()<KNPhotoBrowserDelegate>

@property (nonatomic,strong) NSMutableArray *itemsArr;
@property (nonatomic,strong) NSMutableArray *actionSheetArr;

@property (nonatomic,assign) BOOL  statusBarHidden;

@end

@implementation ViewController

- (NSMutableArray *)itemsArr{
    if (!_itemsArr) {
        _itemsArr = [NSMutableArray array];
    }
    return _itemsArr;
}

- (NSMutableArray *)actionSheetArr{
    if (!_actionSheetArr) {
        _actionSheetArr = [NSMutableArray array];
        [_actionSheetArr addObject:@"第一个"];
        [_actionSheetArr addObject:@"第二个"];
        [_actionSheetArr addObject:@"第三个"];
        [_actionSheetArr addObject:@"第四个"];
    }
    return _actionSheetArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Normal(网络)";
    
    [self setupTopImgView];
    [self setupNineSquareView];
    
    [[KNToast shareToast] initWithText:@"第一张图片在屏幕上方"];
}

// the first imageView is outside of the Window
- (void)setupTopImgView{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, -200, 50, 50);
    [imageView sd_setImageWithURL:[NSURL URLWithString:@"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr1xydcj20gy0o9q6s.jpg"]];
    imageView.userInteractionEnabled = YES;
    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidClick:)]];
    imageView.tag = 0;
    
    [self.view addSubview:imageView];
    
    KNPhotoItems *items = [[KNPhotoItems alloc] init];
    items.url = @"http://ww3.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr1xydcj20gy0o9q6s.jpg";
    items.sourceView = imageView;
    [self.itemsArr addObject:items];
}

- (void)setupNineSquareView{
    CGFloat viewWidth = self.view.frame.size.width;
    
    // NineSquare view as a base view
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 100, viewWidth - 20, viewWidth - 20)];
    view.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:view];
    
    NSArray *urlArr = @[
                        @"https://wx3.sinaimg.cn/thumbnail/9bbc284bgy1frtdh1idwkj218g0rs7li.jpg",
                        @"https://wx3.sinaimg.cn/thumbnail/9bbc284bgy1frtdgoa9xxj218g0rsaon.jpg",
                        @"https://wx2.sinaimg.cn/thumbnail/9bbc284bgy1frtdht9q6mj21hc0u0hdt.jpg",
                        @"http://ww2.sinaimg.cn/thumbnail/642beb18gw1ep3629gfm0g206o050b2a.gif",
                        @"http://ww2.sinaimg.cn/thumbnail/677febf5gw1erma104rhyj20k03dz16y.jpg",
                        @"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr1xydcj20gy0o9q6s.jpg",
                        @"http://ww2.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr39ht9j20gy0o6q74.jpg",
                        @"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr3xvtlj20gy0obadv.jpg",
                        @"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr57tn9j20gy0obn0f.jpg"
                        ];
    
    for (NSInteger i = 0 ;i < urlArr.count; i ++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidClick:)]];
        imageView.tag = i + 1;
        [imageView sd_setImageWithURL:urlArr[i] placeholderImage:[self createImageWithUIColor:[UIColor grayColor]]];
        imageView.backgroundColor = [UIColor grayColor];
        CGFloat width = (view.frame.size.width - 40) / 3;
        NSInteger row = i / 3;
        NSInteger col = i % 3;
        CGFloat x = 10 + col * (10 + width);
        CGFloat y = 10 + row * (10 + width);
        imageView.frame = CGRectMake(x, y, width, width);
        
        KNPhotoItems *items = [[KNPhotoItems alloc] init];
        items.url = [urlArr[i] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
        items.sourceView = imageView;
        [self.itemsArr addObject:items];
        
        [view addSubview:imageView];
    }
}

- (UIImage *)createImageWithUIColor:(UIColor *)imageColor{
    CGRect rect = CGRectMake(0, 0, 1.f, 1.f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [imageColor CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)imageViewDidClick:(UITapGestureRecognizer *)tap{
    KNPhotoBrowser *photoBrower = [[KNPhotoBrowser alloc] init];
    photoBrower.itemsArr = [self.itemsArr copy];
    photoBrower.isNeedPageControl = true;
    photoBrower.isNeedPageNumView = true;
    photoBrower.isNeedRightTopBtn = true;
    photoBrower.isNeedPictureLongPress = true;
    photoBrower.currentIndex = tap.view.tag;
    photoBrower.delegate = self;
    [photoBrower present];
}

- (void)photoBrowserNeedLoadScreenPortrait{
    
}


@end
