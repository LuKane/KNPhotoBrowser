//
//  ScrollViewLocController.m
//  KNPhotoBrower
//
//  Created by LuKane on 2016/10/18.
//  Copyright © 2016年 LuKane. All rights reserved.
//

#import "ScrollViewLocController.h"
#import "KNPhotoBrower.h"

@interface ScrollViewLocController ()<UIScrollViewDelegate,KNPhotoBrowerDelegate>

@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, strong) NSMutableArray *itemsArr;

@end

@implementation ScrollViewLocController

- (instancetype)init{
    if (self = [super init]) {
        NSArray *urlArr = @[
                            [UIImage imageNamed:@"1.jpg"],
                            [UIImage imageNamed:@"2.jpg"],
                            [UIImage imageNamed:@"3.jpg"],
                            [UIImage imageNamed:@"4.jpg"],
                            [UIImage imageNamed:@"5.jpg"],
                            [UIImage imageNamed:@"6.jpg"],
                            [UIImage imageNamed:@"7.jpg"],
                            [UIImage imageNamed:@"8.jpg"],
                            [UIImage imageNamed:@"9.jpg"],
                            [UIImage imageNamed:@"10.jpg"],
                            [UIImage imageNamed:@"11.jpg"],
                            [UIImage imageNamed:@"12.jpg"],
                            [UIImage imageNamed:@"13.jpg"],
                            [UIImage imageNamed:@"14.jpg"],
                            ];
        self.dataArr = [urlArr mutableCopy];
    }
    return self;
}

- (NSMutableArray *)itemsArr{
    if (!_itemsArr) {
        _itemsArr = [NSMutableArray array];
    }
    return _itemsArr;
}

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"ScrollViewLoc";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setupScrollView];
}

- (void)setupScrollView{
    
    CGFloat y = 10;
    CGFloat width = 180;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, width + y * 2)];
    [scrollView setDelegate:self];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    [scrollView setShowsVerticalScrollIndicator:NO];
    [scrollView setContentSize:(CGSize){(width + y * 2) * self.dataArr.count,0}];
    [scrollView setBackgroundColor:[UIColor orangeColor]];
    [self.view addSubview:scrollView];
    
    for (NSInteger i = 0; i < self.dataArr.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView setUserInteractionEnabled:YES];
        [imageView setBackgroundColor:[UIColor grayColor]];
        [imageView setTag:i];
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewIBAction:)]];
        CGFloat x = (y * 2 + width) * i + 10;
        imageView.image = self.dataArr[i];
        imageView.frame = CGRectMake(x, y, width, width);
        [scrollView addSubview:imageView];
        
        KNPhotoItems *items = [[KNPhotoItems alloc] init];
        items.sourceView = imageView;
        [self.itemsArr addObject:items];
    }
}

- (void)imageViewIBAction:(UITapGestureRecognizer *)tap{
    KNPhotoBrower *photoBrower = [[KNPhotoBrower alloc] init];
    photoBrower.itemsArr = [_itemsArr copy];
    photoBrower.currentIndex = tap.view.tag;
    [photoBrower setDelegate:self];
    [photoBrower present];
}


/*************************** == Delegate == ************************/
/* PhotoBrower 即将消失 */
- (void)photoBrowerWillDismiss{
    NSLog(@"Will Dismiss");
}

/* PhotoBrower 右上角按钮的点击 */
- (void)photoBrowerRightOperationActionWithIndex:(NSInteger)index{
    NSLog(@"operation:%zd",index);
}

/**
 *  删除当前图片
 *
 *  @param index 相对 下标
 */
- (void)photoBrowerRightOperationDeleteImageSuccessWithRelativeIndex:(NSInteger)index{
    NSLog(@"delete-Relative:%zd",index);
}

/**
 *  删除当前图片
 *
 *  @param index 绝对 下标
 */
- (void)photoBrowerRightOperationDeleteImageSuccessWithAbsoluteIndex:(NSInteger)index{
    NSLog(@"delete-Absolute:%zd",index);
}

/* PhotoBrower 保存图片是否成功 */
- (void)photoBrowerWriteToSavedPhotosAlbumStatus:(BOOL)success{
    NSLog(@"saveImage:%zd",success);
}
@end
