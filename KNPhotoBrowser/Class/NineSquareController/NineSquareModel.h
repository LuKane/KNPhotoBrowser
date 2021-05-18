//
//  NineSquareModel.h
//  KNPhotoBrowser
//
//  Created by LuKane on 2021/5/18.
//  Copyright © 2021 LuKane. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NineSquareItemsModel: NSObject

@property (nonatomic,copy  ) NSString *url;
@property (nonatomic,assign) BOOL isVideo;
@property (nonatomic,assign) BOOL isLocateGif;
@property (nonatomic,copy  ) NSString *placeHolderUrl;

@end

@interface NineSquareModel : NSObject

@property (nonatomic,strong) NSArray *urlArr;

@property (nonatomic,assign) CGFloat cellHeight;

@end

NS_ASSUME_NONNULL_END
