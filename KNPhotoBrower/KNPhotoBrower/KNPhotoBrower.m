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

#import "KNActionSheet.h"

@interface KNPhotoBrower()<UICollectionViewDataSource,UICollectionViewDelegate>{
    KNPhotoBrowerCell     *_collectionViewCell;
    KNPhotoBrowerNumView  *_numView;
    UICollectionView      *_collectionView;
    UIButton              *_operationBtn;// 操作按钮
    UIPageControl         *_pageControl;// UIPageControl
    BOOL                   _isFirstShow;// 是否是第一次 展示
    CGFloat                _contentOffsetX; // 偏移量
    NSInteger              _page; // 页数
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
    
    _isNeedPageNumView = YES;
    _isNeedRightTopBtn = YES;
    _isNeedPageControl = NO;
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
    
    // 2.create collectionView
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:bounds collectionViewLayout:layout];
    
    [collectionView setBackgroundColor:[UIColor clearColor]];
    [collectionView setPagingEnabled:YES];
    [collectionView setBounces:YES]; // 设置 collectionView的 弹簧效果,这样拉最后一张图时会有拉出来效果,再反弹回去
    
    [collectionView setDataSource:self];
    [collectionView setDelegate:self];
    
    [collectionView setShowsHorizontalScrollIndicator:NO];
    [collectionView setShowsVerticalScrollIndicator:NO];
    [collectionView registerClass:[KNPhotoBrowerCell class] forCellWithReuseIdentifier:ID];
    _collectionView = collectionView;
    
    [self addSubview:collectionView];
}

#pragma mark - 初始化 pageView
- (void)initializePageView{
    KNPhotoBrowerNumView *numView = [[KNPhotoBrowerNumView alloc] init];
    [numView setFrame:(CGRect){{0,25},{ScreenWidth,25}}];
    [numView setCurrentNum:(_currentIndex + 1) totalNum:_imageArr.count];
    _page = [numView currentNum];
    [numView setHidden:!_isNeedPageNumView];
    
#warning 无论 _isNeedPageNumView 如何设置, 只要imageArr 的个数 == 1, 则隐藏
    if(_imageArr.count == 1){
        [numView setHidden:YES];
    }
    
    _numView = numView;
    [self addSubview:numView];
}

#pragma mark - 初始化 UIPageControl
- (void)initializePageControl{
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    [pageControl setCurrentPage:_currentIndex];
    [pageControl setNumberOfPages:_imageArr.count];
    [pageControl setFrame:(CGRect){{0,ScreenHeight - 50},{ScreenWidth,30}}];
    [pageControl setHidden:!_isNeedPageControl];
    
#warning 无论 _isNeedPageControl 如何设置, 只要imageArr 的个数 == 1, 则隐藏
    if(_imageArr.count == 1){
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
    [operationBtn setFrame:(CGRect){{ScreenWidth - 35 - 15,25},{35,20}}];
    [operationBtn addTarget:self action:@selector(operationBtnIBAction) forControlEvents:UIControlEventTouchUpInside];
    [operationBtn setHidden:!_isNeedRightTopBtn];
    _operationBtn = operationBtn;
    [self addSubview:operationBtn];
}

#pragma mark - 右上角 按钮的点击
- (void)operationBtnIBAction{
    __weak typeof(self) weakSelf = self;
    
    KNActionSheet *actionSheet = [[KNActionSheet alloc] initWithCancelBtnTitle:nil destructiveButtonTitle:nil otherBtnTitlesArr:@[@"保存图片",@"转发微博",@"赞"] actionBlock:^(NSInteger buttonIndex) {
        
        // 让代理知道 是哪个按钮被点击了
        if([weakSelf.delegate respondsToSelector:@selector(photoBrowerRightOperationActionWithIndex:)]){
            [weakSelf.delegate photoBrowerRightOperationActionWithIndex:buttonIndex];
        }
        
        switch (buttonIndex) {
            case 0:{
                SDWebImageManager *mgr = [SDWebImageManager sharedManager];
                if(![mgr diskImageExistsForURL:[NSURL URLWithString:_imageArr[_currentIndex]]]){
                    [[KNToast shareToast] initWithText:@"图片需要下载完成"];
                    return ;
                }else{
                    UIImage *image = [[mgr imageCache] imageFromDiskCacheForKey:_imageArr[_currentIndex]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
                    });
                }
            }
            default:
                break;
        }
    }];
    [actionSheet show];
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
    return _imageArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;
    KNPhotoBrowerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    NSString *url = _imageArr[indexPath.row];
    UIImageView *tempView = [weakSelf tempViewFromSourceViewWithCurrentIndex:indexPath.row];
    
    [cell sd_ImageWithUrl:url placeHolder:tempView.image];
    
    cell.singleTap = ^(){
        [weakSelf dismiss];
    };
    
    _collectionViewCell = cell;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    _currentIndex = scrollView.contentOffset.x / (ScreenWidth + PhotoBrowerMargin);
    
    CGFloat scrollViewW = scrollView.frame.size.width;
    CGFloat x = scrollView.contentOffset.x;
    NSInteger page = (x + scrollViewW / 2) / scrollViewW;
    
    if(_page != page){
        _page = page;
        if(_page + 1 <= _imageArr.count){
            [_numView setCurrentNum:_page + 1];
            [_pageControl setCurrentPage:_page];
        }
    }
}

