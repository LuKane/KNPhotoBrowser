//
//  FirstViewController.m
//  KNPhotoBrowser
//
//  Created by LuKane on 2018/12/14.
//  Copyright © 2018 LuKane. All rights reserved.
//

#import "FirstViewController.h"

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
            [arr addObject:@"NineSquareController"];
            [arr addObject:@"ScrollViewController"];
            [_dataArr addObject:arr];
        }
        {
            NSMutableArray *arr = [NSMutableArray array];
            [arr addObject:@"ViewLocController"];
            [arr addObject:@"NineSquareLocController"];
            [arr addObject:@"ScrollViewLocController"];
            [_dataArr addObject:arr];
        }
        {
            NSMutableArray *arr = [NSMutableArray array];
            [arr addObject:@"IMViewController"];
            [_dataArr addObject:arr];
        }
        {
            NSMutableArray *arr = [NSMutableArray array];
            [arr addObject:@"SendImageController"];
            [_dataArr addObject:arr];
        }
        {
            NSMutableArray *arr = [NSMutableArray array];
            [arr addObject:@"CustomViewController"];
            [arr addObject:@"AddImageViewController"];
            
            [_dataArr addObject:arr];
        }
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"KNPhotoBrowser 演示";
    [self setupTableView];
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    NSArray *arr = self.dataArr[indexPath.section];
    
    Class class = NSClassFromString(arr[indexPath.row]);
    UIViewController *vc = [[class alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

@end
