//
//  IMOCompletionCell.m
//  IMOAutoCompletionTextField DEMO
//
//  Created by Cormier Frederic on 28/05/12.
//  Copyright (c) 2012 International MicrOondes. All rights reserved.
//

#import "IMOCompletionCell.h"

@interface IMOCompletionCell()

@property(nonatomic, retain)UIColor *topSeparatorColor;
@property(nonatomic, retain)UIColor *bottomSeparatorColor;
@property(nonatomic, retain)UIColor *cellBackgroundColor;

@end

@implementation IMOCompletionCell

const float IMOCellSizeMagnitude = - 10.0;

@synthesize cellField = cellField_;
@synthesize topSeparatorColor = topSeparatorColor_;
@synthesize bottomSeparatorColor = bottomSeparatorColor_;
@synthesize cellBackgroundColor = cellBackgroundColor_;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    return [self initWithStyle:style reuseIdentifier:reuseIdentifier cellColors:nil];
}


//designated initializer
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellColors:(NSArray *)colors {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        cellField_ = [[UILabel alloc] initWithFrame:CGRectZero];
        [cellField_ setBackgroundColor:[UIColor clearColor]];
        [cellField_ setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
        [cellField_ setTextAlignment:UITextAlignmentLeft];
        [cellField_ setTextColor:[UIColor colorWithRed:0.164 green:0.170 blue:0.174 alpha:1.000]];
        [[self contentView] addSubview:cellField_];
        [cellField_ release];
        
        if (colors) {
            topSeparatorColor_ = colors[0];
            bottomSeparatorColor_ = colors[1];
            cellBackgroundColor_ = colors[2];
        }else{//use default values
            topSeparatorColor_ = [[UIColor whiteColor] retain];
            bottomSeparatorColor_ = [UIColorFromRGB(0xe1e1e1) retain];
            cellBackgroundColor_ = [UIColorFromRGB(0xf2f2f2) retain];
        }
    }
    return self;
}

- (void)dealloc {
    [topSeparatorColor_ release];
    [bottomSeparatorColor_ release];
    [cellBackgroundColor_ release];
    [super dealloc];
}



- (void)layoutSubviews {
    CGRect cellFieldRect = CGRectMake(10.0, 10.0, 300., 20.0);
    [cellField_ setFrame:cellFieldRect];
}

- (void)drawRect:(CGRect)rect {
    
    const float kLineWidth = 3.0;
    
    CGColorRef backGroundColorRef = [[self cellBackgroundColor] CGColor];
    CGColorRef bottomSeparatorColorRef = [[self bottomSeparatorColor] CGColor];
    CGColorRef topSeparatorColorRef = [[self topSeparatorColor] CGColor];
    
    
    rect = [[self contentView] bounds];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    // backGround
    CGContextSetFillColorWithColor(context, backGroundColorRef);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, rect.size.width, 0);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
    CGContextAddLineToPoint(context, 0, rect.size.height);
    CGContextClosePath(context);
    CGContextFillPath(context);
        // Top Separator
    CGContextSetStrokeColorWithColor(context, topSeparatorColorRef);
    CGContextSetLineWidth(context, kLineWidth);
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextMoveToPoint(context, 0.0, 0.0);
    CGContextAddLineToPoint(context, rect.size.width, 0);
    CGContextStrokePath(context);
    
    //Bottom Separator
    CGContextSetStrokeColorWithColor(context, bottomSeparatorColorRef);
    CGContextSetLineWidth(context, kLineWidth);
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextMoveToPoint(context, 0.0, rect.size.height + IMOCellSizeMagnitude);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height + IMOCellSizeMagnitude);
    CGContextStrokePath(context);    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
