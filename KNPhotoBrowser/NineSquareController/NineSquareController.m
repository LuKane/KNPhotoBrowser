//
//  NineSquareController.m
//  KNPhotoBrowser
//
//  Created by LuKane on 2019/1/14.
//  Copyright © 2019 LuKane. All rights reserved.
//

#import "NineSquareController.h"
#import "NineSquareCell.h"
#import "NineSquareModel.h"

@interface NineSquareController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NineSquareCell *cell;
@property (nonatomic,weak  ) UITableView *tableView;

@end

@implementation NineSquareController

- (BOOL)prefersStatusBarHidden{
    return true;
}

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (instancetype)init{
    if (self = [super init]) {
        
        {
            NineSquareUrlModel *urlModel = [[NineSquareUrlModel alloc] init];
            urlModel.url = @"https://wx3.sinaimg.cn/thumbnail/9bbc284bgy1frtdh1idwkj218g0rs7li.jpg";
            NineSquareModel *model = [[NineSquareModel alloc] init];
            model.title = @"一条数据";
            model.urlArr = [NSMutableArray array];
            [model.urlArr addObject:urlModel];
            [self.dataArr addObject:model];
        }
        
        {
            NineSquareUrlModel *urlModel = [[NineSquareUrlModel alloc] init];
            urlModel.url = @"https://wx3.sinaimg.cn/thumbnail/9bbc284bgy1frtdh1idwkj218g0rs7li.jpg";
            NineSquareUrlModel *urlModel2 = [[NineSquareUrlModel alloc] init];
            urlModel2.url = @"http://ww2.sinaimg.cn/thumbnail/642beb18gw1ep3629gfm0g206o050b2a.gif";
            NineSquareUrlModel *urlModel3 = [[NineSquareUrlModel alloc] init];
            urlModel3.url = @"http://ww2.sinaimg.cn/thumbnail/677febf5gw1erma104rhyj20k03dz16y.jpg";
            NineSquareModel *model = [[NineSquareModel alloc] init];
            
            model.title = @"三条数据";
            
            model.urlArr = [NSMutableArray array];
            [model.urlArr addObject:urlModel];
            [model.urlArr addObject:urlModel2];
            [model.urlArr addObject:urlModel3];
            
            [self.dataArr addObject:model];
        }
        
        {
            NineSquareUrlModel *urlModel = [[NineSquareUrlModel alloc] init];
            urlModel.url = @"https://wx3.sinaimg.cn/thumbnail/9bbc284bgy1frtdh1idwkj218g0rs7li.jpg";
            NineSquareUrlModel *urlModel2 = [[NineSquareUrlModel alloc] init];
            urlModel2.url = @"http://ww2.sinaimg.cn/thumbnail/642beb18gw1ep3629gfm0g206o050b2a.gif";
            NineSquareUrlModel *urlModel3 = [[NineSquareUrlModel alloc] init];
            urlModel3.url = @"http://ww2.sinaimg.cn/thumbnail/677febf5gw1erma104rhyj20k03dz16y.jpg";
            NineSquareUrlModel *urlModel4 = [[NineSquareUrlModel alloc] init];
            urlModel4.url = @"https://wx3.sinaimg.cn/thumbnail/9bbc284bgy1frtdgoa9xxj218g0rsaon.jpg";
            NineSquareUrlModel *urlModel5 = [[NineSquareUrlModel alloc] init];
            urlModel5.url = @"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr1xydcj20gy0o9q6s.jpg";
            
            NineSquareModel *model = [[NineSquareModel alloc] init];
            model.title = @"五条数据";
            model.urlArr = [NSMutableArray array];
            [model.urlArr addObject:urlModel];
            [model.urlArr addObject:urlModel2];
            [model.urlArr addObject:urlModel3];
            [model.urlArr addObject:urlModel4];
            [model.urlArr addObject:urlModel5];
            [self.dataArr addObject:model];
        }
        
        {
            NineSquareUrlModel *urlModel = [[NineSquareUrlModel alloc] init];
            urlModel.url = @"https://wx3.sinaimg.cn/thumbnail/9bbc284bgy1frtdh1idwkj218g0rs7li.jpg";
            NineSquareUrlModel *urlModel2 = [[NineSquareUrlModel alloc] init];
            urlModel2.url = @"http://ww2.sinaimg.cn/thumbnail/642beb18gw1ep3629gfm0g206o050b2a.gif";
            NineSquareUrlModel *urlModel3 = [[NineSquareUrlModel alloc] init];
            urlModel3.url = @"http://ww2.sinaimg.cn/thumbnail/677febf5gw1erma104rhyj20k03dz16y.jpg";
            NineSquareUrlModel *urlModel4 = [[NineSquareUrlModel alloc] init];
            urlModel4.url = @"https://wx3.sinaimg.cn/thumbnail/9bbc284bgy1frtdgoa9xxj218g0rsaon.jpg";
            NineSquareUrlModel *urlModel5 = [[NineSquareUrlModel alloc] init];
            urlModel5.url = @"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr1xydcj20gy0o9q6s.jpg";
            NineSquareUrlModel *urlModel6 = [[NineSquareUrlModel alloc] init];
            urlModel6.url = @"http://ww2.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr39ht9j20gy0o6q74.jpg";
            NineSquareUrlModel *urlModel7 = [[NineSquareUrlModel alloc] init];
            urlModel7.url = @"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr3xvtlj20gy0obadv.jpg";
            
            NineSquareModel *model = [[NineSquareModel alloc] init];
            model.title = @"七条数据";
            model.urlArr = [NSMutableArray array];
            
            [model.urlArr addObject:urlModel];
            [model.urlArr addObject:urlModel2];
            [model.urlArr addObject:urlModel3];
            [model.urlArr addObject:urlModel4];
            [model.urlArr addObject:urlModel5];
            [model.urlArr addObject:urlModel6];
            [model.urlArr addObject:urlModel7];
            
            [self.dataArr addObject:model];
        }
        
        {
            NineSquareUrlModel *urlModel = [[NineSquareUrlModel alloc] init];
            urlModel.url = @"https://wx3.sinaimg.cn/thumbnail/9bbc284bgy1frtdh1idwkj218g0rs7li.jpg";
            NineSquareUrlModel *urlModel2 = [[NineSquareUrlModel alloc] init];
            urlModel2.url = @"http://ww2.sinaimg.cn/thumbnail/642beb18gw1ep3629gfm0g206o050b2a.gif";
            NineSquareUrlModel *urlModel3 = [[NineSquareUrlModel alloc] init];
            urlModel3.url = @"http://ww2.sinaimg.cn/thumbnail/677febf5gw1erma104rhyj20k03dz16y.jpg";
            NineSquareUrlModel *urlModel4 = [[NineSquareUrlModel alloc] init];
            urlModel4.url = @"https://wx3.sinaimg.cn/thumbnail/9bbc284bgy1frtdgoa9xxj218g0rsaon.jpg";
            NineSquareUrlModel *urlModel5 = [[NineSquareUrlModel alloc] init];
            urlModel5.url = @"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr1xydcj20gy0o9q6s.jpg";
            NineSquareUrlModel *urlModel6 = [[NineSquareUrlModel alloc] init];
            urlModel6.url = @"http://ww2.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr39ht9j20gy0o6q74.jpg";
            NineSquareUrlModel *urlModel7 = [[NineSquareUrlModel alloc] init];
            urlModel7.url = @"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr3xvtlj20gy0obadv.jpg";
            NineSquareUrlModel *urlModel8 = [[NineSquareUrlModel alloc] init];
            urlModel8.url = @"https://wx2.sinaimg.cn/mw690/9bbc284bgy1frtdht9q6mj21hc0u0hdt.jpg";
            NineSquareUrlModel *urlModel9 = [[NineSquareUrlModel alloc] init];
            urlModel9.url = @"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr57tn9j20gy0obn0f.jpg";
            
            NineSquareModel *model = [[NineSquareModel alloc] init];
            model.title = @"九条数据";
            model.urlArr = [NSMutableArray array];
            
            [model.urlArr addObject:urlModel];
            [model.urlArr addObject:urlModel2];
            [model.urlArr addObject:urlModel3];
            [model.urlArr addObject:urlModel4];
            [model.urlArr addObject:urlModel5];
            [model.urlArr addObject:urlModel6];
            [model.urlArr addObject:urlModel7];
            [model.urlArr addObject:urlModel8];
            [model.urlArr addObject:urlModel9];
            
            [self.dataArr addObject:model];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"九宫格(网络)";
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
    NineSquareCell *cell = [NineSquareCell nineSquareCellWithTableView:tableView];
    NineSquareModel *model = self.dataArr[indexPath.section];
    cell.squareM = model;
    _cell = cell;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _cell.cellHeight;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NineSquareModel *model = self.dataArr[section];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 5, self.view.frame.size.width, 20)];
    label.text = model.title;
    return label;
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
//    self.tableView.frame = self.view.bounds;
}

@end
