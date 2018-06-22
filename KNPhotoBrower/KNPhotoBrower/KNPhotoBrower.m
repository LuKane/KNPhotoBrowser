//
//  KNPhotoBrower.m
//  KNPhotoBrower
//
//  Created by LuKane on 16/8/18.
//  Copyright © 2016年 LuKane. All rights reserved.
//

#import "KNPhotoBrower.h"
#import "KNPhotoBrowerCell.h"

#import "UIImageView+WebCache.h"

#import "KNPhotoBrowerNumView.h"
#import "KNToast.h"
#import "KNPch.h"
#import "UIImage+GIF.h"

#import "KNActionSheet.h"
#import <ImageIO/ImageIO.h>
#import <objc/runtime.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/ALAsset.h>
#import <Photos/Photos.h>

@interface KNPhotoBrower()<UICollectionViewDataSource,UICollectionViewDelegate>{
    KNPhotoBrowerCell     *_collectionViewCell;
    UICollectionViewFlowLayout *_layout;
    KNPhotoBrowerNumView  *_numView;
    UICollectionView      *_collectionView;
    UIButton              *_operationBtn;// 操作按钮
    UIPageControl         *_pageControl;// UIPageControl
    BOOL                   _isFirstShow;// 是否是第一次 展示
    NSInteger              _page; // 页数
    NSArray               *_tempArr; // 给 '绝对数据源'
    NSInteger              _direction;// 1: 竖直  2: 左边  3:右边
}

@end

static NSString *ID = @"KNCollectionView";

@implementation KNPhotoBrower

- (instancetype)init{
    if (self = [super init]) {
        [self initializeDefaultProperty];
    }
    return self;
}

#pragma mark - 初始化 基本属性
- (void)initializeDefaultProperty{
    [self setBackgroundColor:[UIColor blackColor]];
    [self setAlpha:PhotoBrowerBackgroundAlpha];
    
    self.actionSheetArr         = [NSMutableArray array];
    _isNeedPageNumView          = YES;
    _isNeedRightTopBtn          = YES;
    _isNeedPictureLongPress     = YES;
    _isNeedPageControl          = NO;
    _isNeedDeviceOrientation    = NO;
    _direction                  = 1;
    
    // 监听屏幕旋转
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceDidOrientation) name:UIDeviceOrientationDidChangeNotification object:nil];
}

#pragma mark - 当屏幕发生旋转
- (void)deviceDidOrientation{
    if(_isNeedDeviceOrientation == false) return;
    NSInteger page = _page;
    
    if(PhotoOrientationFaceUp || PhotoOrientationFaceDown || PhotoOrientationUnknown){
        
    }else{
        if (PhotoOrientationLandscapeIsPortrait || PhotoOrientationLandscapeIsPortraitUpsideDown){
            _direction = 1;
            [self reloadPortraitFrame:page];
        }else if (PhotoOrientationLandscapeIsLeft){
            if(_direction == 3){
                [self reloadLandscapeFromRightFrame:page];
            }else{
                [self reloadLandscapeIsLeftFrame:page];
            }
            _direction = 2;
        }else if (PhotoOrientationLandscapeIsRight){
            if(_direction == 2){
                [self reloadLandscapeFromLeftFrame:page];
            }else{
                [self reloadLandscapeIsRightFrame:page];
            }
            _direction = 3;
        }
    }
}

/**
 当屏幕旋转到  正上 或  正下
 
 @param page 当前图片的下标
 */
