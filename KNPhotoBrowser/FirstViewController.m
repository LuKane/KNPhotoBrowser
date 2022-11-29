//
//  FirstViewController.m
//  KNPhotoBrowser
//
//  Created by LuKane on 2018/12/14.
//  Copyright © 2018 LuKane. All rights reserved.
//

#import "FirstViewController.h"
#import "NavigationController.h"
#import "SDImageCache.h"
#import "KNPhotoDownloadMgr.h"

@interface FirstViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,weak  ) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation FirstViewController

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
        {
            NSMutableArray *arr = [NSMutableArray array];
            [arr addObject:@"ViewController"];
            [arr addObject:@"ViewLocateController"];
            [_dataArr addObject:arr];
        }
        {
            NSMutableArray *arr = [NSMutableArray array];
            [arr addObject:@"NineSquareController"];
            [arr addObject:@"NineSquareLocateController"];
            
            [_dataArr addObject:arr];
        }
        {
            NSMutableArray *arr = [NSMutableArray array];
            [arr addObject:@"ScrollViewController"];
            [arr addObject:@"ScrollViewLocateController"];
            [_dataArr addObject:arr];
        }
        {
            NSMutableArray *arr = [NSMutableArray array];
            [arr addObject:@"IMController"];
            [_dataArr addObject:arr];
        }
        {
            NSMutableArray *arr = [NSMutableArray array];
            [arr addObject:@"SendImageController"];
            [_dataArr addObject:arr];
        }
        {
            NSMutableArray *arr = [NSMutableArray array];
            [arr addObject:@"CustomSourceViewController"];
            [_dataArr addObject:arr];
        }
        {
            NSMutableArray *arr = [NSMutableArray array];
            [arr addObject:@"CustomViewController"];
            [_dataArr addObject:arr];
        }
        {
            NSMutableArray *arr = [NSMutableArray array];
            [arr addObject:@"PushPhotoBrowserController"];
            [_dataArr addObject:arr];
        }
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"KNPhotoBrowser 演示";
    [self setupTableView];
    [self clearDisk];
}

- (void)clearDisk {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"CLEAR" style:UIBarButtonItemStyleDone target:self action:@selector(clear)];
}

- (void)clear{
    // clear memory for test
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        
    }];
    
    KNPhotoDownloadFileMgr *mgr = [[KNPhotoDownloadFileMgr alloc] init];
    [mgr removeAllVideo];
}

- (void)setupTableView{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:tableView];
    self.tableView = tableView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArr[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *const ID = @"KNPhotoBrowserID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSMutableArray *arr = self.dataArr[indexPath.section];
    cell.textLabel.text = arr[indexPath.row];
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc] initWithFrame:CGRectZero];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc] initWithFrame:CGRectZero];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    NSArray *arr = self.dataArr[indexPath.section];
    
    Class class = NSClassFromString(arr[indexPath.row]);
    UIViewController *vc = [[class alloc] init];
    
    if (indexPath.row == 1) {
        NavigationController *nav = [[NavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:true completion:^{
            
        }];
    }else {
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

@end
