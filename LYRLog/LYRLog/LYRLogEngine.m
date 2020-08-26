//
//  LYRLogEngine.m
//  LYRLog
//
//  Created by 61people on 2020/8/18.
//  Copyright © 2020 LYR. All rights reserved.
//

#import "LYRLogEngine.h"

static NSString * const kLYRDateFormatterString = @"yyyy-MM-dd HH:mm:ss.SSS Z";
static NSString * const kLYRLogSeparator = @"|";

@interface LYRLogEngine ()

@property (nonatomic, strong) NSMutableArray<NSString *> *logStrQueue;
@property (nonatomic, strong) dispatch_queue_t writeFileSerialQueue;
@property (nonatomic, strong) dispatch_semaphore_t logStrSemaphore;
@property (nonatomic, strong) NSOutputStream *outputStream;
@property (nonatomic, copy) NSString *outputFileName;


@property (nonatomic, strong) NSDateFormatter *localDateFormatter;
@property (nonatomic, strong) NSDateFormatter *baselineDateFormatter;

@end

@implementation LYRLogEngine

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static LYRLogEngine *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [LYRLogEngine new];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        _logStrQueue = [NSMutableArray array];
        _writeFileSerialQueue = dispatch_queue_create("com.lyr.lyrlog.writequeue", DISPATCH_QUEUE_SERIAL);
        _logStrSemaphore = dispatch_semaphore_create(1);
        _localDateFormatter = [[NSDateFormatter alloc] init];
        [_localDateFormatter setDateFormat:kLYRDateFormatterString];
        
        _baselineGMT = 8;
        _baselineDateFormatter = [[NSDateFormatter alloc] init];
        [_localDateFormatter setDateFormat:kLYRDateFormatterString];
        [_localDateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:_baselineGMT * 60 * 60]];
        
    }
    return self;
}

- (void)logWithLevel:(LYRLogLevel)level module:(NSString *)module format:(NSString *)format, ... {
    
    if (level > self.level) {
        // if we set self.level = LYRLogLevelGray,
        // only paramter level who smaller than or equl to self.level can log,
        // that means LYRLogLevelOnline and LYRLogLevelGray can log
        // LYRLogLevelDebug can't
        return;
    }
    
    NSString *prefix = [NSString stringWithFormat:@"%@|%@: %@", [self timeStamp], module, format];
    
    va_list args;
    va_start(args, format);
    NSString *fullLogStr = [[NSString alloc] initWithFormat:prefix arguments:args];
#if DEBUG
    printf("%s\n", [fullLogStr UTF8String]);
#endif
    [self enqueueLogStr:fullLogStr];
    va_end(args);
}

- (NSString *)timeStamp {
    NSDate *date = [NSDate now];
    
    NSString *timeStamp = [NSString stringWithFormat:@"%@|%@", [self.baselineDateFormatter stringFromDate:date], [self.localDateFormatter stringFromDate:date]];
    
    return timeStamp;
}

#pragma mark - log queue
- (void)enqueueLogStr:(NSString *)logStr {
    if (logStr.length <= 0) {
        return;
    }
    dispatch_semaphore_wait(self.logStrSemaphore, DISPATCH_TIME_FOREVER);
    [self.logStrQueue addObject:logStr];
    dispatch_semaphore_signal(self.logStrSemaphore);
}

- (NSArray<NSString *> *)dequeueAllLogStr {
    NSArray *allLogStrArr = nil;
    dispatch_semaphore_wait(self.logStrSemaphore, DISPATCH_TIME_FOREVER);
    allLogStrArr = [self.logStrQueue copy];
    [self.logStrQueue removeAllObjects];
    dispatch_semaphore_signal(self.logStrSemaphore);
    
    return allLogStrArr;
}

#pragma mark - write
- (void)writeLog {
    if (!self.basePath) {
        return;
    }
    dispatch_async(self.writeFileSerialQueue, ^{
        
        NSString *filePath = [self.basePath stringByAppendingPathComponent:@"test.log"];
        
        [self.outputStream open];
        
        for (NSString *logStr in [self dequeueAllLogStr]) {
            
            NSString *fileName = [self logFileNameFromLogStr:logStr];
            
            if (!self.outputStream) {
                self.outputStream = [[NSOutputStream alloc] initToFileAtPath:[self.basePath stringByAppendingPathComponent:fileName] append:YES];
                self.outputFileName = fileName;
                [self.outputStream open];
            }
            else if (![self.outputFileName isEqualToString:fileName]) {
                [self.outputStream close];
                self.outputStream = [[NSOutputStream alloc] initToFileAtPath:[self.basePath stringByAppendingPathComponent:fileName] append:YES];
                self.outputFileName = fileName;
                [self.outputStream open];
            }
            
            NSData *logData = [[logStr stringByAppendingString:@"\n"] dataUsingEncoding:NSUTF8StringEncoding];
            
            [self.outputStream write:[logData bytes]  maxLength:[logData length]];
        }
        [self.outputStream close];
                    
    });
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
    [self.localDateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:_baselineGMT * 60 * 60]];
}

- (NSString *)logFileNameFromLogStr:(NSString *)logStr {
    NSString *timeStamp = [[logStr componentsSeparatedByString:kLYRLogSeparator] firstObject];
    if (timeStamp.length >= 13) {
        return [timeStamp substringToIndex:12];
    }
    else {
        return nil;
    }
}

@end