- (void)reloadPortraitFrame:(NSInteger)page{
    
    // _collectionView 的处理
    [UIView animateWithDuration:PhotoBrowerTransformTime animations:^{
        _collectionView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [_collectionViewCell setNeedsLayout];
        [_collectionView setFrame:(CGRect){{0,0},{ScreenWidth + PhotoBrowerMargin,ScreenHeight}}];
        _collectionView.center = CGPointMake((ScreenWidth + 20) * 0.5, ScreenHeight * 0.5);
        _layout.itemSize = CGSizeMake(ScreenWidth + PhotoBrowerMargin, ScreenHeight);
        [_layout invalidateLayout];
        [_collectionView reloadData];
        [_collectionView setContentOffset:(CGPoint){page * (ScreenWidth + PhotoBrowerMargin),0} animated:NO];
    }];
    
    // 顶部数字View的处理
    [UIView animateWithDuration:PhotoBrowerTransformTime animations:^{
        _numView.transform = CGAffineTransformIdentity;
        _numView.frame = (CGRect){{0,iPhoneX?45:25},{ScreenWidth,25}};
        _numView.center = (CGPoint){ScreenWidth * 0.5,iPhoneX?(45 + 12.5):(25 + 12.5)};
    }];
    
    // PageControl 的处理
    [UIView animateWithDuration:PhotoBrowerTransformTime animations:^{
        _pageControl.transform = CGAffineTransformIdentity;
        _pageControl.frame = (CGRect){{0,ScreenHeight - 50},{ScreenWidth,30}};
        _pageControl.center = (CGPoint){ScreenWidth * 0.5,ScreenHeight - 50 + 15};
    }];
    
    // 右上角操作按钮的处理
    [UIView animateWithDuration:PhotoBrowerTransformTime animations:^{
        _operationBtn.transform = CGAffineTransformIdentity;
        _operationBtn.frame = (CGRect){{ScreenWidth - 35 - 15,iPhoneX?45:25},{35,20}};
        _operationBtn.center = (CGPoint){ScreenWidth - 35 - 15 + 35 / 2,iPhoneX?(45 + 10):(15 + 10)};
    }];
}

/**
 当屏幕旋转到 左边时 --> 头朝着左边
 
 @param page 当前图片的下标
 */
- (void)reloadLandscapeIsLeftFrame:(NSInteger)page{
    
    // _collectionView 的处理
    [_collectionView setFrame:(CGRect){{0,0},{ScreenHeight + PhotoBrowerMargin,ScreenWidth}}];
    _collectionView.center = CGPointMake(ScreenWidth * 0.5, ScreenHeight * 0.5);
    _layout.itemSize = CGSizeMake(ScreenHeight + PhotoBrowerMargin, ScreenWidth);
    [_layout invalidateLayout];
    [_collectionView reloadData];
    [_collectionView setContentOffset:(CGPoint){page * (ScreenHeight + PhotoBrowerMargin),0} animated:NO];
    
    [UIView animateWithDuration:PhotoBrowerTransformTime animations:^{
        _collectionView.transform = CGAffineTransformMakeRotation( M_PI * 0.5);
    } completion:^(BOOL finished) {
        [_collectionViewCell setNeedsLayout];
    }];
    
    // 顶部数字View的处理
    [UIView animateWithDuration:PhotoBrowerTransformTime animations:^{
        _numView.transform = CGAffineTransformMakeRotation(M_PI * 0.5);
        _numView.frame = CGRectMake(0, 0, 25 ,ScreenHeight);
        _numView.center = CGPointMake(ScreenWidth - 12.5, ScreenHeight * 0.5);
    }];
    
    // PageControl 的处理
    [UIView animateWithDuration:PhotoBrowerTransformTime animations:^{
        _pageControl.transform = CGAffineTransformMakeRotation(M_PI * 0.5);
        _pageControl.frame = CGRectMake(0, 0, 30 ,ScreenHeight);
        _pageControl.center = CGPointMake(25, ScreenHeight * 0.5);
    }];
    
    // 右上角操作按钮的处理
    [UIView animateWithDuration:PhotoBrowerBrowerTime animations:^{
        _operationBtn.transform = CGAffineTransformMakeRotation(M_PI * 0.5);
        _operationBtn.frame = CGRectMake(0, 0, 20, 35);
        _operationBtn.center = CGPointMake(ScreenWidth - (10 + iPhoneX?45:25), ScreenHeight - 35 * 0.5 - 15);
    }];
}

/**
 当屏幕旋转到右边时 --> 头朝着右边
 
 @param page 当前图片的下标
 */
