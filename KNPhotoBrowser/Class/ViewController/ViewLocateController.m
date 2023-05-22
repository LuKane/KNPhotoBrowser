//
//  ViewLocateController.m
//  KNPhotoBrowser
//
//  Created by LuKane on 2021/5/15.
//  Copyright © 2021 LuKane. All rights reserved.
//

#import "ViewLocateController.h"
#import "UIView+Extension.h"
#import "KNPhotoBrowser.h"
#import <SDAnimatedImageView.h>
#import <UIImageView+WebCache.h>

@interface ViewLocateController ()<KNPhotoBrowserDelegate>

/// contain all urls
@property (nonatomic,strong) NSMutableArray *urlArr;
@property (nonatomic,strong) NSMutableArray<KNPhotoItems *> *itemsArr;

@property (nonatomic,weak  ) UIView *orangeView;

@end

@implementation ViewLocateController

- (NSMutableArray<KNPhotoItems *> *)itemsArr {
    if (!_itemsArr) {
        _itemsArr = [NSMutableArray array];
    }
    return _itemsArr;
}
- (NSMutableArray *)urlArr {
    if (!_urlArr) {
        _urlArr = [NSMutableArray array];
        [_urlArr addObject:[UIImage imageNamed:@"8.jpg"]];
        [_urlArr addObject:[UIImage imageNamed:@"9.jpg"]];
        [_urlArr addObject:[UIImage imageNamed:@"3.jpg"]];
        [_urlArr addObject:[[NSBundle mainBundle] pathForResource:@"location_video.MP4" ofType:nil]];
        [_urlArr addObject:[UIImage imageNamed:@"LocationLong.JPG"]];
        [_urlArr addObject:[UIImage imageNamed:@"6.jpg"]];
        [_urlArr addObject:[UIImage imageNamed:@"7.jpg"]];
        [_urlArr addObject:[[NSBundle mainBundle] pathForResource:@"gif3.GIF" ofType:nil]];
        [_urlArr addObject:[UIImage imageNamed:@"9.jpg"]];
    }
    return _urlArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"loc : Photo + Video";
    [self setupViews];
}
- (void)setupViews {
    
    /// background view
    UIView *orangeView = [[UIView alloc] init];
    orangeView.frame = CGRectMake(20, 80, self.view.width - 40, self.view.width - 40);
    orangeView.backgroundColor = UIColor.orangeColor;
    [self.view addSubview:orangeView];
    self.orangeView = orangeView;
    
    // nine photo or video
    CGFloat width = (self.view.frame.size.width - 40 - 40) / 3;
    
    for (NSInteger i = 0; i < self.urlArr.count; i++) {
        
        if (i == 7) {
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
            items.url = _urlArr[i];
            [self.itemsArr addObject:items];
        }else if(i == 3) {
            
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.userInteractionEnabled = YES;
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidClick:)]];
            imageView.tag = i;
            [orangeView addSubview:imageView];
            imageView.backgroundColor = [UIColor grayColor];
            
            NSInteger row = i / 3;
            NSInteger col = i % 3;
            CGFloat x = 10 + col * (10 + width);
            CGFloat y = 10 + row * (10 + width);
            imageView.frame = CGRectMake(x, y, width, width);
            
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
            KNPhotoItems *items = [[KNPhotoItems alloc] init];
            items.sourceView = imageView;
            items.isVideo = true;
            items.url = [_urlArr[i] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
            
            [self.itemsArr addObject:items];
        }else {
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.userInteractionEnabled = YES;
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidClick:)]];
            imageView.tag = i;
            [orangeView addSubview:imageView];
            imageView.backgroundColor = [UIColor grayColor];
            
            NSInteger row = i / 3;
            NSInteger col = i % 3;
            CGFloat x = 10 + col * (10 + width);
            CGFloat y = 10 + row * (10 + width);
            imageView.frame = CGRectMake(x, y, width, width);
            imageView.image = _urlArr[i];
            
            KNPhotoItems *items = [[KNPhotoItems alloc] init];
            items.sourceView = imageView;
            items.sourceImage = _urlArr[i];
            [self.itemsArr addObject:items];
        }
    }
}

- (void)imageViewDidClick:(UITapGestureRecognizer *)tap {
    KNPhotoBrowser *photoBrowser = [[KNPhotoBrowser alloc] init];
    
    photoBrowser.itemsArr = [self.itemsArr copy];
    photoBrowser.placeHolderColor = UIColor.lightTextColor;
    photoBrowser.currentIndex = tap.view.tag;
    photoBrowser.delegate = self;
    
    photoBrowser.isNeedPageNumView = true;
    photoBrowser.isNeedRightTopBtn = true;
    photoBrowser.isNeedLongPress = true;
    photoBrowser.isNeedPanGesture = true;
    photoBrowser.isNeedPrefetch = true;
    photoBrowser.isNeedAutoPlay = true;
    photoBrowser.isNeedOnlinePlay = false;
    
    [photoBrowser presentOn:self];
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
