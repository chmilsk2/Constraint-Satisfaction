//
//  CSPMenuSectionItem.m
//  CS440ConstraintSatisfactionGame
//
//  Created by Troy Chmieleski on 10/27/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "CSPMenuSectionItem.h"

@implementation CSPMenuSectionItem

- (id)initWithName:(NSString *)name rows:(NSArray *)rows {
	self = [super init];
	
	if (self) {
		_name = name;
		_rows = rows;
	}
	
	return self;
}

@end
