//
//  CSPGameBoardCellView.m
//  CS440ConstraintSatisfactionGame
//
//  Created by Troy Chmieleski on 10/27/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "CSPGameBoardCellView.h"

#define GAME_BOARD_CELL_BORDER_WIDTH 4.0f
#define GAME_BOARD_CELL_FONT_SIZE 18.0f
#define GAME_BOARD_CELL_FONT_NAME @"Avenir-Heavy"
#define GAME_BOARD_CELL_TEXT_VERTICAL_OFFSET 2.0f

@implementation CSPGameBoardCellView {
	NSString *_weight;
	NSUInteger _owner;
	UIColor *_backgroundColor;
	UIColor *_borderColor;
	UIFont *_font;
}

- (id)initWithFrame:(CGRect)frame weight:(NSString *)weight owner:(NSUInteger)owner backgroundColor:(UIColor *)backgroundColor borderColor:(UIColor *)borderColor {
    self = [super initWithFrame:frame];
	
    if (self) {
		_weight = weight;
		_owner = owner;
		
		_backgroundColor = backgroundColor;
		_borderColor = borderColor;
		_font = [UIFont fontWithName:GAME_BOARD_CELL_FONT_NAME size:GAME_BOARD_CELL_FONT_SIZE];
		
		// set background color
		[self setBackgroundColor:_backgroundColor];
    }
	
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
	
	// draw border
	CGRect strokeRect = CGRectInset(self.bounds, 0, 0);
    CGContextSetStrokeColorWithColor(ctx, _borderColor.CGColor);
    CGContextSetLineWidth(ctx, GAME_BOARD_CELL_BORDER_WIDTH);
    CGContextStrokeRect(ctx, strokeRect);
	
	// display weight
	CGFloat fontSize = _font.pointSize;
	CGFloat yOffset = (self.frame.size.height - fontSize)/2.0 - GAME_BOARD_CELL_TEXT_VERTICAL_OFFSET;
	
	CGRect textRect = CGRectMake(0, yOffset, self.frame.size.width, self.frame.size.height);
	
	NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    textStyle.lineBreakMode = NSLineBreakByClipping;
    textStyle.alignment = NSTextAlignmentCenter;
	
	NSDictionary *attributes = @{NSFontAttributeName:_font, NSParagraphStyleAttributeName:textStyle};
	
	[_weight drawInRect:textRect withAttributes:attributes];
}

@end
