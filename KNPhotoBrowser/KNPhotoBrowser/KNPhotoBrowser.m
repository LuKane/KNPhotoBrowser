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
#import "KNPhotoBrowserPch.h"
#import "UIImageView+WebCache.h"
#import "UIImage+GIF.h"
#import "KNPhotoBrowserNumView.h"
#import "KNToast.h"
#import "KNActionSheet/KNActionSheet.h"
#import "SDWebImagePrefetcher.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/ALAsset.h>
#import <Photos/Photos.h>

@interface KNPhotoBrowser ()<UICollectionViewDelegate,UICollectionViewDataSource>{
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
    BOOL                        _hasBeenOrientation;
}

@property (nonatomic,weak  ) KNActionSheet *actionSheet;

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
                if(items.url != nil && [items.url hasPrefix:@"http"]){
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
            if(items.url != nil && [items.url hasPrefix:@"http"]){
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
    [collectionView setBackgroundColor:[UIColor blackColor]];
    [collectionView setScrollsToTop:false];
    [collectionView setShowsHorizontalScrollIndicator:false];
    [collectionView setContentOffset:CGPointZero];
    [collectionView setAlpha:0.f];
    [collectionView setBounces:true];
    [self.view addSubview:collectionView];
    
    _layout = layout;
    _collectionView = collectionView;
    [_collectionView registerClass:[KNPhotoBaseCell class] forCellWithReuseIdentifier:@"KNPhotoBaseCellID"];
    
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
    }
    [self.view addSubview:pageControl];
    
    _pageControl = pageControl;
}

