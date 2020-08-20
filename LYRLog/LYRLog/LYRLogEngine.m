//
//  LYRLogEngine.m
//  LYRLog
//
//  Created by 61people on 2020/8/18.
//  Copyright © 2020 LYR. All rights reserved.
//

#import "LYRLogEngine.h"
@interface LYRLogEngine ()

@property (nonatomic, strong) NSMutableArray<NSString *> *logStrQueue;
@property (nonatomic, strong) dispatch_queue_t writeFileSerialQueue;
@property (nonatomic, strong) dispatch_semaphore_t logStrSemaphore;

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
    }
    return self;
}

- (void)logWithLevel:(LYRLogLevel)level module:(NSString *)module format:(NSString *)format, ... {
    
    if (level > self.level) {
        // if we set self.level = LYRLogLevelGray,
        // only paramter level who smaller or equl self.level can log,
        // that means LYRLogLevelOnline and LYRLogLevelGray can log
        // LYRLogLevelDebug can't
        return;
    }
    
    NSString *prefix = [NSString stringWithFormat:@"%@: %@", module, format];
    
    va_list args;
    va_start(args, format);
    NSString *fullLogStr = [[NSString alloc] initWithFormat:prefix arguments:args];
    printf("%s\n", [fullLogStr UTF8String]);
    [self enqueueLogStr:fullLogStr];
    va_end(args);
}

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

- (void)writeLog {
    
}

@end
