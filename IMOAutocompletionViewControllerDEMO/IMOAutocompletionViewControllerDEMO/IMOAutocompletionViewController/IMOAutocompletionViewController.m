//
//  IMOAutocompletionViewController.m
//  IMOAutoCompletionTextField DEMO
//
//  Created by Cormier Frederic on 28/05/12.
//  Copyright (c) 2012 International MicrOondes. All rights reserved.
//

#import "IMOAutocompletionViewController.h"
#import "IMOCompletionCell.h"
#import "IMOCompletionController.h"
#import <QuartzCore/QuartzCore.h>


NSString * const IMOCompletionCellTopSeparatorColor = @"IMOCompletionCellTopSeparatorColor";
NSString * const IMOCompletionCellBottomSeparatorColor = @"IMOCompletionCellBottomSeparatorColor";
NSString * const IMOCompletionCellBackgroundColor = @"IMOCompletionCellBackgroundColor";

static const CGFloat NavigationBarHeight = 44.f;

@interface IMOAutocompletionViewController ()


@property (strong, nonatomic) IBOutlet UIView *bannerView;
@property (strong, nonatomic) IBOutlet UITextField *valueField;
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *completionCountField;
@property (strong, nonatomic) IBOutlet UILabel *totalCompletionField;

@property (nonatomic, strong) NSArray *cellColorsArray;
@property (strong, nonatomic) IMOCompletionController *completionController;

@property (nonatomic, strong) NSString *textFieldString;
@property (nonatomic, strong) NSString *labelString;
@property (nonatomic, strong) NSString *backgroundImageName;



/* Shadow It's always on
 Could be off when there is no row in the tableView
 and on when the table view appears(like in mail app email addresses) */
- (void)showBannerViewShadow:(BOOL)show;
- (void)resizeTableView:(NSNotification *)notification;
- (void)controllerCancelled;
- (CGFloat)screenHeight;
@end



@implementation IMOAutocompletionViewController


- (id)init {
    return  self = [self initWithNibName:nil bundle:nil];
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    return [self initWithLabelString:@""
                     textFieldString:@""
                 backgroundImageName:nil
                          cellColors:nil];
    
}

- (id)initWithLabelString:(NSString *)lstring
          textFieldString:(NSString *)tfstring
      backgroundImageName:(NSString *) bgImageName{
    return [self initWithLabelString:lstring
                     textFieldString:tfstring
                 backgroundImageName:
            bgImageName cellColors:nil];
}


/* DESIGNATED INITIALIZER */

- (id)initWithLabelString:(NSString *)lstring
          textFieldString:(NSString *)tfstring
      backgroundImageName:(NSString *) bgImageName
               cellColors:(NSDictionary *)cellColors{
    
    if (self = [super initWithNibName:nil bundle:nil]) {
        _textFieldString        = tfstring;
        _labelString            = lstring;
        _backgroundImageName    = bgImageName;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resizeTableView:) name:UIKeyboardDidShowNotification object:nil];
        
        if (cellColors != nil) {
            _cellColorsArray = @[cellColors[IMOCompletionCellTopSeparatorColor],
                                cellColors[IMOCompletionCellBottomSeparatorColor],
                                cellColors[IMOCompletionCellBackgroundColor]];
        }else{
            _cellColorsArray = nil;
        }
        
        
        
        [self setView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320.f, [self screenHeight])]];

        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavigationBarHeight, 320.f, [self screenHeight]) style:UITableViewStylePlain];
        [[self view] addSubview:_tableView];
        
        
        _bannerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320.f, NavigationBarHeight)];
        [_bannerView setBackgroundColor:[UIColor whiteColor]];
        [[self view] addSubview:_bannerView];
        
        _valueField = [[UITextField alloc] initWithFrame:CGRectMake(75.f, 12.f, 200.f, 24.f)];
        [_valueField setClearButtonMode:UITextFieldViewModeWhileEditing];
        [[self bannerView] addSubview:_valueField];
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(4.f, 12.f, 65.f, 24.f)];
        [_label setTextAlignment:NSTextAlignmentRight];
        [_label setFont:[UIFont boldSystemFontOfSize:12.f]];
        [_label setTextColor:[UIColor grayColor]];
        [[self view] addSubview:_label];
        
        _completionCountField = [[UILabel alloc] initWithFrame:CGRectMake(280.f, 12.f, 35.f, 11.f)];
        [_completionCountField setFont:[UIFont boldSystemFontOfSize:10.f]];
        [_completionCountField setTextAlignment:NSTextAlignmentRight];
        [_completionCountField setTextColor:[UIColor colorWithRed:0.168 green:0.315 blue:0.074 alpha:1.000]];
        [[self view] addSubview:_completionCountField];
        
        _totalCompletionField = [[UILabel alloc] initWithFrame:CGRectMake(280.f, 26.f, 35.f, 11.f)];
        [_totalCompletionField setFont:[UIFont boldSystemFontOfSize:10.f]];
        [_totalCompletionField setTextAlignment:NSTextAlignmentRight];
        [_totalCompletionField setTextColor:[UIColor colorWithRed:0.471 green:0.000 blue:0.005 alpha:1.000]];
        [[self view] addSubview:_totalCompletionField];
        
        
        
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if ([self completionController]) {
    }
    
    
    [self setView:nil];
}



