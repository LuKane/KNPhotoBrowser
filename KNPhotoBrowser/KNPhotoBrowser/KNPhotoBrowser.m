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
#import "KNPhotoImageCell.h"
#import "KNPhotoVideoCell.h"
#import "KNPhotoBrowserPch.h"
#import "KNPhotoDownloadMgr.h"
#import "KNPhotoBrowserNumView.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/SDWebImagePrefetcher.h>
#import <SDWebImage/SDImageCache.h>

#import <MobileCoreServices/UTCoreTypes.h>
#import <Photos/Photos.h>
#import <objc/runtime.h>

@interface KNPhotoBrowser ()<UICollectionViewDelegate,UICollectionViewDataSource,KNPhotoVideoCellDelegate>{
    UICollectionViewFlowLayout *_layout;
    KNPhotoBrowserNumView      *_numView;
    UIPageControl              *_pageControl;
    UIButton                   *_operationBtn;
    KNPhotoBrowserImageView    *_imageView;
    KNProgressHUD              *_progressHUD;
    
    NSArray                    *_customArr; // custom view on photoBrowser
    
    CGFloat                     _offsetPageIndex; // record location index, for screen rotate
    NSInteger                   _page; // current page
    BOOL                        _isShowed; // is showed?
    BOOL                        _statusBarHidden;// record original status bar is hidden or not
    BOOL                        _isDismissed; // when photoBrowser will dismiss , it will be true, default is false
}

@property (nonatomic, strong) NSArray *tempArr;
@property (nonatomic, strong) NSMutableArray *followArr;
@property (nonatomic, weak  ) UICollectionView *collectionView;
@property (nonatomic, assign) CGPoint   startLocation;
@property (nonatomic, assign) CGRect    startFrame;
@property (nonatomic, strong) KNPhotoDownloadMgr *downloadMgr;

@end

@implementation KNPhotoBrowser

