//
//  CSPEmployee.m
//  CS440ConstraintSatisfaction
//
//  Created by Troy Chmieleski on 10/24/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "CSPEmployee.h"

@implementation CSPEmployee

- (id)initWithEmployeeId:(NSNumber *)employeeId {
	self = [super init];
	
	if (self) {
		_employeeId = employeeId;
		_meetings = [NSMutableArray array];
	}
	
	return self;
}

@end