- (void)viewWillAppear:(BOOL)animated {
    
    int totalCompletionCount = 0;
    
    [super viewWillAppear:animated];
    
    [[self tableView] setDelegate:self];
    [[self tableView] setDataSource:self];
    [[self tableView] setBackgroundColor:[UIColor clearColor]];
    [[self tableView] setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [[self valueField] setDelegate:self];
    
    
    if ([[self dataSource] respondsToSelector:@selector(sourceForAutoCompletionTextField:)]){
        // get the source
        NSArray *sourceArray = [(id <IMOAutocompletionViewDataSource>)[self dataSource] sourceForAutoCompletionTextField:self];
        _completionController = [[IMOCompletionController alloc] initWithSource:sourceArray initialWord:[self textFieldString]];
        totalCompletionCount = [sourceArray count];
    }
    
    
    [[self valueField] addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    [[self valueField] setText:[self textFieldString]];
    [[self label] setText:[self labelString]];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                  target:self
                                                                                  action:@selector(controllerCancelled)];
    
    [[self navigationItem] setRightBarButtonItem:cancelButton];
    
    if (nil == [self backgroundImageName]) {
        [[self tableView] setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    }else {
        // we got a background picture passed in
        [[self tableView] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:[self backgroundImageName]]]];
    }
    [[self tableView] reloadData];
    
#if COMPLETION_DEBUG
    NSString *completionCount = [NSString stringWithFormat:@"%d", [[self tableView] numberOfRowsInSection:0]] ;
    [[self completionCountField] setText:completionCount];
    [[self totalCompletionField] setText:[NSString stringWithFormat:@"%d", totalCompletionCount]];
#endif
    
}



-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[self valueField] becomeFirstResponder];
}





- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}







- (void)resizeTableView:(NSNotification *)notification {
    NSDictionary* keyboardInfo = [notification userInfo];
    
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    CGFloat keyboardHeight = keyboardFrameBeginRect.size.height;
    
    CGRect originalTableViewRect = [[self tableView] frame];
    originalTableViewRect.size.height -= keyboardHeight + (NavigationBarHeight * 2.4f);
    [[self tableView] setFrame:originalTableViewRect];
}


#pragma mark -stuff


-(CGFloat)screenHeight {
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        CGSize result = [[UIScreen mainScreen] bounds].size;
        return result.height;
    }
    return 0;
}



- (void)showBannerViewShadow:(BOOL)show {
    [self bannerView ].layer.masksToBounds = show ? NO : YES;
    [self bannerView ].layer.shadowOffset = CGSizeMake(0, 3);
    [self bannerView ].layer.shadowColor=[[UIColor colorWithWhite:0.546 alpha:0.870] CGColor];
    [self bannerView ].layer.shadowRadius = 2;
    [self bannerView ].layer.shadowOpacity = 1.0;
    // Setting the rasterize to yes blurs the whole banner - text included
    [[self bannerView ].layer setShouldRasterize:NO];
}



- (void)controllerCancelled {
    if ([[UIViewController class] respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self dismissModalViewControllerAnimated:YES];
    }
}




- (void)textFieldDidChange {
    [[self completionController] findWordStartingWith:[[self valueField] text]];
    [[self tableView] reloadData];
    
#if COMPLETION_DEBUG
    NSString *completionCount = [NSString stringWithFormat:@"%d", [[self tableView] numberOfRowsInSection:0]] ;
    [[self completionCountField] setText:completionCount];
#endif
}




#pragma mark - TableView delegate and data source -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Cell size default is 44.0.
    // This will return a size of 34.0
    // The custom cell needs to know the - 10.0 difference
    return 44.0 + IMOCellSizeMagnitude;
}



- (int)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


//???: Always show the banner shadow ?
- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int rows = [[[self completionController] completions] count];
    if (rows == 0) {
        [self showBannerViewShadow:YES];
        return 0;
    }
    [self showBannerViewShadow:YES];
    return rows;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *completionCell = @"completionCell";
    
    IMOCompletionCell *cell = [tableView dequeueReusableCellWithIdentifier:completionCell];
    if (nil == cell) {
        if ([self cellColorsArray]) { // call with custom colors
            cell = [[IMOCompletionCell alloc] initWithStyle:UITableViewCellStyleValue1
                                             reuseIdentifier:completionCell
                                                  cellColors:[self cellColorsArray]];
        }else { // call with default colors
            cell = [[IMOCompletionCell alloc]initWithStyle:UITableViewCellStyleValue1
                                            reuseIdentifier:completionCell];
        }
    }
    NSString *thisCompletion = [[[self completionController] completions][[indexPath row]] lowercaseString];
    [[cell cellField] setText:thisCompletion];
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    IMOCompletionCell *selectedCell = (IMOCompletionCell *)[tableView cellForRowAtIndexPath:indexPath];
    if ([[self delegate] respondsToSelector:@selector(IMOAutocompletionViewControllerReturnedCompletion:)]) {
        [[self delegate] IMOAutocompletionViewControllerReturnedCompletion:[[selectedCell cellField] text]];
    }
    [self dismissModalViewControllerAnimated:YES];
}



#pragma mark - Textfield delegate -

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([[self delegate]respondsToSelector:@selector(IMOAutocompletionViewControllerReturnedCompletion:)]) {
        [[self delegate] IMOAutocompletionViewControllerReturnedCompletion:[[self valueField] text]];
    }
    [self resignFirstResponder];
    [self dismissModalViewControllerAnimated:YES];
    return YES;
}
@end
