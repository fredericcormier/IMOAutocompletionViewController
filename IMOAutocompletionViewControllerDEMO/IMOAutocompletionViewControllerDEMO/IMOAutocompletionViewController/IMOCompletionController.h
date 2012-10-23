//
//  IMOCompletionController.h
//  IMOAutocompletionViewControllerDEMO
//
//  Created by Frederic Cormier on 18/10/12.
//  Copyright (c) 2012 International MicrOondes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMOCompletionController : NSObject

- (id)initWithSource:(NSArray *)words initialWord:(NSString *)anInitialWord;
- (NSArray *)completions;
- (void)findWordStartingWith:(NSString *)word;

@end
