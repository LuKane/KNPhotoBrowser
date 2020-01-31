//
//  KNPhotoBrowser.h
//  KNPhotoBrowser
//
//  Created by LuKane on 16/8/18.
//  Copyright © 2016年 LuKane. All rights reserved.
//

/**
 *  如果 bug ,希望各位在 github 上通过'邮箱' 或者直接 issue 指出, 谢谢
 *  github地址 : https://github.com/LuKane/KNPhotoBrowser
 *  项目会越来越丰富,也希望大家一起来增加功能 , 欢迎 Star
 */

#import "KNPhotoBrowser.h"
#import "KNPhotoBaseCell.h"
#import "KNPhotoVideoCell.h"
#import "KNPhotoBrowserPch.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/SDWebImagePrefetcher.h>
#import <SDWebImage/SDImageCache.h>

#import "KNPhotoBrowserNumView.h"
#import "KNToast.h"
#import "KNActionSheet/KNActionSheet.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/ALAsset.h>
#import <Photos/Photos.h>
#import "KNPhotoDownloadMgr.h"

@interface KNPhotoBrowser ()<UICollectionViewDelegate,UICollectionViewDataSource,KNPhotoVideoCellDelegate>{
    UICollectionViewFlowLayout *_layout;
    UICollectionView           *_collectionView;
    KNPhotoBrowserNumView      *_numView;
    UIPageControl              *_pageControl;
    UIButton                   *_operationBtn;
    KNPhotoBrowserImageView    *_imageView;
    KNProgressHUD              *_progressHUD;
    NSArray                    *_tempArr; // absolute data source
    
    CGFloat                     _offsetPageIndex; // record location index, for screen rotate
    NSInteger                   _page; // current page
    BOOL                        _isShowed; // is showed?
    BOOL                        _statusBarHidden;// record original status bar is hidden or not
    BOOL                        _ApplicationStatusIsHidden;
}

@property (nonatomic, weak  ) KNActionSheet *actionSheet;
@property (nonatomic, assign) CGPoint   startLocation;
@property (nonatomic, assign) CGRect    startFrame;

@end

@implementation KNPhotoBrowser

- (instancetype)init{
    if (self = [super init]) {
        self.actionSheetArr = [NSArray array];
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.modalPresentationStyle = UIModalPresentationCustom;
        _statusBarHidden = [UIApplication sharedApplication].statusBarHidden;
    }
    return self;
}

- (BOOL)shouldAutorotate{
    return true;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (BOOL)prefersStatusBarHidden{
    return _statusBarHidden;
}

- (void)hiddenStatusBar{
    if (@available(iOS 13.0, *)) {
        
    } else {
        UIView *statusBar = [[UIApplication sharedApplication] valueForKey:@"statusBar"];
        [UIView animateWithDuration:0.15 animations:^{
            statusBar.transform = CGAffineTransformMakeTranslation(0, - statusBar.height);
        }];
    }
}

- (void)showStatusBar{
    if (@available(iOS 13.0, *)) {
        
    } else {
        UIView *statusBar = [[UIApplication sharedApplication] valueForKey:@"statusBar"];
        [UIView animateWithDuration:0.15 animations:^{
            statusBar.transform = CGAffineTransformIdentity;
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = false;
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self prefetchImage];
    [self initCollectionView];
    [self initNumView];
    [self initPageControl];
    [self initOperationView];
    
    if (@available(iOS 11.0, *)){
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    if(self.isNeedPanGesture){
        [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDidGesture:)]];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceWillOrientation)
                                                 name:UIApplicationWillChangeStatusBarOrientationNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceDidOrientation)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];
}

/* prefetch 8 images with SDWebImagePrefetcher */
- (void)prefetchImage{
    if(self.isNeedPrefetch == false) return;
    if(_itemsArr.count == 0) return;
    NSMutableArray *urlArr = [NSMutableArray array];
    if(_itemsArr.count <= PhotoBrowserPrefetchNum + 1){
        for (NSInteger i = 0; i < _itemsArr.count; i++) {
            if(i != _currentIndex){
                KNPhotoItems *items = _itemsArr[i];
                if(items.url != nil && [items.url hasPrefix:@"http"] && items.isVideo == false){
                    [urlArr addObject:[NSURL URLWithString:items.url]];
                }
            }
        }
    }else{
        NSInteger index = 0;
        if(_currentIndex == _itemsArr.count - 1){
            index = _itemsArr.count;
        }else{
            index = _currentIndex + 1;
        }
        for (NSInteger i = index; i < _itemsArr.count; i++) {
            KNPhotoItems *items = _itemsArr[i];
            if(items.url != nil && items.isVideo == false && [items.url hasPrefix:@"http"]){
                [urlArr addObject:[NSURL URLWithString:items.url]];
            }
        }
    }
    if(urlArr.count != 0){
        [[SDWebImagePrefetcher sharedImagePrefetcher] prefetchURLs:urlArr];
    }
}

