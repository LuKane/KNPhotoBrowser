//
//  KNPhotoAVPlayerActionBar.m
//  KNPhotoBrowser
//
//  Created by LuKane on 2019/6/14.
//  Copyright © 2019 LuKane. All rights reserved.
//

#import "KNPhotoAVPlayerActionBar.h"

@interface KNPhotoAVPlayerSlider : UISlider

@end

@implementation KNPhotoAVPlayerSlider

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setThumbImage:[UIImage imageNamed:@"KNPhotoBrowser.bundle/circlePoint@2x.png"] forState:UIControlStateNormal];
        [self setMinimumTrackTintColor:[UIColor whiteColor]];
        [self setMaximumTrackTintColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5]];
    }
    return self;
}

- (CGRect)trackRectForBounds:(CGRect)bounds{
    CGRect frame = [super trackRectForBounds:bounds];
    return CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 2);
}

- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value {
    CGRect frame = [super thumbRectForBounds:bounds trackRect:rect value:value];
    return CGRectMake(frame.origin.x - 10, frame.origin.y - 10, frame.size.width + 20, frame.size.height + 20);
}

@end

@implementation KNPhotoAVPlayerActionBar


@end
