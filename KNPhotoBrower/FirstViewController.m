//
//  FirstViewController.m
//  KNPhotoBrower
//
//  Created by LuKane on 16/9/1.
//  Copyright © 2016年 LuKane. All rights reserved.
//

#import "FirstViewController.h"
#import "ViewController.h"

@interface FirstViewController (){
    BOOL     _isHidden;
    UIView  *_view;
}

@property (nonatomic, strong) NSMutableArray *urlArray;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 100, 50);
    btn.center = self.view.center;
    [btn setTitle:@"跳转" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(Click) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
}

- (void)Click{
    ViewController  *vc = [[ViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}




@end
