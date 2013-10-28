//
//  CSPGameBoard.m
//  CS440ConstraintSatisfactionGame
//
//  Created by Troy Chmieleski on 10/26/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "CSPGameBoard.h"
#import "CSPGameBoardCell.h"

@implementation CSPGameBoard

- (id)initWithBoard:(NSArray *)board numberOfRows:(NSUInteger)numberOfRows numberOfCols:(NSUInteger)numberOfCols {
	self = [super init];
	
	if (self) {
		_numberOfRows = numberOfRows;
		_numberOfCols = numberOfCols;
		_board = board;
	}
	
	return self;
}

- (CSPGameBoardCell *)cellForRow:(NSUInteger)row col:(NSUInteger)col {
	NSUInteger offset = row*_numberOfCols+col;
	return _board[offset];
}

@end
