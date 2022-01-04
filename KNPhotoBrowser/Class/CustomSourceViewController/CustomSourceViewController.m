//
//  CustomSourceViewController.m
//  KNPhotoBrowser
//
//  Created by LuKane on 2021/5/22.
//  Copyright © 2021 LuKane. All rights reserved.
//

#import "CustomSourceViewController.h"
#import "KNPhotoBrowser.h"
#import "UIView+Extension.h"
#import "CustomSourceView1.h"
#import "CustomSourceView2.h"
#import <UIImageView+WebCache.h>

@interface CustomSourceViewController ()

@property (nonatomic,strong) NSMutableArray *itemsArr;
@property (nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation CustomSourceViewController

- (NSMutableArray *)itemsArr{
    if (!_itemsArr) {
        _itemsArr = [NSMutableArray array];
    }
    return _itemsArr;
}

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
        [_dataArr addObject:@"http://wx3.sinaimg.cn/thumbnail/9bbc284bgy1frtdh1idwkj218g0rs7li.jpg"];
        [_dataArr addObject:@"http://ww2.sinaimg.cn/bmiddle/642beb18gw1ep3629gfm0g206o050b2a.gif"];
        [_dataArr addObject:@"http://ww2.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr39ht9j20gy0o6q74.jpg"];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Custom source view";
    [self setupSubViews];
}

- (void)setupSubViews{
    CGFloat viewWidth = self.view.frame.size.width;
    CGFloat itemWidth = (viewWidth - 40 - 20) / 3;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 100, viewWidth - 20, itemWidth + 20)];
    view.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:view];
    
    CustomSourceView1 *sourceV0 = [[CustomSourceView1 alloc] initWithFrame:CGRectMake(10, 10, itemWidth, itemWidth)];
    [view addSubview:sourceV0];
    
    CustomSourceView2 *sourceV1 = [[CustomSourceView2 alloc] initWithFrame:CGRectMake(20 + itemWidth, 10, itemWidth, itemWidth)];
    [view addSubview:sourceV1];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(30 + itemWidth * 2, 10, itemWidth, itemWidth)];
    [view addSubview:imageView];
    
    
    sourceV0.imgView.imageView.userInteractionEnabled = true;
    sourceV1.imgView.imageView.userInteractionEnabled = true;
    imageView.userInteractionEnabled = true;
    
    sourceV0.imgView.imageView.tag = 0;
    sourceV1.imgView.imageView.tag = 1;
    imageView.tag = 2;
    
    [sourceV0.imgView.imageView  addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sourceViewDidClick:)]];
    [sourceV1.imgView.imageView  addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sourceViewDidClick:)]];
    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sourceViewDidClick:)]];
    
    [sourceV0.imgView.imageView sd_setImageWithURL:[NSURL URLWithString:self.dataArr.firstObject]];
    [sourceV1.imgView.imageView sd_setImageWithURL:[NSURL URLWithString:self.dataArr[1]]];
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.dataArr.lastObject]];
    
    {
        /// for normal image
        KNPhotoItems *photoItems = [[KNPhotoItems alloc] init];
        photoItems.sourceView = sourceV0;
        
        NSMutableArray *arr = [NSMutableArray array];
        [arr addObject:@"CustomSourceImageView1"];
        [arr addObject:@"UIImageView"];
        photoItems.sourceLinkArr = [arr copy];
        
        photoItems.url = [self.dataArr[0] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
        
        [self.itemsArr addObject:photoItems];
    }
    
    {
        /// for gif
        KNPhotoItems *photoItems = [[KNPhotoItems alloc] init];
        photoItems.sourceView = sourceV1;
        photoItems.url = [self.dataArr[1] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
        
        NSMutableArray *arr = [NSMutableArray array];
        [arr addObject:@"CustomSourceImageView2"];
        [arr addObject:@"SDAnimatedImageView"];
        photoItems.sourceLinkArr = [arr copy];
        photoItems.sourceLinkProperyName = @"currentFrame";
        
        [self.itemsArr addObject:photoItems];
    }
    
    {
        /// for simple normal image
        KNPhotoItems *photoItems = [[KNPhotoItems alloc] init];
        photoItems.sourceView = imageView;
        photoItems.url = [self.dataArr[2] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
        
        [self.itemsArr addObject:photoItems];
    }
}

- (void)sourceViewDidClick:(UITapGestureRecognizer *)tap{
    KNPhotoBrowser *photoBrowser = [[KNPhotoBrowser alloc] init];
    photoBrowser.itemsArr = [self.itemsArr copy];
    photoBrowser.isNeedPageNumView = true;
    photoBrowser.isNeedPageControl = true;
    photoBrowser.isNeedLongPress = true;
    photoBrowser.isNeedPanGesture = true;
    photoBrowser.isNeedPrefetch = true;
    photoBrowser.isNeedAutoPlay = true;
    photoBrowser.placeHolderColor = UIColor.lightTextColor;
    photoBrowser.currentIndex = tap.view.tag;
    
    [photoBrowser present];
}

@end
