//
//  LYRLogWriter.h
//  LYRLog
//
//  Created by 61people on 2020/8/31.
//  Copyright © 2020 LYR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LYRLogQueue.h"


NS_ASSUME_NONNULL_BEGIN

@class LYRLogWriter;

@protocol LYRLogWriterDelegate <NSObject>
@required
- (NSArray<NSString *> *)writeLogWithLogWriter:(LYRLogWriter *)logWriter;

@end

@interface LYRLogWriter : NSObject
@property (nonatomic, copy) NSString *basePath;
@property (nonatomic, weak) id<LYRLogWriterDelegate> delegate;
@property (nonatomic, strong) LYRLogQueue *logQueue;

- (void)writeLog;


@end

NS_ASSUME_NONNULL_END
