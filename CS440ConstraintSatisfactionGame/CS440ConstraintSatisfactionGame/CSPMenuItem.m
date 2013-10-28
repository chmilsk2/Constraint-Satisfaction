//
//  CSPMenuItem.m
//  CS440ConstraintSatisfactionGame
//
//  Created by Troy Chmieleski on 10/27/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "CSPMenuItem.h"

@implementation CSPMenuItem

- (id)initWithName:(NSString *)name isSelected:(BOOL)isSelected {
	self = [super init];
	
	if (self) {
		_name = name;
		_isSelected = isSelected;
	}
	
	return self;
}

@end
