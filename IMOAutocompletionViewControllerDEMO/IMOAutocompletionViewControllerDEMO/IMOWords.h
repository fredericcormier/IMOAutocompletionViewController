//
//  IMOWords.h
//  IMOAutoCompletionTextField DEMO
//
//  Created by Cormier Frederic on 28/05/12.
//  Copyright (c) 2012 International MicrOondes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMOWords : NSObject


@property(nonatomic, retain)NSArray *someTokens;

@property(nonatomic, strong)NSArray *tokens;

+ (IMOWords *)sharedWords;


@end
