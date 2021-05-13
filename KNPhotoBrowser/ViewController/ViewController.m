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
#import <SDAnimatedImageView.h>

#import "KNPhotoBrowserPch.h"

@interface ViewController ()<KNPhotoBrowserDelegate>

@property (nonatomic,strong) NSMutableArray *itemsArr;
@property (nonatomic,strong) NSMutableArray *actionSheetArr;
@property (nonatomic,weak  ) KNPhotoBrowser *photoBrowser;

// 视频占位图的url
@property (nonatomic,copy  ) NSString *videoUrl1;
@property (nonatomic,copy  ) NSString *videoUrl2;

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
    
    self.videoUrl1 = @"https://edu-201121.oss-cn-beijing.aliyuncs.com/WX20210106-103823.png";
    self.videoUrl2 = @"https://edu-201121.oss-cn-beijing.aliyuncs.com/WX20210106-103742.png";
    
    self.title = @"Normal(网络 + 本地 : 视频)";
    
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
                   @"http://ww2.sinaimg.cn/bmiddle/642beb18gw1ep3629gfm0g206o050b2a.gif"
                   ];
    for (NSInteger i = 0 ;i < urlArr.count; i ++) {
        
        if (i != urlArr.count - 1) {
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.userInteractionEnabled = YES;
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidClick:)]];
            imageView.tag = i + 1;
            
            if(i == 2 || i == 3){
                // net video
                
                if (i == 2) {
                    [imageView sd_setImageWithURL:[NSURL URLWithString:self.videoUrl1] placeholderImage:nil];
                }
                if (i == 3) {
                    [imageView sd_setImageWithURL:[NSURL URLWithString:self.videoUrl2] placeholderImage:nil];
                }
                
            }else if ( i == 1) {
                // locate video , get the first image of video
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
                [imageView sd_setImageWithURL:[NSURL URLWithString:urlArr[i]] placeholderImage:nil];
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
            
            [view addSubview:imageView];
        }else {
            SDAnimatedImageView *imageView = [[SDAnimatedImageView alloc] init];
            imageView.userInteractionEnabled = YES;
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidClick:)]];
            imageView.tag = i + 1;
            [imageView sd_setImageWithURL:urlArr[i] placeholderImage:nil];
            
            imageView.backgroundColor = [UIColor grayColor];
            CGFloat width = (view.frame.size.width - 40) / 3;
            NSInteger row = i / 3;
            NSInteger col = i % 3;
            CGFloat x = 10 + col * (10 + width);
            CGFloat y = 10 + row * (10 + width);
            imageView.frame = CGRectMake(x, y, width, width);
            
            KNPhotoItems *items = [[KNPhotoItems alloc] init];
            items.sourceView = imageView;
            items.url = [urlArr[i] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
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
    photoBrowser.isNeedOnlinePlay = false;
    
    photoBrowser.placeHolderColor = UIColor.lightTextColor;
    
    photoBrowser.currentIndex = tap.view.tag;
    photoBrowser.delegate = self;
    [photoBrowser present];
    
    _photoBrowser = photoBrowser;
}

- (void)photoBrowser:(KNPhotoBrowser *)photoBrowser rightBtnOperationActionWithIndex:(NSInteger)index{
    
    __weak typeof(self) weakself = self;
    KNActionSheet *actionSheet = [[KNActionSheet share] initWithTitle:@"" cancelTitle:@"" titleArray:@[@"删除",@"保存",@"转发微博",@"赞"].mutableCopy destructiveArray:@[@"0"].mutableCopy actionSheetBlock:^(NSInteger buttonIndex) {
        NSLog(@"buttonIndex:%zd",buttonIndex);
        
        if (buttonIndex == 0) {
            [weakself.photoBrowser removeImageOrVideoOnPhotoBrowser];
        }
        
        if (buttonIndex == 1) {
            [UIDevice deviceAlbumAuth:^(BOOL isAuthor) {
                if (isAuthor == false) {
                    // do something -> for example : jump to setting
                }else {
                    [weakself.photoBrowser downloadImageOrVideoToAlbum];
                }
            }];
        }
    }];
    
    [actionSheet show];
}
- (void)photoBrowser:(KNPhotoBrowser *)photoBrowser videoLongPress:(UILongPressGestureRecognizer *)longPress index:(NSInteger)index {
    if (longPress.state == UIGestureRecognizerStateBegan) {
        [UIDevice deviceShake];
        [photoBrowser setImmediatelyPlayerRate:2];
    }else if (longPress.state == UIGestureRecognizerStateEnded || longPress.state == UIGestureRecognizerStateCancelled || longPress.state == UIGestureRecognizerStateFailed || longPress.state == UIGestureRecognizerStateRecognized){
        [photoBrowser setImmediatelyPlayerRate:1];
    }
}
- (void)photoBrowser:(KNPhotoBrowser *)photoBrowser
               state:(KNPhotoDownloadState)state
   photoItemRelative:(KNPhotoItems *)photoItemRe
   photoItemAbsolute:(KNPhotoItems *)photoItemAb{
    NSLog(@"%@==%@",photoItemRe.url, photoItemAb.url);
}
- (void)photoBrowser:(KNPhotoBrowser *)photoBrowser imageDidLongPressWithIndex:(NSInteger)index{
    NSLog(@"image did long press");
}
- (void)photoBrowser:(KNPhotoBrowser *)photoBrowser removeSourceWithRelativeIndex:(NSInteger)relativeIndex {
    NSLog(@"removeSourceWithRelativeIndex");
}
- (void)photoBrowser:(KNPhotoBrowser *)photoBrowser removeSourceWithAbsoluteIndex:(NSInteger)absoluteIndex {
    NSLog(@"removeSourceWithAbsoluteIndex");
}

- (void)dealloc{
    NSLog(@"dealloc");
}

@end
