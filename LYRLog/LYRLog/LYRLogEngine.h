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

@property (nonatomic, copy) NSString *basePath;
@property (nonatomic, assign) LYRLogLevel level;

+ (instancetype)sharedInstance;

- (void)logWithLevel:(LYRLogLevel)level module:(NSString *)module format:(NSString *)format, ...;

@end

NS_ASSUME_NONNULL_END
