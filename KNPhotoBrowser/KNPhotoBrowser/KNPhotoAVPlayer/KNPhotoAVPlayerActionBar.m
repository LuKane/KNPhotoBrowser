//
//  KNPhotoAVPlayerActionBar.m
//  KNPhotoBrowser
//
//  Created by LuKane on 2019/6/14.
//  Copyright © 2019 LuKane. All rights reserved.
//

#import "KNPhotoAVPlayerActionBar.h"
#import <objc/runtime.h>

@interface KNPhotoAVPlayerSlider : UISlider

@end

@implementation KNPhotoAVPlayerSlider

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        NSBundle *bundle = [NSBundle bundleForClass:NSClassFromString(@"KNPhotoBrowser")];
        if(UIScreen.mainScreen.scale < 3) {
            [self setThumbImage:[UIImage imageNamed:@"KNPhotoBrowser.bundle/circlePoint@2x.png" inBundle:bundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        }else {
            [self setThumbImage:[UIImage imageNamed:@"KNPhotoBrowser.bundle/circlePoint@3x.png" inBundle:bundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        }
        [self setMinimumTrackTintColor:[UIColor whiteColor]];
        [self setMaximumTrackTintColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5]];
    }
    return self;
}
- (CGRect)minimumValueImageRectForBounds:(CGRect)bounds{
    CGRect frame = [super minimumValueImageRectForBounds:bounds];
    return CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 15);
}
- (CGRect)maximumValueImageRectForBounds:(CGRect)bounds{
    CGRect frame = [super maximumValueImageRectForBounds:bounds];
    return CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 15);
}
- (CGRect)trackRectForBounds:(CGRect)bounds{
    CGRect frame = [super trackRectForBounds:bounds];
    return CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 3);
}
- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value {
    CGRect frame = [super thumbRectForBounds:bounds trackRect:rect value:value];
    return CGRectMake(frame.origin.x - 10, frame.origin.y - 10, frame.size.width + 20, frame.size.height + 20);
}

@end

@interface KNPhotoAVPlayerActionBar ()

@property (nonatomic,strong) UIButton *pauseStopBtn;
@property (nonatomic,strong) UILabel *preTimeLabel;
@property (nonatomic,strong) UILabel *endTimeLabel;
@property (nonatomic,strong) KNPhotoAVPlayerSlider *slider;
@property (nonatomic,strong) NSBundle *bundle;

@end

@implementation KNPhotoAVPlayerActionBar {
    BOOL _isDragging;
}

/****************************** == lazy == ********************************/

- (NSBundle *)bundle {
    if (!_bundle) {
        _bundle = [NSBundle bundleForClass:NSClassFromString(@"KNPhotoBrowser")];
    }
    return _bundle;
}

