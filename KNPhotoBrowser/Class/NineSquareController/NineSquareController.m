//
//  NineSquareController.m
//  KNPhotoBrowser
//
//  Created by LuKane on 2021/5/18.
//  Copyright © 2021 LuKane. All rights reserved.
//

#import "NineSquareController.h"
#import "NineSquareModel.h"
#import "NineSquareCell.h"

@interface NineSquareController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,weak  ) UITableView *tableView;

@end

@implementation NineSquareController

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
        
        CGFloat width = (self.view.frame.size.width - 40) / 3;
        
        /// 第一条数据
        {
            NSMutableArray *arr = [NSMutableArray array];
            
            NineSquareItemsModel *itemM = [[NineSquareItemsModel alloc] init];
            itemM.url = @"https://wx3.sinaimg.cn/thumbnail/9bbc284bgy1frtdh1idwkj218g0rs7li.jpg";
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
            itemM.url = @"https://wx3.sinaimg.cn/thumbnail/9bbc284bgy1frtdh1idwkj218g0rs7li.jpg";
            [arr addObject:itemM];
            
            NineSquareItemsModel *itemM1 = [[NineSquareItemsModel alloc] init];
            itemM1.url = [[NSBundle mainBundle] pathForResource:@"location_video.MP4" ofType:nil];
            itemM1.isVideo = true;
            [arr addObject:itemM1];
            
            NineSquareItemsModel *itemM2 = [[NineSquareItemsModel alloc] init];
            itemM2.url = @"http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4";
            itemM2.isVideo = true;
            itemM2.placeHolderUrl = @"https://edu-201121.oss-cn-beijing.aliyuncs.com/WX20210106-103823.png";
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
            itemM.url = @"https://wx3.sinaimg.cn/thumbnail/9bbc284bgy1frtdh1idwkj218g0rs7li.jpg";
            [arr addObject:itemM];
            
            NineSquareItemsModel *itemM1 = [[NineSquareItemsModel alloc] init];
            itemM1.url = [[NSBundle mainBundle] pathForResource:@"location_video.MP4" ofType:nil];
            itemM1.isVideo = true;
            [arr addObject:itemM1];
            
            NineSquareItemsModel *itemM2 = [[NineSquareItemsModel alloc] init];
            itemM2.url = @"http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4";
            itemM2.isVideo = true;
            itemM2.placeHolderUrl = @"https://edu-201121.oss-cn-beijing.aliyuncs.com/WX20210106-103823.png";
            [arr addObject:itemM2];
            
            NineSquareItemsModel *itemM3 = [[NineSquareItemsModel alloc] init];
            itemM3.url = @"https://aweme.snssdk.com/aweme/v1/playwm/?video_id=v0200ff00000bdkpfpdd2r6fb5kf6m50&line=0.MP4";
            itemM3.isVideo = true;
            itemM3.placeHolderUrl = @"https://edu-201121.oss-cn-beijing.aliyuncs.com/WX20210106-103742.png";
            [arr addObject:itemM3];
            
            NineSquareItemsModel *itemM4 = [[NineSquareItemsModel alloc] init];
            itemM4.url = @"http://ww2.sinaimg.cn/thumbnail/677febf5gw1erma104rhyj20k03dz16y.jpg";
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
            itemM.url = @"https://wx3.sinaimg.cn/thumbnail/9bbc284bgy1frtdh1idwkj218g0rs7li.jpg";
            [arr addObject:itemM];
            
            NineSquareItemsModel *itemM1 = [[NineSquareItemsModel alloc] init];
            itemM1.url = [[NSBundle mainBundle] pathForResource:@"location_video.MP4" ofType:nil];
            itemM1.isVideo = true;
            [arr addObject:itemM1];
            
            NineSquareItemsModel *itemM2 = [[NineSquareItemsModel alloc] init];
            itemM2.url = @"http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4";
            itemM2.isVideo = true;
            itemM2.placeHolderUrl = @"https://edu-201121.oss-cn-beijing.aliyuncs.com/WX20210106-103823.png";
            [arr addObject:itemM2];
            
            NineSquareItemsModel *itemM3 = [[NineSquareItemsModel alloc] init];
            itemM3.url = @"https://aweme.snssdk.com/aweme/v1/playwm/?video_id=v0200ff00000bdkpfpdd2r6fb5kf6m50&line=0.MP4";
            itemM3.isVideo = true;
            itemM3.placeHolderUrl = @"https://edu-201121.oss-cn-beijing.aliyuncs.com/WX20210106-103742.png";
            [arr addObject:itemM3];
            
            NineSquareItemsModel *itemM4 = [[NineSquareItemsModel alloc] init];
            itemM4.url = @"http://ww2.sinaimg.cn/thumbnail/677febf5gw1erma104rhyj20k03dz16y.jpg";
            [arr addObject:itemM4];
            
            NineSquareItemsModel *itemM5 = [[NineSquareItemsModel alloc] init];
            itemM5.url = @"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr1xydcj20gy0o9q6s.jpg";
            [arr addObject:itemM5];
            
            NineSquareItemsModel *itemM6 = [[NineSquareItemsModel alloc] init];
            itemM6.url = @"http://ww2.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr39ht9j20gy0o6q74.jpg";
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
            itemM.url = @"https://wx3.sinaimg.cn/thumbnail/9bbc284bgy1frtdh1idwkj218g0rs7li.jpg";
            [arr addObject:itemM];
            
            NineSquareItemsModel *itemM1 = [[NineSquareItemsModel alloc] init];
            itemM1.url = [[NSBundle mainBundle] pathForResource:@"location_video.MP4" ofType:nil];
            itemM1.isVideo = true;
            [arr addObject:itemM1];
            
            NineSquareItemsModel *itemM2 = [[NineSquareItemsModel alloc] init];
            itemM2.url = @"http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4";
            itemM2.isVideo = true;
            itemM2.placeHolderUrl = @"https://edu-201121.oss-cn-beijing.aliyuncs.com/WX20210106-103823.png";
            [arr addObject:itemM2];
            
            NineSquareItemsModel *itemM3 = [[NineSquareItemsModel alloc] init];
            itemM3.url = @"https://aweme.snssdk.com/aweme/v1/playwm/?video_id=v0200ff00000bdkpfpdd2r6fb5kf6m50&line=0.MP4";
            itemM3.isVideo = true;
            itemM3.placeHolderUrl = @"https://edu-201121.oss-cn-beijing.aliyuncs.com/WX20210106-103742.png";
            [arr addObject:itemM3];
            
            NineSquareItemsModel *itemM4 = [[NineSquareItemsModel alloc] init];
            itemM4.url = @"http://ww2.sinaimg.cn/thumbnail/677febf5gw1erma104rhyj20k03dz16y.jpg";
            [arr addObject:itemM4];
            
            NineSquareItemsModel *itemM5 = [[NineSquareItemsModel alloc] init];
            itemM5.url = @"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr1xydcj20gy0o9q6s.jpg";
            [arr addObject:itemM5];
            
            NineSquareItemsModel *itemM6 = [[NineSquareItemsModel alloc] init];
            itemM6.url = @"http://ww2.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr39ht9j20gy0o6q74.jpg";
            [arr addObject:itemM6];
            
            NineSquareItemsModel *itemM7 = [[NineSquareItemsModel alloc] init];
            itemM7.url = [[NSBundle mainBundle] pathForResource:@"gif3.GIF" ofType:nil];
            itemM7.isLocateGif = true;
            [arr addObject:itemM7];
            
            NineSquareItemsModel *itemM8 = [[NineSquareItemsModel alloc] init];
            itemM8.url = @"http://ww2.sinaimg.cn/bmiddle/642beb18gw1ep3629gfm0g206o050b2a.gif";
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
    self.title = @"net + loc : Photo + Video";
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
