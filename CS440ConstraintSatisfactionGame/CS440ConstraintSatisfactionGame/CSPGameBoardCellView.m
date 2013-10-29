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
	UIColor *_player1Color;
	UIColor *_player2Color;
	UIColor *_playerTextColor;
	UIColor *_noneTextColor;
	UIFont *_font;
}

- (id)initWithFrame:(CGRect)frame weight:(NSString *)weight owner:(NSUInteger)owner backgroundColor:(UIColor *)backgroundColor borderColor:(UIColor *)borderColor {
    self = [super initWithFrame:frame];
	
    if (self) {
		_weight = weight;
		_owner = owner;
		
		_backgroundColor = backgroundColor;
		_borderColor = borderColor;
		
		_player1Color = [UIColor colorWithRed:253.0/255.0 green:134.0/255.0 blue:9.0/255.0 alpha:1.0];
		_player2Color = [UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:1.0];
		
		_playerTextColor = [UIColor whiteColor];
		_noneTextColor = [UIColor blackColor];
		
		_font = [UIFont fontWithName:GAME_BOARD_CELL_FONT_NAME size:GAME_BOARD_CELL_FONT_SIZE];
		
		// set background color
		[self setBackgroundColor:_backgroundColor];
    }
	
    return self;
}

#pragma mark - Respond to Touch Events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	if ([self.delegate respondsToSelector:@selector(touchedCellFrame:)]) {
		[self.delegate touchedCellFrame:self.frame];
	}
}

- (void)updateWithOwner:(CSPOwner)owner {
	_owner = owner;
	
	if (_owner == CSPOwnerPlayer1) {
		[self setBackgroundColor:_player1Color];
	}
	
	else {
		[self setBackgroundColor:_player2Color];
	}
	
	[self setNeedsDisplay];
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
	
	UIColor *textColor;

	if (_owner == CSPOwnerNone) {
		textColor = _noneTextColor;
	}
	
	else {
		textColor = _playerTextColor;
	}
	
	NSDictionary *attributes = @{NSFontAttributeName:_font, NSParagraphStyleAttributeName:textStyle, NSForegroundColorAttributeName:textColor};
	
	[_weight drawInRect:textRect withAttributes:attributes];
}

@end
