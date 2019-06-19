//
//  KNPhotoAVPlayerView.h
//  KNPhotoBrowser
//
//  Created by LuKane on 2019/6/14.
//  Copyright © 2019 LuKane. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KNPhotoAVPlayerView : UIView

- (instancetype)initWithFrame:(CGRect)frame
                          url:(NSString *)url
                  placeHolder:(UIImage *)placeHolder;

@end

NS_ASSUME_NONNULL_END