/* init collectionView */
- (void)initCollectionView{
    
    // 1.layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    // 2.collectionView
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                                          collectionViewLayout:layout];
    [collectionView setDataSource:self];
    [collectionView setDelegate:self];
    [collectionView setPagingEnabled:true];
    [collectionView setBackgroundColor:[UIColor clearColor]];
    [collectionView setScrollsToTop:false];
    [collectionView setShowsHorizontalScrollIndicator:false];
    [collectionView setContentOffset:CGPointZero];
    [collectionView setAlpha:0.f];
    [collectionView setBounces:true];
    [self.view addSubview:collectionView];
    
    _layout = layout;
    _collectionView = collectionView;
    [_collectionView registerClass:[KNPhotoBaseCell class] forCellWithReuseIdentifier:@"KNPhotoBaseCellID"];
    [_collectionView registerClass:[KNPhotoVideoCell class] forCellWithReuseIdentifier:@"KNPhotoVideoCellID"];
    
    KNPhotoBrowserImageView *imageView = [[KNPhotoBrowserImageView alloc] initWithFrame:self.view.bounds];
    [imageView setHidden:true];
    [self.view addSubview:imageView];
    KNProgressHUD *progressHUD = [[KNProgressHUD alloc] initWithFrame:(CGRect){{([UIScreen mainScreen].bounds.size.width - 40) * 0.5,([UIScreen mainScreen].bounds.size.height - 40) * 0.5},{40,40}}];
    [progressHUD setHidden:true];
    [self.view addSubview:progressHUD];
    
    _imageView = imageView;
    _progressHUD = progressHUD;
}

/* init numView */
- (void)initNumView{
    KNPhotoBrowserNumView *numView = [[KNPhotoBrowserNumView alloc] init];
    [numView setCurrentNum:(_currentIndex + 1) totalNum:_itemsArr.count];
    _page = [numView currentNum];
    [numView setHidden:!_isNeedPageNumView];
    
    // whatever is or not set 'isNeedPageNumView' , if itemArr.cout == 1, it must be hidden
    if(_itemsArr.count == 1){
        [numView setHidden:true];
    }
    [self.view addSubview:numView];
    
    _numView = numView;
}

/* init PageControl */
- (void)initPageControl{
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    [pageControl setCurrentPage:_currentIndex];
    [pageControl setNumberOfPages:_itemsArr.count];
    [pageControl setHidden:!_isNeedPageControl];
    
    // whatever is or not set '_isNeedPageControl' , if itemArr.cout == 1, it must be hidden
    if(_itemsArr.count == 1){
        [pageControl setHidden:true];
    }else {
        // if contain video , hide pagecontrol
        if ([self isContainVideo:_itemsArr]) {
            [pageControl setHidden:true];
        }
    }
    [self.view addSubview:pageControl];
    
    _pageControl = pageControl;
}

- (BOOL)isContainVideo:(NSArray <KNPhotoItems *> *)itemsArr {
    for (KNPhotoItems *items in itemsArr) {
        if (items.isVideo) {
            return true;
        }
    }
    return false;
}

/* init right top Btn */
- (void)initOperationView{
    UIButton *operationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [operationBtn.layer setCornerRadius:3];
    [operationBtn.layer setMasksToBounds:true];
    [operationBtn setBackgroundColor:[UIColor blackColor]];
    [operationBtn setAlpha:0.4];
    [operationBtn setBackgroundImage:[UIImage imageNamed:@"KNPhotoBrowser.bundle/more_tap@2x.png"] forState:UIControlStateNormal];
    [operationBtn addTarget:self action:@selector(operationBtnIBAction) forControlEvents:UIControlEventTouchUpInside];
    [operationBtn setHidden:!_isNeedRightTopBtn];
    _operationBtn = operationBtn;
    [self.view addSubview:operationBtn];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.itemsArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    KNPhotoItems *item = self.itemsArr[indexPath.row];
    if (item.isVideo) {
        KNPhotoVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KNPhotoVideoCellID" forIndexPath:indexPath];
        [cell setDelegate:self];
        return cell;
    }else{
        KNPhotoBaseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KNPhotoBaseCellID" forIndexPath:indexPath];
        __weak typeof(self) weakSelf = self;
        cell.singleTap = ^{
            [weakSelf dismiss];
        };
        cell.longPressTap = ^{
            [weakSelf longPressIBAction];
        };
        return cell;
    }
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [cell prepareForReuse];
    
    KNPhotoItems *item = self.itemsArr[indexPath.row];
    UIImageView *tempView = [self tempViewFromSourceViewWithCurrentIndex:indexPath.row];
    if (item.isVideo) {
        KNPhotoVideoCell *cell1 = (KNPhotoVideoCell *)cell;
        [cell1 playerWithURL:item.url placeHolder:tempView.image];
    } else {
        KNPhotoBaseCell *cell1 = (KNPhotoBaseCell *)cell;
        [cell1 sd_ImageWithUrl:item.url placeHolder:tempView.image];
    }
}
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.itemsArr.count <= indexPath.row) {
        return;
    }
    KNPhotoItems *item = self.itemsArr[indexPath.row];
    if (item.isVideo && [cell isKindOfClass:[KNPhotoVideoCell class]]) {
        KNPhotoVideoCell *cell1 = (KNPhotoVideoCell *)cell;
        [cell1 playerWillEndDisplay];
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return collectionView.frame.size;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat scrollViewW = scrollView.frame.size.width;
    _currentIndex = scrollView.contentOffset.x / _layout.itemSize.width;
    CGFloat x = scrollView.contentOffset.x;
    NSInteger page = (x + scrollViewW / 2) / scrollViewW;
    
    if(_page != page){
        _page = page;
        if(_page + 1 <= _itemsArr.count){
            [_numView setCurrentNum:_page + 1];
            [_pageControl setCurrentPage:_page];
        }
    }
}

