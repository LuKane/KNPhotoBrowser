//
//  CollectionViewLocController.m
//  KNPhotoBrower
//
//  Created by LuKane on 2016/10/18.
//  Copyright © 2016年 LuKane. All rights reserved.
//

#import "CollectionViewLocController.h"

#import "KNWaterflowLayout.h"
#import "CollectionViewCell.h"
#import "CollectionViewModel.h"

#import "KNPhotoBrower.h"

@interface CollectionViewLocController ()<UICollectionViewDataSource, UICollectionViewDelegate,KNWaterflowLayoutDelegate,KNPhotoBrowerDelegate>

@property (nonatomic, weak  ) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, strong) NSMutableArray *itemsArr;
@property (nonatomic, strong) NSMutableArray *tempArr;

// 存放所有的 图片的信息
@property (nonatomic, strong) NSMutableArray *collectionPrepareArr;

@end

NSString *const ID1 = @"collectionLocViewID";

@implementation CollectionViewLocController

- (instancetype)init{
    if (self = [super init]) {
        {
            CollectionViewModel *model = [[CollectionViewModel alloc] init];
            model.img = [UIImage imageNamed:@"1.jpg"];
            model.width = @"120";
            model.height = @"90";
            [self.dataArr addObject:model];
            
            KNPhotoItems *items = [[KNPhotoItems alloc] init];
            items.sourceImage = [UIImage imageNamed:@"1.jpg"];
            items.sourceView = nil;
            [self.collectionPrepareArr addObject:items];
        }
        
        {
            CollectionViewModel *model = [[CollectionViewModel alloc] init];
            model.img = [UIImage imageNamed:@"2.jpg"];
            model.width = @"120";
            model.height = @"75";
            [self.dataArr addObject:model];
            
            KNPhotoItems *items = [[KNPhotoItems alloc] init];
            items.sourceImage = [UIImage imageNamed:@"2.jpg"];
            items.sourceView = nil;
            [self.collectionPrepareArr addObject:items];
        }
        
        {
            CollectionViewModel *model = [[CollectionViewModel alloc] init];
            model.img = [UIImage imageNamed:@"3.jpg"];
            model.width = @"120";
            model.height = @"75";
            [self.dataArr addObject:model];
            
            KNPhotoItems *items = [[KNPhotoItems alloc] init];
            items.sourceImage = [UIImage imageNamed:@"3.jpg"];
            items.sourceView = nil;
            [self.collectionPrepareArr addObject:items];
        }
        
        {
            CollectionViewModel *model = [[CollectionViewModel alloc] init];
            model.img = [UIImage imageNamed:@"4.jpg"];
            model.width = @"120";
            model.height = @"80";
            [self.dataArr addObject:model];
            
            KNPhotoItems *items = [[KNPhotoItems alloc] init];
            items.sourceImage = [UIImage imageNamed:@"4.jpg"];
            items.sourceView = nil;
            [self.collectionPrepareArr addObject:items];
        }
        
        {
            CollectionViewModel *model = [[CollectionViewModel alloc] init];
            model.img = [UIImage imageNamed:@"5.jpg"];
            model.width = @"120";
            model.height = @"80";
            [self.dataArr addObject:model];
            
            KNPhotoItems *items = [[KNPhotoItems alloc] init];
            items.sourceImage = [UIImage imageNamed:@"5.jpg"];
            items.sourceView = nil;
            [self.collectionPrepareArr addObject:items];
        }
        
        {
            CollectionViewModel *model = [[CollectionViewModel alloc] init];
            model.img = [UIImage imageNamed:@"6.jpg"];
            model.width = @"120";
            model.height = @"80";
            [self.dataArr addObject:model];
            
            KNPhotoItems *items = [[KNPhotoItems alloc] init];
            items.sourceImage = [UIImage imageNamed:@"6.jpg"];
            items.sourceView = nil;
            [self.collectionPrepareArr addObject:items];
        }
        
        {
            CollectionViewModel *model = [[CollectionViewModel alloc] init];
            model.img = [UIImage imageNamed:@"7.jpg"];
            model.width = @"120";
            model.height = @"80";
            [self.dataArr addObject:model];
            
            KNPhotoItems *items = [[KNPhotoItems alloc] init];
            items.sourceImage = [UIImage imageNamed:@"7.jpg"];
            items.sourceView = nil;
            [self.collectionPrepareArr addObject:items];
        }
        
        {
            CollectionViewModel *model = [[CollectionViewModel alloc] init];
            model.img = [UIImage imageNamed:@"8.jpg"];
            model.width = @"120";
            model.height = @"80";
            [self.dataArr addObject:model];
            
            KNPhotoItems *items = [[KNPhotoItems alloc] init];
            items.sourceImage = [UIImage imageNamed:@"8.jpg"];
            items.sourceView = nil;
            [self.collectionPrepareArr addObject:items];
        }
        {
            CollectionViewModel *model = [[CollectionViewModel alloc] init];
            model.img = [UIImage imageNamed:@"9.jpg"];
            model.width = @"83";
            model.height = @"119";
            [self.dataArr addObject:model];
            
            KNPhotoItems *items = [[KNPhotoItems alloc] init];
            items.sourceImage = [UIImage imageNamed:@"9.jpg"];
            items.sourceView = nil;
            [self.collectionPrepareArr addObject:items];
        }
        {
            CollectionViewModel *model = [[CollectionViewModel alloc] init];
            model.img = [UIImage imageNamed:@"10.jpg"];
            model.width = @"84";
            model.height = @"120";
            [self.dataArr addObject:model];
            
            KNPhotoItems *items = [[KNPhotoItems alloc] init];
            items.sourceImage = [UIImage imageNamed:@"10.jpg"];
            items.sourceView = nil;
            [self.collectionPrepareArr addObject:items];
        }
        {
            CollectionViewModel *model = [[CollectionViewModel alloc] init];
            model.img = [UIImage imageNamed:@"11.jpg"];
            model.width = @"83";
            model.height = @"119";
            [self.dataArr addObject:model];
            
            KNPhotoItems *items = [[KNPhotoItems alloc] init];
            items.sourceImage = [UIImage imageNamed:@"11.jpg"];
            items.sourceView = nil;
            [self.collectionPrepareArr addObject:items];
        }
        {
            CollectionViewModel *model = [[CollectionViewModel alloc] init];
            model.img = [UIImage imageNamed:@"12.jpg"];
            model.width = @"83";
            model.height = @"119";
            [self.dataArr addObject:model];
            
            KNPhotoItems *items = [[KNPhotoItems alloc] init];
            items.sourceImage = [UIImage imageNamed:@"12.jpg"];
            items.sourceView = nil;
            [self.collectionPrepareArr addObject:items];
        }
        {
            CollectionViewModel *model = [[CollectionViewModel alloc] init];
            model.img = [UIImage imageNamed:@"13.jpg"];
            model.width = @"83";
            model.height = @"119";
            [self.dataArr addObject:model];
            
            KNPhotoItems *items = [[KNPhotoItems alloc] init];
            items.sourceImage = [UIImage imageNamed:@"13.jpg"];
            items.sourceView = nil;
            [self.collectionPrepareArr addObject:items];
        }
        {
            CollectionViewModel *model = [[CollectionViewModel alloc] init];
            model.img = [UIImage imageNamed:@"14.jpg"];
            model.width = @"119";
            model.height = @"119";
            [self.dataArr addObject:model];
            
            KNPhotoItems *items = [[KNPhotoItems alloc] init];
            items.sourceImage = [UIImage imageNamed:@"14.jpg"];
            items.sourceView = nil;
            [self.collectionPrepareArr addObject:items];
        }
        
        {
            CollectionViewModel *model = [[CollectionViewModel alloc] init];
            model.img = [UIImage imageNamed:@"15.jpg"];
            model.width = @"120";
            model.height = @"77";
            [self.dataArr addObject:model];
            
            KNPhotoItems *items = [[KNPhotoItems alloc] init];
            items.sourceImage = [UIImage imageNamed:@"15.jpg"];
            items.sourceView = nil;
            [self.collectionPrepareArr addObject:items];
        }
        
        {
            CollectionViewModel *model = [[CollectionViewModel alloc] init];
            model.img = [UIImage imageNamed:@"16.jpg"];
            model.width = @"113";
            model.height = @"120";
            [self.dataArr addObject:model];
            
            KNPhotoItems *items = [[KNPhotoItems alloc] init];
            items.sourceImage = [UIImage imageNamed:@"16.jpg"];
            items.sourceView = nil;
            [self.collectionPrepareArr addObject:items];
        }
        
        {
            CollectionViewModel *model = [[CollectionViewModel alloc] init];
            model.img = [UIImage imageNamed:@"17.jpg"];
            model.width = @"120";
            model.height = @"120";
            [self.dataArr addObject:model];
            
            KNPhotoItems *items = [[KNPhotoItems alloc] init];
            items.sourceImage = [UIImage imageNamed:@"17.jpg"];
            items.sourceView = nil;
            [self.collectionPrepareArr addObject:items];
        }
        
        {
            CollectionViewModel *model = [[CollectionViewModel alloc] init];
            model.img = [UIImage imageNamed:@"18.jpg"];
            model.width = @"120";
            model.height = @"180";
            [self.dataArr addObject:model];
            
            KNPhotoItems *items = [[KNPhotoItems alloc] init];
            items.sourceImage = [UIImage imageNamed:@"18.jpg"];
            items.sourceView = nil;
            [self.collectionPrepareArr addObject:items];
        }
        
        {
            CollectionViewModel *model = [[CollectionViewModel alloc] init];
            model.img = [UIImage imageNamed:@"19.jpg"];
            model.width = @"120";
            model.height = @"80";
            [self.dataArr addObject:model];
            
            KNPhotoItems *items = [[KNPhotoItems alloc] init];
            items.sourceImage = [UIImage imageNamed:@"19.jpg"];
            items.sourceView = nil;
            [self.collectionPrepareArr addObject:items];
        }
        
        {
            CollectionViewModel *model = [[CollectionViewModel alloc] init];
            model.img = [UIImage imageNamed:@"20.jpg"];
            model.width = @"120";
            model.height = @"80";
            [self.dataArr addObject:model];
            
            KNPhotoItems *items = [[KNPhotoItems alloc] init];
            items.sourceImage = [UIImage imageNamed:@"20.jpg"];
            items.sourceView = nil;
            [self.collectionPrepareArr addObject:items];
        }
        
        {
            CollectionViewModel *model = [[CollectionViewModel alloc] init];
            model.img = [UIImage imageNamed:@"21.jpg"];
            model.width = @"120";
            model.height = @"68";
            [self.dataArr addObject:model];
            
            KNPhotoItems *items = [[KNPhotoItems alloc] init];
            items.sourceImage = [UIImage imageNamed:@"21.jpg"];
            items.sourceView = nil;
            [self.collectionPrepareArr addObject:items];
        }
    }
    return self;
}

