//
//  CSPPlayer.m
//  CS440ConstraintSatisfactionGame
//
//  Created by Troy Chmieleski on 10/26/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "CSPPlayer.h"

@implementation CSPPlayer

- (id)initWithPlayerType:(CSPPlayerType)playerType playerNumber:(CSPPlayerNumber)playerNumber isFirstToMove:(BOOL)isFirstToMove {
	self = [super init];
	
	if (self) {
		_playerType = playerType;
		_playerNumber = playerNumber;
		_isFirstToMove = isFirstToMove;
		_score = 0;
		_totalNumberOfNodesExpanded = 0;
		_averageNumberOfNodesExpandedPerMove = 0;
		_averageTimePerMoveInSeconds = 0;
	}
	
	return self;
}

@end