/**
 * video will dismiss with animate
 */
- (void)photoVideoAVPlayerDismiss{
    [self dismiss];
}
/**
 * pan to dismiss or cancel
 */
- (void)panDidGesture:(UIPanGestureRecognizer *)pan{
    if(!isPortrait) return;
    
    KNPhotoItems *items = self.itemsArr[_currentIndex];
    
    CGPoint point       = CGPointZero;
    CGPoint location    = CGPointZero;
    CGPoint velocity    = CGPointZero;
    
    KNPhotoBrowserImageView *imageView;
    KNPhotoAVPlayerView *playerView;
    
    if (items.isVideo) {
        KNPhotoVideoCell *cell = (KNPhotoVideoCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0]];
        
        playerView  = cell.playerView;
        
        point       = [pan translationInView:self.view];
        location    = [pan locationInView:playerView.playerBgView];
        velocity    = [pan velocityInView:self.view];
    }else{
        KNPhotoBaseCell *cell = (KNPhotoBaseCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0]];
        
        imageView = cell.photoBrowerImageView;
        
        if(imageView.scrollView.zoomScale > 1.f) return;
        point       = [pan translationInView:self.view];
        location    = [pan locationInView:imageView.scrollView];
        velocity    = [pan velocityInView:self.view];
    }
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:{
            _startLocation  = location;
            if(items.isVideo){
                _startFrame     = playerView.playerBgView.frame;
                [playerView videoWillSwipe];
            }else{
                _startFrame     = imageView.imageView.frame;
            }
        }
            break;
        case UIGestureRecognizerStateChanged:{
            double percent = 1 - fabs(point.y) / self.view.frame.size.height;
            double s = MAX(percent, 0.3);
            
            CGFloat width = self.startFrame.size.width * s;
            CGFloat height = self.startFrame.size.height * s;
            
            CGFloat rateX = (self.startLocation.x - self.startFrame.origin.x) / self.startFrame.size.width;
            CGFloat x = location.x - width * rateX;
            
            CGFloat rateY = (self.startLocation.y - self.startFrame.origin.y) / self.startFrame.size.height;
            CGFloat y = location.y - height * rateY;
            
            if(items.isVideo){
                playerView.playerView.frame     = CGRectMake(x, y, width, height);
                playerView.playerLayer.frame    = CGRectMake(0, 0, width, height);
                playerView.placeHolderImgView.frame = CGRectMake(x, y, width, height);
            }else{
                imageView.imageView.frame = CGRectMake(x, y, width, height);
            }
            
            self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:percent];
        }
            break;
            
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            if (items.isVideo) {
                if(fabs(point.y) > 200 || fabs(velocity.y) > 500){
                    // dismiss
                    _startFrame = playerView.playerView.frame;
                    [playerView videoPlayerWillReset];
                    [self dismiss];
                }else{
                    // cancel
                    [self cancelVideoAnimation:playerView];
                }
            }else {
                if(fabs(point.y) > 200 || fabs(velocity.y) > 500){
                    // dismiss
                    _startFrame = imageView.imageView.frame;
                    [self dismiss];
                }else{
                    // cancel
                    [self cancelAnimation:imageView.imageView];
                }
            }
        }
            break;
        default:
            break;
    }
}

/// cancel animate for get back photoBrowser
/// @param imageView current image
- (void)cancelAnimation:(FLAnimatedImageView *)imageView{
    [UIView animateWithDuration:PhotoBrowserAnimateTime animations:^{
        imageView.frame = self.startFrame;
    } completion:^(BOOL finished) {
        self.view.backgroundColor = [UIColor blackColor];
    }];
}

