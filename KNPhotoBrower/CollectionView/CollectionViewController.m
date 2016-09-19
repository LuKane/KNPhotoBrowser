//
//  CollectionViewController.m
//  KNPhotoBrower
//
//  Created by LuKane on 16/9/18.
//  Copyright © 2016年 LuKane. All rights reserved.
//

#import "CollectionViewController.h"
#import "KNWaterflowLayout.h"
#import "CollectionViewCell.h"
#import "CollectionViewModel.h"

#import "KNPhotoBrower.h"

@interface CollectionViewController ()<UICollectionViewDataSource, UICollectionViewDelegate,KNWaterflowLayoutDelegate,KNPhotoBrowerDelegate>{
    BOOL     _ApplicationStatusIsHidden;
}

@property (nonatomic, weak  ) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, strong) NSMutableArray *itemsArr;
@property (nonatomic, strong) NSMutableArray *tempArr;
@property (nonatomic, strong) KNPhotoBrower *photoBrower;

@end

NSString *const ID = @"collectionViewID";

@implementation CollectionViewController

- (instancetype)init{
    if (self = [super init]) {
        {
            CollectionViewModel *model = [[CollectionViewModel alloc] init];
            model.url = @"http://ww4.sinaimg.cn/thumbnail/7f8c1087gw1e9g06pc68ug20ag05y4qq.gif";
            model.width = @"120";
            model.height = @"68";
            [self.dataArr addObject:model];
        }
        {
            CollectionViewModel *model = [[CollectionViewModel alloc] init];
            model.url = @"http://ww2.sinaimg.cn/thumbnail/642beb18gw1ep3629gfm0g206o050b2a.gif";
            model.width = @"120";
            model.height = @"90";
            [self.dataArr addObject:model];
        }
        {
            CollectionViewModel *model = [[CollectionViewModel alloc] init];
            model.url = @"http://ww2.sinaimg.cn/thumbnail/677febf5gw1erma104rhyj20k03dz16y.jpg";
            model.width = @"19";
            model.height = @"116";
            [self.dataArr addObject:model];
        }
        {
            CollectionViewModel *model = [[CollectionViewModel alloc] init];
            model.url = @"http://ww4.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr1d0vyj20pf0gytcj.jpg";
            model.width = @"120";
            model.height = @"80";
            [self.dataArr addObject:model];
        }
        {
            CollectionViewModel *model = [[CollectionViewModel alloc] init];
            model.url = @"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr1xydcj20gy0o9q6s.jpg";
            model.width = @"83";
            model.height = @"119";
            [self.dataArr addObject:model];
        }
        {
            CollectionViewModel *model = [[CollectionViewModel alloc] init];
            model.url = @"http://ww2.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr39ht9j20gy0o6q74.jpg";
            model.width = @"84";
            model.height = @"120";
            [self.dataArr addObject:model];
        }
        {
            CollectionViewModel *model = [[CollectionViewModel alloc] init];
            model.url = @"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr3xvtlj20gy0obadv.jpg";
            model.width = @"83";
            model.height = @"119";
            [self.dataArr addObject:model];
        }
        {
            CollectionViewModel *model = [[CollectionViewModel alloc] init];
            model.url = @"http://ww4.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr4nndfj20gy0o9q6i.jpg";
            model.width = @"83";
            model.height = @"119";
            [self.dataArr addObject:model];
        }
        {
            CollectionViewModel *model = [[CollectionViewModel alloc] init];
            model.url = @"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr57tn9j20gy0obn0f.jpg";
            model.width = @"83";
            model.height = @"119";
            [self.dataArr addObject:model];
        }
        {
            CollectionViewModel *model = [[CollectionViewModel alloc] init];
            model.url = @"http://ww2.sinaimg.cn/thumbnail/98719e4agw1e5j49zmf21j20c80c8mxi.jpg";
            model.width = @"119";
            model.height = @"119";
            [self.dataArr addObject:model];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"CollectionView";
    [self setupCollectionView];
}

- (void)setupCollectionView{
    KNWaterflowLayout *waterFlowLayout = [[KNWaterflowLayout alloc] init];
    [waterFlowLayout setDelegate:self];
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:waterFlowLayout];
    [collectionView setDelegate:self];
    [collectionView setDataSource:self];
    [collectionView setBackgroundColor:[UIColor orangeColor]];
    [collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:ID];
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
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    CollectionViewModel *model = self.dataArr[indexPath.row];
    cell.model = model;
    
    // 设置 tag 值
    cell.iconView.tag = indexPath.row;
    
    // 添加 相片的点击事件
    [cell.iconView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewIBAction:)]];
    
    // 将 url 替换成 高清url
    NSString *bmiddleUrl = [model.url stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
    
    // 如果 itemsArr 没有数据, 则添加第一个数据
    if(self.itemsArr.count == 0){
        KNPhotoItems *items = [[KNPhotoItems alloc] init];
        items.url = bmiddleUrl;
        items.sourceView = cell.iconView;
        [self.tempArr addObject:bmiddleUrl]; // 临时数组 也添加, 方便重复数据的剔除
        [self.itemsArr addObject:items];
    }else{
        
        KNPhotoItems *items = [[KNPhotoItems alloc] init];
        items.url = bmiddleUrl;
        items.sourceView = cell.iconView;
        
        if(![self.tempArr containsObject:bmiddleUrl]){ // 如果临时数组中没有 这个 高清url,则增加
            [self.itemsArr addObject:items];
            [self.tempArr addObject:bmiddleUrl];
        }
    }
    return cell;
}

- (void)imageViewIBAction:(UITapGestureRecognizer *)tap{
    KNPhotoBrower *photoBrower = [[KNPhotoBrower alloc] init];
    [photoBrower setDelegate:self];
    [photoBrower setItemsArr:[self.itemsArr copy]];
    [photoBrower setCurrentIndex:tap.view.tag];
    [photoBrower present];
    
    // 这里是 设置 状态栏的 隐藏 ---> 可不写
    _photoBrower = photoBrower;
    _ApplicationStatusIsHidden = YES;
    [self setNeedsStatusBarAppearanceUpdate];
}

// 下面方法 是让 '状态栏' 在 PhotoBrower 显示的时候 消失, 消失的时候 显示 ---> 根据项目需求而定
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (BOOL)prefersStatusBarHidden{
    if(_ApplicationStatusIsHidden){
        return YES;
    }
    return NO;
}

#pragma mark - Delegate

/* PhotoBrower 即将消失 */
- (void)photoBrowerWillDismiss{
    NSLog(@"Will Dismiss");
    _ApplicationStatusIsHidden = NO;
    [self setNeedsStatusBarAppearanceUpdate];
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
