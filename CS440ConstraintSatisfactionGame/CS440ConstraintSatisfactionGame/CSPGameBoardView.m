//
//  CSPGameBoardView.m
//  CS440ConstraintSatisfactionGame
//
//  Created by Troy Chmieleski on 10/27/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "CSPGameBoardView.h"
#import "CSPGameBoardCellView.h"

@implementation CSPGameBoardView {
	UIColor *_backgroundColor;
	UIColor *_borderColor;
}

- (id)initWithFrame:(CGRect)frame backgroundColor:(UIColor *)backgroundColor borderColor:(UIColor *)borderColor {
	self = [super initWithFrame:frame];
	
	if (self) {
		_backgroundColor = backgroundColor;
		_borderColor = borderColor;
	}
	
	return self;
}

- (void)drawRect:(CGRect)rect
{
	NSUInteger numberOfRows = 0;
	NSUInteger numberOfCols = 0;
	
	if ([self.dataSource respondsToSelector:@selector(numberOfRows)]) {
		numberOfRows = [self.dataSource numberOfRows];
	}
	
	if ([self.dataSource respondsToSelector:@selector(numberOfCols)]) {
		numberOfCols = [self.dataSource numberOfCols];
	}
	
	NSUInteger cellSize = self.frame.size.height/numberOfRows;
	
	for (NSUInteger row = 0; row < numberOfRows; row++) {
		for (NSUInteger col = 0; col < numberOfCols; col++) {
			NSUInteger weight = 0;
			NSUInteger owner = 0;
			
			if ([self.dataSource respondsToSelector:@selector(weightForRow:col:)]) {
				weight = [self.dataSource weightForRow:row col:col];
			}
			
			if ([self.dataSource respondsToSelector:@selector(ownerForRow:col:)]) {
				owner = [self.dataSource ownerForRow:row col:col];
			}
			
			CGRect cellFrame = CGRectMake(col*cellSize, row*cellSize, cellSize, cellSize);
			NSString *weightStr = [NSString stringWithFormat:@"%lu", weight];
			
			CSPGameBoardCellView *cellView = [[CSPGameBoardCellView alloc] initWithFrame:cellFrame weight:weightStr owner:owner backgroundColor:_backgroundColor borderColor:_borderColor];
			
			[self addSubview:cellView];
		}
	}
}

@end
