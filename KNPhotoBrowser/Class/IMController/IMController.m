//
//  IMController.m
//  KNPhotoBrowser
//
//  Created by LuKane on 2021/5/20.
//  Copyright © 2021 LuKane. All rights reserved.
//

#import "IMController.h"
#import "IMModel.h"

@interface IMController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,weak  ) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) NSMutableArray *itemsArr;

@end

@implementation IMController

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
        {
            IMModel *m = [[IMModel alloc] init];
            m.isLeft = true;
            m.url = @"1.jpg";
            m.rate = 0.67;
            [_dataArr addObject:m];
        }
        {
            IMModel *m = [[IMModel alloc] init];
            m.url = @"2.jpg";
            m.rate = 0.67;
            [_dataArr addObject:m];
        }
        {
            IMModel *m = [[IMModel alloc] init];
            m.isLeft = true;
            m.url = @"3.jpg";
            m.rate = 0.71;
            [_dataArr addObject:m];
        }
        {
            IMModel *m = [[IMModel alloc] init];
            m.url = @"4.jpg";
            m.rate = 0.67;
            [_dataArr addObject:m];
        }
        {
            IMModel *m = [[IMModel alloc] init];
            m.isLeft = true;
            m.rate = 0.70;
            m.url = @"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr1xydcj20gy0o9q6s.jpg";
            [_dataArr addObject:m];
        }
        {
            IMModel *m = [[IMModel alloc] init];
            m.url = @"https://wx3.sinaimg.cn/thumbnail/9bbc284bgy1frtdh1idwkj218g0rs7li.jpg";
            m.rate = 1.6;
            [_dataArr addObject:m];
        }
        {
            IMModel *m = [[IMModel alloc] init];
            m.isLeft = true;
            m.rate = 0.56;
            m.url = @"https://aweme.snssdk.com/aweme/v1/playwm/?video_id=v0200ff00000bdkpfpdd2r6fb5kf6m50&line=0.MP4";
            m.isVideo = true;
            m.videoPlaceHolderUrl = @"https://edu-201121.oss-cn-beijing.aliyuncs.com/WX20210106-103742.png";
            [_dataArr addObject:m];
        }
        {
            IMModel *m = [[IMModel alloc] init];
            m.rate = 1.79;
            m.url = @"http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4";
            m.videoPlaceHolderUrl = @"https://edu-201121.oss-cn-beijing.aliyuncs.com/WX20210106-103823.png";
            m.isVideo = true;
            [_dataArr addObject:m];
        }
        {
            IMModel *m = [[IMModel alloc] init];
            m.isLeft = true;
            m.rate = 0.67;
            m.url = @"9.jpg";
            [_dataArr addObject:m];
        }
    }
    return _dataArr;
}
- (NSMutableArray *)itemsArr{
    if (!_itemsArr) {
        _itemsArr = [NSMutableArray array];
    }
    return _itemsArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"IM";
    
    if (TARGET_IPHONE_SIMULATOR == 1 && TARGET_OS_IPHONE == 1) {
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"该功能在真机上执行" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:true];
        }];
        [alertVc addAction:alertAction];
        [self presentViewController:alertVc animated:true completion:^{
            
        }];
    } else {
        [self setupTableView];
    }
}
- (void)setupTableView{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:tableView];
    self.tableView = tableView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}
- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

@end
