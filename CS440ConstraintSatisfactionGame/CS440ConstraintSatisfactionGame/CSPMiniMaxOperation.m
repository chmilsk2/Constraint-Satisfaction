//
//  CSPMiniMaxOperation.m
//  CS440ConstraintSatisfactionGame
//
//  Created by Troy Chmieleski on 10/26/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "CSPMiniMaxOperation.h"

#define MINI_MAX_DEPTH 3

@implementation CSPMiniMaxOperation

- (void)main {
	NSError *error;
	
	[self miniMaxWithNode:self.root depth:MINI_MAX_DEPTH isMaximizingPlayer:self.root.isMaximizingPlayer];
	CSPNode *optimalNode = [self findOptimalNode];
	
	CGPoint optimaLocation = [self optimalLocationForNode:optimalNode];
	
	NSUInteger optimalRow = optimaLocation.x;
	NSUInteger optimalCol = optimaLocation.y;
	
	
	[self didFinishWithRow:optimalRow col:optimalCol error:error];
}

- (NSInteger)miniMaxWithNode:(CSPNode *)node depth:(NSUInteger)depth isMaximizingPlayer:(BOOL)isMaximizingPlayer {
	if (!depth || [self isTerminalNode:node]) {
		// return the heuristic value of node
		NSInteger heuristicValue = [self heuristicValueOfNode:node];
		
		return heuristicValue;
	}
	
	// max value
	if (node.isMaximizingPlayer) {
		NSInteger bestValue = NSIntegerMin;
		
		// find the node's children
		NSArray *children = [self childrenForNode:node];
		[node setChildren:children];
		
		for (CSPNode *child in children) {
			NSInteger val = [self miniMaxWithNode:child depth:depth - 1 isMaximizingPlayer:NO];
			bestValue = MAX(bestValue, val);
		}
		
		[node setValue:bestValue];

		return bestValue;
	}
	
	// min value
	else {
		NSInteger bestValue = NSIntegerMax;
		
		// find the node's children
		NSArray *children = [self childrenForNode:node];
		[node setChildren:children];
		
		for (CSPNode *child in children) {
			NSInteger val = [self miniMaxWithNode:child depth:depth - 1 isMaximizingPlayer:YES];
			bestValue = MIN(bestValue, val);
		}
		
		[node setValue:bestValue];
		
		return bestValue;
	}
}

@end
