//
//  KNActionSheetItem.h
//  test
//
//  Created by LuKane on 2019/12/18.
//  Copyright © 2019 LuKane. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol KNActionSheetItemDelegate <NSObject>

/// item did click
/// @param index self's tag
- (void)actionSheetItemDidClick:(NSInteger)index;

@end

@interface KNActionSheetItem : UIView

/// delegate
@property (nonatomic,weak  ) id<KNActionSheetItemDelegate> delegate;

/// title
@property (nonatomic,copy  ) NSString *title;

/// title color
@property (nonatomic,copy  ) UIColor *color;

@end

NS_ASSUME_NONNULL_END
