//
//  ViewController.m
//  KNPhotoBrowser
//
//  Created by LuKane on 2021/5/15.
//  Copyright © 2021 LuKane. All rights reserved.
//

#import "ViewController.h"
#import "UIView+Extension.h"

#import "KNPhotoBrowser.h"
#import <UIImageView+WebCache.h>
#import <SDAnimatedImageView.h>

@interface ViewController ()<KNPhotoBrowserDelegate>

/// contain all urls
@property (nonatomic,strong) NSMutableArray *urlArr;

@property (nonatomic,strong) NSMutableArray<KNPhotoItems *> *itemsArr;

@property (nonatomic,copy  ) NSString *videoPlaceHolderUrl0;
@property (nonatomic,copy  ) NSString *videoPlaceHolderUrl1;

@property (nonatomic,weak  ) UIView *orangeView;

@end

@implementation ViewController

- (NSMutableArray<KNPhotoItems *> *)itemsArr {
    if (!_itemsArr) {
        _itemsArr = [NSMutableArray array];
    }
    return _itemsArr;
}
- (NSMutableArray *)urlArr {
    if (!_urlArr) {
        _urlArr = [NSMutableArray array];
        /// net image 
        [_urlArr addObject:@"http://wx3.sinaimg.cn/thumbnail/9bbc284bgy1frtdh1idwkj218g0rs7li.jpg"];
        /// loc video
        [_urlArr addObject:[[NSBundle mainBundle] pathForResource:@"location_video.MP4" ofType:nil]];
        /// net video
        [_urlArr addObject:@"http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4"];
        [_urlArr addObject:@"https://aweme.snssdk.com/aweme/v1/playwm/?video_id=v0200ff00000bdkpfpdd2r6fb5kf6m50&line=0.MP4"];
        
        /// net image
        [_urlArr addObject:@"http://ww2.sinaimg.cn/thumbnail/677febf5gw1erma104rhyj20k03dz16y.jpg"];
        [_urlArr addObject:@"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr1xydcj20gy0o9q6s.jpg"];
        [_urlArr addObject:@"http://ww2.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr39ht9j20gy0o6q74.jpg"];
        
        /// loc gif image
        [_urlArr addObject:[[NSBundle mainBundle] pathForResource:@"gif3.GIF" ofType:nil]];
        
        /// net gif image
        [_urlArr addObject:@"http://ww2.sinaimg.cn/bmiddle/642beb18gw1ep3629gfm0g206o050b2a.gif"];
    }
    return _urlArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"net + loc : Photo + Video";
    
    self.videoPlaceHolderUrl0 = @"https://edu-201121.oss-cn-beijing.aliyuncs.com/WX20210106-103823.png";
    self.videoPlaceHolderUrl1 = @"https://edu-201121.oss-cn-beijing.aliyuncs.com/WX20210106-103742.png";
    
    [self setupViews];
}
- (void)setupViews {
    
    /// background view
    UIView *orangeView = [[UIView alloc] init];
    orangeView.size = CGSizeMake(self.view.width - 40, self.view.width - 40);
    orangeView.center = self.view.center;
    orangeView.backgroundColor = UIColor.orangeColor;
    [self.view addSubview:orangeView];
    self.orangeView = orangeView;
    
    // nine photo or video
    CGFloat width = (self.view.frame.size.width - 40 - 40) / 3;
    
    for (NSInteger i = 0; i < self.urlArr.count; i++) {
        if (i != 7 && i != 8) {
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.userInteractionEnabled = YES;
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidClick:)]];
            imageView.tag = i;
            [orangeView addSubview:imageView];
            
            if(i == 2 || i == 3){
                // net video
                if (i == 2) {
                    [imageView sd_setImageWithURL:[NSURL URLWithString:self.videoPlaceHolderUrl0] placeholderImage:nil];
                }
                if (i == 3) {
                    [imageView sd_setImageWithURL:[NSURL URLWithString:self.videoPlaceHolderUrl1] placeholderImage:nil];
                }
            }else if ( i == 1) {
                // locate video , get the first image of video
                AVURLAsset *avAsset = nil;
                avAsset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:_urlArr[i]]];
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
                [imageView sd_setImageWithURL:[NSURL URLWithString:_urlArr[i]] placeholderImage:nil];
            }
            
            imageView.backgroundColor = [UIColor grayColor];
            
            NSInteger row = i / 3;
            NSInteger col = i % 3;
            CGFloat x = 10 + col * (10 + width);
            CGFloat y = 10 + row * (10 + width);
            imageView.frame = CGRectMake(x, y, width, width);
            
            KNPhotoItems *items = [[KNPhotoItems alloc] init];
            items.sourceView = imageView;
            
            if(i == 2 || i == 3 || i == 1){
                items.isVideo = true;
                items.url = _urlArr[i];
                if (i == 2) {
                    items.videoPlaceHolderImageUrl = self.videoPlaceHolderUrl0;
                }
                if (i == 3) {
                    items.videoPlaceHolderImageUrl = self.videoPlaceHolderUrl1;
                }
            }else{
                items.url = [_urlArr[i] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
            }
            
            [self.itemsArr addObject:items];
            
        }else if (i == 7) {
            NSData *data = [NSData dataWithContentsOfFile:_urlArr[i]];
            SDAnimatedImage *animatedImage = [[SDAnimatedImage alloc] initWithData:data];
            SDAnimatedImageView *imageView = [[SDAnimatedImageView alloc] init];
            imageView.userInteractionEnabled = true;
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidClick:)]];
            imageView.tag = i;
            imageView.backgroundColor = [UIColor grayColor];
            [orangeView addSubview:imageView];
            imageView.image = animatedImage;
            
            NSInteger row = i / 3;
            NSInteger col = i % 3;
            CGFloat x = 10 + col * (10 + width);
            CGFloat y = 10 + row * (10 + width);
            imageView.frame = CGRectMake(x, y, width, width);
            
            KNPhotoItems *items = [[KNPhotoItems alloc] init];
            items.sourceView = imageView;
            items.isLocateGif = true;
            items.url = [_urlArr[i] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
            [self.itemsArr addObject:items];
        }else if (i == 8) {
            SDAnimatedImageView *imageView = [[SDAnimatedImageView alloc] init];
            imageView.userInteractionEnabled = true;
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidClick:)]];
            imageView.tag = i;
            imageView.backgroundColor = [UIColor grayColor];
            [orangeView addSubview:imageView];
            [imageView sd_setImageWithURL:_urlArr[i] placeholderImage:nil];
            
            NSInteger row = i / 3;
            NSInteger col = i % 3;
            CGFloat x = 10 + col * (10 + width);
            CGFloat y = 10 + row * (10 + width);
            imageView.frame = CGRectMake(x, y, width, width);
            
            KNPhotoItems *items = [[KNPhotoItems alloc] init];
            items.sourceView = imageView;
            items.url = [_urlArr[i] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
            [self.itemsArr addObject:items];
        }
    }
}
- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    _orangeView.size = CGSizeMake(self.view.width - 40, self.view.width - 40);
    _orangeView.center = self.view.center;
}
- (void)imageViewDidClick:(UITapGestureRecognizer *)tap {
    KNPhotoBrowser *photoBrowser = [[KNPhotoBrowser alloc] init];
    
    photoBrowser.itemsArr = [self.itemsArr copy];
    photoBrowser.placeHolderColor = UIColor.lightTextColor;
    photoBrowser.currentIndex = tap.view.tag;
    photoBrowser.delegate = self;
    photoBrowser.isSoloAmbient = false;
    photoBrowser.isNeedPageNumView = true;
    photoBrowser.isNeedRightTopBtn = true;
    photoBrowser.isNeedLongPress = true;
    photoBrowser.isNeedPanGesture = true;
    photoBrowser.isNeedPrefetch = true;
    photoBrowser.isNeedAutoPlay = true;
    photoBrowser.isNeedOnlinePlay = true;
    
    [photoBrowser present];
}

