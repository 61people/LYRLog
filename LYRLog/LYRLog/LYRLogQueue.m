//
//  LYRLogQueue.m
//  LYRLog
//
//  Created by 61people on 2020/8/31.
//  Copyright © 2020 LYR. All rights reserved.
//

#import "LYRLogQueue.h"

@implementation LYRLogNode

- (instancetype)init {
    
    if (self = [super init]) {
        _logStringQueue = [NSMutableArray array];
    }
    return self;
}

@end

@interface LYRLogQueue ()

@property (nonatomic, strong) dispatch_semaphore_t logSemaphore;
@property (nonatomic, strong) NSMutableArray<NSString *> *logStringQueue;
@end

@implementation LYRLogQueue

- (instancetype)init {
    if (self = [super init]) {
        _logStringQueue = [NSMutableArray array];
        _logSemaphore = dispatch_semaphore_create(1);
    }
    return self;
}

- (void)enqueueLogString:(NSString *)logString {
    if (logString.length <= 0) {
        return;
    }
    dispatch_semaphore_wait(self.logSemaphore, DISPATCH_TIME_FOREVER);
    [self.logStringQueue addObject:logString];
    dispatch_semaphore_signal(self.logSemaphore);
}

- (NSArray<NSString *> *)dequeueAllLogString {
    NSArray *allLogStringArr = nil;
    dispatch_semaphore_wait(self.logSemaphore, DISPATCH_TIME_FOREVER);
    allLogStringArr = [self.logStringQueue copy];
    [self.logStringQueue removeAllObjects];
    dispatch_semaphore_signal(self.logSemaphore);
    return allLogStringArr;
}

- (LYRLogNode *)dequeueAllLogStringToNode {
    NSArray *allLogStringArr = [self dequeueAllLogString];
    return [self createLogNodeWithLogStringArr:allLogStringArr];
}

- (LYRLogNode *)createLogNodeWithLogStringArr:(NSArray *)logStringArr {
    LYRLogNode *head = nil;
    LYRLogNode *node = nil;
    for (NSString *logString in logStringArr) {
        NSString *time = [self timeFromLogString:logString];
        if (!node || ![node.nodeName isEqualToString:time]) {
            LYRLogNode *next = [[LYRLogNode alloc] init];
            next.nodeName = time;
            node.next = next;
            node = next;
            
            if (!head) {
                head = node;
            }
        }
        
        [node.logStringQueue addObject:logString];
        
    }
    return head;
}

- (NSString *)timeFromLogString:(NSString *)logString {
    if (logString.length < 13) {
        return nil;
    }
    NSString *time = [logString substringToIndex:13];
    return time;
}
@end
