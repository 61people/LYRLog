//
//  LYRLogProcessor.h
//  LYRLog
//
//  Created by 61people on 2020/8/27.
//  Copyright © 2020 LYR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LYRLogEngine.h"

NS_ASSUME_NONNULL_BEGIN

@interface LYRLogProcessor : NSObject

/// offset from Greenwich Mean Time, -12 to 12, default is Beijing +8
@property (nonatomic, assign) NSInteger baselineGMT;

- (NSString *)logStringWithLevel:(LYRLogLevel)level module:(NSString *)module format:(NSString *)format args:(va_list)args;
@end

NS_ASSUME_NONNULL_END
