//
//  KNPhotoPlayerProtocol.h
//  KNPhotoBrowser
//
//  Created by LuKane on 2021/5/12.
//  Copyright © 2021 LuKane. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol KNPhotoPlayerViewDelegate <NSObject>

/**
 avplayer dimiss
 */
- (void)photoPlayerViewDismiss;
/**
 avplayer long press
 */
- (void)photoPlayerLongPress:(UILongPressGestureRecognizer *)longPress;

@end

NS_ASSUME_NONNULL_END
