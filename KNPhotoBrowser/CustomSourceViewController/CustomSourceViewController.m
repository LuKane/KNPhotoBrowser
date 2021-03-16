//
//  CustomSourceViewController.m
//  KNPhotoBrowser
//
//  Created by LuKane on 2021/3/1.
//  Copyright © 2021 LuKane. All rights reserved.
//

#import "CustomSourceViewController.h"
#import "KNPhotoBrowser.h"
#import "UIImageView+WebCache.h"
#import <SDAnimatedImageView.h>
#import "KNPhotoBrowserPch.h"

#import "CustomSourceView.h"
#import "CustomSourceView2.h"

@interface CustomSourceViewController ()

@property (nonatomic,strong) NSMutableArray *itemsArr;

// 视频占位图的url
@property (nonatomic,copy  ) NSString *videoUrl1;
@property (nonatomic,copy  ) NSString *videoUrl2;

@end

@implementation CustomSourceViewController

- (NSMutableArray *)itemsArr{
    if (!_itemsArr) {
        _itemsArr = [NSMutableArray array];
    }
    return _itemsArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"自定义 SourceView";
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.videoUrl1 = @"https://edu-201121.oss-cn-beijing.aliyuncs.com/WX20210106-103823.png";
    self.videoUrl2 = @"https://edu-201121.oss-cn-beijing.aliyuncs.com/WX20210106-103742.png";
    
    
    [self setupNineSquareView];
}

- (void)setupNineSquareView{
    
    CGFloat viewWidth = self.view.frame.size.width;
    
    // NineSquare view as a base view
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 100, viewWidth - 20, viewWidth - 20)];
    view.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:view];
    
    NSString *videoUrl1 = @"http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4";
    NSString *videoUrl2 = @"https://aweme.snssdk.com/aweme/v1/playwm/?video_id=v0200ff00000bdkpfpdd2r6fb5kf6m50&line=0.MP4";
    
    NSArray *urlArr =
                   @[
                   @"https://wx3.sinaimg.cn/thumbnail/9bbc284bgy1frtdh1idwkj218g0rs7li.jpg",
                   @"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr1xydcj20gy0o9q6s.jpg",
                   videoUrl1,
                   videoUrl2,
                   @"http://ww2.sinaimg.cn/thumbnail/677febf5gw1erma104rhyj20k03dz16y.jpg",
                   @"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr1xydcj20gy0o9q6s.jpg",
                   @"http://ww2.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr39ht9j20gy0o6q74.jpg",
                   @"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr3xvtlj20gy0obadv.jpg",
                   @"http://ww2.sinaimg.cn/bmiddle/642beb18gw1ep3629gfm0g206o050b2a.gif"
                   ];
    for (NSInteger i = 0 ;i < urlArr.count; i ++) {
        
        if (i != urlArr.count - 1) {
            
            CGFloat width = (view.frame.size.width - 40) / 3;
            NSInteger row = i / 3;
            NSInteger col = i % 3;
            CGFloat x = 10 + col * (10 + width);
            CGFloat y = 10 + row * (10 + width);
            
            CustomSourceView *customV = [[CustomSourceView alloc] initWithFrame:CGRectMake(x, y, width, width)];
            customV.imgV.userInteractionEnabled = true;
            customV.imgV.imgV.userInteractionEnabled = true;
            customV.backgroundColor = [UIColor grayColor];
            customV.userInteractionEnabled = true;
            [customV.imgV.imgV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidClick:)]];
            customV.imgV.imgV.tag = i;
            
            if(i == 2 || i == 3){
                // net video
                if (i == 2) {
                    [customV.imgV.imgV sd_setImageWithURL:[NSURL URLWithString:self.videoUrl1] placeholderImage:nil];
                }
                if (i == 3) {
                    [customV.imgV.imgV sd_setImageWithURL:[NSURL URLWithString:self.videoUrl2] placeholderImage:nil];
                }
            }else {
                [customV.imgV.imgV sd_setImageWithURL:[NSURL URLWithString:urlArr[i]] placeholderImage:nil];
            }
            
            KNPhotoItems *items = [[KNPhotoItems alloc] init];
            items.sourceView = customV;
            
            NSMutableArray *arr = [NSMutableArray array];
            [arr addObject:@"CustomSourceImageView"];
            [arr addObject:@"UIImageView"];
            items.sourceLinkArr = [arr copy];
            
            if(i == 2 || i == 3){
                items.isVideo = true;
                items.url = urlArr[i];
                if (i == 2) {
                    items.videoPlaceHolderImageUrl = self.videoUrl1;
                }
                if (i == 3) {
                    items.videoPlaceHolderImageUrl = self.videoUrl2;
                }
            }else{
                items.url = [urlArr[i] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
            }
            
            [self.itemsArr addObject:items];
            
            [view addSubview:customV];
        }else {
            
            CGFloat width = (view.frame.size.width - 40) / 3;
            NSInteger row = i / 3;
            NSInteger col = i % 3;
            CGFloat x = 10 + col * (10 + width);
            CGFloat y = 10 + row * (10 + width);
            
            CustomSourceView2 *imageView = [[CustomSourceView2 alloc] initWithFrame:CGRectMake(x, y, width, width)];
            imageView.userInteractionEnabled = true;
            [imageView.imgV.imgV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidClick:)]];
            imageView.imgV.imgV.tag = i;
            imageView.imgV.userInteractionEnabled = true;
            imageView.imgV.imgV.userInteractionEnabled = true;
            [imageView.imgV.imgV sd_setImageWithURL:urlArr[i] placeholderImage:nil];
            
            imageView.backgroundColor = [UIColor grayColor];
            
            KNPhotoItems *items = [[KNPhotoItems alloc] init];
            items.sourceView = imageView;
            items.url = [urlArr[i] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
            
            NSMutableArray *arr = [NSMutableArray array];
            [arr addObject:@"CustomSourceImageView2"];
            [arr addObject:@"SDAnimatedImageView"];
            items.sourceLinkArr = [arr copy];
            
            // this `currentFrame` is SDAnimatedImageView's property
            // and currentFrame is the current image of the SDAnimatedImageView
            items.sourceLinkProperyName = @"currentFrame";
            
            [self.itemsArr addObject:items];
            [view addSubview:imageView];
        }
    }
}

- (void)imageViewDidClick:(UITapGestureRecognizer *)tap{
    KNPhotoBrowser *photoBrowser = [[KNPhotoBrowser alloc] init];
    photoBrowser.itemsArr = [self.itemsArr copy];
    photoBrowser.isNeedPageNumView = true;
    photoBrowser.isNeedRightTopBtn = true;
    photoBrowser.isNeedLongPress = true;
    photoBrowser.isNeedPanGesture = true;
    photoBrowser.isNeedPrefetch = true;
    photoBrowser.isNeedAutoPlay = true;
    photoBrowser.placeHolderColor = UIColor.lightTextColor;
    photoBrowser.currentIndex = tap.view.tag;
    
    [photoBrowser present];
}

@end
