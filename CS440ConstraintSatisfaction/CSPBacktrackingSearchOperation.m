//
//  CSPBacktrackingSearchOperation.m
//  CS440ConstraintSatisfaction
//
//  Created by Troy Chmieleski on 10/23/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "CSPBacktrackingSearchOperation.h"
#import "CSPSchedule.h"
#import "CSPMeeting.h"
#import "CSPEmployee.h"

@implementation CSPBacktrackingSearchOperation {
	CSPSchedule *_schedule;
	NSMutableArray *_timeSlots;
}

- (id)initWithSchedule:(CSPSchedule *)schedule {
	self = [super init];
	
	if (self) {
		_schedule = schedule;
	}
	
	return self;
}

- (void)main {
	NSError *error;
	
	NSArray *assignment = [self backtrackingSearch];
	
	[self didFinishWithAssignment:(NSArray *)assignment error:error];
}

#pragma mark - Backtracking Search

- (NSArray *)backtrackingSearch {
	// start out with empty assignment
	NSMutableArray *assignment = [NSMutableArray array];
	for (NSUInteger i = 0; i < _schedule.numberOfTimeSlots; i++) {
		NSMutableArray *individualAssignment = [NSMutableArray array];
		[assignment addObject:individualAssignment];
	}
	
	return [self backtrackWithAssignment:assignment];
}

#pragma mark - Backtrack

- (NSArray *)backtrackWithAssignment:(NSMutableArray *)assignment {
	if ([self isAssignmentComplete:assignment]) {
		return assignment;
	}
	
	CSPMeeting *var = [self selectUnassignedVariable];
	
	NSArray *values = [self orderDomainValuesForVar:var assignment:assignment];
	
	// loop through all of the values and check if the value is a valid assignment
	// if it is a valid assignment, then keep it, otherwise remove it from the assignments
	for (NSNumber *value in values) {
		[assignment[value.unsignedIntegerValue - 1] addObject:var];
		[var setTimeSlot:value];
		
		//[self prettyPrintAssignment:assignment];
		
		BOOL isAssignmentValid = [self isValidAssignment:assignment];
		
		if (isAssignmentValid) {
			NSArray *result = [self backtrackWithAssignment:assignment];
			
			if (result) {
				return result;
			}
		}
		
		[assignment[value.unsignedIntegerValue - 1] removeObject:var];
		[var setTimeSlot:nil];
	}
	
	return nil;
}

- (void)prettyPrintAssignment:(NSArray *)assignment {
	NSString *assignmentStr = @"Assignment: ";
	
	for (NSUInteger i = 0; i < assignment.count; i++) {
		NSArray *timeSlotAssignment = assignment[i];
		NSString *timeSlotAssignmentStr = @"[";
		
		if (timeSlotAssignment.count) {
			for (NSUInteger j = 0; j < timeSlotAssignment.count; j++) {
				CSPMeeting *meeting = timeSlotAssignment[j];
				
				if (![meeting isEqual:timeSlotAssignment.lastObject]) {
					timeSlotAssignmentStr = [timeSlotAssignmentStr stringByAppendingString:[NSString stringWithFormat:@"%@, ", [meeting.meetingId stringValue]]];
				}
				
				else {
					timeSlotAssignmentStr = [timeSlotAssignmentStr stringByAppendingString:[NSString stringWithFormat:@"%@]", [meeting.meetingId stringValue]]];
				}
			}
		}
		
		else {
			timeSlotAssignmentStr = [timeSlotAssignmentStr stringByAppendingString:@"]"];
		}
		
		assignmentStr = [assignmentStr stringByAppendingString:[NSString stringWithFormat:@"%lu: %@ ", (unsigned long)(i+1), timeSlotAssignmentStr]];
	}
	
	NSLog(@"%@", assignmentStr);
}

#pragma mark - Order Domain Values

- (NSArray *)orderDomainValuesForVar:(CSPMeeting *)var assignment:(NSArray *)assignment {
	// in what order should the values be tried
	// least constraining value (degree heuristic)
	// for now just return the original order of the time slots
	return self.timeSlots;
}

- (NSMutableArray *)timeSlots {
	if (!_timeSlots) {
		_timeSlots = [NSMutableArray array];
	
		for (NSUInteger i = 1; i <= _schedule.numberOfTimeSlots; i++) {
			[_timeSlots addObject:[NSNumber numberWithUnsignedInteger:i]];
		}
	}
	
	return _timeSlots;
}

#pragma mark - Is Assignment Complete

- (BOOL)isAssignmentComplete:(NSArray *)assignment {
	BOOL isAssignmentComplete = NO;
	__block BOOL isEveryAssignmentMade = YES;
	BOOL isValidAssignment = NO;
	
	// check if every meeting has an assignment
	[_schedule.meetings enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
		CSPMeeting *meeting = [_schedule.meetings objectForKey:key];
		
		if (!meeting.timeSlot) {
			isEveryAssignmentMade = NO;
			*stop = YES;
		}
	}];

	if (isEveryAssignmentMade) {
		isValidAssignment = [self isValidAssignment:assignment];
	}
	
	if (isEveryAssignmentMade && isValidAssignment) {
		isAssignmentComplete = YES;
	}
	
	return isAssignmentComplete;
}