- (void)reloadLandscapeIsRightFrame:(NSInteger)page{
    
    // _collectionView 的处理
    [_collectionView setFrame:(CGRect){{0,0},{ScreenHeight + PhotoBrowerMargin,ScreenWidth}}];
    _collectionView.center = CGPointMake(ScreenWidth * 0.5, ScreenHeight * 0.5);
    _layout.itemSize = CGSizeMake(ScreenHeight + PhotoBrowerMargin, ScreenWidth);
    [_layout invalidateLayout];
    [_collectionView reloadData];
    [_collectionView setContentOffset:(CGPoint){page * (ScreenHeight + PhotoBrowerMargin),0} animated:NO];
    
    [UIView animateWithDuration:PhotoBrowerTransformTime animations:^{
        _collectionView.transform = CGAffineTransformMakeRotation(- M_PI * 0.5);
    } completion:^(BOOL finished) {
        [_collectionViewCell setNeedsLayout];
    }];
    
    // 顶部数字View的处理
    [UIView animateWithDuration:PhotoBrowerTransformTime animations:^{
        _numView.transform = CGAffineTransformMakeRotation(- M_PI * 0.5);
        _numView.frame = CGRectMake(0, 0, 25 ,ScreenHeight);
        _numView.center = CGPointMake(12.5, ScreenHeight * 0.5);
    }];
    
    // PageControl 的处理
    [UIView animateWithDuration:PhotoBrowerTransformTime animations:^{
        _pageControl.transform = CGAffineTransformMakeRotation(- M_PI * 0.5);
        _pageControl.frame = CGRectMake(0, 0, 30 ,ScreenHeight);
        _pageControl.center = CGPointMake(ScreenWidth - 25, ScreenHeight * 0.5);
    }];
    
    // 右上角操作按钮的处理
    [UIView animateWithDuration:PhotoBrowerBrowerTime animations:^{
        _operationBtn.transform = CGAffineTransformMakeRotation(- M_PI * 0.5);
        _operationBtn.frame = CGRectMake(0, 0, 20, 35);
        _operationBtn.center = CGPointMake(10 + iPhoneX?45:25,  35 * 0.5 + 15);
    }];
}


/**
 当屏幕 旋转180
 
 @param page 当前图片的下标
 */
- (void)reloadLandscapeFromRightFrame:(NSInteger)page{
    [UIView animateWithDuration:PhotoBrowerBrowerTime animations:^{
        _collectionView.transform = CGAffineTransformMakeRotation(M_PI * 0.5);
    } completion:^(BOOL finished) {
        [_collectionView reloadData];
    }];
}

/**
 当屏幕 旋转180
 
 @param page 当前图片的下标
 */
- (void)reloadLandscapeFromLeftFrame:(NSInteger)page{
    [UIView animateWithDuration:PhotoBrowerBrowerTime animations:^{
        _collectionView.transform = CGAffineTransformMakeRotation(-M_PI * 0.5);
    } completion:^(BOOL finished) {
        [_collectionView reloadData];
    }];
}

#pragma mark - 初始化 CollectionView
- (void)initializeCollectionView{
    
    CGRect bounds = (CGRect){{0,0},{self.width,self.height}};
    bounds.size.width += PhotoBrowerMargin;
    
    // 1.create layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setItemSize:bounds.size];
    [layout setMinimumInteritemSpacing:0];
    [layout setMinimumLineSpacing:0];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    _layout = layout;
    
    // 2.create collectionView
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:bounds collectionViewLayout:layout];
    
    [collectionView setBackgroundColor:[UIColor clearColor]];
    [collectionView setPagingEnabled:YES];
    [collectionView setBounces:YES]; // 设置 collectionView的 弹簧效果,这样拉最后一张图时会有拉出来效果,再反弹回去
    
    [collectionView setDataSource:self];
    [collectionView setDelegate:self];
    
    [collectionView setShowsHorizontalScrollIndicator:NO];
    [collectionView setShowsVerticalScrollIndicator:NO];
    [collectionView setDecelerationRate:0];
    [collectionView registerClass:[KNPhotoBrowerCell class] forCellWithReuseIdentifier:ID];
    _collectionView = collectionView;
    
    [self addSubview:collectionView];
}

#pragma mark - 初始化 pageView
- (void)initializePageView{
    KNPhotoBrowerNumView *numView = [[KNPhotoBrowerNumView alloc] init];
    [numView setFrame:(CGRect){{0,iPhoneX?45:25},{ScreenWidth,25}}];
    [numView setCurrentNum:(_currentIndex + 1) totalNum:_itemsArr.count];
    _page = [numView currentNum];
    [numView setHidden:!_isNeedPageNumView];
    
    //  无论 _isNeedPageNumView 如何设置, 只要imageArr 的个数 == 1, 则隐藏
    if(_itemsArr.count == 1){
        [numView setHidden:YES];
    }
    
    _numView = numView;
    [self addSubview:numView];
}

#pragma mark - 初始化 UIPageControl
- (void)initializePageControl{
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    [pageControl setCurrentPage:_currentIndex];
    [pageControl setNumberOfPages:_itemsArr.count];
    [pageControl setFrame:(CGRect){{0,ScreenHeight - 50},{ScreenWidth,30}}];
    [pageControl setHidden:!_isNeedPageControl];
    
    // 无论 _isNeedPageControl 如何设置, 只要imageArr 的个数 == 1, 则隐藏
    if(_itemsArr.count == 1){
        [pageControl setHidden:YES];
    }
    
    _pageControl = pageControl;
    [self addSubview:pageControl];
}

