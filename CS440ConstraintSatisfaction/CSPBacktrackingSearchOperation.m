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

#pragma mark - Order Domain Values

- (NSArray *)orderDomainValuesForVar:(CSPMeeting *)var assignment:(NSArray *)assignment {
	// in what order should the values be tried
	// least constraining value (degree heuristic)
	
	// for now just return the original order of the time slots
	NSMutableArray *timeSlots = [NSMutableArray array];
	
	for (NSUInteger i = 1; i <= _schedule.numberOfTimeSlots; i++) {
		[timeSlots addObject:[NSNumber numberWithUnsignedInteger:i]];
	}
	
	return timeSlots;
}

#pragma mark - Is Assignment Complete

- (BOOL)isAssignmentComplete:(NSArray *)assignment {
	BOOL isAssignmentComplete = NO;
	BOOL isEveryAssignmentMade = YES;
	BOOL isValidAssignment = NO;
	
	// check if every meeting has an assignment
	NSArray *allKeys = _schedule.meetings.allKeys;
	for (NSUInteger i = 0; i < allKeys.count; i++) {
		CSPMeeting *meeting = [_schedule.meetings objectForKey:allKeys[i]];
		
		if (!meeting.timeSlot) {
			isEveryAssignmentMade = NO;
			break;
		}
	}
	
	if (isEveryAssignmentMade) {
		isValidAssignment = [self isValidAssignment:assignment];
	}
	
	if (isEveryAssignmentMade && isValidAssignment) {
		isAssignmentComplete = YES;
	}
	
	return isAssignmentComplete;
}

- (BOOL)isValidAssignment:(NSArray *)assignment {
	BOOL isValidAssignment = NO;
	
	// assignment is complete if all the constraints are satisfied
	
	// check that no employee has more than 1 meeting during a particular time slot
	BOOL hasNoMoreThanOneMeetingPerTimeSlot = [self hasNoMoreThanOneMeetingPerTimeSlotForAssignment:assignment];
	
	// check that the employee can make it to all of the assigned meetings
	BOOL hasSatisfiableTravelTimes = [self hasSatisfiableTravelTimesForAssignment:assignment];
	
	if (hasNoMoreThanOneMeetingPerTimeSlot && hasSatisfiableTravelTimes) {
		isValidAssignment = YES;
	}
	
	return isValidAssignment;
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
					for (NSUInteger j = i+1; j < employee.meetings.count; j++) {
						if ([employee.meetings[i] isEqual:employee.meetings[j]]) {
							return NO;
						}
					}
				}
			}
		}
	}
	
	return YES;
}

- (BOOL)hasSatisfiableTravelTimesForAssignment:(NSArray *)assignment {
	NSMutableDictionary *employeesChecked = [NSMutableDictionary dictionary];
	
	// loop through all of the time slots in the assignment
	for (NSUInteger timeSlot = 0; timeSlot < _schedule.numberOfTimeSlots; timeSlot++) {
		// loop through all of the meetings in the assignment
		NSArray *meetings = assignment[timeSlot];
		
		for (CSPMeeting *meeting in meetings) {
			// loop through all of the employees associated with the meeting
			NSArray *employees = meeting.employees;
			
			for (CSPEmployee *employee in employees) {
				if (![employeesChecked objectForKey:employee.employeeId]) {
					// sort the meetings for the employee
					NSMutableArray *timeSlottedMeetings = [NSMutableArray array];
					
					for (CSPMeeting *meeting in employee.meetings) {
						if (meeting.timeSlot) {
							[timeSlottedMeetings addObject:meeting];
						}
					}
					
					NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeSlot"
																				   ascending:YES];
					NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
					NSArray *sortedArray = [timeSlottedMeetings sortedArrayUsingDescriptors:sortDescriptors];
					
					// make sure the employee can make the next meeting
					for (NSUInteger i = 0; i < sortedArray.count - 1; i++) {
						CSPMeeting *meeting1 = sortedArray[i];
						CSPMeeting *meeting2 = sortedArray[i+1];
						
						NSUInteger delta = meeting2.timeSlot.unsignedIntegerValue - meeting1.timeSlot.unsignedIntegerValue;
						
						if (delta <= [_schedule travelTimeBetweenMeeting1:meeting1 meeting2:meeting2]) {
							return NO;
						}
					}
					
					// if the employees travel times have already been checked for consistency, do not check them again
					[employeesChecked setObject:employee forKey:employee.employeeId];
				}
			}
			
		}
	}
	
	return YES;
}

#pragma mark - Select Unassigned Variable

- (CSPMeeting *)selectUnassignedVariable {
	// the variables for the CSP are the meetings
	CSPMeeting *unassignedMeeting;
	
	// for now, just select a random variable that is not assigned
	NSArray *allKeys = _schedule.meetings.allKeys;
	for (NSUInteger i = 0; i < allKeys.count; i++) {
		CSPMeeting *meeting = [_schedule.meetings objectForKey:allKeys[i]];
		
		if (!meeting.timeSlot) {
			unassignedMeeting = meeting;
			break;
		}
	}
	
	return unassignedMeeting;
}

- (void)didFinishWithAssignment:(NSArray *)assignment error:(NSError *)error {
	if (self.backtrackingSearchCompletionBlock) {
		self.backtrackingSearchCompletionBlock(assignment, error);
	}
}

@end
