//
//  IMOAutocompletionViewController.h
//  IMOAutoCompletionTextField DEMO
//
//  Created by Cormier Frederic on 28/05/12.
//  Copyright (c) 2012 International MicrOondes. All rights reserved.
//

#import <UIKit/UIKit.h>

#define COMPLETION_DEBUG    1

@class IMOAutocompletionViewController;


@protocol IMOAutocompletionViewDataSource <NSObject>

- (NSArray *)sourceForAutoCompletionTextField:(IMOAutocompletionViewController *)autocompletionViewController;

@end


@protocol IMOAutocompletionViewDelegate <NSObject>

- (void)IMOAutocompletionViewControllerReturnedCompletion:(NSString *)completion;

@end


extern NSString * const IMOCompletionCellTopSeparatorColor;
extern NSString * const IMOCompletionCellBottomSeparatorColor;
extern NSString * const IMOCompletionCellBackgroundColor;

@interface IMOAutocompletionViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) id <IMOAutocompletionViewDataSource> dataSource;
@property (weak, nonatomic) id <IMOAutocompletionViewDelegate> delegate;


- (id)initWithLabelString:(NSString *)lstring
          textFieldString:(NSString *)tfstring
      backgroundImageName:(NSString *) bgImageName;

// pass cell colors info
- (id)initWithLabelString:(NSString *)lstring
          textFieldString:(NSString *)tfstring
      backgroundImageName:(NSString *) bgImageName
               cellColors:(NSDictionary *)cellColors;

@end

