//
//  LYRLogProcessorTests.m
//  LYRLogTests
//
//  Created by 61people on 2020/8/27.
//  Copyright © 2020 LYR. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LYRLogProcessor.h"

@interface LYRLogProcessorTests : XCTestCase
@property (nonatomic, strong) LYRLogProcessor *logProcessor;
@end

@implementation LYRLogProcessorTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.logProcessor = [[LYRLogProcessor alloc] init];
    self.logProcessor.baselineGMT = 7;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (NSString *)logWithLevel:(LYRLogLevel)level module:(NSString *)module format:(NSString *)format, ... {
    va_list args;
    va_start(args, format);
    
    NSString *logString = [self.logProcessor logStringWithLevel:level module:module format:format args:args];
    
    va_end(args);
    return logString;
}

- (void)testLogString {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    NSString *logString = [self logWithLevel:LYRLogLevelOnline module:@"module" format:@"%@:%@", @"1", @"2"];
    printf("%s\n", [logString UTF8String]);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