- (NSMutableArray *)followArr{
    if (!_followArr) {
        _followArr = [NSMutableArray array];
    }
    return _followArr;
}
- (KNPhotoDownloadMgr *)downloadMgr{
    if (!_downloadMgr) {
        _downloadMgr = [[KNPhotoDownloadMgr shareInstance] init];
    }
    return _downloadMgr;
}
- (instancetype)init{
    if (self = [super init]) {
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.modalPresentationStyle = UIModalPresentationCustom;
        _statusBarHidden = [UIApplication sharedApplication].statusBarHidden;
        
        self.animatedMode  = UIViewContentModeScaleToFill;
        self.presentedMode = UIViewContentModeScaleAspectFit;
        self.isSoloAmbient = true;
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
            statusBar.transform = CGAffineTransformMakeTranslation(0, - statusBar.bounds.size.height);
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
    [self initCustomView];
    
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
    [_collectionView registerClass:[KNPhotoImageCell class] forCellWithReuseIdentifier:@"KNPhotoImageCellID"];
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
    pageControl.userInteractionEnabled = false;
    if (_isNeedPageControlTarget == true) {
        pageControl.userInteractionEnabled = true;
        [pageControl addTarget:self action:@selector(pageControlValueChange:) forControlEvents:UIControlEventValueChanged];        
    } 
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
/* init customView */
- (void)initCustomView{
    if ([self isEmptyArray:_customArr]) return;
    for (UIView *view in _customArr) {
        [self.view addSubview:view];
    }
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
    
    NSBundle *bundle = [NSBundle bundleForClass:NSClassFromString(@"KNPhotoBrowser")];
    
    UIButton *operationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [operationBtn.layer setCornerRadius:3];
    [operationBtn setClipsToBounds:true];
    [operationBtn setBackgroundColor:[UIColor blackColor]];
    [operationBtn setAlpha:0.4];
    if(UIScreen.mainScreen.scale < 3) {
        [operationBtn setBackgroundImage:[UIImage imageNamed:@"KNPhotoBrowser.bundle/more_tap@2x.png" inBundle:bundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    }else {
        [operationBtn setBackgroundImage:[UIImage imageNamed:@"KNPhotoBrowser.bundle/more_tap@3x.png" inBundle:bundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    }
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
    }else {
        KNPhotoImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KNPhotoImageCellID" forIndexPath:indexPath];
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
        
        if (_isDismissed == true) {
            return;
        }
        
        KNPhotoVideoCell *videoCell = (KNPhotoVideoCell *)cell;
        videoCell.isSoloAmbient = _isSoloAmbient;
        
        if (_isNeedOnlinePlay) {
            [videoCell playerOnLinePhotoItems:item placeHolder:tempView.image];
        }else {
            [videoCell playerLocatePhotoItems:item placeHolder:tempView.image];
        }
        
        if (_isNeedAutoPlay == true) {
            [videoCell setIsNeedAutoPlay:true];
        }
        [videoCell setPresentedMode:self.presentedMode];
    } else {
        KNPhotoImageCell *imageCell = (KNPhotoImageCell *)cell;
        [imageCell imageWithUrl:item.url placeHolder:tempView.image photoItem:item];
        [imageCell setPresentedMode:self.presentedMode];
    }
}
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.itemsArr.count <= indexPath.row) {
        return;
    }
    KNPhotoItems *item = self.itemsArr[indexPath.row];
    if (item.isVideo && [cell isKindOfClass:[KNPhotoVideoCell class]]) {
        KNPhotoVideoCell *videoCell = (KNPhotoVideoCell *)cell;
        [videoCell playerWillEndDisplay];
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return collectionView.frame.size;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat scrollViewW = scrollView.frame.size.width;
    _currentIndex = scrollView.contentOffset.x / _layout.itemSize.width;
    CGFloat x = scrollView.contentOffset.x;
    NSInteger page = (x + scrollViewW / 2) / scrollViewW;
    
    if(_page != page){
        _page = page;
        
        if ([_delegate respondsToSelector:@selector(photoBrowser:scrollToLocateWithIndex:)]) {
            [_delegate photoBrowser:self scrollToLocateWithIndex:page];
        }
        
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
 video will long press
 */
- (void)photoVideoAVPlayerLongPress:(UILongPressGestureRecognizer *)longPress{
    if (!_isNeedLongPress) return;
    if ([_delegate respondsToSelector:@selector(photoBrowser:videoLongPress:index:)]) {
        [_delegate photoBrowser:self videoLongPress:longPress index:_currentIndex];
    }
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
    id playerView;
    
    if (items.isVideo) {
        KNPhotoVideoCell *cell = (KNPhotoVideoCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0]];
        
        if (_isNeedOnlinePlay) {
            playerView = (KNPhotoAVPlayerView *)cell.onlinePlayerView;
            location    = [pan locationInView:[(KNPhotoAVPlayerView *)playerView playerBgView]];
        }else {
            playerView = (KNPhotoLocateAVPlayerView *)cell.locatePlayerView;
            location    = [pan locationInView:[(KNPhotoLocateAVPlayerView *)playerView playerBgView]];
        }
        
        point       = [pan translationInView:self.view];
        velocity    = [pan velocityInView:self.view];
    }else{
        KNPhotoImageCell *cell = (KNPhotoImageCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0]];
        
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
                if (_isNeedOnlinePlay) {
                    _startFrame = [(KNPhotoAVPlayerView *)playerView playerBgView].frame;
                    [(KNPhotoAVPlayerView *)playerView setIsNeedVideoPlaceHolder:![(KNPhotoAVPlayerView *)playerView isBeginPlayed]];
                    [[(KNPhotoAVPlayerView *)playerView playerView] setBackgroundColor:UIColor.clearColor];
                }else {
                    _startFrame = [(KNPhotoLocateAVPlayerView *)playerView playerBgView].frame;
                    [(KNPhotoLocateAVPlayerView *)playerView setIsNeedVideoPlaceHolder:![(KNPhotoLocateAVPlayerView *)playerView isBeginPlayed]];
                    [[(KNPhotoLocateAVPlayerView *)playerView playerView] setBackgroundColor:UIColor.clearColor];
                }
                [playerView playerWillSwipe];
            }else{
                _startFrame = imageView.imageView.frame;
            }
            [self customViewSubViewsWillDismiss];
            [playerView setIsNeedVideoPlaceHolder:false];
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
                if (_isNeedOnlinePlay) {
                    [(KNPhotoAVPlayerView *)playerView playerView].frame         = CGRectMake(x, y, width, height);
                    [(KNPhotoAVPlayerView *)playerView playerLayer].frame        = CGRectMake(0, 0, width, height);
                    [(KNPhotoAVPlayerView *)playerView placeHolderImgView].frame = CGRectMake(x, y, width, height);
                }else {
                    [(KNPhotoLocateAVPlayerView *)playerView playerView].frame         = CGRectMake(x, y, width, height);
                    [(KNPhotoLocateAVPlayerView *)playerView playerLayer].frame        = CGRectMake(0, 0, width, height);
                    [(KNPhotoLocateAVPlayerView *)playerView placeHolderImgView].frame = CGRectMake(x, y, width, height);
                }
                
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
                    if (_isNeedOnlinePlay) {
                        _startFrame = [(KNPhotoAVPlayerView *)playerView playerView].frame;
                    }else {
                        _startFrame = [(KNPhotoLocateAVPlayerView *)playerView playerView].frame;
                    }
                    [playerView playerWillReset]; /// stop avplayer and cancel download task
                    [self cancelVideoDownload];
                    [playerView setIsNeedVideoPlaceHolder:true];
                    [self dismiss];
                    [[(KNPhotoLocateAVPlayerView *)playerView playerView] setBackgroundColor:UIColor.clearColor];
                }else{
                    // cancel
                    [self cancelVideoAnimation:playerView];
                    [self customViewSubViewsWillShow];
                    [playerView playerWillSwipeCancel];
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(PhotoBrowserAnimateTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [[(KNPhotoLocateAVPlayerView *)playerView playerView] setBackgroundColor:UIColor.blackColor];
                        [playerView setIsNeedVideoPlaceHolder:true];
                    });
                }
            }else {
                if(fabs(point.y) > 200 || fabs(velocity.y) > 500){
                    // dismiss
                    _startFrame = imageView.imageView.frame;
                    [self dismiss];
                }else{
                    // cancel
                    [self cancelAnimation:imageView.imageView];
                    [self customViewSubViewsWillShow];
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
- (void)cancelAnimation:(SDAnimatedImageView *)imageView{
    [UIView animateWithDuration:PhotoBrowserAnimateTime animations:^{
        imageView.frame = self.startFrame;
    } completion:^(BOOL finished) {
        self.view.backgroundColor = [UIColor blackColor];
    }];
}

- (void)cancelVideoAnimation:(id)playerView{
    
    CGRect frame = CGRectMake(0, 0, self.startFrame.size.width, self.startFrame.size.height);
    
    [UIView animateWithDuration:PhotoBrowserAnimateTime animations:^{
        if (self.isNeedOnlinePlay) {
            [(KNPhotoAVPlayerView *)playerView playerView].frame = frame;
            [(KNPhotoAVPlayerView *)playerView playerLayer].frame = frame;
            [(KNPhotoAVPlayerView *)playerView placeHolderImgView].frame = frame;
        }else {
            [(KNPhotoLocateAVPlayerView *)playerView playerView].frame = frame;
            [(KNPhotoLocateAVPlayerView *)playerView playerLayer].frame = frame;
            [(KNPhotoLocateAVPlayerView *)playerView placeHolderImgView].frame = frame;
        }
    } completion:^(BOOL finished) {
        self.view.backgroundColor = [UIColor blackColor];
    }];
}

#pragma mark - photoBrowser will present -- window
- (void)present{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window.rootViewController presentViewController:self animated:false completion:^{
        
    }];
}
#pragma mark - photoBrowser will present -- controller
- (void)present:(UIViewController *)controller {
    [controller presentViewController:self animated:false completion:^{
        
    }];
}
#pragma mark - photoBrowser will present -- controller
- (void)presentOn:(UIViewController *)controller {
    [controller presentViewController:self animated:false completion:^{
        
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
    tempView.contentMode = self.animatedMode;
    
    if (CGRectEqualToRect(rect, CGRectZero)) {
        // when source == nil
        [UIView animateWithDuration:PhotoBrowserAnimateTime delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self->_collectionView setAlpha:1];
        } completion:^(BOOL finished) {
            [self->_collectionView setHidden:false];
            [self hiddenStatusBar];
            
            [UIView animateWithDuration:0.15 animations:^{
                [tempView setAlpha:0.f];
            } completion:^(BOOL finished) {
                [tempView removeFromSuperview];
            }];
            self->_page = self.currentIndex;
        }];
        return;
    }
    
    // in case tempView'image create fail
    if(tempView.image == nil){
        [_collectionView setHidden:false];
        [UIView animateWithDuration:PhotoBrowserAnimateTime delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self->_collectionView setAlpha:1];
        } completion:^(BOOL finished) {
            self->_page = self.currentIndex;
        }];
        return;
    }
    
    [tempView setFrame:rect];
    
    tempView.layer.cornerRadius = 0.001;
    tempView.clipsToBounds = true;
    [self.view insertSubview:tempView atIndex:0];
    
    CGSize tempRectSize;
    CGFloat width  = tempView.image.size.width;
    CGFloat height = tempView.image.size.height;
    
    if(isPortrait == true){
        if (width/height >= PBViewWidth / PBViewHeight) {
            tempRectSize = (CGSize){PBViewWidth,(height * PBViewWidth / width) > PBViewHeight?PBViewHeight:(height * PBViewWidth / width)};
        }else {
            if (items.isVideo == true) {
                tempRectSize = (CGSize){width * PBViewHeight / height,PBViewHeight};
            }else {
                tempRectSize = (CGSize){PBViewWidth,(height * PBViewWidth / width) > PBViewHeight?PBViewHeight:(height * PBViewWidth / width)};
            }
        }
    }else{
        if(width > height){
            if(width / height > PBViewWidth / PBViewHeight){
                tempRectSize = (CGSize){PBViewWidth,height * PBViewWidth / width};
            }else{
                tempRectSize = (CGSize){PBViewHeight * width / height,PBViewHeight};
            }
        }else{
            tempRectSize = (CGSize){(width * PBViewHeight) / height,PBViewHeight};
        }
    }
    [_collectionView setHidden:true];
    
    [UIView animateWithDuration:PhotoBrowserAnimateTime delay:0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
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
        self->_page = self.currentIndex;
    }];
}

