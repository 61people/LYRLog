//
//  LYRLogQueue.h
//  LYRLog
//
//  Created by 61people on 2020/8/31.
//  Copyright © 2020 LYR. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LYRLogNode : NSObject

@property (nonatomic, strong) LYRLogNode *next;
@property (nonatomic, copy) NSString *nodeName;
@property (nonatomic, strong) NSMutableArray<NSString *> *logStringQueue;

@end

@interface LYRLogQueue : NSObject
- (void)enqueueLogString:(NSString *)logString;
- (NSArray<NSString *> *)dequeueAllLogString;
- (LYRLogNode *)dequeueAllLogStringToNode;
@end

NS_ASSUME_NONNULL_END