#pragma mark - 初始化 右上角 操作按钮
- (void)initializeOperationView{
    UIButton *operationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [operationBtn.layer setCornerRadius:3];
    [operationBtn.layer setMasksToBounds:YES];
    [operationBtn setBackgroundColor:[UIColor blackColor]];
    [operationBtn setAlpha:0.4];
    [operationBtn setBackgroundImage:[UIImage imageNamed:@"KNPhotoBrower.bundle/more_tap@2x.png"] forState:UIControlStateNormal];
    [operationBtn setFrame:(CGRect){{ScreenWidth - 35 - 15,iPhoneX?45:25},{35,20}}];
    [operationBtn addTarget:self action:@selector(operationBtnIBAction) forControlEvents:UIControlEventTouchUpInside];
    [operationBtn setHidden:!_isNeedRightTopBtn];
    _operationBtn = operationBtn;
    [self addSubview:operationBtn];
}

#pragma mark - 右上角 按钮的点击
- (void)operationBtnIBAction{
    __weak typeof(self) weakSelf = self;
    
    if(!_isNeedPictureLongPress) return;
    
    if(_actionSheetArr.count != 0){ // 如果是自定义的 选项
        KNActionSheet *actionSheet = [[KNActionSheet alloc] initWithCancelTitle:nil otherTitleArr:[weakSelf.actionSheetArr copy] actionBlock:^(NSInteger buttonIndex) {
            // 让代理知道 是哪个按钮被点击了
            if([weakSelf.delegate respondsToSelector:@selector(photoBrowerRightOperationActionWithIndex:)]){
                [weakSelf.delegate photoBrowerRightOperationActionWithIndex:buttonIndex];
            }
            //  如果传入的 ActionSheetArr 有下载图片这一选项. 则在这里调用和下面一样的方法 switch.....,如果没有下载图片,则通过代理方法去实现...
        }];
        actionSheet.isNeedDeviceOrientation = _isNeedDeviceOrientation;
        [actionSheet show];
    }else{
        KNActionSheet *actionSheet = [[KNActionSheet alloc] initWithCancelTitle:nil destructiveTitle:@"删除" otherTitleArr:@[@"保存图片",@"转发微博",@"赞"]  actionBlock:^(NSInteger buttonIndex) {
            // 让代理知道 是哪个按钮被点击了
            if([weakSelf.delegate respondsToSelector:@selector(photoBrowerRightOperationActionWithIndex:)]){
                [weakSelf.delegate photoBrowerRightOperationActionWithIndex:buttonIndex];
            }
            
            switch (buttonIndex) {
                case 0:{ // 删除图片
#pragma mark - 删除图片
                    // 0: 删除后 回调返回 相对 下标
                    if([weakSelf.delegate respondsToSelector:@selector(photoBrowerRightOperationDeleteImageSuccessWithRelativeIndex:)]){
                        [weakSelf.delegate photoBrowerRightOperationDeleteImageSuccessWithRelativeIndex:weakSelf.currentIndex];
                    }
                    
                    KNPhotoItems *items = _itemsArr[_currentIndex];
                    NSInteger index = [_tempArr indexOfObject:items];
                    // 1: 删除后 回调返回 绝对 下标
                    if([weakSelf.delegate respondsToSelector:@selector(photoBrowerRightOperationDeleteImageSuccessWithAbsoluteIndex:)]){
                        [weakSelf.delegate photoBrowerRightOperationDeleteImageSuccessWithAbsoluteIndex:index];
                    }
                    
                    [weakSelf deleteImageIBAction];
                }
                    break;
                case 1:{ // 下载图片
#pragma mark - 下载图片 : 如果没有权限 :  弹出框 , dismiss
                    
                    KNPhotoItems *items = weakSelf.itemsArr[weakSelf.currentIndex];
                    if(items.url){ // 如果是网络图片
                        SDWebImageManager *mgr = [SDWebImageManager sharedManager];
                        
                        [mgr diskImageExistsForURL:[NSURL URLWithString:items.url] completion:^(BOOL isInCache) {
                            if(!isInCache){
                                [[KNToast shareToast] initWithText:PhotoSaveImageFailureReason];
                                return ;
                            }else{
                                
                                __weak typeof(weakSelf) weakS = weakSelf;
                                [[mgr imageCache] queryCacheOperationForKey:items.url done:^(UIImage * _Nullable image, NSData * _Nullable data, SDImageCacheType cacheType) {
                                    if([image isGIF]){
                                        [weakS savePhotoToLocation:data]; // 将 gif 图片存入本地
                                    }else{
                                        UIImage *image = [[mgr imageCache] imageFromDiskCacheForKey:items.url];
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            UIImageWriteToSavedPhotosAlbum(image, weakSelf, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
                                        });
                                    }
                                }];
                            }
                        }];
                    }else{ // 如果是本地图片
                        UIImageView *imageView = [weakSelf tempViewFromSourceViewWithCurrentIndex:_currentIndex];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            UIImageWriteToSavedPhotosAlbum(imageView.image, weakSelf, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
                        });
                    }
                    if([weakSelf isAuthPhoto] == false){
                        [weakSelf dismiss];
                        return ;
                    }
                }
                    /**
                     *  剩下的需要自己去实现
                     */
                default:
                    break;
            }
        }];
        actionSheet.isNeedDeviceOrientation = _isNeedDeviceOrientation;
        [actionSheet show];
    }
}