- (void)cancelVideoAnimation:(KNPhotoAVPlayerView *)playerView{
    [UIView animateWithDuration:PhotoBrowserAnimateTime animations:^{
        playerView.playerView.frame = CGRectMake(0, 0, self.startFrame.size.width, self.startFrame.size.height);;
        playerView.playerLayer.frame = playerView.playerView.bounds;
        playerView.placeHolderImgView.frame = CGRectMake(0, 0, self.startFrame.size.width, self.startFrame.size.height);
    } completion:^(BOOL finished) {
        self.view.backgroundColor = [UIColor blackColor];
    }];
}

#pragma mark - photoBrowser will present
- (void)present{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window.rootViewController presentViewController:self animated:false completion:^{
        
    }];
}

/**
 photoBrowser first show
 */
- (void)photoBrowserWillShowWithAnimated{
    // 0. catch absolute data source
    _tempArr = [NSMutableArray arrayWithArray:_itemsArr];
    
    // 1.set collectionView offset by currentIndex
    [_collectionView setContentOffset:(CGPoint){_currentIndex * _layout.itemSize.width,0} animated:false];
    
    // 2.set sourceView for get the frame and image
    KNPhotoItems *items = _itemsArr[_currentIndex];
    UIView *sourceView;
    sourceView = items.sourceView;
    
    CGRect rect = [sourceView convertRect:[sourceView bounds] toView:[UIApplication sharedApplication].keyWindow];
    
    UIImageView *tempView = [self tempViewFromSourceViewWithCurrentIndex:_currentIndex];
    
    if(tempView.image == nil){
        [_collectionView setHidden:false];
        [UIView animateWithDuration:PhotoBrowserAnimateTime delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self->_collectionView setAlpha:1];
        } completion:^(BOOL finished) {
            self->_page = self->_currentIndex;
        }];
        
        return;
    }
    
    [tempView setFrame:rect];
//    [tempView setContentMode:sourceView.contentMode];
    tempView.layer.cornerRadius = 0.001;
    tempView.clipsToBounds = true;
    [self.view insertSubview:tempView atIndex:0];
    
    CGSize tempRectSize;
    CGFloat width  = tempView.image.size.width;
    CGFloat height = tempView.image.size.height;
    
    if(isPortrait == true){
        tempRectSize = (CGSize){ScreenWidth,(height * ScreenWidth / width) > ScreenHeight?ScreenHeight:(height * ScreenWidth / width)};
    }else{
        if(width > height){
            if(width / height > ScreenWidth / ScreenHeight){
                tempRectSize = (CGSize){ScreenWidth,height * ScreenWidth / width};
            }else{
                tempRectSize = (CGSize){ScreenHeight * width / height,ScreenHeight};
            }
        }else{
            tempRectSize = (CGSize){(width * ScreenHeight) / height,ScreenHeight};
        }
    }
    [_collectionView setHidden:true];
    
    [UIView animateWithDuration:PhotoBrowserAnimateTime delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [tempView setCenter:[self.view center]];
        [tempView setBounds:(CGRect){CGPointZero,tempRectSize}];
        [self->_collectionView setAlpha:1];
    } completion:^(BOOL finished) {
        [self->_collectionView setHidden:false];
        [self hiddenStatusBar];
        
        [UIView animateWithDuration:0.15 animations:^{
            [tempView setAlpha:0.f];
        } completion:^(BOOL finished) {
            [tempView removeFromSuperview];
        }];
        self->_page = self->_currentIndex;
    }];
}

#pragma mark - photoBrowser will dismiss
- (void)dismiss{
    if([_delegate respondsToSelector:@selector(photoBrowserWillDismiss)]){
        [_delegate photoBrowserWillDismiss];
    }
    
    UIImageView *tempView = [[UIImageView alloc] init];
    
    KNPhotoItems *items = self->_itemsArr[self->_currentIndex];
    
    if(items.sourceImage){ // locate image by sourceImage of items
        tempView.image = items.sourceImage;
        [self photoBrowserWillDismissWithAnimated:tempView items:items];
    }else{ // net image or locate image without sourceImage of items
        if(items.url && items.isVideo == false){
            SDImageCache *cache = [SDImageCache sharedImageCache];
            [cache diskImageExistsWithKey:items.url completion:^(BOOL isInCache) {
                if(isInCache){
                    if([[[[items.url lastPathComponent] pathExtension] lowercaseString] isEqualToString:@"gif"]){ // gif image
                        NSData *data = UIImageJPEGRepresentation([cache imageFromCacheForKey:items.url], 1.f);
                        if(data){
                            tempView.image = [self imageFromGifFirstImage:data];
                        }
                    }else{ // normal image
                        tempView.image = [cache imageFromCacheForKey:items.url];
                    }
                }else{
                    tempView.image = [[self tempViewFromSourceViewWithCurrentIndex:self->_currentIndex] image];
                }
                [self photoBrowserWillDismissWithAnimated:tempView items:items];
            }];
        }else{
            tempView.image = [[self tempViewFromSourceViewWithCurrentIndex:self->_currentIndex] image];
            [self photoBrowserWillDismissWithAnimated:tempView items:items];
        }
    }
}