#pragma mark - photoBrowser will dismiss
- (void)dismiss{
    // willDismissWithIndex
    if([_delegate respondsToSelector:@selector(photoBrowser:willDismissWithIndex:)]){
        [_delegate photoBrowser:self willDismissWithIndex:_currentIndex];
    }
    
    // if customView on photoBrowser, them must be show
    for (UIView *subView in self.followArr) {
        [subView setAlpha:1];
    }
    
    UIImageView *tempView = [[UIImageView alloc] init];
    tempView.clipsToBounds = true;
    tempView.layer.cornerRadius = 0.01;
    tempView.contentMode = self.animatedMode;
    
    KNPhotoItems *items = _itemsArr[_currentIndex];
    
    if(items.sourceImage){ // locate image by sourceImage of items
        tempView.image = items.sourceImage;
        [self photoBrowserWillDismissWithAnimated:tempView items:items];
    }else{ // net image or locate image without sourceImage of items
        if(items.url && items.isVideo == false){
            
            __weak typeof(self) weakself = self;
            SDImageCache *cache = [SDImageCache sharedImageCache];
            [cache diskImageExistsWithKey:items.url completion:^(BOOL isInCache) {
                if(isInCache){
                    if([[[[items.url lastPathComponent] pathExtension] lowercaseString] isEqualToString:@"gif"]){ // gif image
                        NSData *data = UIImageJPEGRepresentation([cache imageFromCacheForKey:items.url], 1.f);
                        if(data){
                            tempView.image = [weakself imageFromGifFirstImage:data];
                        }
                    }else{ // normal image
                        tempView.image = [cache imageFromCacheForKey:items.url];
                    }
                }else{
                    tempView.image = [[weakself tempViewFromSourceViewWithCurrentIndex:weakself.currentIndex] image];
                }
                [self photoBrowserWillDismissWithAnimated:tempView items:items];
            }];
        }else{
            tempView.image = [[self tempViewFromSourceViewWithCurrentIndex:_currentIndex] image];
            [self photoBrowserWillDismissWithAnimated:tempView items:items];
        }
    }
}

