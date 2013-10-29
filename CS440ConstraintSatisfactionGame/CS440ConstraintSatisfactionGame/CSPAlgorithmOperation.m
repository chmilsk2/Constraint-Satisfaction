//
//  CSPAlgorithmOperation.m
//  CS440ConstraintSatisfactionGame
//
//  Created by Troy Chmieleski on 10/26/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "CSPAlgorithmOperation.h"
#import "CSPNode.h"
#import "CSPGameBoardCell.h"

@implementation CSPAlgorithmOperation

- (id)initWithRoot:(CSPNode *)root {
	self = [super init];
	
	if (self) {
		_root = root;
	}
	
	return self;
}

- (BOOL)isTerminalNode:(CSPNode *)node {
	BOOL isTerminalNode = YES;
	
	// if there are no more unoccupied spaces on the board, the node is a terminal node
	for (NSUInteger row = 0; row < node.board.numberOfRows; row++) {
		for (NSUInteger col = 0; col < node.board.numberOfCols; col++) {
			CSPGameBoardCell *cell = [node.board cellForRow:row col:col];
			
			if (cell.owner == CSPOwnerNone) {
				isTerminalNode = NO;
				return isTerminalNode;
			}
		}
	}
	
	return isTerminalNode;
}

- (NSArray *)childrenForNode:(CSPNode *)node {
	NSMutableArray *children = [NSMutableArray array];
	
	NSUInteger owner;
	
	// player 1 is always treated as the maximizing player
	if (node.isMaximizingPlayer) {
		owner = CSPOwnerPlayer1;
	}
	
	else {
		owner = CSPOwnerPlayer2;
	}
	
	for (NSUInteger row = 0; row < node.board.numberOfRows; row++) {
		for (NSUInteger col = 0; col < node.board.numberOfCols; col++) {
			// each empty cell represents a new child
			CSPGameBoardCell *cell = [node.board cellForRow:row col:col];
			
			if (cell.owner == CSPOwnerNone) {
				CSPGameBoard *childBoard = [node.board copy];
				
				// set the current cell
				[childBoard setCellStateForRow:row col:col owner:owner];
				
				// retrieve conquerable neighbors if any exist
				NSArray *conquerableNeighborCellLocations = [childBoard conquerableNeighborCellLocationsFromRow:row col:col];
				
				for (NSValue *location in conquerableNeighborCellLocations) {
					NSUInteger conquerableNeighborRow = location.CGPointValue.x;
					NSUInteger conquerableNeighborCol = location.CGPointValue.y;
					
					[childBoard setCellStateForRow:conquerableNeighborRow col:conquerableNeighborCol owner:owner];
				}
				
				CSPNode *child = [[CSPNode alloc] initWithBoard:childBoard isMaximizingPlayer:!node.isMaximizingPlayer];
				[child setRow:row];
				[child setCol:col];
				[children addObject:child];
			}
		}
	}
	
	return children;
}

- (NSInteger)heuristicValueOfNode:(CSPNode *)node {
	NSInteger heuristicValue = 0;
	
	for (NSUInteger row = 0; row < node.board.numberOfRows; row++) {
		for (NSUInteger col = 0; col < node.board.numberOfCols; col++) {
			CSPGameBoardCell *cell = [node.board cellForRow:row col:col];
			
			// player 1 is maximizing player, player 2 is minimizing player
			if (cell.owner == CSPOwnerPlayer1) {
				heuristicValue += cell.weight;
			}
			
			else if (cell.owner == CSPOwnerPlayer2) {
				heuristicValue -= cell.weight;
			}
		}
	}
	
	return heuristicValue;
}

- (CSPNode *)findOptimalNode {
	// find the node that matches the root's score
	CSPNode *optimalNode;
	
	for (CSPNode *node in self.root.children) {
		if (node.value == self.root.value) {
			optimalNode = node;
			break;
		}
	}
	
	return optimalNode;
}

- (CGPoint)optimalLocationForNode:(CSPNode *)node {
	CGPoint optimalLocation;
	
	if (node) {
		optimalLocation.x = node.row;
		optimalLocation.y = node.col;
	}
	
	else {
		BOOL didFindOptimalLocation = NO;
		
		// only one space left on the board, must take that space
		for (NSUInteger row = 0; row < self.root.board.numberOfRows; row++) {
			for (NSUInteger col = 0; col < self.root.board.numberOfCols; col++) {
				CSPGameBoardCell *cell = [self.root.board cellForRow:row col:col];
				
				if (cell.owner == CSPOwnerNone) {
					optimalLocation.x = row;
					optimalLocation.y = col;
					
					didFindOptimalLocation = YES;
					break;
				}
			}
			
			if (didFindOptimalLocation) {
				break;
			}
		}
	}
	
	return optimalLocation;
}

- (void)didFinishWithRow:(NSUInteger)row col:(NSUInteger)col error:(NSError *)error {
	if (self.aglorithmOperationCompletionBlock) {
		self.aglorithmOperationCompletionBlock(row, col, error);
	}
}

@end
