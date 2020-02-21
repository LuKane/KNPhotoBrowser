//
//  SendImageController.m
//  KNPhotoBrowser
//
//  Created by LuKane on 2019/12/30.
//  Copyright © 2019 LuKane. All rights reserved.
//

#import "SendImageController.h"
#import "SendImageItem.h"
#import "KNPhotoBrowser.h"
#import "UIImageView+WebCache.h"

@interface SendImageController ()<SendImageItemDelegate,KNPhotoBrowserDelegate>

@property (nonatomic,weak  ) UIView *bgView;
@property (nonatomic,strong) NSMutableArray *itemsArr;

@property (nonatomic,weak  ) KNPhotoBrowser *photoBrowser;

@end

@implementation SendImageController

- (NSMutableArray *)itemsArr{
    if (!_itemsArr) {
        _itemsArr = [NSMutableArray array];
    }
    return _itemsArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"上传图片";
    
    [self setupBgView];
}

- (void)setupBgView{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 30, self.view.frame.size.width - 20, self.view.frame.size.width - 20)];
    bgView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:bgView];
    _bgView = bgView;
    
    CGFloat width = (bgView.frame.size.width - 40) / 3;
    NSMutableArray *arr = [NSMutableArray array];
    [arr addObject:@"https://wx3.sinaimg.cn/thumbnail/9bbc284bgy1frtdh1idwkj218g0rs7li.jpg"];
    [arr addObject:@"http://ww2.sinaimg.cn/thumbnail/642beb18gw1ep3629gfm0g206o050b2a.gif"];
    [arr addObject:@"http://ww2.sinaimg.cn/thumbnail/677febf5gw1erma104rhyj20k03dz16y.jpg"];
    
    [arr addObject:@"https://wx3.sinaimg.cn/thumbnail/9bbc284bgy1frtdgoa9xxj218g0rsaon.jpg"];
    [arr addObject:@"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr1xydcj20gy0o9q6s.jpg"];
    [arr addObject:@"http://ww2.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr39ht9j20gy0o6q74.jpg"];
    
    [arr addObject:@"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr3xvtlj20gy0obadv.jpg"];
    [arr addObject:@"https://wx2.sinaimg.cn/mw690/9bbc284bgy1frtdht9q6mj21hc0u0hdt.jpg"];
    [arr addObject:@"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr57tn9j20gy0obn0f.jpg"];
    
    for (NSInteger i = 0; i < arr.count; i++) {
        NSInteger row = i / 3;
        NSInteger col = i % 3;
        CGFloat x = 10 + col * (10 + width);
        CGFloat y = 10 + row * (10 + width);
        SendImageItem *imgItem = [[SendImageItem alloc] initWithFrame:CGRectMake(x, y, width, width)];
        imgItem.delegate = self;
        imgItem.tag = i;
        [imgItem.iconView sd_setImageWithURL:[NSURL URLWithString:arr[i]] placeholderImage:nil];
        imgItem.backgroundColor = [UIColor grayColor];
        [bgView addSubview:imgItem];
        
        KNPhotoItems *items = [[KNPhotoItems alloc] init];
        items.url = [arr[i] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
        items.sourceView = imgItem.iconView;
        [self.itemsArr addObject:items];
    }
}

- (void)sendImageItemDidClick:(NSInteger)index{
    KNPhotoBrowser *photoBrower = [[KNPhotoBrowser alloc] init];
    photoBrower.itemsArr = [self.itemsArr mutableCopy];
    photoBrower.currentIndex = index;
    photoBrower.isNeedPageControl = true;
    photoBrower.isNeedPageNumView = true;
    photoBrower.isNeedRightTopBtn = true;
    photoBrower.isNeedPictureLongPress = true;
    [photoBrower present];
    photoBrower.delegate = self;
    _photoBrowser = photoBrower;
}
// photoBrowser's delegate
- (void)photoBrowserRightOperationDeleteImageSuccessWithRelativeIndex:(NSInteger)index{
    
    // delete locate control
    [_bgView.subviews[index] removeFromSuperview];
    
    // you need reload dataResource
    [self.itemsArr removeObjectAtIndex:index];
    
    // reload locate UI
    [self reloadSubViews];
}

- (void)photoBrowserRightOperationAction{
    
    __weak typeof(self) weakself = self;
    KNActionSheet *actionSheet = [[KNActionSheet share] initWithTitle:@"" cancelTitle:@"" titleArray:@[@"删除"].mutableCopy destructiveArray:@[@"0"].mutableCopy actionSheetBlock:^(NSInteger buttonIndex) {
        NSLog(@"buttonIndex:%zd",buttonIndex);
        
        if (buttonIndex == 0) {
            [weakself.photoBrowser deletePhotoAndVideo];
        }
        
        if (buttonIndex == 1) {
            [UIDevice deviceAlbumAuth:^(BOOL isAuthor) {
                if (isAuthor == false) {
                    // do something -> for example : jump to setting
                }else {
                    [weakself.photoBrowser downloadPhotoAndVideo];
                }
            }];
        }
    }];
    
    [actionSheet show];
}

- (void)sendImageItemDeleteClick:(NSInteger)index{
    // delete locate control
    [_bgView.subviews[index] removeFromSuperview];
    
    // you need reload dataResource
    [self.itemsArr removeObjectAtIndex:index];
    
    // reload locate UI
    [self reloadSubViews];
}

- (void)reloadSubViews{
    CGFloat width = (_bgView.frame.size.width - 40) / 3;
    [_bgView.subviews enumerateObjectsUsingBlock:^(__kindof SendImageItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger row = idx / 3;
        NSInteger col = idx % 3;
        CGFloat x = 10 + col * (10 + width);
        CGFloat y = 10 + row * (10 + width);
        item.frame = CGRectMake(x, y, width, width);
        item.tag = idx;
    }];
}

@end