/* 将动图 存入 本地 : gif*/
- (void)savePhotoToLocation:(NSData *)photoData{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    NSDictionary *metadata = @{@"UTI":(__bridge NSString *)kUTTypeGIF};
    [library writeImageDataToSavedPhotosAlbum:photoData metadata:metadata completionBlock:^(NSURL *assetURL, NSError *error) {
        if(!error){
            [[KNToast shareToast] initWithText:PhotoSaveImageSuccessMessage duration:PhotoSaveImageMessageTime];
        }else{
            [[KNToast shareToast] initWithText:PhotoSaveImageFailureMessage duration:PhotoSaveImageMessageTime];
        }
    }] ;
}

/**
 是否有相册权限
 
 @return 是否有
 */
- (BOOL)isAuthPhoto{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted) { // 此应用程序没有被授权访问的照片数据。可能是家长控制权限。
        return false;
    } else if (status == PHAuthorizationStatusDenied) { // 用户拒绝访问相册
        return false;
    } else if (status == PHAuthorizationStatusAuthorized) { // 用户允许访问相册
        return true;
    } else if (status == PHAuthorizationStatusNotDetermined) { // 用户还没有做出选择
        return false;
    }
    return false;
}

- (void)deleteImageIBAction{
    NSMutableArray *tempArr = [NSMutableArray arrayWithArray:_itemsArr];
    [tempArr removeObjectAtIndex:_currentIndex];
    _itemsArr = [tempArr copy];
    [_collectionView reloadData];
    
    if(_itemsArr.count == 0){
        [_numView setCurrentNum:_currentIndex totalNum:_itemsArr.count];
        [_collectionView setHidden:YES];
        [_operationBtn   setHidden:YES];
        [_pageControl    setHidden:YES];
        [_numView        setHidden:YES];
        [self removeFromSuperview];
    }else{
        [_numView setCurrentNum:(_currentIndex + 1) totalNum:_itemsArr.count];
    }
}

#pragma mark - 将相片存入相册, 只回调这个方法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    __weak typeof(self) weakSelf = self;
    
    if(!error){
        [[KNToast shareToast] initWithText:PhotoSaveImageSuccessMessage duration:PhotoSaveImageMessageTime];
    }else{
        [[KNToast shareToast] initWithText:PhotoSaveImageFailureMessage duration:PhotoSaveImageMessageTime];
    }
    
    if([weakSelf.delegate respondsToSelector:@selector(photoBrowerWriteToSavedPhotosAlbumStatus:)]){
        [weakSelf.delegate photoBrowerWriteToSavedPhotosAlbumStatus:error?NO:YES];
    }
}

#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _itemsArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    __weak typeof(self) weakSelf = self;
    KNPhotoBrowerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    KNPhotoItems *items = _itemsArr[indexPath.row];
    NSString *url = items.url;
    
    UIImageView *tempView = [weakSelf tempViewFromSourceViewWithCurrentIndex:indexPath.row];
    
    [cell sd_ImageWithUrl:url placeHolder:tempView.image?tempView.image:nil];
    
    cell.singleTap = ^(){
        [weakSelf dismiss];
    };
    
    cell.longPress = ^(){
        [weakSelf longPressIBAction];
    };
    
    _collectionViewCell = cell;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    [cell prepareForReuse];
}

/**
 长按 按钮的点击
 */
