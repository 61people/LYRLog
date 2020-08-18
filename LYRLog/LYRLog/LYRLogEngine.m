//
//  LYRLogEngine.m
//  LYRLog
//
//  Created by LYR on 2020/8/18.
//  Copyright © 2020 LYR. All rights reserved.
//

#import "LYRLogEngine.h"
@interface LYRLogEngine ()
//@property (nonatomic, copy)
@end


@implementation LYRLogEngine
//void LYRlog(NSString *module, NSString *format, ...) {
//
//}
- (void)logWithLevel:(LYRLogLevel)level module:(NSString *)module format:(NSString *)format, ... {
    
    NSString *prefix = [NSString stringWithFormat:@"%@: %@", module, format];
    
    va_list args;
    va_start(args, format);
    NSLogv(prefix, args);
    va_end(args);
}

@end
