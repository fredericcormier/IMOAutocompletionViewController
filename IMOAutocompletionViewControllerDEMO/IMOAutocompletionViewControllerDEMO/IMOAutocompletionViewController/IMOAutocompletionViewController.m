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


@property (retain, nonatomic) IBOutlet UIView *bannerView;
@property (retain, nonatomic) IBOutlet UITextField *valueField;
@property (retain, nonatomic) IBOutlet UILabel *label;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UILabel *completionCountField;
@property (retain, nonatomic) IBOutlet UILabel *totalCompletionField;

@property (nonatomic, retain) NSArray *cellColorsArray;
@property (retain, nonatomic) IMOCompletionController *completionController;

@property (nonatomic, retain) NSString *textFieldString;
@property (nonatomic, retain) NSString *labelString;
@property (nonatomic, retain) NSString *backgroundImageName;



/* Shadow It's always on
 Could be off when there is no row in the tableView
 and on when the table view appears(like in mail app email addresses) */
- (void)showBannerViewShadow:(BOOL)show;
- (void)resizeTableView:(NSNotification *)notification;
- (void)controllerCancelled;
- (CGFloat)screenHeight;
@end



@implementation IMOAutocompletionViewController

@synthesize bannerView = bannerView_;
@synthesize valueField = valueField_;
@synthesize label = label_;
@synthesize tableView = tableView_;
@synthesize dataSource =  dataSource_;
@synthesize delegate = delegate_;
@synthesize backgroundImageName = backgroundImageName_;
@synthesize completionController = completionController_;
@synthesize textFieldString =  textFieldString_;
@synthesize labelString = labelString_;
@synthesize completionCountField = completionCountField_;
@synthesize totalCompletionField = totalCompletionField_;
@synthesize cellColorsArray = cellColorsArray_;

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
        textFieldString_        = [tfstring retain];
        labelString_            = [lstring retain];
        backgroundImageName_    = [bgImageName retain];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resizeTableView:) name:UIKeyboardDidShowNotification object:nil];
        
        if (cellColors != nil) {
            cellColorsArray_ = [[NSArray alloc] initWithObjects:
                                cellColors[IMOCompletionCellTopSeparatorColor],
                                cellColors[IMOCompletionCellBottomSeparatorColor],
                                cellColors[IMOCompletionCellBackgroundColor], nil];
        }else{
            cellColorsArray_ = nil;
        }
        
        
        
        [self setView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320.f, [self screenHeight])]];

        
        tableView_ = [[UITableView alloc]initWithFrame:CGRectMake(0, NavigationBarHeight, 320.f, [self screenHeight]) style:UITableViewStylePlain];
        [[self view] addSubview:tableView_];
        
        
        bannerView_ = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320.f, NavigationBarHeight)];
        [bannerView_ setBackgroundColor:[UIColor whiteColor]];
        [[self view] addSubview:bannerView_];
        
        valueField_ = [[UITextField alloc] initWithFrame:CGRectMake(75.f, 12.f, 200.f, 24.f)];
        [valueField_ setClearButtonMode:UITextFieldViewModeWhileEditing];
        [[self bannerView] addSubview:valueField_];
        
        label_ = [[UILabel alloc] initWithFrame:CGRectMake(4.f, 12.f, 65.f, 24.f)];
        [label_ setTextAlignment:NSTextAlignmentRight];
        [label_ setFont:[UIFont boldSystemFontOfSize:12.f]];
        [label_ setTextColor:[UIColor grayColor]];
        [[self view] addSubview:label_];
        
        completionCountField_ = [[UILabel alloc] initWithFrame:CGRectMake(280.f, 12.f, 35.f, 11.f)];
        [completionCountField_ setFont:[UIFont boldSystemFontOfSize:10.f]];
        [completionCountField_ setTextAlignment:NSTextAlignmentRight];
        [completionCountField_ setTextColor:[UIColor colorWithRed:0.168 green:0.315 blue:0.074 alpha:1.000]];
        [[self view] addSubview:completionCountField_];
        
        totalCompletionField_ = [[UILabel alloc] initWithFrame:CGRectMake(280.f, 26.f, 35.f, 11.f)];
        [totalCompletionField_ setFont:[UIFont boldSystemFontOfSize:10.f]];
        [totalCompletionField_ setTextAlignment:NSTextAlignmentRight];
        [totalCompletionField_ setTextColor:[UIColor colorWithRed:0.471 green:0.000 blue:0.005 alpha:1.000]];
        [[self view] addSubview:totalCompletionField_];
        
        
        
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [bannerView_ release];
    [valueField_ release];
    [label_ release];
    [tableView_ release];
    if ([self completionController]) {
        [completionController_ release];
    }
    [backgroundImageName_ release];
    [textFieldString_ release];
    [labelString_ release];
    [completionCountField_ release];
    [totalCompletionField_ release];
    [cellColorsArray_ release];
    
    [bannerView_ release];
    [tableView_ release];
    [valueField_ release];
    [label_ release];
    [completionCountField_ release];
    [totalCompletionField_ release];
    
    [self setView:nil];
    [super dealloc];
}


//- (void)viewDidLoad {
//    NSLog(@"%@ Invoked",[NSString stringWithUTF8String:__PRETTY_FUNCTION__]);
//    [super viewDidLoad];
//    [[self tableView] setDelegate:self];
//    [[self tableView] setDataSource:self];
//    [[self tableView] setBackgroundColor:[UIColor clearColor]];
//    [[self tableView] setSeparatorStyle:UITableViewCellSeparatorStyleNone];
//    [[self valueField] setDelegate:self];
//
//}


//
//- (void)viewDidUnload {
//    NSLog(@"%@ Invoked",[NSString stringWithUTF8String:__PRETTY_FUNCTION__]);
//    [self setBannerView:nil];
//    [self setValueField:nil];
//    [self setLabel:nil];
//    [self setTableView:nil];
//    [self setCompletionCountField:nil];
//    [self setTotalCompletionField:nil];
//    [super viewDidUnload];
//}
//


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
        completionController_ = [[IMOCompletionController alloc] initWithSource:sourceArray initialWord:[self textFieldString]];
        totalCompletionCount = [sourceArray count];
    }
    
    
    [[self valueField] addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    [[self valueField] setText:[self textFieldString]];
    [[self label] setText:[self labelString]];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                  target:self
                                                                                  action:@selector(controllerCancelled)];
    
    [[self navigationItem] setRightBarButtonItem:cancelButton];
    [cancelButton release];
    
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
    originalTableViewRect.size.height -= keyboardHeight + (NavigationBarHeight * 2.5f);
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
            cell = [[[IMOCompletionCell alloc] initWithStyle:UITableViewCellStyleValue1
                                             reuseIdentifier:completionCell
                                                  cellColors:[self cellColorsArray]]autorelease];
        }else { // call with default colors
            cell = [[[IMOCompletionCell alloc]initWithStyle:UITableViewCellStyleValue1
                                            reuseIdentifier:completionCell] autorelease];
        }
    }
    NSString *thisCompletion = [[[[self completionController] completions] objectAtIndex:[indexPath row]] lowercaseString];
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