- (void)createCustomViewArrOnTopView:(NSArray<UIView *> *)customViewArr
                            animated:(BOOL)animated
                      followAnimated:(BOOL)followAnimated {
    [self createOverlayViewArrOnTopView:customViewArr
                               animated:animated
                         followAnimated:followAnimated];
}

- (void)createOverlayViewArrOnTopView:(NSArray<UIView *> *)overlayViewArr
                             animated:(BOOL)animated
                       followAnimated:(BOOL)followAnimated{
    if ([self isEmptyArray:overlayViewArr]) {
        return;
    }
    if (followAnimated == true) {
        [self.followArr addObjectsFromArray:overlayViewArr];
    }
    
    if (animated == false) {
        _customArr = [NSArray arrayWithArray:overlayViewArr];
    }else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(PhotoBrowserAnimateTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            for (UIView *view in overlayViewArr) {
                [self.view addSubview:view];
            }
        });
    }
}

- (void)customViewSubViewsWillShow{
    if ([self isEmptyArray:self.followArr] == false) {
        for (UIView *subView in self.followArr) {
            [subView setAlpha:1];
        }
    }
    if (_isNeedFollowAnimated == true) {
        [_numView setAlpha:1];
        [_pageControl setAlpha:1];
        [_operationBtn setAlpha:1];
    }
}
- (void)customViewSubViewsWillDismiss{
    if ([self isEmptyArray:self.followArr] == false) {
        for (UIView *subView in self.followArr) {
            [subView setAlpha:0.0];
        }
    }
    if (_isNeedFollowAnimated == true) {
        [_numView setAlpha:0.0];
        [_pageControl setAlpha:0.0];
        [_operationBtn setAlpha:0.0];
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
        
        _isDismissed = true;
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
            _isDismissed = true;
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
        CGSize tempRectSize = (CGSize){PBViewWidth,(height * PBViewWidth / width) > PBViewHeight ? PBViewHeight:(height * PBViewWidth / width)};
        
        if(isPortrait == true){
            [tempView setBounds:(CGRect){CGPointZero,{tempRectSize.width,tempRectSize.height}}];
            [tempView setCenter:[self.view center]];
            
            if(!CGRectEqualToRect(self.startFrame, CGRectZero)){
                if(items.isVideo == true) {
                    tempView.frame = CGRectMake(self.startFrame.origin.x, self.startFrame.origin.y, tempRectSize.width, tempRectSize.height);
                }else {
                    tempView.frame = self.startFrame;
                }
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
            _isDismissed = true;
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

/// let screen to portrait
- (void)loadScreenPortrait{
    if(isPortrait) return;
    NSNumber *resetOrientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
    [[UIDevice currentDevice] setValue:resetOrientationTarget forKey:@"orientation"];
    NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [self layoutCollectionViewAndLayout];
    if ([_delegate respondsToSelector:@selector(photoBrowserWillLayoutSubviews)]) {
        [_delegate photoBrowserWillLayoutSubviews];
    }
}

- (void)layoutCollectionViewAndLayout{
    
    [_layout setItemSize:(CGSize){PBViewWidth + 20,PBViewHeight}];
    _layout.minimumInteritemSpacing = 0;
    _layout.minimumLineSpacing = 0;
    
    [_collectionView setFrame:(CGRect){{-10,0},{PBViewWidth + 20,PBViewHeight}}];
    [_collectionView setCollectionViewLayout:_layout];
    
    _imageView.frame = (CGRect){{-10,0},{PBViewWidth + 20,PBViewHeight}};
    _progressHUD.center = self.view.center;
    
    CGFloat y = 25;
    CGFloat x = 0;
    if(PBDeviceHasBang){
        y = 45;
    }
    
    if(!isPortrait){
        y = 15;
        x = 35;
    }
    
    [_numView setFrame:(CGRect){{0,y},{PBViewWidth,25}}];
    [_pageControl setFrame:(CGRect){{0,PBViewHeight - 50},{PBViewWidth,30}}];
    [_operationBtn setFrame:(CGRect){{PBViewWidth - 35 - 15 - x,y},{35,20}}];
    
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
        
        [_imageView imageWithUrl:[NSURL URLWithString:url]
                     progressHUD:_progressHUD
                     placeHolder:tempView.image
                       photoItem:item];
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
    if ([_delegate respondsToSelector:@selector(photoBrowser:rightBtnOperationActionWithIndex:)]) {
        [_delegate photoBrowser:self rightBtnOperationActionWithIndex:_currentIndex];
    }
}

/**
 save image to the location --> for example
 
 @param image image
 @param error error
 @param contextInfo context
 */
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    __weak typeof(self) weakself = self;
    if (error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([weakself.delegate respondsToSelector:@selector(photoBrowser:state:progress:photoItemRelative:photoItemAbsolute:)]) {
                [weakself.delegate photoBrowser:weakself
                                          state:KNPhotoDownloadStateSaveFailure
                                       progress:0.0
                              photoItemRelative:weakself.itemsArr[weakself.currentIndex]
                              photoItemAbsolute:weakself.tempArr[weakself.currentIndex]];
            }
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([weakself.delegate respondsToSelector:@selector(photoBrowser:state:progress:photoItemRelative:photoItemAbsolute:)]) {
                [weakself.delegate photoBrowser:weakself
                                          state:KNPhotoDownloadStateSaveSuccess
                                       progress:1.0
                              photoItemRelative:weakself.itemsArr[weakself.currentIndex]
                              photoItemAbsolute:weakself.tempArr[weakself.currentIndex]];
            }
        });
    }
}

/**
 save gif image to location --> for example
 
 @param photoData data
 */
- (void)savePhotoToLocation:(NSData *)photoData url:(NSString *)url{
    __weak typeof(self) weakself = self;
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
                    if ([weakself.delegate respondsToSelector:@selector(photoBrowser:state:progress:photoItemRelative:photoItemAbsolute:)]) {
                        [weakself.delegate photoBrowser:weakself
                                                  state:KNPhotoDownloadStateSuccess
                                               progress:1.0
                                      photoItemRelative:weakself.itemsArr[weakself.currentIndex]
                                      photoItemAbsolute:weakself.tempArr[weakself.currentIndex]];
                    }
                }else if(error) {
                    if ([weakself.delegate respondsToSelector:@selector(photoBrowser:state:progress:photoItemRelative:photoItemAbsolute:)]) {
                        [weakself.delegate photoBrowser:weakself
                                                  state:KNPhotoDownloadStateFailure
                                               progress:0.0
                                      photoItemRelative:weakself.itemsArr[weakself.currentIndex]
                                      photoItemAbsolute:weakself.tempArr[weakself.currentIndex]];
                    }
                }
            });
        }];
    });
}

