//
//  FirstViewController.m
//  KNPhotoBrower
//
//  Created by LuKane on 16/9/1.
//  Copyright © 2016年 LuKane. All rights reserved.
//

#import "FirstViewController.h"

#import "ViewController.h"
#import "NineSquareController.h"
#import "ScrollViewController.h"
#import "CollectionViewController.h"

@interface FirstViewController ()<UITableViewDataSource,UITableViewDelegate>{
    BOOL     _isHidden;
    UIView  *_view;
}

@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation FirstViewController

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
        [_dataArr addObject:@"ViewController"];
        [_dataArr addObject:@"NineSquareController"];
        [_dataArr addObject:@"ScrollViewController"];
        [_dataArr addObject:@"CollectionViewController"];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @" KNPhotoBrower 演示";
    
    [self setupTableView];
}

- (void)setupTableView{
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [self.view addSubview:tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *const ID = @"KNPhotoBrowerID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.dataArr[indexPath.section];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Class class = NSClassFromString(self.dataArr[indexPath.section]);
    UIViewController *vc = [[class alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
