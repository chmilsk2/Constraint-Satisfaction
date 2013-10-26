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
	NSUInteger _numberOfAssignments;
}

- (id)initWithSchedule:(CSPSchedule *)schedule {
	self = [super init];
	
	if (self) {
		_schedule = schedule;
		_numberOfAssignments = 0;
	}
	
	return self;
}

- (void)main {
	NSError *error;
	
	NSDate *methodStart = [NSDate date];
	
	NSArray *assignment = [self backtrackingSearch];
	
	NSDate *methodFinish = [NSDate date];

	NSTimeInterval executionTime = [methodFinish timeIntervalSinceDate:methodStart] * 1000;
	
	[self didFinishWithAssignment:assignment numberOfAssignments:_numberOfAssignments executionTime:executionTime error:error];
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
		
		_numberOfAssignments++;
		
		if (_numberOfAssignments % 1000 == 0) {
			//NSLog(@"num: %lu", _numberOfAssignments);
		}
		
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
	__block NSUInteger numEmployees = NSNotFound;
	
	// most constrained variable, select the meeting with the most employees as the most constrained variable
	[_schedule.meetings enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
		CSPMeeting *meeting = [_schedule.meetings objectForKey:key];
		
		if (!meeting.timeSlot) {
			if (numEmployees == NSNotFound || meeting.employees.count > numEmployees) {
				unassignedMeeting = meeting;
				numEmployees = meeting.employees.count;
			}
		}
	}];
	
	return unassignedMeeting;
}


#pragma mark - Order Domain Values

- (NSArray *)orderDomainValuesForVar:(CSPMeeting *)var assignment:(NSArray *)assignment {
	// in what order should the values be tried
	// least constraining value (degree heuristic)
	// initially returned the original order of the values i.e. return self.timeslots
	
	// choose the time slot that has the least meetings
	// sort the time slots by the number of meetings in the time slot
	//return self.timeSlots;
	
	return self.timeSlots;
}

#pragma mark - Sort Meetings

- (void)sortMeetingsByTimeSlot:(NSMutableArray *)meetings {
	[meetings sortUsingComparator:^NSComparisonResult(CSPMeeting *meeting1, CSPMeeting *meeting2) {
		if (!meeting1.timeSlot || !meeting2.timeSlot) {
			if (!meeting1.timeSlot && !meeting2.timeSlot) {
				return NSOrderedSame;
			}
			
			if (!meeting1.timeSlot) {
				return NSOrderedDescending;
			}
			
			if (!meeting2.timeSlot) {
				return NSOrderedAscending;
			}
		}
		
		if (meeting1.timeSlot.unsignedIntegerValue > meeting2.timeSlot.unsignedIntegerValue) {
			return NSOrderedDescending;
		}
		
		if (meeting1.timeSlot.unsignedIntegerValue < meeting2.timeSlot.unsignedIntegerValue) {
			return NSOrderedAscending;
		}
		
		return NSOrderedSame;
	}];
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

- (void)didFinishWithAssignment:(NSArray *)assignment numberOfAssignments:(NSUInteger)numberOfAssignments executionTime:(NSTimeInterval)executionTime error:(NSError *)error {
	if (self.backtrackingSearchCompletionBlock) {
		self.backtrackingSearchCompletionBlock(assignment, numberOfAssignments, executionTime, error);
	}
}

@end