/**
 photoBrowser dismiss with animated
 
 @param tempView tempView
 @param items current items
 */
- (void)photoBrowserWillDismissWithAnimated:(UIImageView *)tempView items:(KNPhotoItems *)items{
    [_pageControl setHidden:true];
    [_numView setHidden:true];
    
    if(tempView.image == nil){
        
        [self loadScreenPortrait];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self->_collectionView.alpha = 0.f;
            } completion:^(BOOL finished) {
                [self showStatusBar];
                self->_startFrame = CGRectZero;
                [self dismissViewControllerAnimated:false completion:nil];
            }];
        });
        return;
    }
    
    UIView *sourceView = items.sourceView;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    __block CGRect rect = [sourceView convertRect:[sourceView bounds] toView:window];
    
    [self->_collectionView setHidden:true];
    
    if([self isOutOfScreen:rect]){
        if(isPortrait == true){
            [UIView animateWithDuration:PhotoBrowserAnimateTime delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [tempView setAlpha:0.f];
            } completion:^(BOOL finished) {
                [tempView removeFromSuperview];
                [self showStatusBar];
                self->_startFrame = CGRectZero;
                [self dismissViewControllerAnimated:true completion:nil];
            }];
        }else{
            [self loadScreenPortrait];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:PhotoBrowserAnimateTime delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    [tempView setAlpha:0.f];
                } completion:^(BOOL finished) {
                    [tempView removeFromSuperview];
                    [self showStatusBar];
                    self->_startFrame = CGRectZero;
                    [self dismissViewControllerAnimated:true completion:nil];
                }];
            });
        }
    }else{
        
        CGFloat width  = tempView.image.size.width;
        CGFloat height = tempView.image.size.height;
        CGSize tempRectSize = (CGSize){ScreenWidth,(height * ScreenWidth / width) > ScreenHeight ? ScreenHeight:(height * ScreenWidth / width)};
        
        if(isPortrait == true){
            [tempView setBounds:(CGRect){CGPointZero,{tempRectSize.width,tempRectSize.height}}];
            [tempView setCenter:[self.view center]];
            if(!CGRectEqualToRect(self.startFrame, CGRectZero)){
                tempView.frame = self.startFrame;
            }
            [window addSubview:tempView];
            self->_startFrame = CGRectZero;
            [self dismissViewControllerAnimated:false completion:nil];
            
            [UIView animateWithDuration:PhotoBrowserAnimateTime delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [tempView setFrame:rect];
            } completion:^(BOOL finished) {
                [self showStatusBar];
                [UIView animateWithDuration:0.15 animations:^{
                    [tempView setAlpha:0.f];
                } completion:^(BOOL finished) {
                    [tempView removeFromSuperview];
                }];
            }];
        }else{
            
            [self loadScreenPortrait];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                rect = [sourceView convertRect:[sourceView bounds] toView:window];
                
                [tempView setBounds:(CGRect){CGPointZero,{tempRectSize.width,tempRectSize.height}}];
                [tempView setCenter:[self.view center]];
                [window addSubview:tempView];
                self->_startFrame = CGRectZero;
                [self dismissViewControllerAnimated:true completion:nil];
                
                [UIView animateWithDuration:PhotoBrowserAnimateTime delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    [tempView setFrame:rect];
                } completion:^(BOOL finished) {
                    [self showStatusBar];
                    [UIView animateWithDuration:0.15 animations:^{
                        [tempView setAlpha:0.f];
                    } completion:^(BOOL finished) {
                        [tempView removeFromSuperview];
                    }];
                }];
            });
        }
    }
}

- (BOOL)isOutOfScreen:(CGRect)rect{
    if(isPortrait){
        if(rect.origin.y > ScreenHeight ||
           rect.origin.y <= - rect.size.height ||
           rect.origin.x > ScreenWidth ||
           rect.origin.x <= - rect.size.width ){
            return true;
        }
    }else{
        if(rect.origin.y > ScreenWidth ||
           rect.origin.y <= - rect.size.height ||
           rect.origin.x > ScreenHeight ||
           rect.origin.x <= - rect.size.width){
            return true;
        }
    }
    
    return false;
}

