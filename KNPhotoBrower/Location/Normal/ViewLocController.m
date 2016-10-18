//
//  ViewLocController.m
//  KNPhotoBrower
//
//  Created by LuKane on 2016/10/18.
//  Copyright © 2016年 LuKane. All rights reserved.
//

#import "ViewLocController.h"
#import "KNPhotoBrower.h"

@interface ViewLocController ()

@property (nonatomic, strong) NSMutableArray *itemsArray;

@end

@implementation ViewLocController

- (NSMutableArray *)itemsArray{
    if (!_itemsArray) {
        _itemsArray = [NSMutableArray array];
    }
    return _itemsArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Normal(本地)";
    
    CGFloat viewWidth = self.view.frame.size.width;
    // 背景View =======================
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 100, viewWidth - 20, viewWidth - 20)];
    view.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:view];
    
    
    NSMutableArray *imageArr = [NSMutableArray array];
    [imageArr addObject:[UIImage imageNamed:@"1.jpg"]];
    [imageArr addObject:[UIImage imageNamed:@"2.jpg"]];
    [imageArr addObject:[UIImage imageNamed:@"3.jpg"]];
    [imageArr addObject:[UIImage imageNamed:@"4.jpg"]];
    [imageArr addObject:[UIImage imageNamed:@"5.jpg"]];
    [imageArr addObject:[UIImage imageNamed:@"6.jpg"]];
    [imageArr addObject:[UIImage imageNamed:@"7.jpg"]];
    [imageArr addObject:[UIImage imageNamed:@"8.jpg"]];
    [imageArr addObject:[UIImage imageNamed:@"9.jpg"]];
    
    for (NSInteger i = 0 ;i < imageArr.count; i ++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)]];
        imageView.tag = i;
        imageView.image = imageArr[i];
        
        imageView.backgroundColor = [UIColor grayColor];
        
        CGFloat width = (view.frame.size.width - 40) / 3;
        NSInteger row = i / 3;
        NSInteger col = i % 3;
        CGFloat x = 10 + col * (10 + width);
        CGFloat y = 10 + row * (10 + width);
        imageView.frame = CGRectMake(x, y, width, width);
        
        KNPhotoItems *items = [[KNPhotoItems alloc] init];
        items.sourceView = imageView;
        [self.itemsArray addObject:items];
        
        [view addSubview:imageView];
    }
}

- (void)click:(UITapGestureRecognizer *)tap{
    KNPhotoBrower *photoBrower = [[KNPhotoBrower alloc] init];
    photoBrower.itemsArr = [_itemsArray copy];
    photoBrower.currentIndex = tap.view.tag;
    
//    photoBrower.isLocationImage = YES; // ⭐️
    
    [photoBrower present];
}



@end
