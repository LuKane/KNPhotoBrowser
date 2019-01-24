//
//  NineSquareCell.m
//  KNPhotoBrowser
//
//  Created by LuKane on 16/9/18.
//  Copyright © 2016年 LuKane. All rights reserved.
//

#import "NineSquareCell.h"
#import "NineSquareModel.h"
#import "UIImageView+WebCache.h"

#import "KNPhotoBrowser.h"

@interface NineSquareCell()<KNPhotoBrowserDelegate>

@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) NSMutableArray *itemsArr;

@end

@implementation NineSquareCell


- (NSMutableArray *)imageArray{
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}

+ (instancetype)nineSquareCellWithTableView:(UITableView *)tableView{
    static NSString *const ID = @"nineSquareCellID";
    NineSquareCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[NineSquareCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews{
    for (NSInteger i = 0; i < 9; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView setUserInteractionEnabled:YES];
        [imageView setBackgroundColor:[UIColor grayColor]];
        [imageView setContentMode:UIViewContentModeTop | UIViewContentModeLeft | UIViewContentModeRight];
        [imageView setTag:i];
        [self.imageArray addObject:imageView];
        [self.contentView addSubview:imageView];
    }
}

- (void)setSquareM:(NineSquareModel *)squareM{
    _squareM = squareM;
    
    for (NSInteger i = squareM.urlArr.count; i < 9; i++) {
        UIImageView *imageView = [self.imageArray objectAtIndex:i];
        imageView.hidden = YES;
    }
    
    self.itemsArr = [NSMutableArray array];
    [self settingData];
}

- (void)settingData{
    
    CGFloat width = (self.contentView.frame.size.width - 40) / 3;
    
    for (NSInteger i = 0; i < _squareM.urlArr.count; i++) {
        UIImageView *imageView = [self.imageArray objectAtIndex:i];
        [imageView setHidden:NO];
        NineSquareUrlModel *urlModel = [_squareM.urlArr objectAtIndex:i];
        [imageView sd_setImageWithURL:[NSURL URLWithString:urlModel.url] placeholderImage:nil];
        NSInteger row = i / 3;
        NSInteger col = i % 3;
        CGFloat x = 10 + col * (10 + width);
        CGFloat y = 10 + row * (10 + width);
        imageView.frame = CGRectMake(x, y, width, width);
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewIBAction:)]];
/****************************** == 添加 控件和url == ********************************/
        KNPhotoItems *items = [[KNPhotoItems alloc] init];
        items.url = [urlModel.url stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
        items.sourceView = imageView;
        [self.itemsArr addObject:items];
    }
    
    switch (_squareM.urlArr.count) {
        case 1:
        case 2:
        case 3:
            _cellHeight = width + 20;
            break;
        case 4:
        case 5:
        case 6:
            _cellHeight = (width + 20) * 2;
            break;
        case 7:
        case 8:
        case 9:
            _cellHeight = (width + 20) * 3;
            break;
        default:
            break;
    }
}

- (void)imageViewIBAction:(UITapGestureRecognizer *)tap{
    KNPhotoBrowser *photoBrower = [[KNPhotoBrowser alloc] init];
    photoBrower.itemsArr = [self.itemsArr copy];
    photoBrower.currentIndex = tap.view.tag;
    photoBrower.isNeedPageControl = true;
    photoBrower.isNeedPageNumView = true;
    [photoBrower present];
    [photoBrower setDelegate:self];
}

/****************************** == 代理方法 == ********************************/
/* PhotoBrower 右上角按钮的点击 */
- (void)photoBrowerRightOperationActionWithIndex:(NSInteger)index{
    NSLog(@"operation:%zd",index);
}

/**
 *  删除当前图片
 *
 *  @param index 相对 下标
 */
- (void)photoBrowerRightOperationDeleteImageSuccessWithRelativeIndex:(NSInteger)index{
    NSLog(@"delete-Relative:%zd",index);
}

/**
 *  删除当前图片
 *
 *  @param index 绝对 下标
 */
- (void)photoBrowerRightOperationDeleteImageSuccessWithAbsoluteIndex:(NSInteger)index{
    NSLog(@"delete-Absolute:%zd",index);
}

/* PhotoBrower 保存图片是否成功 */
- (void)photoBrowerWriteToSavedPhotosAlbumStatus:(BOOL)success{
    NSLog(@"saveImage:%d",success);
}

@end
