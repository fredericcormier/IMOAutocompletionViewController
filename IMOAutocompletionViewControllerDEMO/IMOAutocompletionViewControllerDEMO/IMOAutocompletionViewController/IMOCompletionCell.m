//
//  IMOCompletionCell.m
//  IMOAutoCompletionTextField DEMO
//
//  Created by Cormier Frederic on 28/05/12.
//  Copyright (c) 2012 International MicrOondes. All rights reserved.
//

#import "IMOCompletionCell.h"

@interface IMOCompletionCell()

@property(nonatomic, strong)UIColor *topSeparatorColor;
@property(nonatomic, strong)UIColor *bottomSeparatorColor;
@property(nonatomic, strong)UIColor *cellBackgroundColor;

@end

@implementation IMOCompletionCell



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    return [self initWithStyle:style reuseIdentifier:reuseIdentifier cellColors:nil];
}


//designated initializer
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellColors:(NSArray *)colors {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _cellField = [[UILabel alloc] initWithFrame:CGRectZero];
        [_cellField setBackgroundColor:[UIColor clearColor]];
        [_cellField setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
        [_cellField setTextAlignment:NSTextAlignmentLeft];
        [_cellField setTextColor:[UIColor colorWithRed:0.164 green:0.170 blue:0.174 alpha:1.000]];
        [[self contentView] addSubview:_cellField];
        
        if (colors) {
            _topSeparatorColor = colors[0];
            _bottomSeparatorColor = colors[1];
            _cellBackgroundColor = colors[2];
        }else{//use default values
            _topSeparatorColor = [UIColor whiteColor];
            _bottomSeparatorColor = UIColorFromRGB(0xe1e1e1);
            _cellBackgroundColor = UIColorFromRGB(0xf2f2f2);
        }
    }
    return self;
}




- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect cellFieldRect = CGRectMake(10.f, 8.5f, 300.f, 20.f);
    [_cellField setFrame:cellFieldRect];
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
    CGContextMoveToPoint(context, 0.0, rect.size.height );
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height );
    CGContextStrokePath(context);    
    
}

@end
