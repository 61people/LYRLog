//
//  LYRLogEngine.m
//  LYRLog
//
//  Created by 61people on 2020/8/18.
//  Copyright © 2020 LYR. All rights reserved.
//

#import "LYRLogEngine.h"
#import "LYRLogProcessor.h"
#import "LYRLogStreamWriter.h"
#import "LYRLogQueue.h"

@interface LYRLogEngine () <LYRLogWriterDelegate>

@property (nonatomic, strong) LYRLogProcessor *logProcessor;
@property (nonatomic, strong) LYRLogWriter *logWriter;

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
        
        _logProcessor = [[LYRLogProcessor alloc] init];
        
        _logWriter = [[LYRLogStreamWriter alloc] init];
        _logWriter.logQueue = [[LYRLogQueue alloc] init];
        _logWriter.delegate = self;
                
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
    
    va_list args;
    va_start(args, format);
    
    NSString *logString = [self.logProcessor logStringWithLevel:level module:module format:format args:args];
#if DEBUG
    printf("%s\n", [logString UTF8String]);
#endif
    [self.logWriter.logQueue enqueueLogString:logString];
    va_end(args);
}

#pragma mark - write
- (void)writeLog {
    [self.logWriter writeLog];
}

- (void)setBaselineGMT:(NSInteger)baselineGMT {
    self.logProcessor.baselineGMT = baselineGMT;
}

- (NSInteger)baselineGMT {
    return self.logProcessor.baselineGMT;
}

- (NSString *)basePath {
    return self.logWriter.basePath;
}

- (void)setBasePath:(NSString *)basePath {
    self.logWriter.basePath = basePath;
}

@end
