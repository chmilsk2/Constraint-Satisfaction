//
//  CSPGameBoardCell.m
//  CS440ConstraintSatisfactionGame
//
//  Created by Troy Chmieleski on 10/27/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "CSPGameBoardCell.h"

@implementation CSPGameBoardCell

- (id)initWithWeight:(NSUInteger)weight {
	self = [super init];
	
	if (self) {
		_weight = weight;
		_owner = CSPOwnerNone;
	}
	
	return self;
}

- (id)copyWithZone:(NSZone *)zone {
	CSPGameBoardCell *copy = [[CSPGameBoardCell alloc] init];
	
	if (copy) {
		[copy setWeight:self.weight];
		[copy setOwner:self.owner];
	}
	
	return copy;
}

@end
