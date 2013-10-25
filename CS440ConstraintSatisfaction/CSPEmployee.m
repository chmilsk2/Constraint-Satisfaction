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

- (BOOL)isEqualToEmployee:(CSPEmployee *)employee {
	BOOL isEqualToEmployee = NO;
	
	if ([_employeeId isEqualToNumber:employee.employeeId]) {
		isEqualToEmployee = YES;
	}
	
	return isEqualToEmployee;
}

- (BOOL)isEqual:(id)object {
	if (self == object) {
		return YES;
	}
	
	if (![object isKindOfClass:[CSPEmployee class]]) {
		return NO;
	}
	
	return [self isEqualToEmployee:(CSPEmployee *)object];
}

@end