- (void)longPressIBAction{
    if(!_isNeedPictureLongPress) return;
    [self operationBtnIBAction];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat scrollViewW = scrollView.frame.size.width;
    
    if(_isFirstShow == false){
        _currentIndex = scrollView.contentOffset.x / (ScreenWidth + PhotoBrowerMargin);
    }else{
        if(PhotoOrientationLandscapeIsPortrait || PhotoOrientationLandscapeIsPortraitUpsideDown){
            _currentIndex = scrollView.contentOffset.x / (ScreenWidth + PhotoBrowerMargin);
        }else{
            _currentIndex = scrollView.contentOffset.x / (ScreenHeight + PhotoBrowerMargin);
            scrollViewW = ScreenHeight;
        }
    }
    
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

#pragma mark - 移到父控件上
- (void)willMoveToSuperview:(UIView *)newSuperview{
    if(!newSuperview) return;
    [self initializeCollectionView];
    [self initializePageView];
    [self initializePageControl];
    [self initializeOperationView];
}

#pragma mark - 展现
- (void)present{
    if([self imageArrayIsEmpty:_itemsArr]){
        return;
    }
    
    if(![self imageArrayIsEmpty:_dataSourceUrlArr]){
        NSArray *arr = [_dataSourceUrlArr subarrayWithRange:NSMakeRange(_itemsArr.count, _dataSourceUrlArr.count -_itemsArr.count)];
        NSMutableArray *Arrs = [NSMutableArray arrayWithArray:_itemsArr];
        [Arrs addObjectsFromArray:arr];
        _itemsArr = [Arrs copy];
    }
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [self setFrame:window.bounds];
    self.center = window.center;
    [window addSubview:self];
}

#pragma mark - 消失
- (void)dismiss{
    // 让 代理 知道 PhotoBrower 即将 消失
    if([self.delegate respondsToSelector:@selector(photoBrowerWillDismiss)]){
        [self.delegate photoBrowerWillDismiss];
    }
    
    UIImageView *tempView = [[UIImageView alloc] init];
    SDWebImageManager *mgr = [SDWebImageManager sharedManager];
    
    KNPhotoItems *items = _itemsArr[_currentIndex];
    tempView.contentMode = items.sourceView.contentMode;
    tempView.layer.cornerRadius = 0.001;
    tempView.clipsToBounds = YES;
    
    [mgr diskImageExistsForURL:[NSURL URLWithString:items.url] completion:^(BOOL isInCache) {
        if(isInCache){
            if([[[[items.url lastPathComponent] pathExtension] lowercaseString] isEqualToString:@"gif"]){ // gif 图片
                NSData *data = UIImageJPEGRepresentation([[mgr imageCache] imageFromDiskCacheForKey:items.url], 1.f);
                tempView.image = [self imageFromGifFirstImage:data]; // 获取图片的第一帧
            }else{ // 普通图片
                tempView.image = [[mgr imageCache] imageFromCacheForKey:items.url];
            }
        }else{
            UIImage *image = [[self tempViewFromSourceViewWithCurrentIndex:_currentIndex] image];
            if(image){
                [tempView setImage:image];
            }else{
                [tempView setImage:items.sourceImage];
            }
        }
        if(!tempView.image){
            [tempView setImage:[self createImageWithUIColor:PhotoShowPlaceHolderImageColor]];
        }
        
        [_collectionView setHidden:YES];
        [_operationBtn   setHidden:YES];
        [_pageControl    setHidden:YES];
        [_numView        setHidden:YES];
        
        _tempArr = nil;
        _itemsArr = nil;
        
        UIView *sourceView;
        if([_sourceViewForCellReusable isKindOfClass:[UICollectionView class]]){
            sourceView = [(UICollectionView *)_sourceViewForCellReusable cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0]];
        }else{
            sourceView = items.sourceView;
        }
        
        // 原始控件的 图片
        NSArray *sourceArr = [self removeSourceViewImage:sourceView];
        
        CGRect rect = [sourceView convertRect:[sourceView bounds] toView:self];
        
        if(rect.origin.y > ScreenHeight ||
           rect.origin.y <= - rect.size.height ||
           rect.origin.x > ScreenWidth ||
           rect.origin.x <= -rect.size.width
           ){
            
            if(![self imageArrayIsEmpty:sourceArr]){
                if([sourceArr lastObject]){
                    if([sourceView isKindOfClass:[UIButton class]]){
                        NSString *isCurrentBack = objc_getAssociatedObject(self, &KNBtnCurrentImageKey);
                        if([isCurrentBack isEqualToString:@"1"]){
                            [(UIButton *)sourceView setBackgroundImage:[sourceArr lastObject] forState:UIControlStateNormal];
                        }else{
                            [(UIButton *)sourceView setImage:[sourceArr lastObject] forState:UIControlStateNormal];
                        }
                    }else{
                        [(UIImageView *)[sourceArr firstObject] setImage:[sourceArr lastObject]];
                    }
                }
            }
            
            
            [UIView animateWithDuration:PhotoBrowerBrowerTime delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [tempView setAlpha:0.f];
                [self setBackgroundColor:[UIColor clearColor]];
            } completion:^(BOOL finished) {
                [tempView removeFromSuperview];
                [UIView animateWithDuration:0.15 animations:^{
                    [tempView setAlpha:0.f];
                } completion:^(BOOL finished) {
                    [self removeFromSuperview];
                }];
            }];
        }else{
            
            CGFloat width  = tempView.image.size.width;
            CGFloat height = tempView.image.size.height;
            
            CGSize tempRectSize = (CGSize){ScreenWidth,(height * ScreenWidth / width) > ScreenHeight ? ScreenHeight:(height * ScreenWidth / width)};
            
            [tempView setBounds:(CGRect){CGPointZero,{tempRectSize.width,tempRectSize.height}}];
            [tempView setCenter:[self center]];
            [self addSubview:tempView];
            
            [UIView animateWithDuration:PhotoBrowerBrowerTime delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [tempView setFrame:rect];
                [self setBackgroundColor:[UIColor clearColor]];
            } completion:^(BOOL finished) {
                
                if(![self imageArrayIsEmpty:sourceArr]){
                    if([sourceArr lastObject]){
                        if([sourceView isKindOfClass:[UIButton class]]){
                            NSString *isCurrentBack = objc_getAssociatedObject(self, &KNBtnCurrentImageKey);
                            if([isCurrentBack isEqualToString:@"1"]){
                                [(UIButton *)sourceView setBackgroundImage:[sourceArr lastObject] forState:UIControlStateNormal];
                            }else{
                                [(UIButton *)sourceView setImage:[sourceArr lastObject] forState:UIControlStateNormal];
                            }
                        }else{
                            [(UIImageView *)[sourceArr firstObject] setImage:[sourceArr lastObject]];
                        }
                    }
                }
                
                [UIView animateWithDuration:0.15 animations:^{
                    [tempView setAlpha:0.f];
                } completion:^(BOOL finished) {
                    [self removeFromSuperview];
                }];
            }];
        }
    }];
}