- (NSMutableArray *)tempArr{
    if (!_tempArr) {
        _tempArr = [NSMutableArray array];
    }
    return _tempArr;
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

- (NSMutableArray *)collectionPrepareArr{
    if (!_collectionPrepareArr) {
        _collectionPrepareArr = [NSMutableArray array];
    }
    return _collectionPrepareArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"CollectionView(本地)";
    [self setupCollectionView];
}

- (void)setupCollectionView{
    KNWaterflowLayout *waterFlowLayout = [[KNWaterflowLayout alloc] init];
    [waterFlowLayout setDelegate:self];
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:waterFlowLayout];
    [collectionView setDelegate:self];
    [collectionView setDataSource:self];
    [collectionView setBackgroundColor:[UIColor orangeColor]];
    [collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:ID1];
    [self.view addSubview:collectionView];
    _collectionView = collectionView;
}

- (CGFloat)waterflowLayout:(KNWaterflowLayout *)waterflowLayout heightForItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth{
    CollectionViewModel *model = self.dataArr[indexPath.row];
    return [model.height floatValue] / [model.width floatValue] * itemWidth;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID1 forIndexPath:indexPath];
    CollectionViewModel *model = self.dataArr[indexPath.row];
    [cell.iconView setImage:model.img];
    
    // 设置 tag 值
    cell.iconView.tag = indexPath.row;
    
    // 添加 相片的点击事件
    [cell.iconView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewIBAction:)]];
    
    KNPhotoItems *items = [[KNPhotoItems alloc] init];
    items.sourceView = cell.iconView;
    
    if(![self.tempArr containsObject:model.img]){ // 如果临时数组中没有 这个 高清url,则增加
        [self.itemsArr addObject:items];
        [self.tempArr addObject:model.img];
    }
    return cell;
}

- (void)imageViewIBAction:(UITapGestureRecognizer *)tap{
    KNPhotoBrower *photoBrower = [[KNPhotoBrower alloc] init];
    [photoBrower setDelegate:self];
    [photoBrower setItemsArr:[self.itemsArr copy]];
    [photoBrower setCurrentIndex:tap.view.tag];
    
    /****************  为了 循环利用 而做出的 新的属性  *****************/
    
    [photoBrower setDataSourceUrlArr:[self.collectionPrepareArr copy]];
    [photoBrower setSourceViewForCellReusable:_collectionView];
    
    /****************  为了 循环利用 而做出的 新的属性  *****************/
    
    
    [photoBrower present];
}

#pragma mark - Delegate

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
