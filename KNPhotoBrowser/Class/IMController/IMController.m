//
//  IMController.m
//  KNPhotoBrowser
//
//  Created by LuKane on 2021/5/20.
//  Copyright © 2021 LuKane. All rights reserved.
//

#import "IMController.h"
#import "IMModel.h"
#import "IMTableViewCell.h"
#import "KNPhotoBrowser.h"

@interface IMController ()<UITableViewDelegate,UITableViewDataSource, IMTableViewCellDelegate>

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
            m.url = @"http://wx3.sinaimg.cn/thumbnail/9bbc284bgy1frtdh1idwkj218g0rs7li.jpg";
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
    IMTableViewCell *cell = [IMTableViewCell imTableViewCell:tableView];
    cell.imModel = _dataArr[indexPath.row];
    cell.delegate = self;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140;
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

- (void)imageViewDidClick:(IMModel *)imModel{
    [self.itemsArr removeAllObjects];
    
    NSMutableArray *tempArr = [NSMutableArray array];
    
    for (NSInteger i = 0; i < self.dataArr.count; i++) {
        IMModel *m = self.dataArr[i];
        
        KNPhotoItems *photoItems = [[KNPhotoItems alloc] init];
        if (m.url == nil || [m.url isEqualToString:@""] == true) { // it's not a pic, maybe it is a text
            
        }else {
            if (m.isVideo == true) { // video
                photoItems.isVideo = true;
                photoItems.url = m.url;
                photoItems.videoPlaceHolderImageUrl = m.videoPlaceHolderUrl;
            }else { // pic
                if ([m.url hasPrefix:@"http"] == true) { // net pic
                    photoItems.url = [m.url stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
                }else { // loc pic
                    photoItems.sourceImage = [UIImage imageNamed:m.url];
                }
            }
            [self.itemsArr addObject:photoItems];
            [tempArr addObject:m];
        }
    }
    
    
    NSArray *visibleCells = self.tableView.visibleCells;
    for (NSInteger i = 0; i < self.itemsArr.count; i++) {
        
        KNPhotoItems *photoItems = self.itemsArr[i];
        IMModel *m = tempArr[i];
        
        for (NSInteger j = 0; j < visibleCells.count; j++) {
            IMTableViewCell *cell = (IMTableViewCell *)visibleCells[j];
            if (cell.imModel.url == nil) {
                
            }else {
                if(m == cell.imModel){
                    photoItems.sourceView = cell.imgView;
                    photoItems.isVideo    = m.isVideo;
                }
            }
        }
    }
    
    KNPhotoBrowser *photoBrower = [[KNPhotoBrowser alloc] init];
    photoBrower.itemsArr = [self.itemsArr copy];
    photoBrower.isNeedPageControl = true;
    photoBrower.isNeedPageNumView = true;
    photoBrower.isNeedRightTopBtn = true;
    photoBrower.isNeedPanGesture  = true;
    photoBrower.isNeedLongPress   = true;
    photoBrower.isNeedAutoPlay    = true;
    photoBrower.isNeedOnlinePlay  = true;
    photoBrower.currentIndex = [tempArr indexOfObject:imModel];
    [photoBrower present];
}

@end
