//
//  LYRLogProcessor.m
//  LYRLog
//
//  Created by 61people on 2020/8/27.
//  Copyright © 2020 LYR. All rights reserved.
//

#import "LYRLogProcessor.h"

static NSString * const kLYRDateFormatterString = @"yyyy-MM-dd HH:mm:ss.SSSZ";
static NSString * const kLYRLogSeparator = @"|";

@interface LYRLogProcessor ()

@property (nonatomic, strong) NSDateFormatter *localDateFormatter;
@property (nonatomic, strong) NSDateFormatter *baselineDateFormatter;

@end

@implementation LYRLogProcessor

- (instancetype)init {
    if (self = [super init]) {
        
        _localDateFormatter = [[NSDateFormatter alloc] init];
        [_localDateFormatter setDateFormat:kLYRDateFormatterString];
        
        _baselineGMT = 8;
        _baselineDateFormatter = [[NSDateFormatter alloc] init];
        [_baselineDateFormatter setDateFormat:kLYRDateFormatterString];
        [_baselineDateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:_baselineGMT * 60 * 60]];
    }
    return self;
}

- (NSString *)timeStamp {
    NSDate *date = [NSDate now];
    
    NSString *timeStamp = [NSString stringWithFormat:@"%@|%@", [self.baselineDateFormatter stringFromDate:date], [self.localDateFormatter stringFromDate:date]];
    
    return timeStamp;
}

- (NSString *)logStringWithLevel:(LYRLogLevel)level module:(NSString *)module format:(NSString *)format args:(va_list)args {
    
    NSString *logSuffix = [[NSString alloc] initWithFormat:format arguments:args];
    
    NSArray *logParamArr = @[[self timeStamp], module, logSuffix];
    NSString *logString = [logParamArr componentsJoinedByString:kLYRLogSeparator];
    
    return logString;
}

- (void)setBaselineGMT:(NSInteger)baselineGMT {
    if (baselineGMT > 12) {
        _baselineGMT = 12;
    }
    else if (baselineGMT < -12) {
        _baselineGMT = -12;
    }
    else {
        _baselineGMT = baselineGMT;
    }
    [self.baselineDateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:_baselineGMT * 60 * 60]];
}

@end
