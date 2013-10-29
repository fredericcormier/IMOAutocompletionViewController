//
//  IMOAutocompletionViewControllerTests.m
//  IMOAutocompletionViewControllerTests
//
//  Created by Frederic Cormier on 23/07/13.
//  Copyright (c) 2013 International MicrOondes. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "IMOWords.h"
#import "IMOCompletionController.h"

@interface IMOAutocompletionViewControllerTests : XCTestCase
@property(nonatomic, strong)IMOCompletionController *bigCompletionController;
@property(nonatomic, strong)IMOCompletionController *smallCompletionController;
@end

@implementation IMOAutocompletionViewControllerTests

- (void)setUp{
    [super setUp];
    _bigCompletionController = [[IMOCompletionController alloc]
                                initWithSource:[[IMOWords sharedWords] tokens]
                                initialWord:nil];
    
    _smallCompletionController = [[IMOCompletionController alloc]
                                  initWithSource:[[IMOWords sharedWords] someTokens]
                                  initialWord:nil];
    
}

- (void)tearDown{
    [self setBigCompletionController:nil];
    [self setSmallCompletionController:nil];
    [super tearDown];
}


- (void)testCompletionOfEmptyStringShouldReturnNIL {
    [[self bigCompletionController] findWordStartingWith:@""];
    NSArray *result = [[self bigCompletionController] completions];
    XCTAssertNil(result, @"Should be nil");
}

- (void)testCompletionFoundOneCandidate {
    [[self smallCompletionController] findWordStartingWith:@"ken"];
    NSArray *result = [[self smallCompletionController] completions];
    XCTAssertTrue([result count] == 1, @"Should return one and only one completion");
}

- (void)testCompletionsFound2Candidates {
    [[self smallCompletionController] findWordStartingWith:@"go"];
    NSArray *result = [[self smallCompletionController] completions];
    XCTAssertTrue([result count] == 2, @"Should return 2 completions");
}

- (void)testCompletionIsCaseInsensitive{
    [[self smallCompletionController] findWordStartingWith:@"ISLand"];
    NSArray *result = [[self smallCompletionController] completions];
    XCTAssertTrue([result count] == 1, @"Should return 1 completion and should not care about case sensitivity");
}


- (void)testCompletionFromOneCharacterShouldReturn3candidates{
    [[self smallCompletionController] findWordStartingWith:@"g"];
    NSArray *result = [[self smallCompletionController] completions];
    XCTAssertTrue([result count] == 3, @"Should return 3 completions");
}



- (void)testCompletionOfDigitShouldAnEmptyArray {
    [[self bigCompletionController] findWordStartingWith:@"34"];
    XCTAssertTrue([[[self bigCompletionController] completions] count] == 0, @"Looking for 34 should return nil");
}
@end