/**************************** == delegate == ******************************/
- (void)photoBrowser:(KNPhotoBrowser *)photoBrowser willDismissWithIndex:(NSInteger)index {
    NSLog(@"willDismissWithIndex:%zd",index);
}
- (void)photoBrowser:(KNPhotoBrowser *)photoBrowser rightBtnOperationActionWithIndex:(NSInteger)index{
    KNActionSheet *actionSheet = [[KNActionSheet share] initWithTitle:@""
                                                          cancelTitle:@"CANCEL"
                                                           titleArray:@[@"DELETE",@"SAVE",@"LIKE"].mutableCopy
                                                     destructiveArray:@[@"0"].mutableCopy
                                                     actionSheetBlock:^(NSInteger buttonIndex) {
        NSLog(@"buttonIndex:%zd",buttonIndex);
        
        if (buttonIndex == 0) {
            [photoBrowser removeImageOrVideoOnPhotoBrowser];
        }
        
        if (buttonIndex == 1) {
            [UIDevice deviceAlbumAuth:^(BOOL isAuthor) {
                if (isAuthor == false) {
                    // do something -> for example : jump to setting
                }else {
                    [photoBrowser downloadImageOrVideoToAlbum];
                }
            }];
        }
    }];
    [actionSheet showOnView:photoBrowser.view];
}
- (void)photoBrowser:(KNPhotoBrowser *)photoBrowser imageLongPressWithIndex:(NSInteger)index{
    
    KNActionSheet *actionSheet = [[KNActionSheet share] initWithTitle:@""
                                                          cancelTitle:@"CANCEL"
                                                           titleArray:@[@"SAVE",@"LIKE"].mutableCopy
                                                     destructiveArray:@[].mutableCopy
                                                     actionSheetBlock:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            [UIDevice deviceAlbumAuth:^(BOOL isAuthor) {
                if (isAuthor == false) {
                    // do something -> for example : jump to setting
                }else {
                    [photoBrowser downloadImageOrVideoToAlbum];
                }
            }];
        }
    }];
    [actionSheet showOnView:photoBrowser.view];
}
- (void)photoBrowser:(KNPhotoBrowser *)photoBrowser videoLongPress:(UILongPressGestureRecognizer *)longPress index:(NSInteger)index{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        [UIDevice deviceShake];
        [photoBrowser setImmediatelyPlayerRate:2];
    }else if (longPress.state == UIGestureRecognizerStateEnded || longPress.state == UIGestureRecognizerStateCancelled || longPress.state == UIGestureRecognizerStateFailed || longPress.state == UIGestureRecognizerStateRecognized){
        [photoBrowser setImmediatelyPlayerRate:1];
    }
}
- (void)photoBrowser:(KNPhotoBrowser *)photoBrowser removeSourceWithRelativeIndex:(NSInteger)relativeIndex{
    NSLog(@"removeSourceWithRelativeIndex:%zd",relativeIndex);
}
- (void)photoBrowser:(KNPhotoBrowser *)photoBrowser removeSourceWithAbsoluteIndex:(NSInteger)absoluteIndex{
    NSLog(@"removeSourceWithAbsoluteIndex:%zd",absoluteIndex);
}
- (void)photoBrowser:(KNPhotoBrowser *)photoBrowser scrollToLocateWithIndex:(NSInteger)index{
    NSLog(@"scrollToLocateWithIndex:%zd",index);
}
- (void)photoBrowser:(KNPhotoBrowser *)photoBrowser state:(KNPhotoDownloadState)state progress:(float)progress photoItemRelative:(KNPhotoItems *)photoItemRe photoItemAbsolute:(KNPhotoItems *)photoItemAb {
    NSLog(@"%@ ===> %ld -- %f",photoBrowser,(long)state,progress);
}

@end
