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
#import "SDWebImagePrefetcher.h"

#import "KNPhotoBrowerNumView.h"
#import "KNToast.h"
#import "KNPch.h"

#import "KNActionSheet.h"
#import <ImageIO/ImageIO.h>

@interface KNPhotoBrower()<UICollectionViewDataSource,UICollectionViewDelegate>{
    KNPhotoBrowerCell     *_collectionViewCell;
    KNPhotoBrowerNumView  *_numView;
    UICollectionView      *_collectionView;
    UIButton              *_operationBtn;// 操作按钮
    UIPageControl         *_pageControl;// UIPageControl
    BOOL                   _isFirstShow;// 是否是第一次 展示
    CGFloat                _contentOffsetX; // 偏移量
    NSInteger              _page; // 页数
    NSArray               *_tempArr; // 给 '绝对数据源'
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
    
    self.actionSheetArr = [NSMutableArray array];
    _isNeedPageNumView      = YES;
    _isNeedRightTopBtn      = YES;
    _isNeedPictureLongPress = YES;
    _isNeedPageControl      = NO;
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
    [collectionView setDecelerationRate:0];
    [collectionView registerClass:[KNPhotoBrowerCell class] forCellWithReuseIdentifier:ID];
    _collectionView = collectionView;
    
    [self addSubview:collectionView];
}

#pragma mark - 初始化 pageView
- (void)initializePageView{
    KNPhotoBrowerNumView *numView = [[KNPhotoBrowerNumView alloc] init];
    [numView setFrame:(CGRect){{0,25},{ScreenWidth,25}}];
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
    [operationBtn setFrame:(CGRect){{ScreenWidth - 35 - 15,25},{35,20}}];
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
#pragma mark - 下载图片
                    KNPhotoItems *items = weakSelf.itemsArr[weakSelf.currentIndex];
                    if(items.url){ // 如果是网络图片
                        SDWebImageManager *mgr = [SDWebImageManager sharedManager];
                        if(![mgr diskImageExistsForURL:[NSURL URLWithString:items.url]]){
                            [[KNToast shareToast] initWithText:PhotoSaveImageFailureReason];
                            return ;
                        }else{
                            UIImage *image = [[mgr imageCache] imageFromDiskCacheForKey:items.url];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
                            });
                        }
                    }else{ // 如果是本地图片
                        UIImageView *imageView = [self tempViewFromSourceViewWithCurrentIndex:_currentIndex];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            UIImageWriteToSavedPhotosAlbum(imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
                        });
                    }
                }
                /**
                 *  剩下的需要自己去实现
                 */
                default:
                    break;
            }
        }];
        [actionSheet show];
    }
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


- (void)longPressIBAction{
    if(!_isNeedPictureLongPress) return;
    [self operationBtnIBAction];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    _currentIndex = scrollView.contentOffset.x / (ScreenWidth + PhotoBrowerMargin);
    
    CGFloat scrollViewW = scrollView.frame.size.width;
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
    
    if([mgr diskImageExistsForURL:[NSURL URLWithString:items.url]]){
        if([[[[items.url lastPathComponent] pathExtension] lowercaseString] isEqualToString:@"gif"]){ // gif 图片
            NSData *data = UIImageJPEGRepresentation([[mgr imageCache] imageFromDiskCacheForKey:items.url], 1.f);
            tempView.image = [self imageFromGifFirstImage:data]; // 获取图片的第一帧
        }else{ // 普通图片
            tempView.image = [[mgr imageCache] imageFromDiskCacheForKey:items.url];
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
    
    CGRect rect = [sourceView convertRect:[sourceView bounds] toView:self];
    
    if(rect.origin.y > ScreenHeight ||
       rect.origin.y <= - rect.size.height ||
        rect.origin.x > ScreenWidth ||
       rect.origin.x <= -rect.size.width
       ){
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
            [UIView animateWithDuration:0.15 animations:^{
                [tempView setAlpha:0.f];
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
        }];
    }
}

#pragma mark - 展现的时候 动画
- (void)photoBrowerWillShowWithAnimated{
    // 0.初始化绝对数据源
    _tempArr = [NSArray arrayWithArray:_itemsArr];
    
    // 1.判断用户 点击了的控件是 控制器中的第几个图片. 在这里设置 collectionView的偏移量
    [_collectionView setContentOffset:(CGPoint){_currentIndex * (self.width + PhotoBrowerMargin),0} animated:NO];
    _contentOffsetX = _collectionView.contentOffset.x;
    
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
        
        [UIView animateWithDuration:0.15 animations:^{
            [tempView setAlpha:0.f];
        } completion:^(BOOL finished) {
            [tempView removeFromSuperview];
        }];
        [_collectionView setHidden:NO];
    }];
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
    
}

@end

@implementation KNPhotoItems

@end
