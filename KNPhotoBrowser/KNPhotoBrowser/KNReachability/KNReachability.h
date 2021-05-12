//
//  KNReachability.h
//  KNPhotoBrowser
//
//  Created by LuKane on 2021/3/19.
//  Copyright © 2021 LuKane. All rights reserved.

//  ***************************************
//  **** this class is from the github ****
//  ***************************************

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString *const kKNReachabilityChangedNotification;

typedef NS_ENUM(NSInteger, NetworkStatus) {
    NotReachable = 0,
    ReachableViaWiFi = 2,
    ReachableViaWWAN = 1
};

@class KNReachability;

typedef void (^NetworkReachable)(KNReachability * reachability);
typedef void (^NetworkUnreachable)(KNReachability * reachability);
typedef void (^NetworkReachability)(KNReachability * reachability, SCNetworkConnectionFlags flags);

@interface KNReachability : NSObject

@property (nonatomic, copy, nullable) NetworkReachable    reachableBlock;
@property (nonatomic, copy, nullable) NetworkUnreachable  unreachableBlock;
@property (nonatomic, copy, nullable) NetworkReachability reachabilityBlock;

@property (nonatomic, assign) BOOL reachableOnWWAN;

+ (instancetype)reachabilityWithHostname:(NSString*)hostname;
+ (instancetype)reachabilityWithHostName:(NSString*)hostname;
+ (instancetype)reachabilityForInternetConnection;
+ (instancetype)reachabilityWithAddress:(void *)hostAddress;
+ (instancetype)reachabilityForLocalWiFi;

- (instancetype)initWithReachabilityRef:(SCNetworkReachabilityRef)ref;
- (BOOL)startNotifier;
- (void)stopNotifier;
- (BOOL)isReachable;
- (BOOL)isReachableViaWWAN;
- (BOOL)isReachableViaWiFi;
- (BOOL)isConnectionRequired;
- (BOOL)connectionRequired;
- (BOOL)isConnectionOnDemand;
- (BOOL)isInterventionRequired;
- (NetworkStatus)currentReachabilityStatus;
- (SCNetworkReachabilityFlags)reachabilityFlags;
- (NSString *)currentReachabilityString;
- (NSString *)currentReachabilityFlags;


@end

NS_ASSUME_NONNULL_END
