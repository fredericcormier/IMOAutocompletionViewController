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

@interface IMOAutocompletionViewController ()


@property(nonatomic, retain)NSArray *source;

@property (retain, nonatomic) IBOutlet UIView *bannerView;
@property (retain, nonatomic) IBOutlet UITextField *valueField;
@property (retain, nonatomic) IBOutlet UILabel *label;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UILabel *completionCountField;


@property (retain, nonatomic) IMOCompletionController *completionController;

@property (nonatomic, retain) NSString *textFieldString;
@property (nonatomic, retain) NSString *labelString;
@property (nonatomic, retain) NSString *backgroundImageName;



/*  It's always on
 Could be off when there is no row in the tableView
 and on when the table view appears(like in mail app email address) */
- (void)showBannerViewShadow:(BOOL)show;

- (void)controllerCancelled;

@end



@implementation IMOAutocompletionViewController
@synthesize bannerView = bannerView_;
@synthesize valueField = valueField_;
@synthesize label = label_;
@synthesize tableView = tableView_;
@synthesize source = source_;
@synthesize dataSource =  dataSource_;
@synthesize delegate = delegate_;
@synthesize backgroundImageName = backgroundImageName_;
@synthesize completionController = completionController_;
@synthesize textFieldString =  textFieldString_;
@synthesize labelString = labelString_;
@synthesize completionCountField = completionCountField_;


- (id)init {
    return  self = [self initWithNibName:nil bundle:nil];
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    return self = [self initWithLabelString:@""
                            textFieldString:@""
                        backgroundImageName:nil];
    
}


/* DESIGNATED INITIALIZER */

- (id)initWithLabelString:(NSString *)lstring
          textFieldString:(NSString *)tfstring
      backgroundImageName:(NSString *) bgImageName {
    
    if (self = [super initWithNibName:nil bundle:nil]) {
        textFieldString_        = [tfstring retain];
        labelString_            = [lstring retain];
        backgroundImageName_    = [bgImageName retain];
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [[self tableView] setDelegate:self];
    [[self tableView] setDataSource:self];
    [[self tableView] setBackgroundColor:[UIColor clearColor]];
    [[self tableView] setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [[self valueField] setDelegate:self];
    
}



- (void)viewDidUnload {
    [self setBannerView:nil];
    [self setValueField:nil];
    [self setLabel:nil];
    [self setTableView:nil];
    [self setSource:nil];
    [self setCompletionCountField:nil];
    [super viewDidUnload];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([[self dataSource] respondsToSelector:@selector(sourceForAutoCompletionTextField:)]){
        // get the source and sort it
        NSArray *sourceArray = [(id <IMOAutocompletionViewDataSouce>)[self dataSource] sourceForAutoCompletionTextField:self];
              completionController_ = [[IMOCompletionController alloc] initWithSource:sourceArray initialWord:[self textFieldString]];
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
#ifdef COMPLETION_DEBUG
    NSString *completionCount = [NSString stringWithFormat:@"%d", [[self tableView] numberOfRowsInSection:0]] ;
    [[self completionCountField] setText:completionCount];
#endif
    
    
}



-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[self valueField] becomeFirstResponder];
}





- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}




- (void)dealloc {
    [bannerView_ release];
    [valueField_ release];
    [label_ release];
    [tableView_ release];
    [source_ release];
    if ([self completionController]) {
        [completionController_ release];
    }
    [backgroundImageName_ release];
    [textFieldString_ release];
    [labelString_ release];
    [completionCountField_ release];
    [super dealloc];
}



- (void)showBannerViewShadow:(BOOL)show {
    [self bannerView ].layer.masksToBounds = show ? NO : YES;
    [self bannerView ].layer.shadowOffset = CGSizeMake(0, 3);
    [self bannerView ].layer.shadowColor=[[UIColor lightGrayColor] CGColor];
    [self bannerView ].layer.shadowRadius = 2;
    [self bannerView ].layer.shadowOpacity = 1.0;
    // Setting the rasterize to yes blurs the whole banner - text included
    [[self bannerView ].layer setShouldRasterize:NO];
}



- (void)controllerCancelled {
    [self dismissModalViewControllerAnimated:YES];
}




- (void)textFieldDidChange {
    [[self completionController] findWordStartingWith:[[[self valueField] text] lowercaseString]];
    [[self tableView] reloadData];
#ifdef COMPLETION_DEBUG
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
        cell = [[[IMOCompletionCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:completionCell] autorelease];
    }
    [[cell cellField] setText:[[[self completionController] completions] objectAtIndex:[indexPath row]]];
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
