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

const int MAX_WORD_LENGTH = 30;

@interface IMOCompletionController () {
    NSString *oldWord;
}

@property (nonatomic, retain) NSArray* source;
@property (nonatomic, retain) NSMutableArray* ranges;
@property (nonatomic, assign) int rangePointer;

- (void)calculateRangeForLengthOfWord:(NSString *)word;
- (void)calculateAllRangesForWord:(NSString *)word;
- (void)resetRanges;

@end



@implementation IMOCompletionController

@synthesize source = source_;
@synthesize ranges = ranges_;
@synthesize rangePointer = rangePointer_;



- (id)initWithSource:(NSArray *)words initialWord:(NSString *)anInitialWord{
    if (self = [super init]) {
        source_ =   [[words sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [(NSString *)obj1 caseInsensitiveCompare:(NSString *)obj2];            
        }] retain];

        ranges_ = [[NSMutableArray alloc] initWithCapacity:MAX_WORD_LENGTH];

        for (int i = 0; i < MAX_WORD_LENGTH; i++) {
            [ranges_ addObject:[NSNull null]];
        }
        
        NSRange allWordsRange = NSMakeRange(0, [source_ count] - 1 );
        [ranges_ replaceObjectAtIndex:0 withObject:[NSValue valueWithRange:allWordsRange]];
        if ([anInitialWord isEqualToString:@""] == NO) {
            [self calculateAllRangesForWord:anInitialWord];
            oldWord = [anInitialWord retain];
        }else{
            oldWord = @"";
            rangePointer_ = 0;
        }
    }
    return self;
}



- (void)dealloc {
    [source_ release];
    [ranges_ release];
    [oldWord release];
    [super dealloc];
}


- (NSArray *)completions {
    //   empty string
    if ([self rangePointer] == 0) {
        return nil;
    }else{
        NSRange currentSolution = [[[self ranges] objectAtIndex:[self rangePointer]] rangeValue];
        return [[self source] subarrayWithRange:currentSolution];
    }
}



- (void)resetRanges {
    for (int i = 0; i < MAX_WORD_LENGTH; i++) {
        [ranges_ replaceObjectAtIndex:i withObject:[NSNull null]];
    }
    NSRange allWordsRange = NSMakeRange(0, [source_ count] - 1 );
    [ranges_ replaceObjectAtIndex:0 withObject:[NSValue valueWithRange:allWordsRange]];
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
    NSRange range = [[[self ranges] objectAtIndex:length -1] rangeValue];
    int start = 0;
    int counter = 0;
    BOOL running = NO;
    for (int i = range.location; i < range.location + range.length; i++) {
        if ([[[self source] objectAtIndex:i] hasPrefix:word]) { // does match
            if (running == NO) { // time to start tracking
                start = i;
                counter++;
                running = YES;
            }else{
                counter++;
            }
        }else {// does not match
            if (running == YES) { //there was a match perviously so this the end
                break;
            }// otherwise - no match yet - continue
        }
    }
    NSRange newRange = NSMakeRange(start, counter);
    [[self ranges] replaceObjectAtIndex:length withObject:[NSValue valueWithRange:newRange]];
}




- (void)findWordStartingWith:(NSString *)newWord {
    int length = [newWord length];
    int deviation = [newWord length] -[oldWord length];
    
    //Adding a char at the end
    if ((deviation == 1) && ([newWord hasPrefix:oldWord] || [oldWord isEqualToString:@""] )) {
        [self calculateRangeForLengthOfWord:newWord];
    }
    
    // Deleting a char at the end - the ranges have been already computed - just need to clean up at length + 1
    else if ((deviation == -1) && ([oldWord hasPrefix:newWord] || [newWord isEqualToString:@""])) {
        [[self ranges] replaceObjectAtIndex:length + 1 withObject:[NSNull null]];
    }
    // deleting a char inside the word
    else if ((deviation == 1 || deviation == -1)
             && ([newWord characterAtIndex:0] == [oldWord characterAtIndex:0])
             && ([newWord characterAtIndex:[newWord length] -1] == [oldWord characterAtIndex:[oldWord length] -1])) {
        [self resetRanges];
        [self calculateAllRangesForWord:newWord];
    }
    // deleting several chars
    else if ((deviation > 1) || (deviation < -1)){
        [self resetRanges];
        [self calculateAllRangesForWord:newWord];
    }
    [self setRangePointer:length];
    [newWord retain];
    [oldWord release];
    oldWord = newWord;
}


@end
