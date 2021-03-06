//
//  LYRLogEngine.h
//  LYRLog
//
//  Created by 61people on 2020/8/18.
//  Copyright © 2020 LYR. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, LYRLogLevel) {
    LYRLogLevelOnline = 0,
    LYRLogLevelGray = 1,
    LYRLogLevelDebug =2
};

NS_ASSUME_NONNULL_BEGIN

@interface LYRLogEngine : NSObject

@property (nonatomic, assign) LYRLogLevel level;

@property (nonatomic, copy) NSString *basePath;
/// offset from Greenwich Mean Time, -12 to 12, default is Beijing +8
@property (nonatomic, assign) NSInteger baselineGMT;

/// time unit is day, default is 30 days
@property (nonatomic, assign) NSUInteger expiration;

//@property (nonatomic, copy)

+ (instancetype)sharedInstance;

- (void)logWithLevel:(LYRLogLevel)level module:(NSString *)module format:(NSString *)format, ...;

@end

NS_ASSUME_NONNULL_END
