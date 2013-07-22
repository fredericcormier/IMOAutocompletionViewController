//
//  IMOCompletionController.m
//  IMOAutocompletionViewControllerDEMO
//
//  Created by Frederic Cormier on 18/10/12.
//  Copyright (c) 2012 International MicrOondes. All rights reserved.
//
/*
 
 
 */
#import "IMOCompletionController.h"

@interface IMOCompletionController () {
    NSString *oldWord;
}

@property (nonatomic, strong) NSArray* source;
@property (nonatomic, strong) NSMutableArray* ranges;
@property (nonatomic, assign) int rangePointer;

- (void)calculateRangeForLengthOfWord:(NSString *)word;
- (void)calculateAllRangesForWord:(NSString *)word;
- (void)resetRanges;

@end



@implementation IMOCompletionController



- (id)initWithSource:(NSArray *)words initialWord:(NSString *)anInitialWord{
    if (self = [super init]) {
        _source =   [words sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                    return [(NSString *)obj1 caseInsensitiveCompare:(NSString *)obj2];
                    }];
        
        _ranges = [[NSMutableArray alloc] init];
        
        
        NSRange allWordsRange = NSMakeRange(0, [_source count]);
        [_ranges addObject:[NSValue valueWithRange:allWordsRange]];
        
        if ([anInitialWord isEqualToString:@""] == NO) {
            [self calculateAllRangesForWord:anInitialWord];
            oldWord = anInitialWord;
        }else{
            oldWord = @"";
            _rangePointer = 0;
        }
    }
    return self;
}





- (NSArray *)completions {
    //   empty string
    if ([self rangePointer] == 0) {
        return nil;
    }else{
        NSRange currentSolution = [[self ranges][[self rangePointer]] rangeValue];
        return [[self source] subarrayWithRange:currentSolution];
    }
}



- (void)resetRanges {
    _ranges = [[NSMutableArray alloc] init];
    
    NSRange allWordsRange = NSMakeRange(0, [_source count] - 1 );
    [_ranges addObject:[NSValue valueWithRange:allWordsRange]];
}



- (void)calculateAllRangesForWord:(NSString *)word {
    int end = 0;
    for (int i = 0; i < [word length]; i++) {
        end++;
        [self calculateRangeForLengthOfWord:[word substringWithRange:NSMakeRange(0, end)]];
    }
    [self setRangePointer:[word length]];
}




- (void)calculateRangeForLengthOfWord:(NSString *)word{
    int length = [word length];
    NSRange range = [[self ranges][length -1] rangeValue];
    int start = 0;
    int counter = 0;
    BOOL running = NO;
    for (int i = range.location; i < range.location + range.length; i++) {
        if ([[[self source][i] lowercaseString] hasPrefix:[word lowercaseString]]) { // does match
            if (running == NO) { // time to start tracking
                start = i;
                counter++;
                running = YES;
            }else{
                counter++;
            }
        }else {// does not match
            if (running == YES) { //there was a match previously so, this the end.
                break;
            }// otherwise - no match yet - continue
        }
    }
    NSRange newRange = NSMakeRange(start, counter);
    [[self ranges] addObject:[NSValue valueWithRange:newRange]];
}




- (void)findWordStartingWith:(NSString *)newWord {
    // if working directly with the IMOCompletionController (you know you shouldn't),
    // there might be situations where oldWord might be nil, so ...
    if (oldWord == nil) {
        oldWord = @"";
    }

    
    int length = [newWord length];
    int deviation = [newWord length] -[oldWord length];
    
    //Adding a char at the end
    if ((deviation == 1) && ([[newWord lowercaseString] hasPrefix:[oldWord lowercaseString]] || [oldWord isEqualToString:@""] )) {
        [self calculateRangeForLengthOfWord:newWord];
    }
    
    // Deleting a char at the end - the ranges have been already computed - just need to clean up at length + 1
    else if ((deviation == -1) && ([[oldWord lowercaseString] hasPrefix:[newWord lowercaseString]] || [newWord isEqualToString:@""])) {
        [[self ranges] removeObjectAtIndex: length + 1 ];
    }
    // deleting or adding a char inside the word
    else if ((deviation == 1 || deviation == -1)
             && ([newWord characterAtIndex:0] == [oldWord characterAtIndex:0])
             && ([newWord characterAtIndex:[newWord length] -1] == [oldWord characterAtIndex:[oldWord length] -1])) {
        [self resetRanges];
        [self calculateAllRangesForWord:newWord];
    }
    // deleting or adding several chars inside the word
    else if ((deviation > 1) || (deviation < -1)){
        [self resetRanges];
        [self calculateAllRangesForWord:newWord];
    }
    [self setRangePointer:length];
    oldWord = newWord;
}


@end