#pragma mark - 展现的时候 动画
- (void)photoBrowerWillShowWithAnimated{
    // 0.初始化绝对数据源
    _tempArr = [NSArray arrayWithArray:_itemsArr];
    
    // 1.判断用户 点击了的控件是 控制器中的第几个图片. 在这里设置 collectionView的偏移量
    [_collectionView setContentOffset:(CGPoint){_currentIndex * (self.width + PhotoBrowerMargin),0} animated:NO];
    
    // 2. 可能考虑到 self.sourceView上面放着的是: 'button' ,所以这里用 UIView去接收
    KNPhotoItems *items = _itemsArr[_currentIndex];
    // 将 sourView的frame 转到 self上, 获取到 frame
    
    UIView *sourceView;
    if([_sourceViewForCellReusable isKindOfClass:[UICollectionView class]]){
        sourceView = [(UICollectionView *)_sourceViewForCellReusable cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0]];
    }else{
        sourceView = items.sourceView;
    }
    
    CGRect rect = [sourceView convertRect:[sourceView bounds] toView:self];
    
    UIImageView *tempView = [self tempViewFromSourceViewWithCurrentIndex:_currentIndex];
    
    [tempView setFrame:rect];
    [tempView setContentMode:sourceView.contentMode];
    tempView.layer.cornerRadius = 0.001;
    tempView.clipsToBounds = YES;
    [self insertSubview:tempView atIndex:0];
    
    CGSize tempRectSize;
    
    CGFloat width = tempView.image.size.width;
    CGFloat height = tempView.image.size.height;
    
    tempRectSize = (CGSize){ScreenWidth,(height * ScreenWidth / width) > ScreenHeight ? ScreenHeight:(height * ScreenWidth / width)};
    
    [_collectionView setHidden:YES];
    
    [UIView animateWithDuration:PhotoBrowerBrowerTime delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [tempView setCenter:[self center]];
        [tempView setBounds:(CGRect){CGPointZero,tempRectSize}];
    } completion:^(BOOL finished) {
        _isFirstShow = YES;
        [_collectionView setHidden:NO];
        
        [UIView animateWithDuration:0.15 animations:^{
            [tempView setAlpha:0.f];
            
        } completion:^(BOOL finished) {
            [tempView removeFromSuperview];
        }];
        _page = _currentIndex;
        [self deviceDidOrientation];
    }];
}