- (void)loadScreenPortrait{
    if(isPortrait) return;
    NSNumber *resetOrientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
    [[UIDevice currentDevice] setValue:resetOrientationTarget forKey:@"orientation"];
    NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    if(_actionSheet){
        [_actionSheet removeFromSuperview];
        _actionSheet = nil;
        sleep(0.7);
        [self layoutCollectionViewAndLayout];
    }else{
        [self layoutCollectionViewAndLayout];
    }
}

- (void)layoutCollectionViewAndLayout{
    
    [_layout setItemSize:(CGSize){self.view.width + 20,self.view.height}];
    _layout.minimumInteritemSpacing = 0;
    _layout.minimumLineSpacing = 0;
    
    [_collectionView setFrame:(CGRect){{-10,0},{self.view.width + 20,self.view.height}}];
    [_collectionView setCollectionViewLayout:_layout];
    
    _imageView.frame = (CGRect){{-10,0},{self.view.width + 20,self.view.height}};
    _progressHUD.center = self.view.center;
    
    CGFloat y = 25;
    CGFloat x = 0;
    if(iPhoneX || iPhoneXR || iPhoneXs_Max){
        y = 45;
    }
    
    if(!isPortrait){
        y = 15;
        x = 35;
    }
    
    [_numView setFrame:(CGRect){{0,y},{ScreenWidth,25}}];
    [_pageControl setFrame:(CGRect){{0,self.view.height - 50},{ScreenWidth,30}}];
    [_operationBtn setFrame:(CGRect){{ScreenWidth - 35 - 15 - x,y},{35,20}}];
    
    if(_offsetPageIndex){
        [_collectionView setContentOffset:(CGPoint){_layout.itemSize.width * _offsetPageIndex,0} animated:false];
    }
    
    if(!_isShowed){
        [self photoBrowserWillShowWithAnimated];
        _isShowed = true;
    }
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [_collectionView.collectionViewLayout invalidateLayout];
}

/**
 ApplicationWillChangeStatusBarOrientation -> Notification
 */
- (void)deviceWillOrientation{
    
    KNPhotoItems *item = self.itemsArr[_currentIndex];
    NSString *url  = item.url;
    
    if(![item.url.lastPathComponent.pathExtension.lowercaseString isEqualToString:@"gif"] && item.isVideo == false){
        [_collectionView setHidden:true];
        [_imageView setHidden:false];
        [_progressHUD setHidden:false];
        UIImageView *tempView = [self tempViewFromSourceViewWithCurrentIndex:_currentIndex];
        [_imageView sd_ImageWithUrl:[NSURL URLWithString:url] progressHUD:_progressHUD placeHolder:tempView.image];
    }else{
        [_collectionView setHidden:false];
    }
    _offsetPageIndex = _collectionView.contentOffset.x / _layout.itemSize.width;
}

/**
 ApplicationDidChangeStatusBarOrientation -> Notification
 */
- (void)deviceDidOrientation{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self->_imageView setHidden:true];
        [self->_progressHUD setHidden:true];
        [self->_collectionView setHidden:false];
    });
}

/**
 right top Btn Did click
 */
