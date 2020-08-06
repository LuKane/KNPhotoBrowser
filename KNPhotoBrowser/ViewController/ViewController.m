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
@property (nonatomic,weak  ) KNPhotoBrowser *photoBrowser;
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
    
    self.title = @"Normal(网络图片)(网络 + 本地 : 视频)";
    
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
    
    NSString *videoUrl1 = @"http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4";
    NSString *videoUrl2 = @"https://aweme.snssdk.com/aweme/v1/playwm/?video_id=v0200ff00000bdkpfpdd2r6fb5kf6m50&line=0.MP4";
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"location_video.MP4" ofType:nil];
    NSArray *urlArr =
                   @[
                   @"https://wx3.sinaimg.cn/thumbnail/9bbc284bgy1frtdh1idwkj218g0rs7li.jpg",
                   path,
                   videoUrl1,
                   videoUrl2,
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
        
        if(i == 2 || i == 3){
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
        }else if ( i == 1) {
            AVURLAsset *avAsset = nil;
            avAsset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:path]];
            if (avAsset) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:avAsset];
                    generator.appliesPreferredTrackTransform = YES;
                    NSError *error = nil;
                    CGImageRef cgImage = [generator copyCGImageAtTime:CMTimeMake(0, 1) actualTime:NULL error:&error];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        imageView.image = [UIImage imageWithCGImage:cgImage];
                    });
                });
            }
        }else {
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
        
        if(i == 2 || i == 3 || i == 1){
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
    KNPhotoBrowser *photoBrowser = [[KNPhotoBrowser alloc] init];
    photoBrowser.itemsArr = [self.itemsArr copy];
//    photoBrowser.isNeedPageControl = true; // if it has video to play , I do not suggest you to use PageControl
    photoBrowser.isNeedPageNumView = true;
    photoBrowser.isNeedRightTopBtn = true;
    photoBrowser.isNeedPictureLongPress = true;
    photoBrowser.isNeedPanGesture = true;
    photoBrowser.isNeedPrefetch = true;
    photoBrowser.isNeedAutoPlay = true;
    
    photoBrowser.currentIndex = tap.view.tag;
    photoBrowser.delegate = self;
    [photoBrowser present];
    
    _photoBrowser = photoBrowser;
}

- (void)photoBrowserRightOperationAction{
    
    __weak typeof(self) weakself = self;
    KNActionSheet *actionSheet = [[KNActionSheet share] initWithTitle:@"" cancelTitle:@"" titleArray:@[@"删除",@"保存",@"转发微博",@"赞"].mutableCopy destructiveArray:@[@"0"].mutableCopy actionSheetBlock:^(NSInteger buttonIndex) {
        NSLog(@"buttonIndex:%zd",buttonIndex);
        
        if (buttonIndex == 0) {
            [weakself.photoBrowser deletePhotoAndVideo];
        }
        
        if (buttonIndex == 1) {
            [UIDevice deviceAlbumAuth:^(BOOL isAuthor) {
                if (isAuthor == false) {
                    // do something -> for example : jump to setting
                }else {
                    [weakself.photoBrowser downloadPhotoAndVideo];                    
                }
            }];
        }
    }];
    
    [actionSheet show];
}

/// long press
/// @param photoBrowser pb
/// @param longPress press
- (void)photoBrowser:(KNPhotoBrowser *)photoBrowser longPress:(UILongPressGestureRecognizer *)longPress {
    if (longPress.state == UIGestureRecognizerStateBegan) {
        [photoBrowser setImmediatelyPlayerRate:2];
    }else if (longPress.state == UIGestureRecognizerStateEnded || longPress.state == UIGestureRecognizerStateCancelled || longPress.state == UIGestureRecognizerStateFailed || longPress.state == UIGestureRecognizerStateRecognized){
        [photoBrowser setImmediatelyPlayerRate:1];
    }
}
- (void)photoBrowserToast:(KNPhotoShowState)state photoBrower:(KNPhotoBrowser *)photoBrowser photoItemRelative:(KNPhotoItems *)photoItemRe photoItemAbsolute:(KNPhotoItems *)photoItemAb{
    NSLog(@"%@==%@",photoItemRe.url, photoItemAb.url);
}

- (void)dealloc{
    NSLog(@"dealloc");
}

@end
