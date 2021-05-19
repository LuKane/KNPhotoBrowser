//
//  NineSquareLocateController.m
//  KNPhotoBrowser
//
//  Created by LuKane on 2021/5/18.
//  Copyright © 2021 LuKane. All rights reserved.
//

#import "NineSquareLocateController.h"
#import "NineSquareModel.h"
#import "NineSquareCell.h"

@interface NineSquareLocateController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,weak  ) UITableView *tableView;

@end

@implementation NineSquareLocateController

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
        
        CGFloat width = (self.view.frame.size.width - 40) / 3;
        
        /// 第一条数据
        {
            NSMutableArray *arr = [NSMutableArray array];
            
            NineSquareItemsModel *itemM = [[NineSquareItemsModel alloc] init];
            itemM.url = @"1.jpg";
            [arr addObject:itemM];
            
            NineSquareModel *squareM = [[NineSquareModel alloc] init];
            squareM.urlArr = [arr copy];
            squareM.cellHeight = width + 20;
            [_dataArr addObject:squareM];
        }
        /// 第二条数据
        {
            NSMutableArray *arr = [NSMutableArray array];
            
            NineSquareItemsModel *itemM = [[NineSquareItemsModel alloc] init];
            itemM.url = @"1.jpg";
            [arr addObject:itemM];
            
            NineSquareItemsModel *itemM1 = [[NineSquareItemsModel alloc] init];
            itemM1.url = [[NSBundle mainBundle] pathForResource:@"location_video.MP4" ofType:nil];
            itemM1.isVideo = true;
            [arr addObject:itemM1];
            
            NineSquareItemsModel *itemM2 = [[NineSquareItemsModel alloc] init];
            itemM2.url = @"2.jpg";
            [arr addObject:itemM2];
            
            NineSquareModel *squareM = [[NineSquareModel alloc] init];
            squareM.urlArr = [arr copy];
            squareM.cellHeight = width + 20;
            [_dataArr addObject:squareM];
        }
        /// 第三条数据
        {
            NSMutableArray *arr = [NSMutableArray array];
            
            NineSquareItemsModel *itemM = [[NineSquareItemsModel alloc] init];
            itemM.url = @"1.jpg";
            [arr addObject:itemM];
            
            NineSquareItemsModel *itemM1 = [[NineSquareItemsModel alloc] init];
            itemM1.url = [[NSBundle mainBundle] pathForResource:@"location_video.MP4" ofType:nil];
            itemM1.isVideo = true;
            [arr addObject:itemM1];
            
            NineSquareItemsModel *itemM2 = [[NineSquareItemsModel alloc] init];
            itemM2.url = @"2.jpg";
            [arr addObject:itemM2];
            
            NineSquareItemsModel *itemM3 = [[NineSquareItemsModel alloc] init];
            itemM3.url = @"3.jpg";
            [arr addObject:itemM3];
            
            NineSquareItemsModel *itemM4 = [[NineSquareItemsModel alloc] init];
            itemM4.url = @"4.jpg";
            [arr addObject:itemM4];
            
            NineSquareModel *squareM = [[NineSquareModel alloc] init];
            squareM.urlArr = [arr copy];
            squareM.cellHeight = width + 30 + width;
            [_dataArr addObject:squareM];
        }
        /// 第四条数据
        {
            NSMutableArray *arr = [NSMutableArray array];
            
            NineSquareItemsModel *itemM = [[NineSquareItemsModel alloc] init];
            itemM.url = @"1.jpg";
            [arr addObject:itemM];
            
            NineSquareItemsModel *itemM1 = [[NineSquareItemsModel alloc] init];
            itemM1.url = [[NSBundle mainBundle] pathForResource:@"location_video.MP4" ofType:nil];
            itemM1.isVideo = true;
            [arr addObject:itemM1];
            
            NineSquareItemsModel *itemM2 = [[NineSquareItemsModel alloc] init];
            itemM2.url = @"2.jpg";
            [arr addObject:itemM2];
            
            NineSquareItemsModel *itemM3 = [[NineSquareItemsModel alloc] init];
            itemM3.url = @"3.jpg";
            [arr addObject:itemM3];
            
            NineSquareItemsModel *itemM4 = [[NineSquareItemsModel alloc] init];
            itemM4.url = @"4.jpg";
            [arr addObject:itemM4];
            
            NineSquareItemsModel *itemM5 = [[NineSquareItemsModel alloc] init];
            itemM5.url = @"5.jpg";
            [arr addObject:itemM5];
            
            NineSquareItemsModel *itemM6 = [[NineSquareItemsModel alloc] init];
            itemM6.url = @"6.jpg";
            [arr addObject:itemM6];
            
            NineSquareModel *squareM = [[NineSquareModel alloc] init];
            squareM.urlArr = [arr copy];
            squareM.cellHeight = width * 3 + 40;
            [_dataArr addObject:squareM];
        }
        /// 第五条数据
        {
            NSMutableArray *arr = [NSMutableArray array];
            
            NineSquareItemsModel *itemM = [[NineSquareItemsModel alloc] init];
            itemM.url = @"1.jpg";
            [arr addObject:itemM];
            
            NineSquareItemsModel *itemM1 = [[NineSquareItemsModel alloc] init];
            itemM1.url = [[NSBundle mainBundle] pathForResource:@"location_video.MP4" ofType:nil];
            itemM1.isVideo = true;
            [arr addObject:itemM1];
            
            NineSquareItemsModel *itemM2 = [[NineSquareItemsModel alloc] init];
            itemM2.url = @"2.jpg";
            [arr addObject:itemM2];
            
            NineSquareItemsModel *itemM3 = [[NineSquareItemsModel alloc] init];
            itemM3.url = @"3.jpg";
            [arr addObject:itemM3];
            
            NineSquareItemsModel *itemM4 = [[NineSquareItemsModel alloc] init];
            itemM4.url = @"4.jpg";
            [arr addObject:itemM4];
            
            NineSquareItemsModel *itemM5 = [[NineSquareItemsModel alloc] init];
            itemM5.url = @"5.jpg";
            [arr addObject:itemM5];
            
            NineSquareItemsModel *itemM6 = [[NineSquareItemsModel alloc] init];
            itemM6.url = @"6.jpg";
            [arr addObject:itemM6];
            
            NineSquareItemsModel *itemM7 = [[NineSquareItemsModel alloc] init];
            itemM7.url = @"7.jpg";
            [arr addObject:itemM7];
            
            NineSquareItemsModel *itemM8 = [[NineSquareItemsModel alloc] init];
            itemM8.url = @"8.jpg";
            [arr addObject:itemM8];
            
            NineSquareModel *squareM = [[NineSquareModel alloc] init];
            squareM.urlArr = [arr copy];
            squareM.cellHeight = width * 3 + 40;
            [_dataArr addObject:squareM];
        }
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"loc : Photo + Video";
    [self setupTableView];
    
    if (@available(iOS 11.0, *)){
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}
- (void)setupTableView{
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [tableView setDataSource:self];
    [tableView setDelegate:self];
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NineSquareCell *cell = [NineSquareCell nineSquareCell:tableView];
    cell.isLocate = true;
    cell.squareM = self.dataArr[indexPath.section];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NineSquareModel *m = self.dataArr[indexPath.section];
    return m.cellHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc] initWithFrame:CGRectZero];
}
- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

@end