- (void)operationBtnIBAction{
    // ActionSheet will show , if self.actionSheetArr is not empty , that means custom ActionSheet, just let delegate to do
    // if self.actionSheetArr is empty , that actionSheet just is example
    
    // careful : there is weakSelf , not self. be careful of the strong link
    __weak typeof(self) weakSelf = self;
    if(_actionSheetArr.count != 0){ // custom
        KNActionSheet *actionSheet = [[KNActionSheet share] initWithTitle:@"" cancelTitle:@"" titleArray:self.actionSheetArr.mutableCopy actionSheetBlock:^(NSInteger buttonIndex) {
            if([weakSelf.delegate respondsToSelector:@selector(photoBrowserRightOperationActionWithIndex:)]){
                [weakSelf.delegate photoBrowserRightOperationActionWithIndex:buttonIndex];
            }
        }];
        [actionSheet show];
        self.actionSheet = actionSheet;
    }else{ // example
        KNActionSheet *actionSheet = [[KNActionSheet share] initWithTitle:@"" cancelTitle:@"" titleArray:@[@"删除",@"保存",@"转发微博",@"赞"].mutableCopy destructiveArray:@[@"0"].mutableCopy actionSheetBlock:^(NSInteger buttonIndex) {
            
            if([weakSelf.delegate respondsToSelector:@selector(photoBrowserRightOperationActionWithIndex:)]){
                [weakSelf.delegate photoBrowserRightOperationActionWithIndex:buttonIndex];
            }
            
            switch (buttonIndex) {
                case 0:{ // Delete image or video
                    
                    // relative index
                    if([weakSelf.delegate respondsToSelector:@selector(photoBrowserRightOperationDeleteImageSuccessWithRelativeIndex:)]){
                        [weakSelf.delegate photoBrowserRightOperationDeleteImageSuccessWithRelativeIndex:weakSelf.currentIndex];
                    }
                    
                    // absolute index
                    KNPhotoItems *items = weakSelf.itemsArr[weakSelf.currentIndex];
                    NSInteger index = [self->_tempArr indexOfObject:items];
                    if([weakSelf.delegate respondsToSelector:@selector(photoBrowserRightOperationDeleteImageSuccessWithAbsoluteIndex:)]){
                        [weakSelf.delegate photoBrowserRightOperationDeleteImageSuccessWithAbsoluteIndex:index];
                    }
                    
                    // going to delete image
                    [weakSelf deletePhotoAndVideo];
                }
                    break;
                case 1:{// save image or video
                    [weakSelf deviceAlbumAuth:^(BOOL isAuthor) {
                        if(isAuthor == false){
                            // do not have auth, you need alert .....
                        }else{
                            // save currrent image to album
                            KNPhotoItems *items = weakSelf.itemsArr[weakSelf.currentIndex];
                            if (items.isVideo) { // video
                                KNPhotoDownloadMgr *mgr = [[KNPhotoDownloadMgr alloc] init];
                                [mgr downloadVideoWithItems:items downloadBlock:^(KNPhotoDownloadState downloadState, float prgress) {
                                    if (downloadState == KNPhotoDownloadStateFailure) {
                                        [[KNToast shareToast] initWithText:PhotoSaveVideoFailureReason];
                                    }else if (downloadState == KNPhotoDownloadStateSuccess) {
                                        [[KNToast shareToast] initWithText:PhotoSaveVideoSuccessReason];
                                    }else if (downloadState == KNPhotoDownloadStateUnknow) {
                                        [[KNToast shareToast] initWithText:PhotoSaveVideoCannotReason];
                                    }else if (downloadState == KNPhotoDownloadStateDownloading) {
                                        // video is downloading --> u can show loading
                                    }
                                }];
                            }else{ // image
                                if(items.url){ // net image
                                    SDImageCache *cache = [SDImageCache sharedImageCache];
                                    SDWebImageManager *mgr = [SDWebImageManager sharedManager];
                                    [cache diskImageExistsWithKey:items.url completion:^(BOOL isInCache) {
                                        if(!isInCache){
                                            [[KNToast shareToast] initWithText:PhotoSaveImageFailureReason];
                                            return ;
                                        }else{
                                            [[mgr imageCache] queryImageForKey:items.url options:SDWebImageQueryMemoryData | SDWebImageRetryFailed context:nil completion:^(UIImage * _Nullable image, NSData * _Nullable data, SDImageCacheType cacheType) {
                                                if([image images] != nil){
                                                    [weakSelf savePhotoToLocation:data url:items.url];
                                                }else{
                                                    if(image){
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            UIImageWriteToSavedPhotosAlbum(image, weakSelf, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
                                                        });
                                                    }
                                                }
                                            }];
                                        }
                                    }];
                                }else{ // locate image or sourceimage
                                    UIImageView *imageView = [weakSelf tempViewFromSourceViewWithCurrentIndex:weakSelf.currentIndex];
                                    if(imageView.image){
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            UIImageWriteToSavedPhotosAlbum(imageView.image, weakSelf, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
                                        });
                                    }else{
                                        [[KNToast shareToast] initWithText:PhotoSaveImageFailureMessage duration:PhotoSaveImageMessageTime];
                                    }
                                }
                            }
                        }
                    }];
                }
                    break;
                default:
                    // the other func ,you need do by yourself
                    break;
            }
        }];
        [actionSheet show];
        self.actionSheet = actionSheet;
    }
}

/**
 judge is have auth of Album --> for example
 
 @param authorBlock block
 */
- (void)deviceAlbumAuth:(void (^)(BOOL isAuthor))authorBlock{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted) {
        if(authorBlock){
            authorBlock(false);
        }
    } else if (status == PHAuthorizationStatusDenied) {
        if(authorBlock){
            authorBlock(false);
        }
    } else if (status == PHAuthorizationStatusAuthorized) {
        if(authorBlock){
            authorBlock(true);
        }
    } else if (status == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(authorBlock){
                        authorBlock(true);
                    }
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(authorBlock){
                        authorBlock(false);
                    }
                });
            }
        }];
    }
}

/**
 save image to the location --> for example
 
 @param image image
 @param error error
 @param contextInfo context
 */
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    __weak typeof(self) weakSelf = self;
    
    if(!error){
        [[KNToast shareToast] initWithText:PhotoSaveImageSuccessMessage duration:PhotoSaveImageMessageTime];
    }else{
        [[KNToast shareToast] initWithText:PhotoSaveImageFailureMessage duration:PhotoSaveImageMessageTime];
    }
    
    if([weakSelf.delegate respondsToSelector:@selector(photoBrowserWriteToSavedPhotosAlbumStatus:)]){
        [weakSelf.delegate photoBrowserWriteToSavedPhotosAlbumStatus:error?false:true];
    }
}

