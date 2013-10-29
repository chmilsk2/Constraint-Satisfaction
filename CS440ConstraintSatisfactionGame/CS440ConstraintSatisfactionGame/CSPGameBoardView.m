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
	NSMutableArray *_cellViews;
	NSUInteger _numberOfRows;
	NSUInteger _numberOfCols;
	UIColor *_backgroundColor;
	UIColor *_borderColor;
}

- (id)initWithFrame:(CGRect)frame backgroundColor:(UIColor *)backgroundColor borderColor:(UIColor *)borderColor {
	self = [super initWithFrame:frame];
	
	if (self) {
		_cellViews = [NSMutableArray array];
		_backgroundColor = backgroundColor;
		_borderColor = borderColor;
	}
	
	return self;
}

- (void)createBoardView {
	_numberOfRows = 0;
	_numberOfCols = 0;
	
	if ([self.dataSource respondsToSelector:@selector(numberOfRows)]) {
		_numberOfRows = [self.dataSource numberOfRows];
	}
	
	if ([self.dataSource respondsToSelector:@selector(numberOfCols)]) {
		_numberOfCols = [self.dataSource numberOfCols];
	}

	_cellSize = (_numberOfRows > 0) ? self.frame.size.height/_numberOfRows : 0;
	
	for (NSUInteger row = 0; row < _numberOfRows; row++) {
		for (NSUInteger col = 0; col < _numberOfCols; col++) {
			NSUInteger weight = 0;
			NSUInteger owner = 0;
			
			if ([self.dataSource respondsToSelector:@selector(weightForRow:col:)]) {
				weight = [self.dataSource weightForRow:row col:col];
			}
			
			if ([self.dataSource respondsToSelector:@selector(ownerForRow:col:)]) {
				owner = [self.dataSource ownerForRow:row col:col];
			}

			NSString *weightStr = [NSString stringWithFormat:@"%lu", (unsigned long)weight];
			
			CSPGameBoardCellView *cellView = [[CSPGameBoardCellView alloc] initWithFrame:CGRectZero weight:weightStr owner:owner backgroundColor:_backgroundColor borderColor:_borderColor];
			
			[cellView setDelegate:self];
			
			[_cellViews addObject:cellView];
			
			[self addSubview:cellView];
		}
	}
}

- (void)layoutSubviews {
	for (NSUInteger row = 0; row < _numberOfRows; row++) {
		for (NSUInteger col = 0; col < _numberOfCols; col++) {
			CSPGameBoardCellView *cellView = [self cellViewForRow:row col:col];
			[cellView setFrame:CGRectMake(col*_cellSize, row*_cellSize, _cellSize, _cellSize)];
		}
	}
}

- (void)updateCellViewForRow:(NSUInteger)row col:(NSUInteger)col {
	CSPGameBoardCellView *cellView = [self cellViewForRow:row col:col];
	[cellView updateWithOwner:[self.dataSource ownerForRow:row col:col]];
}

- (CSPGameBoardCellView *)cellViewForRow:(NSUInteger)row col:(NSUInteger)col {
	NSUInteger offset = row*_numberOfCols + col;
	CSPGameBoardCellView *cellView = _cellViews[offset];
	
	return cellView;
}

- (void)touchedCellFrame:(CGRect)frame {
	NSUInteger numberOfRows = 0;
	NSUInteger numberOfCols = 0;
	
	if ([self.dataSource respondsToSelector:@selector(numberOfRows)]) {
		numberOfRows = [self.dataSource numberOfRows];
	}
	
	if ([self.dataSource respondsToSelector:@selector(numberOfCols)]) {
		numberOfCols = [self.dataSource numberOfCols];
	}
	
	NSUInteger cellSize = (numberOfRows > 0) ? self.frame.size.height/numberOfRows : 0;
	
	NSUInteger touchedRow = 0;
	NSUInteger touchedCol = 0;
	
	BOOL isFound = NO;
	
	for (NSUInteger row = 0; row < numberOfRows; row++) {
		for (NSUInteger col = 0; col < numberOfCols; col++) {
			CGRect cellFrame = CGRectMake(col*cellSize, row*cellSize, cellSize, cellSize);
			
			if (frame.origin.x == cellFrame.origin.x && frame.origin.y == cellFrame.origin.y) {
				touchedRow = row;
				touchedCol = col;
				isFound = YES;
				
				break;
			}
		}
		
		if (isFound) {
			break;
		}
	}
	
	if ([self.delegate respondsToSelector:@selector(prepareToMoveAtRow:col:)]) {
		[self.delegate prepareToMoveAtRow:touchedRow col:touchedCol];
	}
}

@end