/**
 remove current image or video on photobrowser
 */
- (void)removeImageOrVideoOnPhotoBrowser{
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
        
        [self setNeedsStatusBarAppearanceUpdate];
        
        if([_delegate respondsToSelector:@selector(photoBrowser:willDismissWithIndex:)]){
            [_delegate photoBrowser:self willDismissWithIndex:_currentIndex];
        }
        
        [self dismissViewControllerAnimated:true completion:nil];
    }else{
        [_pageControl setCurrentPage:_currentIndex];
        [_pageControl setNumberOfPages:_itemsArr.count];
        [_numView setCurrentNum:(_currentIndex + 1) totalNum:_itemsArr.count];
    }
    
    if ([_delegate respondsToSelector:@selector(photoBrowser:removeSourceWithRelativeIndex:)]) {
        [_delegate photoBrowser:self removeSourceWithRelativeIndex:_currentIndex];
    }
    
    if ([_delegate respondsToSelector:@selector(photoBrowser:removeSourceWithAbsoluteIndex:)]) {
        [_delegate photoBrowser:self removeSourceWithAbsoluteIndex:[_tempArr indexOfObject:item]];
    }
}

/**
 download photo or video to Album, but it must be authed at first
 */
- (void)downloadImageOrVideoToAlbum{
    KNPhotoItems *items = self.itemsArr[self.currentIndex];
    __weak typeof(self) weakself = self;
    if (items.isVideo) { // video
        if ([items.url hasPrefix:@"http"]) {
            KNPhotoDownloadFileMgr *fileMgr = [[KNPhotoDownloadFileMgr alloc] init];
            if ([fileMgr startCheckIsExistVideo:items]) { // video is exist
                NSString *filePath = [fileMgr startGetFilePath:items];
                UISaveVideoAtPathToSavedPhotosAlbum(filePath, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
            }else { // downloading
                
                self.downloadMgr = [[KNPhotoDownloadMgr shareInstance] init];
                if (weakself.isNeedOnlinePlay == true) {
                    [self.downloadMgr downloadVideoWithPhotoItems:items downloadBlock:^(KNPhotoDownloadState downloadState, float progress) {
                        if (downloadState == KNPhotoDownloadStateSuccess) {
                            NSString *filePath = [fileMgr startGetFilePath:items];
                            UISaveVideoAtPathToSavedPhotosAlbum(filePath, weakself, @selector(video:didFinishSavingWithError:contextInfo:), nil);
                        }else if (downloadState == KNPhotoDownloadStateDownloading){
                            dispatch_async(dispatch_get_main_queue(), ^{
                                if ([weakself.delegate respondsToSelector:@selector(photoBrowser:state:progress:photoItemRelative:photoItemAbsolute:)]) {
                                    [weakself.delegate photoBrowser:weakself
                                                              state:downloadState
                                                           progress:progress
                                                  photoItemRelative:weakself.itemsArr[weakself.currentIndex]
                                                  photoItemAbsolute:weakself.tempArr[weakself.currentIndex]];
                                }
                            });
                        }
                    }];
                }else {
                    KNPhotoVideoCell *cell = (KNPhotoVideoCell *)[weakself.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:weakself.currentIndex inSection:0]];
                    [cell.locatePlayerView playerDownloadBlock:^(KNPhotoDownloadState downloadState, float progress) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if ([weakself.delegate respondsToSelector:@selector(photoBrowser:state:progress:photoItemRelative:photoItemAbsolute:)]) {
                                [weakself.delegate photoBrowser:weakself
                                                          state:downloadState
                                                       progress:progress
                                              photoItemRelative:weakself.itemsArr[weakself.currentIndex]
                                              photoItemAbsolute:weakself.tempArr[weakself.currentIndex]];
                            }
                        });
                        if (downloadState == KNPhotoDownloadStateSuccess) {
                            NSString *filePath = [fileMgr startGetFilePath:items];
                            UISaveVideoAtPathToSavedPhotosAlbum(filePath, weakself, @selector(video:didFinishSavingWithError:contextInfo:), nil);
                        }
                    }];
                }
            }
        }else {
            UISaveVideoAtPathToSavedPhotosAlbum(items.url, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
        }
    }else{ // image
        if(items.url){ // net image
            SDImageCache *cache = [SDImageCache sharedImageCache];
            SDWebImageManager *mgr = [SDWebImageManager sharedManager];
            [cache diskImageExistsWithKey:items.url completion:^(BOOL isInCache) {
                if(!isInCache){
                    if ([weakself.delegate respondsToSelector:@selector(photoBrowser:state:progress:photoItemRelative:photoItemAbsolute:)]) {
                        [weakself.delegate photoBrowser:weakself
                                                  state:KNPhotoDownloadStateUnknow
                                               progress:0.0
                                      photoItemRelative:weakself.itemsArr[weakself.currentIndex]
                                      photoItemAbsolute:weakself.tempArr[weakself.currentIndex]];
                    }
                }else{
                    [[mgr imageCache] queryImageForKey:items.url options:SDWebImageQueryMemoryData | SDWebImageRetryFailed context:nil completion:^(UIImage * _Nullable image, NSData * _Nullable data, SDImageCacheType cacheType) {
                        if([image images] != nil){
                            [weakself savePhotoToLocation:data url:items.url];
                        }else{
                            if(image){
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    UIImageWriteToSavedPhotosAlbum(image, weakself, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
                                });
                            }
                        }
                    }];
                }
            }];
        }else{ // locate image or sourceimage
            UIImageView *imageView = [self tempViewFromSourceViewWithCurrentIndex:self.currentIndex];
            if(imageView.image){
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIImageWriteToSavedPhotosAlbum(imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
                });
            }else{
                if ([weakself.delegate respondsToSelector:@selector(photoBrowser:state:progress:photoItemRelative:photoItemAbsolute:)]) {
                    [weakself.delegate photoBrowser:weakself
                                              state:KNPhotoDownloadStateFailure
                                           progress:0.0
                                  photoItemRelative:weakself.itemsArr[weakself.currentIndex]
                                  photoItemAbsolute:weakself.tempArr[weakself.currentIndex]];
                }
            }
        }
    }
}

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    __weak typeof(self) weakself = self;
    if (error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([weakself.delegate respondsToSelector:@selector(photoBrowser:state:progress:photoItemRelative:photoItemAbsolute:)]) {
                [weakself.delegate photoBrowser:weakself
                                          state:KNPhotoDownloadStateSaveFailure
                                       progress:0.0
                              photoItemRelative:weakself.itemsArr[weakself.currentIndex]
                              photoItemAbsolute:weakself.tempArr[weakself.currentIndex]];
            }
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([weakself.delegate respondsToSelector:@selector(photoBrowser:state:progress:photoItemRelative:photoItemAbsolute:)]) {
                [weakself.delegate photoBrowser:weakself
                                          state:KNPhotoDownloadStateSaveSuccess
                                       progress:1.0
                              photoItemRelative:weakself.itemsArr[weakself.currentIndex]
                              photoItemAbsolute:weakself.tempArr[weakself.currentIndex]];
            }
        });
    }
}

