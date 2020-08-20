//
//  LYRLogTests.m
//  LYRLogTests
//
//  Created by 61people on 2020/8/18.
//  Copyright © 2020 LYR. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LYRLogEngine.h"

@interface LYRLogTests : XCTestCase

@end

@implementation LYRLogTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [LYRLogEngine sharedInstance].level = LYRLogLevelDebug;
    [LYRLogEngine sharedInstance].basePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    [[LYRLogEngine sharedInstance] logWithLevel:LYRLogLevelDebug module:@"test" format:@"%@:%@", @"dsf", @"dfs"];
    
}

//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

@end
