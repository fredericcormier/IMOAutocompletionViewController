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

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define IOS7_OR_MORE                                SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")

NSString * const IMOCompletionCellTopSeparatorColor =       @"IMOCompletionCellTopSeparatorColor";
NSString * const IMOCompletionCellBottomSeparatorColor =    @"IMOCompletionCellBottomSeparatorColor";
NSString * const IMOCompletionCellBackgroundColor =         @"IMOCompletionCellBackgroundColor";

static const CGFloat kNavigationBarHeightPortrait =         44.f;
static const CGFloat kNavigationBarHeightLandscape =        32.f;
static const CGFloat kStatusBarHeight =                     20.f;

@interface IMOAutocompletionViewController ()
@property (strong, nonatomic) UIView *bannerView;
@property (strong, nonatomic) UITextField *valueField;
@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UILabel *completionCountField;
@property (strong, nonatomic) UILabel *totalCompletionField;
@property (nonatomic, strong) NSArray *cellColorsArray;
@property (strong, nonatomic) IMOCompletionController *completionController;
@property (nonatomic, strong) NSString *textFieldString;
@property (nonatomic, strong) NSString *labelString;
@property (nonatomic, strong) NSString *backgroundImageName;
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
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resizeUI:) name:UIKeyboardDidShowNotification object:nil];
        
        if (cellColors != nil) {
            _cellColorsArray = @[cellColors[IMOCompletionCellTopSeparatorColor],
                                 cellColors[IMOCompletionCellBottomSeparatorColor],
                                 cellColors[IMOCompletionCellBackgroundColor]];
        }else{
            _cellColorsArray = nil;
        }
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,
                                                                  kNavigationBarHeightPortrait,
                                                                  [self viewWidth],
                                                                  [self screenHeight])
                                                 style:UITableViewStylePlain];
        [[self view] addSubview:_tableView];
        
        _bannerView = [[UIView alloc] initWithFrame:[self bannerViewAdjustedFrame]];
        
        
        [_bannerView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [_bannerView setBackgroundColor:[UIColor whiteColor]];
        [[self view] addSubview:_bannerView];
        
        _valueField = [[UITextField alloc] initWithFrame:CGRectMake([_bannerView frame].origin.x + 75.f, 12.f, [self viewWidth] - 120.f, 24.f)];
        [_valueField setClearButtonMode:UITextFieldViewModeWhileEditing];
        [[self bannerView] addSubview:_valueField];
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(4.f, 12.f, 65.f, 24.f)];
        [_label setTextAlignment:NSTextAlignmentRight];
        [_label setFont:[UIFont boldSystemFontOfSize:12.f]];
        [_label setTextColor:[UIColor grayColor]];
        [[self bannerView] addSubview:_label];
        
        _completionCountField = [[UILabel alloc] initWithFrame:CGRectMake([self viewWidth] - 40.f, 12.f, 35.f, 11.f)];
        [_completionCountField setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
        [_completionCountField setFont:[UIFont boldSystemFontOfSize:10.f]];
        [_completionCountField setTextAlignment:NSTextAlignmentRight];
        [_completionCountField setTextColor:[UIColor colorWithRed:0.168 green:0.315 blue:0.074 alpha:1.000]];
        [[self bannerView] addSubview:_completionCountField];
        
        _totalCompletionField = [[UILabel alloc] initWithFrame:CGRectMake([self viewWidth] - 40.f, 26.f, 35.f, 11.f)];
        [_totalCompletionField setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
        [_totalCompletionField setFont:[UIFont boldSystemFontOfSize:10.f]];
        [_totalCompletionField setTextAlignment:NSTextAlignmentRight];
        [_totalCompletionField setTextColor:[UIColor colorWithRed:0.471 green:0.000 blue:0.005 alpha:1.000]];
        [[self bannerView] addSubview:_totalCompletionField];
    }
    return self;
}





- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if ([self completionController]) {
        [self setCompletionController:nil];
    }
    [self setView:nil];
}