/// cancen download video when downloading
- (void)cancelVideoDownload{
    [self.downloadMgr cancelTask];
}

/**
 player's rate immediately to use
 */
- (void)setImmediatelyPlayerRate:(CGFloat)rate {
    
    if (rate < 0.5 || rate > 2.0) {
        return;
    }
    
    KNPhotoItems *items = self.itemsArr[_currentIndex];
    if (items.isVideo) {
        KNPhotoVideoCell *cell = (KNPhotoVideoCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0]];
        if (_isNeedOnlinePlay) {
            [cell.onlinePlayerView playerRate:rate];
        }else {
            [cell.locatePlayerView playerRate:rate];
        }
    }
}

/**
 longPress Did click
 */
- (void)longPressIBAction{
    if(!_isNeedLongPress) return;
    if ([_delegate respondsToSelector:@selector(photoBrowser:imageLongPressWithIndex:)]) {
        [_delegate photoBrowser:self imageLongPressWithIndex:_currentIndex];
    }
}

/// create one image by Color
/// @param imageColor color
/// @param size image size
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
 judge array is empty or null or nil
 @param array isEmpty array
 */
- (BOOL)isEmptyArray:(NSArray *)array{
    if(array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0){
        return true;
    }
    return false;
}

/// judge string is empty or null or nil
/// @param string isEmpty string
- (BOOL)isEmptyString:(NSString *)string{
    if(string == nil || string == NULL || [string isKindOfClass:[NSNull class]] || [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0){
        return true;
    }
    return false;
}

/**
 get the image of current sourceView
 
 @param currentIndex index
 @return imageView with image
 */
- (UIImageView *)tempViewFromSourceViewWithCurrentIndex:(NSInteger)currentIndex{
    UIImageView *imageView = [[UIImageView alloc] init];
    KNPhotoItems *items = _itemsArr[currentIndex];
    
    // if it is not custom sourceView, just UIImageView or UIButton
    if ([self isEmptyArray:items.sourceLinkArr]) {
        if([items.sourceView isKindOfClass:[UIImageView class]]){
            imageView.image = [(UIImageView *)items.sourceView image];
        }else if ([items.sourceView isKindOfClass:[UIButton class]]){
            UIButton *btn = (UIButton *)items.sourceView;
            [imageView setImage:[btn currentBackgroundImage]?[btn currentBackgroundImage]:[btn currentImage]];
        }
    }else { // custom sourceView , it must set sourceLinkArr and sourceLinkProperyName
        
        UIView *currentView = items.sourceView;
        
        for (NSInteger i = 0; i < items.sourceLinkArr.count; i++) {
            Class cls = NSClassFromString(items.sourceLinkArr[i]);
            for (NSInteger j = 0; j < currentView.subviews.count; j++) {
                if ([currentView.subviews[j] isKindOfClass:cls]) {
                    currentView = currentView.subviews[j];
                    break;
                }
            }
        }
        
        NSString *lastType = items.sourceLinkArr.lastObject;
        if ([lastType isEqualToString:@"UIImageView"] && [currentView isKindOfClass:[UIImageView class]]) {
            imageView.image = [(UIImageView *)currentView image];
        }else if ([lastType isEqualToString:@"UIButton"] && [currentView isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)currentView;
            [imageView setImage:[btn currentBackgroundImage]?[btn currentBackgroundImage]:[btn currentImage]];
        }else {
            if ([self isEmptyString:items.sourceLinkProperyName] == false) { // get all propertyName of currentView's class
                unsigned int count;
                objc_property_t *propertyList = class_copyPropertyList([currentView class], &count);
                for (NSInteger i = 0; i < count; i++) {
                    struct objc_property *objc_property = propertyList[i];
                    NSString *property = [NSString stringWithFormat:@"%s",property_getName(objc_property)];
                    if ([property isEqualToString:items.sourceLinkProperyName]) {
                        [imageView setImage:[currentView valueForKey:items.sourceLinkProperyName]];
                    }
                }
                free(propertyList);
            }
        }
    }
    
    if(items.sourceView == nil && imageView.image == nil && items.sourceImage != nil){
        imageView.image = items.sourceImage;
    }
    
    if(imageView.image == nil){
        if (items.isVideo == false) {
            if (items.url) {
                UIColor *imageColor = self.placeHolderColor ? self.placeHolderColor : UIColor.clearColor;
                CGSize size = CGSizeMake(PBViewWidth, PBViewWidth);
                imageView.image = [self createImageWithUIColor: imageColor size: size];
            }else {
                imageView.image = [self createImageWithUIColor: UIColor.clearColor size: CGSizeMake(PBViewWidth, PBViewWidth)];
            }
        }else {
            if (items.videoPlaceHolderImageUrl) {
                UIColor *imageColor = self.placeHolderColor ? self.placeHolderColor : UIColor.clearColor;
                CGSize size = CGSizeMake(PBViewWidth, PBViewWidth);
                imageView.image = [self createImageWithUIColor: imageColor size: size];
            }else {
                imageView.image = [self createImageWithUIColor: UIColor.clearColor size: CGSizeMake(PBViewWidth, PBViewWidth)];
            }
        }
    }
    return imageView;
}


/// pageCotrol did be selected by click 
/// @param pageControl pageControl
- (void)pageControlValueChange:(UIPageControl *)pageControl {
#ifdef DEBUG
     NSLog(@"currentPage ===> %zd", pageControl.currentPage);
#endif
     [_collectionView setContentOffset:(CGPoint){pageControl.currentPage * _layout.itemSize.width,0} animated: true];
}

@end

@implementation KNPhotoItems

@end

@implementation UIDevice(PBExtension)

/**
 judge is have auth of Album --> for example
 
 @param authorBlock block
 */
+ (void)deviceAlbumAuth:(void (^)(BOOL isAuthor))authorBlock{
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

/// device shake
+ (void)deviceShake{
    AudioServicesPlaySystemSound(1520);
}

@end