/* init right top Btn */
- (void)initOperationView{
    UIButton *operationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [operationBtn.layer setCornerRadius:3];
    [operationBtn.layer setMasksToBounds:YES];
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
    KNPhotoBaseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KNPhotoBaseCellID" forIndexPath:indexPath];
    KNPhotoItems *item = self.itemsArr[indexPath.row];
    NSString *url  = item.url;
    UIImageView *tempView = [self tempViewFromSourceViewWithCurrentIndex:indexPath.row];
    
    [cell sd_ImageWithUrl:url placeHolder:tempView.image?tempView.image:[self createImageWithUIColor:[UIColor lightGrayColor]]];
    
    __weak typeof(self) weakSelf = self;
    cell.singleTap = ^{
        [weakSelf dismiss];
    };
    cell.longPressTap = ^{
        [weakSelf longPressIBAction];
    };
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [cell prepareForReuse];
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
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self->_collectionView setAlpha:1];
        } completion:^(BOOL finished) {
            self->_page = self->_currentIndex;
        }];
        
        return;
    }
    
    [tempView setFrame:rect];
    [tempView setContentMode:sourceView.contentMode];
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
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [tempView setCenter:[self.view center]];
        [tempView setBounds:(CGRect){CGPointZero,tempRectSize}];
        [self->_collectionView setAlpha:1];
    } completion:^(BOOL finished) {
        [self->_collectionView setHidden:false];
        
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
        if(items.url){
            SDWebImageManager *mgr = [SDWebImageManager sharedManager];
            [mgr cachedImageExistsForURL:[NSURL URLWithString:items.url] completion:^(BOOL isInCache) {
                if(isInCache){
                    if([[[[items.url lastPathComponent] pathExtension] lowercaseString] isEqualToString:@"gif"]){ // gif image
                        NSData *data = UIImageJPEGRepresentation([[mgr imageCache] imageFromDiskCacheForKey:items.url], 1.f);
                        if(data){
                            tempView.image = [self imageFromGifFirstImage:data];
                        }
                    }else{ // normal image
                        tempView.image = [[mgr imageCache] imageFromCacheForKey:items.url];
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
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [tempView setAlpha:0.f];
            } completion:^(BOOL finished) {
                [tempView removeFromSuperview];
                [self dismissViewControllerAnimated:true completion:nil];
            }];
        }else{
            [self loadScreenPortrait];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    [tempView setAlpha:0.f];
                } completion:^(BOOL finished) {
                    [tempView removeFromSuperview];
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
            [window addSubview:tempView];
            
            [self dismissViewControllerAnimated:false completion:nil];
            
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [tempView setFrame:rect];
            } completion:^(BOOL finished) {
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
                
                [self dismissViewControllerAnimated:true completion:nil];
                
                [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    [tempView setFrame:rect];
                } completion:^(BOOL finished) {
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
    
    if(![item.url.lastPathComponent.pathExtension.lowercaseString isEqualToString:@"gif"]){
        [_collectionView setHidden:true];
        [_imageView setHidden:false];
        [_progressHUD setHidden:false];
        UIImageView *tempView = [self tempViewFromSourceViewWithCurrentIndex:_currentIndex];
        [_imageView sd_ImageWithUrl:[NSURL URLWithString:url] progressHUD:_progressHUD placeHolder:tempView.image?tempView.image:[self createImageWithUIColor:[UIColor lightGrayColor]]];
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
    if(_hasBeenOrientation == false){
        _hasBeenOrientation = true;
    }
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
        KNActionSheet *actionSheet = [[KNActionSheet alloc] initWithCancelTitle:nil otherTitleArr:self.actionSheetArr.copy actionBlock:^(NSInteger buttonIndex) {
            if([weakSelf.delegate respondsToSelector:@selector(photoBrowserRightOperationActionWithIndex:)]){
                [weakSelf.delegate photoBrowserRightOperationActionWithIndex:buttonIndex];
            }
        }];
        [actionSheet show];
        self.actionSheet = actionSheet;
    }else{ // example
        KNActionSheet *actionSheet = [[KNActionSheet alloc] initWithCancelTitle:nil destructiveTitle:@"删除" otherTitleArr:@[@"保存图片",@"转发微博",@"赞"]  actionBlock:^(NSInteger buttonIndex) {
            
            if([weakSelf.delegate respondsToSelector:@selector(photoBrowserRightOperationActionWithIndex:)]){
                [weakSelf.delegate photoBrowserRightOperationActionWithIndex:buttonIndex];
            }
            
            switch (buttonIndex) {
                case 0:{ // Delete image
                    
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
                    [weakSelf deleteImageDidClick];
                }
                    break;
                case 1:{
                    [weakSelf deviceAlbumAuth:^(BOOL isAuthor) {
                        if(isAuthor == false){
                            // do not have auth, you need alert .....
                        }else{
                            // save currrent image to album
                            KNPhotoItems *items = weakSelf.itemsArr[weakSelf.currentIndex];
                            if(items.url){ // net image
                                SDWebImageManager *mgr = [SDWebImageManager sharedManager];
                                [mgr diskImageExistsForURL:[NSURL URLWithString:items.url] completion:^(BOOL isInCache) {
                                    if(!isInCache){
                                        [[KNToast shareToast] initWithText:PhotoSaveImageFailureReason];
                                        return ;
                                    }else{
                                        [[mgr imageCache] queryCacheOperationForKey:items.url done:^(UIImage * _Nullable image, NSData * _Nullable data, SDImageCacheType cacheType) {
                                            if([image isGIF]){
                                                [weakSelf savePhotoToLocation:data];
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
        [weakSelf.delegate photoBrowserWriteToSavedPhotosAlbumStatus:error?NO:YES];
    }
}

/**
 save gif image to location --> for example
 
 @param photoData data
 */
- (void)savePhotoToLocation:(NSData *)photoData{
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        PHAssetResourceCreationOptions *options = [[PHAssetResourceCreationOptions alloc] init];
        options.shouldMoveFile = true;
        PHAssetCreationRequest *request = [PHAssetCreationRequest creationRequestForAsset];
        [request addResourceWithType:PHAssetResourceTypePhoto data:photoData options:options];
        request.creationDate = [NSDate date];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            if(success){
                [[KNToast shareToast] initWithText:PhotoSaveImageSuccessMessage duration:PhotoSaveImageMessageTime];
            }else if(error) {
                [[KNToast shareToast] initWithText:PhotoSaveImageFailureMessage duration:PhotoSaveImageMessageTime];
            }
        });
    }];
}

/**
 delete image --> for example
 */
- (void)deleteImageDidClick{
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
        [_numView setCurrentNum:(_currentIndex + 1) totalNum:_itemsArr.count];
    }
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
- (UIImage *)createImageWithUIColor:(UIColor *)imageColor{
    CGRect rect = CGRectMake(0, 0, 1.f, 1.f);
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
    
    return imageView;
}

@end

@implementation KNPhotoItems


@end
