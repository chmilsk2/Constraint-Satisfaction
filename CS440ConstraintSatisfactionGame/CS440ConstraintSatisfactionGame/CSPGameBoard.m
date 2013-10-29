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

- (void)setCellStateForRow:(NSUInteger)row col:(NSUInteger)col owner:(CSPOwner)playerOwner {
	CSPGameBoardCell *cell = [self cellForRow:row col:col];
	[cell setOwner:playerOwner];
}

- (NSUInteger)weightForRow:(NSUInteger)row col:(NSUInteger)col {
	CSPGameBoardCell *cell = [self cellForRow:row col:col];
	return cell.weight;
}

- (NSArray *)conquerableNeighborCellLocationsFromRow:(NSUInteger)row col:(NSUInteger)col {
	CSPGameBoardCell *currentCell = [self cellForRow:row col:col];
	
	NSUInteger allyNeighborCount = 0;
	
	NSMutableArray *conquerableCellLocations = [NSMutableArray array];
	
	// check the cell's neighbors
	NSInteger upRow = row - 1;
	NSInteger downRow = row + 1;
	NSInteger leftCol = col - 1;
	NSInteger rightCol = col + 1;
	
	if (upRow >= 0) {
		CSPGameBoardCell *upCell = [self cellForRow:upRow col:col];
		
		if (upCell.owner == currentCell.owner) {
			allyNeighborCount++;
		}
		
		else if (upCell.owner != CSPOwnerNone) {
			CGPoint location = CGPointMake(upRow, col);
			[conquerableCellLocations addObject:[NSValue valueWithCGPoint:location]];
		}
	}
	
	if (downRow < _numberOfRows) {
		CSPGameBoardCell *downCell = [self cellForRow:downRow col:col];
		
		if (downCell.owner == currentCell.owner) {
			allyNeighborCount++;
		}
		
		else if (downCell.owner != CSPOwnerNone) {
			CGPoint location = CGPointMake(downRow, col);
			[conquerableCellLocations addObject:[NSValue valueWithCGPoint:location]];
		}
	}
	
	if (leftCol >= 0) {
		CSPGameBoardCell *leftCell = [self cellForRow:row col:leftCol];
		
		if (leftCell.owner == currentCell.owner) {
			allyNeighborCount++;
		}
		
		else if (leftCell.owner != CSPOwnerNone) {
			CGPoint location = CGPointMake(row, leftCol);
			[conquerableCellLocations addObject:[NSValue valueWithCGPoint:location]];
		}
	}
	
	if (rightCol < _numberOfCols) {
		CSPGameBoardCell *rightCell = [self cellForRow:row col:rightCol];
		
		if (rightCell.owner == currentCell.owner) {
			allyNeighborCount++;
		}
		
		else if (rightCell.owner != CSPOwnerNone) {
			CGPoint location = CGPointMake(row, rightCol);
			[conquerableCellLocations addObject:[NSValue valueWithCGPoint:location]];
		}
	}
	
	if (!allyNeighborCount) {
		[conquerableCellLocations removeAllObjects];
	}
	
	return conquerableCellLocations;
}

@end
