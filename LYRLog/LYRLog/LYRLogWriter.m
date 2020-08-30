//
//  LYRLogWriter.m
//  LYRLog
//
//  Created by 刘奕任 on 2020/8/31.
//  Copyright © 2020 LYR. All rights reserved.
//

#import "LYRLogWriter.h"

@implementation LYRLogWriter

- (NSString *)logFileNameFromLogStr:(NSString *)logStr {
    NSString *timeStamp = [[logStr componentsSeparatedByString:@"|"] firstObject];
    if (timeStamp.length >= 13) {
        return [[timeStamp substringToIndex:13] stringByAppendingString:@".log"];
    }
    else {
        return nil;
    }
}

@end
