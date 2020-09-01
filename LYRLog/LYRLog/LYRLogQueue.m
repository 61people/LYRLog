//
//  LYRLogQueue.m
//  LYRLog
//
//  Created by 61people on 2020/8/31.
//  Copyright © 2020 LYR. All rights reserved.
//

#import "LYRLogQueue.h"

@interface LYRLogSubQueue : NSObject
@property (nonatomic, strong) NSMutableArray<NSString *> *logStringQueue;

@property (nonatomic, strong) LYRLogSubQueue *nextSubQueue;
//@property (nonatomic, copy)
@end

@implementation LYRLogSubQueue

- (instancetype)init {
    if (self = [super init]) {
        _logStringQueue = [NSMutableArray array];
    }
    return self;
}

- (void)enqueueLogString:(NSString *)logString {
    if (logString.length <= 0) {
        return;
    }
    [self.logStringQueue addObject:logString];
}

- (NSArray<NSString *> *)dequeueAllLogString {
    NSArray *allLogStringArr = [self.logStringQueue copy];
    [self.logStringQueue removeAllObjects];
    return allLogStringArr;
}

@end

@interface LYRLogQueue ()

@property (nonatomic, strong) dispatch_semaphore_t logSemaphore;

@property (nonatomic, strong) LYRLogSubQueue *subQueueHead;
@property (nonatomic, strong) LYRLogSubQueue *subQueueTail;
@end

@implementation LYRLogQueue

- (instancetype)init {
    if (self = [super init]) {
        _subQueueHead = [[LYRLogSubQueue alloc] init];
        _subQueueTail = _subQueueHead;
        _logSemaphore = dispatch_semaphore_create(1);
    }
    return self;
}

- (void)enqueueLogString:(NSString *)logString {
    dispatch_semaphore_wait(self.logSemaphore, DISPATCH_TIME_FOREVER);
    [self.subQueueTail enqueueLogString:logString];
    dispatch_semaphore_signal(self.logSemaphore);
}

- (NSArray<NSString *> *)dequeueAllLogString {
    NSArray *allLogStringArr = nil;
    dispatch_semaphore_wait(self.logSemaphore, DISPATCH_TIME_FOREVER);
    allLogStringArr = [self.subQueueTail dequeueAllLogString];
    dispatch_semaphore_signal(self.logSemaphore);
    return allLogStringArr;
}
@end
