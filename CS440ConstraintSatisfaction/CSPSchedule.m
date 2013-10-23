//
//  CSPSchedule.m
//  CS440ConstraintSatisfaction
//
//  Created by Troy Chmieleski on 10/23/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "CSPSchedule.h"

@implementation CSPSchedule

- (id)initWithNumberOfMeetings:(NSUInteger)numberOfMeetings numberOfEmployees:(NSUInteger)numberOfEmployees numberOfTimeSlots:(NSUInteger)numberOfTimeSlots assignedMeetingsDict:(NSDictionary *)assignedMeetingsDict travelTimeBetweenMeetings:(NSArray *)travelTimeBetweenMeetings {
	self = [super init];
	
	if (self) {
		_numberOfMeetings = numberOfMeetings;
		_numberOfEmployees = numberOfEmployees;
		_numberOfTimeSlots = numberOfTimeSlots;
		_assignedMeetingsDict = assignedMeetingsDict;
		_travelTimeBetweenMeetings = travelTimeBetweenMeetings;
	}
	
	return self;
}

@end
