//
//  IMViewController.m
//  KNPhotoBrowser
//
//  Created by LuKane on 2019/2/1.
//  Copyright © 2019 LuKane. All rights reserved.
//

#import "IMViewController.h"
#import "IMTableViewCell.h"
#import "IMModel.h"

#import "KNPhotoBrowser.h"
#import <Photos/Photos.h>

@interface IMViewController ()<UITableViewDelegate,UITableViewDataSource,IMTableViewCellDelegate,UIAlertViewDelegate>

@property (nonatomic,weak  ) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArr;

@property (nonatomic,strong) NSMutableArray *itemsArr;

@end

@implementation IMViewController

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
    self.title = @"IM";
    
    if (TARGET_IPHONE_SIMULATOR == 1 && TARGET_OS_IPHONE == 1) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该功能在真机上执行" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alertView show];
    } else {
        [self setupTableView];
        [self loadingData];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController popViewControllerAnimated:true];
}

- (void)loadingData{
    {   // 1
        IMModel *model = [[IMModel alloc] init];
        model.locImage = [UIImage imageNamed:@"1.jpg"];
        model.isLeft   = true;
        [self.dataArr addObject:model];
    }

    {   // 2
        IMModel *model = [[IMModel alloc] init];
        model.locImage = [UIImage imageNamed:@"2.jpg"];
        [self.dataArr addObject:model];
    }

    {   // 3
        IMModel *model = [[IMModel alloc] init];
        model.locImage = [UIImage imageNamed:@"3.jpg"];
        model.isLeft   = true;
        [_dataArr addObject:model];
    }

    {   // 4
        IMModel *model = [[IMModel alloc] init];
        model.locImage = [UIImage imageNamed:@"4.jpg"];
        [_dataArr addObject:model];
    }

    {   // 5
        IMModel *model = [[IMModel alloc] init];
        model.url = @"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr1xydcj20gy0o9q6s.jpg";
        model.isLeft   = true;
        [_dataArr addObject:model];
    }

    {   // 6
        IMModel *model = [[IMModel alloc] init];
        model.url = @"https://wx3.sinaimg.cn/thumbnail/9bbc284bgy1frtdh1idwkj218g0rs7li.jpg";
        [_dataArr addObject:model];
    }

    {
        // 7
        NSString *videoUrl2 = @"https://aweme.snssdk.com/aweme/v1/playwm/?video_id=v0200ff00000bdkpfpdd2r6fb5kf6m50&line=0.MP4";

        IMModel *model = [[IMModel alloc] init];
        model.isVideo  = true;
        model.url      = videoUrl2;
        model.isLeft   = true;
        model.rate     = ScreenWidth / ScreenHeight;
        [self.dataArr addObject:model];
    }
    
    {   // 8
        NSString *path = [[NSBundle mainBundle] pathForResource:@"location_video.MP4" ofType:nil];
        IMModel *model = [[IMModel alloc] init];
        model.url      = path;
        model.isVideo  = true;
        model.rate     = ScreenWidth / ScreenHeight;
        [self.dataArr addObject:model];
    }
    
    {   // 9
        IMModel *model = [[IMModel alloc] init];
        model.locImage = [UIImage imageNamed:@"9.jpg"];
        model.isLeft   = true;
        [_dataArr addObject:model];
    }
    
    [self.tableView reloadData];
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
    IMTableViewCell *cell = [IMTableViewCell imTableViewCellWithTableView:tableView];
    cell.imModel = self.dataArr[indexPath.row];
    cell.delegate = self;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

// reload cell height
- (void)reloadCellWithModel:(IMModel *)immModel{
    NSInteger index = [self.dataArr indexOfObject:immModel];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

// pic did  Click
- (void)imImageViewDidClick:(IMModel *)imModel{
    
    [self.itemsArr removeAllObjects];
    
    NSMutableArray *tempArr = [NSMutableArray array];
    
    for (NSInteger i = 0; i < self.dataArr.count; i++) {
        IMModel *imM = self.dataArr[i];
        
        KNPhotoItems *items = [[KNPhotoItems alloc] init];
        
        if(imM.url == nil && imM.locImage == nil) { // if it's not a picture
            
        }else{
            if(imM.url && imM.isVideo == false){
                items.url = [imM.url stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
            }else if(imM.locImage){
                items.sourceImage = imM.locImage;
            }else if (imM.isVideo && imM.url) {
                items.url = imM.url;
                items.isVideo = true;
                
                AVURLAsset *avAsset = nil;
                if ([imM.url hasPrefix:@"http"]) {
                    avAsset = [AVURLAsset assetWithURL:[NSURL URLWithString:imM.url]];
                    if (avAsset) {
                        CGFloat padding = 5, imageViewLength = ([UIScreen mainScreen].bounds.size.width - padding * 2) / 3 - 10, scale = [UIScreen mainScreen].scale;
                        CGSize imageViewSize = CGSizeMake(imageViewLength * scale, imageViewLength * scale);
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:avAsset];
                            generator.appliesPreferredTrackTransform = YES;
                            generator.maximumSize = imageViewSize;
                            NSError *error = nil;
                            CGImageRef cgImage = [generator copyCGImageAtTime:CMTimeMake(0, 1) actualTime:NULL error:&error];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                items.sourceImage = [UIImage imageWithCGImage:cgImage];
                            });
                        });
                    }
                }else{
                    avAsset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:imM.url]];
                    if (avAsset) {
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:avAsset];
                            generator.appliesPreferredTrackTransform = YES;
                            NSError *error = nil;
                            CGImageRef cgImage = [generator copyCGImageAtTime:CMTimeMake(0, 1) actualTime:NULL error:&error];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                items.sourceImage = [UIImage imageWithCGImage:cgImage];
                            });
                        });
                    }
                }
                
            }
            [self.itemsArr addObject:items];
            [tempArr addObject:imM];
        }
    }
    
    NSArray *visibleCells = self.tableView.visibleCells;

    for (NSInteger i = 0; i < self.itemsArr.count; i++) {
        KNPhotoItems *items = self.itemsArr[i];
        IMModel      *imM   = tempArr[i];

        for (NSInteger j = 0; j < visibleCells.count; j++) {
            IMTableViewCell *cell = (IMTableViewCell *)visibleCells[j];
            if(cell.imModel.url == nil && cell.imModel.locImage == nil){

            }else{
                if(imM == cell.imModel){
                    items.sourceView = cell.picImgView;
                    items.isVideo    = imM.isVideo;
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
    photoBrower.isNeedPictureLongPress = true;
    photoBrower.currentIndex = [tempArr indexOfObject:imModel];
    [photoBrower present];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    IMModel *model = self.dataArr[indexPath.row];
    return model.cellHeight;
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
