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
#import <Photos/Photos.h>

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
    
    self.title = @"Normal(图片 + 视频)(网络)";
    
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
                   @"http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4",
                   @"https://aweme.snssdk.com/aweme/v1/playwm/?video_id=v0200ff00000bdkpfpdd2r6fb5kf6m50&line=0.MP4",
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
        
        if(i == 2 || i == 1){
            AVURLAsset *avAsset = nil;
            if ([urlArr[i] hasPrefix:@"http"]) {
                avAsset = [AVURLAsset assetWithURL:[NSURL URLWithString:urlArr[i]]];
            }
            if (avAsset) {
                CGFloat padding = 5, imageViewLength = ([UIScreen mainScreen].bounds.size.width - padding * 2) / 3 - 10, scale = [UIScreen mainScreen].scale;
                CGSize imageViewSize = CGSizeMake(imageViewLength * scale, imageViewLength * scale);
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:avAsset];
                    generator.appliesPreferredTrackTransform = YES;
                    generator.maximumSize = imageViewSize;
                    NSError *error = nil;
                    CGImageRef cgImage = [generator copyCGImageAtTime:CMTimeMake(0, 1) actualTime:NULL error:&error];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        imageView.image = [UIImage imageWithCGImage:cgImage];
                    });
                });
            }
        }else{
            [imageView sd_setImageWithURL:urlArr[i] placeholderImage:nil];
        }
        
        imageView.backgroundColor = [UIColor grayColor];
        CGFloat width = (view.frame.size.width - 40) / 3;
        NSInteger row = i / 3;
        NSInteger col = i % 3;
        CGFloat x = 10 + col * (10 + width);
        CGFloat y = 10 + row * (10 + width);
        imageView.frame = CGRectMake(x, y, width, width);
        
        KNPhotoItems *items = [[KNPhotoItems alloc] init];
        items.sourceView = imageView;
        
        if(i == 2 || i == 1){
            items.isVideo = true;
            items.url = urlArr[i];
        }else{
            items.url = [urlArr[i] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
        }

        [self.itemsArr addObject:items];
        
        [view addSubview:imageView];
    }
}

- (void)imageViewDidClick:(UITapGestureRecognizer *)tap{
    KNPhotoBrowser *photoBrower = [[KNPhotoBrowser alloc] init];
    photoBrower.itemsArr = [self.itemsArr copy];
//    photoBrower.isNeedPageControl = true; // if it has video to play , I do not suggest you to use PageControl
    photoBrower.isNeedPageNumView = true;
    photoBrower.isNeedRightTopBtn = true;
    photoBrower.isNeedPictureLongPress = true;
    photoBrower.isNeedPanGesture = true;
    photoBrower.isNeedPrefetch = true;
    photoBrower.currentIndex = tap.view.tag;
    photoBrower.delegate = self;
    [photoBrower present];
}

@end
