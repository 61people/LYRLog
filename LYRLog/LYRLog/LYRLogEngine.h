//
//  LYRLogEngine.h
//  LYRLog
//
//  Created by 61people on 2020/8/18.
//  Copyright © 2020 LYR. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, LYRLogLevel) {
    LYRLogLevelDebug = 0,
    LYRLogLevelGray = 1,
    LYRLogLevelOnline =2
};
NS_ASSUME_NONNULL_BEGIN

@interface LYRLogEngine : NSObject



@end

NS_ASSUME_NONNULL_END
