//
//  LYRLogEnigineTests.m
//  LYRLogTests
//
//  Created by 61people on 2020/8/23.
//  Copyright © 2020 LYR. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LYRLogEngine.h"

@interface LYRLogEngine (Test)
- (void)writeLog;
@end

@interface LYRLogEnigineTests : XCTestCase

@end

@implementation LYRLogEnigineTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [LYRLogEngine sharedInstance].level = LYRLogLevelDebug;
    [LYRLogEngine sharedInstance].basePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    [LYRLogEngine sharedInstance].baselineGMT = 8;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testLog {
    [[LYRLogEngine sharedInstance] logWithLevel:LYRLogLevelDebug module:@"test" format:@"%@:%@", @"dsf", @"dfs"];
}

- (void)testWriteLog {
    [[LYRLogEngine sharedInstance] writeLog];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
