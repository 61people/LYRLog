//
//  LYRLogWriter.h
//  LYRLog
//
//  Created by 刘奕任 on 2020/8/31.
//  Copyright © 2020 LYR. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LYRLogWriter;

@protocol LYRLogWriterDelegate <NSObject>
@required
- (NSArray<NSString *> *)writeLogWithLogWriter:(LYRLogWriter *)logWriter;

@end

@interface LYRLogWriter : NSObject
@property (nonatomic, copy) NSString *basePath;
@property (nonatomic, weak) id<LYRLogWriterDelegate> delegate;

- (NSString *)logFileNameFromLogStr:(NSString *)logStr;

- (void)writeLog;
@end

NS_ASSUME_NONNULL_END
