//
//  CSPPlayer.m
//  CS440ConstraintSatisfactionGame
//
//  Created by Troy Chmieleski on 10/26/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "CSPPlayer.h"

@implementation CSPPlayer

- (id)initWithPlayerType:(CSPPlayerType)playerType isFirstToMove:(BOOL)isFirstToMove {
	self = [super init];
	
	if (self) {
		_playerType = playerType;
		_isFirstToMove = isFirstToMove;
	}
	
	return self;
}

@end
