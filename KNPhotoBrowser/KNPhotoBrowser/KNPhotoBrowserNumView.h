//
//  KNPhotoBrowserNumView.h
//  KNPhotoBrowser
//
//  Created by LuKane on 16/9/2.
//  Copyright © 2016年 LuKane. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KNPhotoBrowserNumView : UILabel

- (void)setCurrentNum:(NSInteger)currentNum totalNum:(NSInteger)totalNum;

@property (nonatomic, assign) NSInteger currentNum;
@property (nonatomic, assign) NSInteger totalNum;

@end
