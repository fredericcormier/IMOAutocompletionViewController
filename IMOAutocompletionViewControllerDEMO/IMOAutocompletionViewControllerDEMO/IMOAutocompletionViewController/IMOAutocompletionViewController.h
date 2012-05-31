//
//  IMOAutocompletionViewController.h
//  IMOAutoCompletionTextField DEMO
//
//  Created by Cormier Frederic on 28/05/12.
//  Copyright (c) 2012 International MicrOondes. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IMOAutocompletionViewController;


@protocol IMOAutocompletionViewDataSouce <NSObject>

- (NSArray *)sourceForAutoCompletionTextField:(IMOAutocompletionViewController *)asViewController;

@end


@protocol IMOAutocompletionViewDelegate <NSObject>

- (void)IMOAutocompletionViewControllerReturnedCompletion:(NSString *)completion;

@end

@interface IMOAutocompletionViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

//@property (nonatomic, retain) NSString *item;
//@property (nonatomic, retain) NSString *itemLabel;
@property (nonatomic, retain) NSString *backgroundImageName;

@property (assign, nonatomic) id <IMOAutocompletionViewDataSouce> dataSource;
@property (assign, nonatomic) id <IMOAutocompletionViewDelegate> delegate;


- (id)initWithLabelString:(NSString *)lstring
          textFieldString:(NSString *)tfstring
      backgroundImageName:(NSString *) bgImageName;
@end
