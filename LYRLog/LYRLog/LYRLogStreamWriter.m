//
//  LYRLogStreamWriter.m
//  LYRLog
//
//  Created by 61people on 2020/8/28.
//  Copyright © 2020 LYR. All rights reserved.
//

#import "LYRLogStreamWriter.h"
#import "LYRLogWriter+Private.h"

@interface LYRLogStreamWriter ()

@property (nonatomic, strong) dispatch_queue_t writeFileSerialQueue;
@property (nonatomic, strong) NSOutputStream *outputStream;

@property (nonatomic, copy) NSString *outputFileName;

@end

@implementation LYRLogStreamWriter

- (instancetype)init {
    if (self = [super init]) {
        _writeFileSerialQueue = dispatch_queue_create("com.lyr.lyrlog.writequeue", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)writeLog {
    if (!self.basePath) {
        return;
    }

    dispatch_async(self.writeFileSerialQueue, ^{
        
        [self.outputStream open];
        for (LYRLogNode *logNode in [self.logQueue dequeueAllLogStringToNode]) {
            NSString *fileName = [logNode.nodeName stringByAppendingString:@".log"];
            
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
            
            for (NSString *logString in logNode.logStringQueue) {
                NSData *logData = [[logString stringByAppendingString:@"\n"] dataUsingEncoding:NSUTF8StringEncoding];
                [self.outputStream write:[logData bytes]  maxLength:[logData length]];
            }
            
        }
        [self.outputStream close];
                    
    });
}


@end
