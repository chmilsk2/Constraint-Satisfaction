//
//  CSPNode.m
//  CS440ConstraintSatisfactionGame
//
//  Created by Troy Chmieleski on 10/28/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "CSPNode.h"
#import "CSPCellOwner.h"

@implementation CSPNode

- (id)initWithBoard:(CSPGameBoard *)board isMaximizingPlayer:(BOOL)isMaximizingPlayer {
	self = [super init];
	
	if (self) {
		_board = board;
		_isMaximizingPlayer = isMaximizingPlayer;
	}
	
	return self;
}

@end