#pragma mark - 将原始控件上面 这张图片返回 ,再做移除
- (NSArray *)removeSourceViewImage:(UIView *)sourceView{
    
    if([sourceView isKindOfClass:[UIImageView class]]){
        UIImageView *imageView = (UIImageView *)sourceView;
        UIImage *image = [imageView image];
        if(!image){
            image = [self createImageWithUIColor:PhotoShowPlaceHolderImageColor];
        }
        [imageView setImage:nil];
        return @[(UIImageView *)sourceView,image];
    }
    
    if([sourceView isKindOfClass:[UIButton class]]){
        UIButton *btn = (UIButton *)sourceView;
        UIImage *image = [btn currentBackgroundImage]?[btn currentBackgroundImage]:[btn currentImage];
        if(!image){
            image = [self createImageWithUIColor:PhotoShowPlaceHolderImageColor];
        }
        [btn setBackgroundImage:nil forState:btn.state];
        [btn setImage:nil forState:btn.state];
        return @[(UIButton *)sourceView,image];
    }
    
    if([self imageArrayIsEmpty:_dataSourceUrlArr]){
        return nil;
    }else{
        if([_sourceViewForCellReusable isKindOfClass:[UICollectionView class]]){
            UICollectionViewCell *cell = [(UICollectionView *)_sourceViewForCellReusable cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0]];
            if(cell){
                UIImage *image = [(UIImageView *)cell.contentView.subviews[0] image];
                if(!image){
                    image = [self createImageWithUIColor:PhotoShowPlaceHolderImageColor];
                }
                [(UIImageView *)cell.contentView.subviews[0] setImage:nil];
                return @[(UIImageView *)cell.contentView.subviews[0],image];;
            }else{
                return nil;
            }
        }
    }
    
    return nil;
}

#pragma mark - 获取到 GIF图片的第一帧
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

static char KNBtnCurrentImageKey;
#pragma mark 私有方法 : 将子控件上的控件 转成 ImageView
- (UIImageView *)tempViewFromSourceViewWithCurrentIndex:(NSInteger)currentIndex{
    // 生成临时的一个 imageView 去做 动画
    UIImageView *tempView = [[UIImageView alloc] init];
    KNPhotoItems *items = _itemsArr[currentIndex];
    
    if([items.sourceView isKindOfClass:[UIImageView class]]){
        UIImageView *imgV = (UIImageView *)items.sourceView;
        [tempView setImage:[imgV image]];
    }
    
    if([items.sourceView isKindOfClass:[UIButton class]]){
        UIButton *btn = (UIButton *)items.sourceView;
        [tempView setImage:[btn currentBackgroundImage]?[btn currentBackgroundImage]:[btn currentImage]];
        
        if([btn currentBackgroundImage]){
            objc_setAssociatedObject(self, &KNBtnCurrentImageKey, @"1", OBJC_ASSOCIATION_COPY_NONATOMIC);
        }else{
            objc_setAssociatedObject(self, &KNBtnCurrentImageKey, @"0", OBJC_ASSOCIATION_COPY_NONATOMIC);
        }
    }
    
    if([self imageArrayIsEmpty:_dataSourceUrlArr]){
        if(!tempView.image){
            [tempView setImage:[self createImageWithUIColor:PhotoShowPlaceHolderImageColor]];
        }
    }else{
        if([_sourceViewForCellReusable isKindOfClass:[UICollectionView class]]){
            UICollectionViewCell *cell = [(UICollectionView *)_sourceViewForCellReusable cellForItemAtIndexPath:[NSIndexPath indexPathForRow:currentIndex inSection:0]];
            tempView.image = [(UIImageView *)cell.contentView.subviews[0] image];
        }
        
        if(!tempView.image){
            if(items.sourceImage && !items.url){
                tempView.image = items.sourceImage;
            }else{
                tempView.image = nil;
            }
        }
    }
    
    return tempView;
}

// 判断 imageUrl数组是否为空
- (BOOL)imageArrayIsEmpty:(NSArray *)array{
    if(array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0){
        return YES;
    }else{
        return NO;
    }
}

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

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if(!_isFirstShow){
        [self photoBrowerWillShowWithAnimated];
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"PhotoBrower dealloc");
}

@end

@implementation KNPhotoItems

@end

