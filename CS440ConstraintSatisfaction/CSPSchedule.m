//
//  CSPSchedule.m
//  CS440ConstraintSatisfaction
//
//  Created by Troy Chmieleski on 10/23/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "CSPSchedule.h"

@implementation CSPSchedule

- (id)initWithNumberOfMeetings:(NSUInteger)numberOfMeetings
			 numberOfEmployees:(NSUInteger)numberOfEmployees
			 numberOfTimeSlots:(NSUInteger)numberOfTimeSlots
					 employees:(NSDictionary *)employees
					  meetings:(NSDictionary *)meetings
	 travelTimeBetweenMeetings:(NSArray *)travelTimeBetweenMeetings {
	self = [super init];
	
	if (self) {
		_numberOfMeetings = numberOfMeetings;
		_numberOfEmployees = numberOfEmployees;
		_numberOfTimeSlots = numberOfTimeSlots;
		_employees = employees;
		_meetings = meetings;
		_travelTimeBetweenMeetings = travelTimeBetweenMeetings;
	}
	
	return self;
}

#pragma mark - Travel Time Between Meetings

- (NSUInteger)travelTimeBetweenMeeting1:(NSUInteger)meeting1 meeting2:(NSUInteger)meeting2 {
	// row major order offset
	// matrix is symmetric so it doesn't matter which meeting passed in is used for the row or column
	NSUInteger offset = (meeting1 - 1)*_numberOfMeetings+(meeting2 - 1);
	
	return [_travelTimeBetweenMeetings[offset] unsignedIntegerValue];
}

@end