#pragma mark - 移到父控件上
- (void)willMoveToSuperview:(UIView *)newSuperview{
    [self initializeCollectionView];
    [self initializePageView];
    [self initializePageControl];
    [self initializeOperationView];
}

#pragma mark - 展现
- (void)present{
    if([self imageArrayIsEmpty]){
        return;
    }
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [self setFrame:window.bounds];
    [window addSubview:self];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

#pragma mark - 消失
- (void)dismiss{
    
    // 让 代理 知道 PhotoBrower 即将 消失
    if([self.delegate respondsToSelector:@selector(photoBrowerWillDismiss)]){
        [self.delegate photoBrowerWillDismiss];
    }
    
    UIImageView *tempView = [[UIImageView alloc] init];
    SDWebImageManager *mgr = [SDWebImageManager sharedManager];
    if([mgr diskImageExistsForURL:[NSURL URLWithString:_imageArr[_currentIndex]]]){
        tempView.image = [[mgr imageCache] imageFromDiskCacheForKey:_imageArr[_currentIndex]];
    }else{
        tempView.image = [[self tempViewFromSourceViewWithCurrentIndex:_currentIndex] image];
    }
    
    if(!tempView.image){
        tempView.image = [UIImage imageNamed:@"KNPhotoBrower.bundle/defaultPlaceHolder"];
    }
    
    [_collectionView setHidden:YES];
    [_operationBtn   setHidden:YES];
    [_pageControl    setHidden:YES];
    [_numView        setHidden:YES];
    
    UIView *sourceView = _sourceView.subviews[_currentIndex];
    CGRect rect = [_sourceView convertRect:[sourceView frame] toView:self];
    
    CGFloat width  = tempView.image.size.width;
    CGFloat height = tempView.image.size.height;
    
    CGSize tempRectSize = (CGSize){ScreenWidth,(height * ScreenWidth / width) > ScreenHeight ? ScreenHeight:(height * ScreenWidth / width)};
    
    [tempView setBounds:(CGRect){CGPointZero,{tempRectSize.width,tempRectSize.height}}];
    [tempView setCenter:[self center]];
    [self addSubview:tempView];
    
    [UIView animateWithDuration:PhotoBrowerBrowerTime delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [tempView setFrame:rect];
        [self setBackgroundColor:[UIColor clearColor]];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - 展现的时候 动画
- (void)photoBrowerWillShowWithAnimated{
    // 1.判断用户 点击了的控件是 控制器中的第几个图片. 在这里设置 collectionView的偏移量
    [_collectionView setContentOffset:(CGPoint){_currentIndex * (self.width + PhotoBrowerMargin),0} animated:NO];
    _contentOffsetX = _collectionView.contentOffset.x;
    // 2. 可能考虑到 self.sourceView上面放着的是: 'button' ,所以这里用 UIView去接收
    UIView *sourceView = _sourceView.subviews[_currentIndex];
    
    // 将 sourView的frame 转到 self上, 获取到 frame
    CGRect rect = [_sourceView convertRect:[sourceView frame] toView:self];
    
    UIImageView *tempView = [self tempViewFromSourceViewWithCurrentIndex:_currentIndex];
    
    [tempView setFrame:rect];
    [tempView setContentMode:sourceView.contentMode];
    [self addSubview:tempView];
    
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
        [tempView removeFromSuperview];
        [_collectionView setHidden:NO];
    }];
}

#pragma mark 私有方法 : 将子控件上的控件 转成 ImageView
- (UIImageView *)tempViewFromSourceViewWithCurrentIndex:(NSInteger)currentIndex{
    // 生成临时的一个 imageView 去做 动画
    UIImageView *tempView = [[UIImageView alloc] init];
    if([_sourceView.subviews[currentIndex] isKindOfClass:[UIImageView class]]){
        UIImageView *imgV = (UIImageView *)_sourceView.subviews[currentIndex];
        [tempView setImage:[imgV image]];
    }
    
    if([_sourceView.subviews[currentIndex] isKindOfClass:[UIButton class]]){
        UIButton *btn = (UIButton *)_sourceView.subviews[currentIndex];
        [tempView setImage:[btn currentBackgroundImage]?[btn currentBackgroundImage]:[btn currentImage]];
    }
    
    if(!tempView.image){
        [tempView setImage:[UIImage imageNamed:@"KNPhotoBrower.bundle/defaultPlaceHolder"]];
    }
    return tempView;
}

// 判断 imageUrl数组是否为空
- (BOOL)imageArrayIsEmpty{
    if(_imageArr == nil || [_imageArr isKindOfClass:[NSNull class]] || _imageArr.count == 0){
        return YES;
    }else{
        return NO;
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if(!_isFirstShow){
        [self photoBrowerWillShowWithAnimated];
    }
}

@end
