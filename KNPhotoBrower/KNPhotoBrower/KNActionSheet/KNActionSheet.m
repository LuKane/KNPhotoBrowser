//
//  KNActionSheet.m
//  KNActionSheet
//
//  Created by LuKane on 16/9/5.
//  Copyright © 2016年 LuKane. All rights reserved.
//

#import "KNActionSheet.h"
#import "KNActionSheetView.h"

#ifndef ScreenWidth
    #define ScreenWidth [UIScreen mainScreen].bounds.size.width
#endif

#ifndef ScreenHeight
    #define ScreenHeight [UIScreen mainScreen].bounds.size.height
#endif

#define kActionCoverBackGroundColor [UIColor colorWithRed:30/255.f green:30/255.f blue:30/255.f alpha:1.f]
#define kActionBgViewBackGroundColor [UIColor colorWithRed:220/255.f green:220/255.f blue:220/255.f alpha:1.f]
#define kActionDuration 0.3
#define kActionItemHeight 49

@interface KNActionSheet()<KNActionSheetViewDelegate>

@property (nonatomic, copy) ActionBlock ActionBlock;

@end


@implementation KNActionSheet{
    NSString *_cancelBtnTitle;
    NSString *_destructiveBtnTitle;
    NSArray  *_otherBtnTitlesArr;
    
    UIView   *_bgView; // 存放子控件的View
    UIView   *_coverView; // 背景遮盖
    
    NSInteger _destructiveIndex;
}

static id ActionSheet;
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(!ActionSheet){
            ActionSheet = [super allocWithZone:zone];
        }
    });
    return ActionSheet;
}


#pragma mark - 初始化 子控件
- (void)setupSubViews{
    
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    [self setFrame:[[UIScreen mainScreen] bounds]];
    [self setBackgroundColor:[UIColor clearColor]];
    [self setHidden:YES];
    
    UIView *coverView = [[UIView alloc] initWithFrame:[self bounds]];
    _coverView = coverView;
    [coverView setBackgroundColor:kActionCoverBackGroundColor];
    [coverView setAlpha:0.f];
    [coverView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)]];
    [self addSubview:coverView];
    
    UIView *bgView = [[UIView alloc] init];
    [bgView setBackgroundColor:kActionBgViewBackGroundColor];
    _bgView = bgView;
    [self addSubview:bgView];
    
    for (NSInteger i = 0; i < _otherBtnTitlesArr.count; i++) {   
        KNActionSheetView *sheetView = [[KNActionSheetView alloc] init];
        [sheetView setTag:i];
        [sheetView setDelegate:self];
        
        CGFloat buttonY = kActionItemHeight * i;
        [sheetView setFrame:(CGRect){{0,buttonY},{ScreenWidth,kActionItemHeight}}];
        
        if (i == _destructiveIndex && _destructiveBtnTitle.length){
            [sheetView setIsDestructive:YES];
        }
        
        [sheetView setTitle:_otherBtnTitlesArr[i]];
        [_bgView addSubview:sheetView];
        
        CALayer *line = [CALayer layer];
        [line setBackgroundColor: [kActionBgViewBackGroundColor CGColor]];
        line.frame = CGRectMake(0, buttonY, ScreenWidth, 0.5);
        [_bgView.layer addSublayer:line];
    }

    CGFloat height = kActionItemHeight * (_otherBtnTitlesArr.count + 1) + 5;
    KNActionSheetView *cancelView = [[KNActionSheetView alloc] init];
    [cancelView setDelegate:self];
    [cancelView setTag:_otherBtnTitlesArr.count];
    
    CGFloat buttonY = kActionItemHeight * (_otherBtnTitlesArr.count) + 5;
    [cancelView setFrame:(CGRect){{0,buttonY},{ScreenWidth,kActionItemHeight}}];
    
    [cancelView setTitle:_cancelBtnTitle?_cancelBtnTitle:@"取消"];
    [_bgView addSubview:cancelView];
    
    _bgView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, height);
}

- (void)actionSheetViewIBAction:(NSInteger)index{
    if(_ActionBlock){
        _ActionBlock(index);
    }
    [self dismiss];
}

- (void)show{
    [_coverView setAlpha:0];
    [_bgView setTransform:CGAffineTransformIdentity];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    
    [self setHidden:NO];
    
    [UIView animateWithDuration:kActionDuration animations:^{
        [_coverView setAlpha:0.3];
        [_bgView setTransform:CGAffineTransformMakeTranslation(0, -_bgView.frame.size.height)];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismiss{
    [UIView animateWithDuration:kActionDuration animations:^{
        [_coverView setAlpha:0];
        [_bgView setTransform:CGAffineTransformIdentity];
    } completion:^(BOOL finished) {
        [self setHidden:YES];
        [self removeFromSuperview];
    }];
}

/**
 弹出层
 
 @param cancelTitle 取消功能的文字
 @param otherTitleArr 其他功能的文字 数组
 @param ActionBlock 回调
 @return 弹出层本身
 */
- (instancetype)initWithCancelTitle:(NSString *)cancelTitle
                      otherTitleArr:(NSArray  *)otherTitleArr
                        actionBlock:(ActionBlock)ActionBlock{
    return [self initWithCancelTitle:cancelTitle
                    destructiveTitle:nil
                       otherTitleArr:[otherTitleArr copy]
                         actionBlock:ActionBlock];
}

/**
 弹出层 + 销毁
 
 @param cancelTitle 取消功能的文字
 @param destructiveTitle 标红 的文字
 @param otherTitleArr 其他功能的文字 数组
 @param ActionBlock 回调
 @return 弹出层本身
 */
- (instancetype)initWithCancelTitle:(NSString *)cancelTitle
                   destructiveTitle:(NSString *)destructiveTitle
                      otherTitleArr:(NSArray  *)otherTitleArr
                        actionBlock:(ActionBlock)ActionBlock{
    return [self initWithCancelTitle:cancelTitle
                    destructiveTitle:destructiveTitle
                    destructiveIndex:0
                       otherTitleArr:[otherTitleArr copy]
                         actionBlock:ActionBlock];
}

/**
 弹出层 + 销毁 + 销毁下标
 
 @param cancelTitle 取消功能的文字
 @param destructiveTitle 标红 的文字
 @param destructiveIndex 标红 的文字 的下标
 @param otherTitleArr 其他功能的文字 数组
 @param ActionBlock 回调
 @return 弹出层本身
 */
- (instancetype)initWithCancelTitle:(NSString *)cancelTitle
                   destructiveTitle:(NSString *)destructiveTitle
                   destructiveIndex:(NSInteger )destructiveIndex
                      otherTitleArr:(NSArray  *)otherTitleArr
                        actionBlock:(ActionBlock)ActionBlock{
    
    if(self = [super init]){
        _cancelBtnTitle = cancelTitle;
        _destructiveBtnTitle = destructiveTitle;
        
        NSMutableArray *titleArr = [NSMutableArray arrayWithArray:otherTitleArr];
        
        if(destructiveTitle.length){
            _destructiveIndex = destructiveIndex;
            [titleArr insertObject:destructiveTitle atIndex:destructiveIndex];
        }
        
        _otherBtnTitlesArr = [NSArray arrayWithArray:titleArr];
        _ActionBlock = ActionBlock;
        
        [self setupSubViews];
    }
    return self;
}

@end
