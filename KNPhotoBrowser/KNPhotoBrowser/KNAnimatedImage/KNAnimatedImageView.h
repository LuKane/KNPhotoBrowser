//
//  KNAnimatedImageView.h
//  KNPhotoBrowser
//
//  Created by LuKane on 2020/3/12.
//  Copyright © 2020 LuKane. All rights reserved.
//  copy it with FLAnimatedImage

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class KNAnimatedImage;

@interface KNAnimatedImageView : UIImageView

@property (nonatomic, strong) KNAnimatedImage *animatedImage;
@property (nonatomic, copy) void(^loopCompletionBlock)(NSUInteger loopCountRemaining);

@property (nonatomic, strong, readonly) UIImage *currentFrame;
@property (nonatomic, assign, readonly) NSUInteger currentFrameIndex;

@property (nonatomic, copy) NSString *runLoopMode;

@end

NS_ASSUME_NONNULL_END