- (BOOL)isValidAssignment:(NSArray *)assignment {
	// assignment is complete if all the constraints are satisfied
	
	// check that no employee has more than 1 meeting during a particular time slot
	BOOL hasNoMoreThanOneMeetingPerTimeSlot = [self hasNoMoreThanOneMeetingPerTimeSlotForAssignment:assignment];
	
	if (!hasNoMoreThanOneMeetingPerTimeSlot) {
		return NO;
	}
	
	// check that the employee can make it to all of the assigned meetings
	BOOL hasSatisfiableTravelTimes = [self hasSatisfiableTravelTimesForAssignment:assignment];
	
	if (!hasSatisfiableTravelTimes) {
		return NO;
	}
	
	return YES;
}

- (BOOL)hasNoMoreThanOneMeetingPerTimeSlotForAssignment:(NSArray *)assignment {
	for (NSUInteger timeSlot = 0; timeSlot < _schedule.numberOfTimeSlots; timeSlot++) {
		NSArray *individualMeetingAssignments = assignment[timeSlot];
		
		for (CSPMeeting *meeting in individualMeetingAssignments) {
			// retrieve the employees for each meeting
			NSArray *employees = meeting.employees;
			
			for (CSPEmployee *employee in employees) {
				// make sure no time slotted meetings are at the same time for a given employee
				for (NSUInteger i = 0; i < employee.meetings.count; i++) {					
					CSPMeeting *meeting1 = employee.meetings[i];
				
					if (meeting1.timeSlot) {
						for (NSUInteger j = i+1; j < employee.meetings.count; j++) {
							CSPMeeting *meeting2 = employee.meetings[j];
							
							if (meeting2.timeSlot) {
								if (meeting1.timeSlot.unsignedIntegerValue == meeting2.timeSlot.unsignedIntegerValue) {
									return NO;
								}
							}
							
							else {
								break;
							}
						}
					}
					
					else {
						break;
					}
				}
			}
		}
	}
	
	return YES;
}

- (BOOL)hasSatisfiableTravelTimesForAssignment:(NSArray *)assignment {
	// loop through all of the time slots in the assignment
	for (NSUInteger timeSlot = 1; timeSlot <= _schedule.numberOfTimeSlots; timeSlot++) {
		// loop through all of the meetings in the assignment
		NSArray *meetings = assignment[timeSlot - 1];
		
		for (CSPMeeting *meeting in meetings) {
			// loop through all of the employees associated with the meeting
			NSArray *employees = meeting.employees;
			
			for (CSPEmployee *employee in employees) {
				// meetings without time slots are placed at the end of the array
				[self sortMeetingsByTimeSlot:employee.meetings];
			
				// make sure the employee can make the next meeting
				for (NSUInteger i = 0; i < employee.meetings.count - 1; i++) {
					CSPMeeting *meeting1 = employee.meetings[i];
					
					if (meeting1.timeSlot) {
						if (meeting1.timeSlot.unsignedIntegerValue == timeSlot) {
							CSPMeeting *meeting2 = employee.meetings[i+1];
							
							NSUInteger delta = meeting2.timeSlot.unsignedIntegerValue - meeting1.timeSlot.unsignedIntegerValue;
							
							if (delta <= [_schedule travelTimeBetweenMeeting1:meeting1 meeting2:meeting2]) {
								return NO;
							}
						}
					}
					
					else {
						break;
					}
				}
			}
			
		}
	}
	
	return YES;
}

#pragma mark - Select Unassigned Variable

- (CSPMeeting *)selectUnassignedVariable {
	// the variables for the CSP are the meetings
	__block CSPMeeting *unassignedMeeting;
	
	// for now, just select a random variable that is not assigned
	[_schedule.meetings enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
		CSPMeeting *meeting = [_schedule.meetings objectForKey:key];
		
		if (!meeting.timeSlot) {
			unassignedMeeting = meeting;
			*stop = YES;
		}
	}];
	
	return unassignedMeeting;
}

#pragma mark - Sort Meetings

- (void)sortMeetingsByTimeSlot:(NSMutableArray *)meetings {
	[meetings sortUsingComparator:^NSComparisonResult(CSPMeeting *meeting1, CSPMeeting *meeting2) {
		if (!meeting1.timeSlot || !meeting2.timeSlot) {
			if (!meeting1.timeSlot && !meeting2.timeSlot) {
				return (NSComparisonResult)NSOrderedSame;
			}
			
			if (!meeting1.timeSlot) {
				return (NSComparisonResult)NSOrderedDescending;
			}
			
			if (!meeting2.timeSlot) {
				return (NSComparisonResult)NSOrderedAscending;
			}
		}
		
		if (meeting1.timeSlot.unsignedIntegerValue > meeting2.timeSlot.unsignedIntegerValue) {
			return (NSComparisonResult)NSOrderedDescending;
		}
		
		if (meeting1.timeSlot.unsignedIntegerValue < meeting2.timeSlot.unsignedIntegerValue) {
			return (NSComparisonResult)NSOrderedAscending;
		}
		
		return (NSComparisonResult)NSOrderedSame;
	}];
}

- (void)didFinishWithAssignment:(NSArray *)assignment error:(NSError *)error {
	if (self.backtrackingSearchCompletionBlock) {
		self.backtrackingSearchCompletionBlock(assignment, error);
	}
}

@end
