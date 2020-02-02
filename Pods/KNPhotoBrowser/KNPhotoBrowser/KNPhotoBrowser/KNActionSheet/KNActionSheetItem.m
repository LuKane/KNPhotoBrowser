//
//  KNActionSheetItem.m
//  test
//
//  Created by LuKane on 2019/12/18.
//  Copyright © 2019 LuKane. All rights reserved.
//

#import "KNActionSheetItem.h"

@implementation KNActionSheetItem

- (instancetype)init{
    if (self = [super init]) {
        _color = [UIColor blackColor];
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self setBackgroundColor:[UIColor colorWithRed:220 / 255.f green:220 / 255.f blue:220 / 255.f alpha:1.f]];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self setBackgroundColor:[UIColor whiteColor]];
    [self setAlpha:1.f];
    
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint point = [touch locationInView:[touch view]];
    
    CGFloat x = point.x;
    CGFloat y = point.y;
    
    if(x < self.frame.size.width && x > 0 && y >0 && y < self.frame.size.height){
        if([_delegate respondsToSelector:@selector(actionSheetItemDidClick:)]){
            [_delegate actionSheetItemDidClick:self.tag];
        }
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self setBackgroundColor:[UIColor whiteColor]];
    [self setAlpha:1.f];
}

- (void)setTitle:(NSString *)title{
    _title = title;
    [self setNeedsDisplay];
}

- (void)setColor:(UIColor *)color{
    _color = color;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = [UIFont systemFontOfSize:16];
    dict[NSForegroundColorAttributeName] = _color;
    
    NSMutableParagraphStyle *paragrap = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    paragrap.alignment = NSTextAlignmentCenter;
    
    dict[NSParagraphStyleAttributeName] = paragrap;
    [_title drawInRect:(CGRect){{0,self.bounds.size.height * 0.3},self.bounds.size} withAttributes:dict];
}

@end