- (UIButton *)pauseStopBtn{
    if (!_pauseStopBtn) {
        _pauseStopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        if(UIScreen.mainScreen.scale < 3) {
            [_pauseStopBtn setImage:[UIImage imageNamed:@"KNPhotoBrowser.bundle/pause@2x.png" inBundle:self.bundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        }else {
            [_pauseStopBtn setImage:[UIImage imageNamed:@"KNPhotoBrowser.bundle/pause@3x.png" inBundle:self.bundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        }
        [_pauseStopBtn addTarget:self action:@selector(pauseStopBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pauseStopBtn;
}

- (UILabel *)preTimeLabel{
    if (!_preTimeLabel) {
        _preTimeLabel = [UILabel new];
        [_preTimeLabel setText:@"00:00"];
        [_preTimeLabel setFont:[UIFont systemFontOfSize:11]];
        [_preTimeLabel setTextAlignment:NSTextAlignmentCenter];
        [_preTimeLabel setAdjustsFontSizeToFitWidth:true];
        [_preTimeLabel setTextColor:UIColor.whiteColor];
    }
    return _preTimeLabel;
}

- (UILabel *)endTimeLabel{
    if (!_endTimeLabel) {
        _endTimeLabel = [[UILabel alloc] init];
        [_endTimeLabel setText:self.preTimeLabel.text];
        [_endTimeLabel setFont:self.preTimeLabel.font];
        [_endTimeLabel setTextColor:self.preTimeLabel.textColor];
        [_endTimeLabel setAdjustsFontSizeToFitWidth:true];
        [_endTimeLabel setTextAlignment:self.preTimeLabel.textAlignment];
    }
    return _endTimeLabel;
}

- (KNPhotoAVPlayerSlider *)slider{
    if (!_slider) {
        _slider = [[KNPhotoAVPlayerSlider alloc] init];
        [_slider addTarget:self action:@selector(actionBarSliderFinished:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchUpOutside];
        [_slider addTarget:self action:@selector(actionBarSliderDown:) forControlEvents:UIControlEventTouchDown];
    }
    return _slider;
}

/****************************** == lazy == ********************************/

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 5;
        self.clipsToBounds = true;
        [self addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragViewMoved:)]];
        [self addSubview:self.pauseStopBtn];
        [self addSubview:self.preTimeLabel];
        [self addSubview:self.endTimeLabel];
        [self addSubview:self.slider];
    }
    return self;
}

- (void)dragViewMoved:(UIPanGestureRecognizer *)panGestureRecognizer{
    
}

- (void)pauseStopBtnDidClick{
    if ([_delegate respondsToSelector:@selector(photoAVPlayerActionBarClickWithIsPlay:)]) {
        [_delegate photoAVPlayerActionBarClickWithIsPlay:!_isPlaying];
    }
}

- (void)actionBarSliderFinished:(KNPhotoAVPlayerSlider *)slider{
    if ([_delegate respondsToSelector:@selector(photoAVPlayerActionBarChangeValue:)]) {
        [_delegate photoAVPlayerActionBarChangeValue:slider.value];
    }
    _isDragging = false;
   [_slider setUserInteractionEnabled:true];
}
- (void)actionBarSliderDown:(KNPhotoAVPlayerSlider *)slider{
    _isDragging = true;
    if ([_delegate respondsToSelector:@selector(photoAVPlayerActionBarBeginChange)]) {
        [_delegate photoAVPlayerActionBarBeginChange];
    }
    [slider setUserInteractionEnabled:false];
}

- (void)setIsPlaying:(BOOL)isPlaying{
    _isPlaying = isPlaying;
    
    if (isPlaying) {
        _isDragging = false;
        [_slider setUserInteractionEnabled:true];
        if(UIScreen.mainScreen.scale < 3) {
            [_pauseStopBtn setImage:[UIImage imageNamed:@"KNPhotoBrowser.bundle/pause@2x.png" inBundle:self.bundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        }else {
            [_pauseStopBtn setImage:[UIImage imageNamed:@"KNPhotoBrowser.bundle/pause@3x.png" inBundle:self.bundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        }
    }else{
        if(UIScreen.mainScreen.scale < 3) {
            [_pauseStopBtn setImage:[UIImage imageNamed:@"KNPhotoBrowser.bundle/play@2x.png" inBundle:self.bundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        }else {
            [_pauseStopBtn setImage:[UIImage imageNamed:@"KNPhotoBrowser.bundle/play@3x.png" inBundle:self.bundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        }
    }
}

- (void)setCurrentTime:(float)currentTime{
    if (isnan(currentTime)) return;
    _currentTime = currentTime;
    [_preTimeLabel setText:[self caluTimeFormatWithSeconds:currentTime]];
    
    if (_isDragging == false) {
        [_slider setValue:currentTime animated:false];
    }
}

- (void)setAllDuration:(float)allDuration{
    if (isnan(allDuration)) return;
    _allDuration = allDuration;
    _slider.maximumValue = allDuration;
    [_endTimeLabel setText:[self caluTimeFormatWithSeconds:allDuration]];
}

- (NSString *)caluTimeFormatWithSeconds:(NSInteger)seconds{
    if(seconds > 60 * 60){ // one hour or more than
        return [NSString stringWithFormat:@"%02zd:%02zd:%02zd",(NSInteger)(seconds / 3600),(NSInteger)((seconds % 3600) / 60) , (NSInteger)(seconds % 60)];
    }else{ // in one hour
        return [NSString stringWithFormat:@"%02zd:%02zd", (NSInteger)((seconds % 3600) / 60), (NSInteger)(seconds % 60)];
    }
}

- (void)resetActionBarAllInfo{
    self.isPlaying = false;
    _preTimeLabel.text = @"00:00";
    _endTimeLabel.text = @"00:00";
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.pauseStopBtn.frame = CGRectMake(10, 10, 20, 20);
    self.preTimeLabel.frame = CGRectMake(30, 5, 55, 30);
    self.endTimeLabel.frame = CGRectMake(self.bounds.size.width - 55, 5, 55, 30);
    self.slider.frame       = CGRectMake(85, 0, CGRectGetMinX(self.endTimeLabel.frame) - CGRectGetMaxX(self.preTimeLabel.frame), 40);
}

@end