- (void)viewWillAppear:(BOOL)animated {
    
    int totalCompletionCount = 0;
    
    [super viewWillAppear:animated];
    
    [[self tableView] setDelegate:self];
    [[self tableView] setDataSource:self];
    [[self tableView] setBackgroundColor:[UIColor clearColor]];
    if (IOS7_OR_MORE) {
        [[self tableView] setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    }else{
        [[self tableView] setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
    }
    [[self tableView] setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
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
        // we got a background image passed in
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





- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAll;
}


- (void)resizeUI:(NSNotification *)notification {

    NSDictionary* keyboardInfo = [notification userInfo];
    
    CGFloat ios7NavBarHeight;
    
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    
    // the height and width are "swapped" depending on the orientation
    CGFloat keyboardHeight;
    CGFloat tableViewHeight = 0;
    CGFloat tableViewWidth = 0;
    
    UIInterfaceOrientation orientation = [self interfaceOrientation];
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
        keyboardHeight = keyboardFrameBeginRect.size.height;
        tableViewWidth = keyboardFrameBeginRect.size.width;
        tableViewHeight = [self screenHeight] - (keyboardHeight + (kNavigationBarHeightPortrait * 1.f) + kStatusBarHeight + [[self bannerView] frame].size.height);
        ios7NavBarHeight = kNavigationBarHeightPortrait + kStatusBarHeight;
    }else {
        keyboardHeight = keyboardFrameBeginRect.size.width;
        tableViewWidth = keyboardFrameBeginRect.size.height;
        tableViewHeight = [self screenWidth] - (keyboardHeight + (kNavigationBarHeightLandscape * 1.f) + kStatusBarHeight + [[self bannerView] frame].size.height);
        ios7NavBarHeight = kNavigationBarHeightLandscape +kStatusBarHeight;
    }
    
    CGRect valueFieldRect = CGRectMake([[self bannerView] frame].origin.x + 75.f, 12.f, tableViewWidth - 120.f, 24.f);
    [[self valueField] setFrame:valueFieldRect];
    
    // Place the banner view correctly
    [[self bannerView] setFrame:[self bannerViewAdjustedFrame]];
    
    CGRect tableViewRect = [[self tableView] frame];
    if (IOS7_OR_MORE) {
        tableViewRect.size.height = tableViewHeight + ios7NavBarHeight +4.f ;
    }else{
        tableViewRect.size.height = tableViewHeight;
    }
    tableViewRect.size.width = tableViewWidth;
    [[self tableView] setFrame:tableViewRect];
}



- (CGRect) bannerViewAdjustedFrame {
    CGFloat ios7NavBarHeight, width;
    CGRect bannerRect = CGRectMake(0, 0, [self viewWidth], kNavigationBarHeightPortrait + 4.f);
    
    UIInterfaceOrientation orientation = [self interfaceOrientation];
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
        ios7NavBarHeight = kNavigationBarHeightPortrait + kStatusBarHeight;
        width = [self screenWidth];
    }else {
        ios7NavBarHeight = kNavigationBarHeightLandscape +kStatusBarHeight;
        width = [self screenHeight];
    }
    if (IOS7_OR_MORE) {
        bannerRect.origin.y = ios7NavBarHeight;
        bannerRect.size.width = width;
        [[self bannerView] setFrame:bannerRect];
    }
    return bannerRect;
}



#pragma mark -stuff

- (CGFloat)viewWidth {
    UIInterfaceOrientation orientation = [self interfaceOrientation];
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
        return [[self view] frame].size.width;
    }else{
        return [[self view] frame].size.height;
    }
    
}


-(CGFloat)screenHeight {
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        CGSize result = [[UIScreen mainScreen] bounds].size;
        return result.height;
    }
    return 0;
}


- (CGFloat)screenWidth {
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        CGSize result = [[UIScreen mainScreen] bounds].size;
        return result.width;
    }
    return 0;
}

- (void)showBannerViewShadow:(BOOL)show {
    if (IOS7_OR_MORE) {
        return;
    }
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
    return 34.0;
}



- (int)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


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
    [cell setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
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
