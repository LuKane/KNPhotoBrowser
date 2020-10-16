//
//  LocateGifController.m
//  KNPhotoBrowser
//
//  Created by LuKane on 2020/10/16.
//  Copyright © 2020 LuKane. All rights reserved.
//

#import "LocateGifController.h"
#import "KNPhotoBrowser.h"

#import <SDAnimatedImage.h>
#import <SDAnimatedImageView.h>
#import <UIImageView+WebCache.h>

@interface LocateGifController ()

@property (nonatomic,strong) NSMutableArray *itemArr;

@end

@implementation LocateGifController

- (NSMutableArray *)itemArr {
    if (!_itemArr) {
        _itemArr = [NSMutableArray array];
    }
    return _itemArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"本地GIF";
    
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
        
        if (i == 0) {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"gif3.GIF" ofType:nil];
            NSData *data = [NSData dataWithContentsOfFile:path];
            SDAnimatedImage *animatedImage = [[SDAnimatedImage alloc] initWithData:data];
            
            SDAnimatedImageView *imgView = [[SDAnimatedImageView alloc] initWithFrame:CGRectMake(x, y, width, width)];
            imgView.userInteractionEnabled = true;
            [imgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidClick:)]];
            imgView.image = animatedImage;
            [bgView addSubview:imgView];
            
            KNPhotoItems *itemM = [[KNPhotoItems alloc] init];
            itemM.sourceImage = animatedImage;
            itemM.sourceView = imgView;
            itemM.isLocateGif = true;
            [self.itemArr addObject:itemM];
        }else {
            UIImageView *imgItem = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, width)];
            imgItem.userInteractionEnabled = true;
            imgItem.tag = i;
            [imgItem addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidClick:)]];
            [imgItem sd_setImageWithURL:[NSURL URLWithString:arr[i]] placeholderImage:nil];
            imgItem.backgroundColor = [UIColor grayColor];
            [bgView addSubview:imgItem];
            
            KNPhotoItems *items = [[KNPhotoItems alloc] init];
            items.url = [arr[i] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
            items.sourceView = imgItem;
            [self.itemArr addObject:items];
        }
    }
}

- (void)imageViewDidClick:(UITapGestureRecognizer *)tap{
    KNPhotoBrowser *photoBrowser = [[KNPhotoBrowser alloc] init];
    photoBrowser.itemsArr = self.itemArr;
    photoBrowser.isNeedPanGesture = true;
    photoBrowser.currentIndex = tap.view.tag;
    [photoBrowser present];
}


@end