/**
 save gif image to location --> for example
 
 @param photoData data
 */
- (void)savePhotoToLocation:(NSData *)photoData url:(NSString *)url{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            PHAssetResourceCreationOptions *options = [[PHAssetResourceCreationOptions alloc] init];
            options.shouldMoveFile = true;
            PHAssetCreationRequest *request = [PHAssetCreationRequest creationRequestForAsset];
            [request addResourceWithType:PHAssetResourceTypePhoto data:photoData options:options];
            request.creationDate = [NSDate date];
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(success){
                    [[KNToast shareToast] initWithText:PhotoSaveImageSuccessMessage duration:PhotoSaveImageMessageTime];
                }else if(error) {
                    [[KNToast shareToast] initWithText:PhotoSaveImageFailureMessage duration:PhotoSaveImageMessageTime];
                }
            });
        }];
    });
}

/**
 delete current photo or video
 */
- (void)deletePhotoAndVideo{
    KNPhotoItems *item = _itemsArr[_currentIndex];
    if (item.isVideo) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:_currentIndex inSection:0];
        KNPhotoVideoCell *cell = (KNPhotoVideoCell *)[_collectionView cellForItemAtIndexPath:path];
        [cell playerWillEndDisplay];
    }
    
    NSMutableArray *tempArr = [NSMutableArray arrayWithArray:_itemsArr];
    [tempArr removeObjectAtIndex:_currentIndex];
    _itemsArr = [tempArr copy];
    [_collectionView reloadData];
    
    if(_itemsArr.count == 0){
        [_collectionView setHidden:true];
        [_operationBtn setHidden:true];
        [_pageControl setHidden:true];
        [_numView setHidden:true];
        
        _ApplicationStatusIsHidden = false;
        [self setNeedsStatusBarAppearanceUpdate];
        
        if([_delegate respondsToSelector:@selector(photoBrowserWillDismiss)]){
            [_delegate photoBrowserWillDismiss];
        }
        
        [self dismissViewControllerAnimated:true completion:nil];
    }else{
        [_pageControl setCurrentPage:_currentIndex];
        [_pageControl setNumberOfPages:_itemsArr.count];
        [_numView setCurrentNum:(_currentIndex + 1) totalNum:_itemsArr.count];
    }
}

/**
 download photo or video to Album, but it must be authed at first
 */
- (void)downloadPhotoAndVideo{
    
}

/**
 longPress Did click
 */
- (void)longPressIBAction{
    if(!_isNeedPictureLongPress) return;
    [self operationBtnIBAction];
}

/**
 create one image by Color
 
 @param imageColor color
 @return image is created by color
 */
- (UIImage *)createImageWithUIColor:(UIColor *)imageColor size:(CGSize)size{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [imageColor CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/**
 get the first image of GIF
 
 @param data data
 @return image
 */
- (UIImage *)imageFromGifFirstImage:(NSData *)data{
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    size_t count = CGImageSourceGetCount(source);
    
    UIImage *sourceImage;
    if(count <= 1){
        CFRelease(source);
        sourceImage = [[UIImage alloc] initWithData:data];
    }else{
        CGImageRef image = CGImageSourceCreateImageAtIndex(source, 0, NULL);
        sourceImage = [UIImage imageWithCGImage:image];
        CFRelease(source);
        CGImageRelease(image);
    }
    return sourceImage;
}

/**
 get the image of current sourceView
 
 @param currentIndex index
 @return imageView with image
 */
- (UIImageView *)tempViewFromSourceViewWithCurrentIndex:(NSInteger)currentIndex{
    UIImageView *imageView = [[UIImageView alloc] init];
    KNPhotoItems *items = _itemsArr[currentIndex];
    if([items.sourceView isKindOfClass:[UIImageView class]]){
        imageView.image = [(UIImageView *)items.sourceView image];
    }else if ([items.sourceView isKindOfClass:[UIButton class]]){
        UIButton *btn = (UIButton *)items.sourceView;
        [imageView setImage:[btn currentBackgroundImage]?[btn currentBackgroundImage]:[btn currentImage]];
    }
    
    if(items.sourceView == nil && imageView.image == nil && items.sourceImage != nil){
        imageView.image = items.sourceImage;
    }
    
    if(imageView.image == nil){
        if (items.isVideo == false) {
            imageView.image = [self createImageWithUIColor:PhotoPlaceHolderDefaultColor size:CGSizeMake(ScreenWidth, ScreenWidth)];
        }else {
            imageView.image = [self createImageWithUIColor:UIColor.clearColor size:CGSizeMake(ScreenWidth, ScreenWidth)];
        }
    }
    
    return imageView;
}

@end

@implementation KNPhotoItems


@end
