//
//  IMOCompletionCell.m
//  IMOAutoCompletionTextField DEMO
//
//  Created by Cormier Frederic on 28/05/12.
//  Copyright (c) 2012 International MicrOondes. All rights reserved.
//

#import "IMOCompletionCell.h"

@implementation IMOCompletionCell


@synthesize cellField = cellField_;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        cellField_ = [[UILabel alloc] initWithFrame:CGRectZero];
        [cellField_ setBackgroundColor:[UIColor clearColor]];
        [cellField_ setFont:[UIFont boldSystemFontOfSize:12.0]];
        [cellField_ setTextAlignment:UITextAlignmentLeft];
        
        [[self contentView] addSubview:cellField_];
        [cellField_ release];
        
    }
    return self;
}

- (void)layoutSubviews {
    CGRect cellFieldRect = CGRectMake(10.0, 10.0, 300., 20.0);
    [cellField_ setFrame:cellFieldRect];
}

- (void)drawRect:(CGRect)rect {
    
    const float kLineWidth = 1.0;
    UIColor *greyish = UIColorFromRGB(0xe8e4e3);
    UIColor *creamy = UIColorFromRGB(0xecdbc1);
    
    CGColorRef backGroundColorRef = [[UIColor whiteColor] CGColor];
    CGColorRef bottomSeparatorColorRef = [creamy CGColor];
    CGColorRef topSeparatorColorRef = [greyish CGColor];
    
    
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
    //Bottom Separator
    CGContextSetStrokeColorWithColor(context, bottomSeparatorColorRef);
    CGContextSetLineWidth(context, kLineWidth);
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextMoveToPoint(context, 0.0, rect.size.height);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
    CGContextStrokePath(context);
    // Top Separator
    CGContextSetStrokeColorWithColor(context, topSeparatorColorRef);
    CGContextSetLineWidth(context, kLineWidth);
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextMoveToPoint(context, 0.0, 0.0);
    CGContextAddLineToPoint(context, rect.size.width, 0);
    CGContextStrokePath(context);
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
