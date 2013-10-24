//
//  CSPScheduleParser.m
//  CS440ConstraintSatisfaction
//
//  Created by Troy Chmieleski on 10/21/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "CSPScheduleParsingOperation.h"
#import "CSPSchedule.h"
#import "CSPMeeting.h"
#import "CSPEmployee.h"

#define SCHEDULE_EXTENSION_TYPE @".txt"
#define SCHEDULE_NUMBER_OF_MEETINGS_KEY @"Number of meetings"
#define SCHEDULE_NUMBER_OF_EMPLOYEES_KEY @"Number of employees"
#define SCHEDULE_NUMBER_OF_TIME_SLOTS_KEY @"Number of time slots"
#define SCHEDULE_ASSIGNED_MEETINGS_KEY @"Meetings each employee must attend"
#define SCHEDULE_TRAVEL_TIME_BETWEEN_MEETINGS_KEY @"Travel time between meetings"

@implementation CSPScheduleParsingOperation {
	NSString *_scheduleName;
}

- (id)initWithScheduleName:(NSString *)scheduleName {
    self = [super init];
	
    if (self) {
        _scheduleName = scheduleName;
    }
	
    return self;
}

- (void)main {
	NSError *error;
	
	CSPSchedule *schedule;
	
	NSUInteger numberOfMeetings;
	NSUInteger numberOfEmployees;
	NSUInteger numberOfTimeSlots;
	NSMutableDictionary *employees = [NSMutableDictionary dictionary];
	NSMutableDictionary *meetings = [NSMutableDictionary dictionary];
	NSMutableArray *travelTimeBetweenMeetings = [NSMutableArray array];
	
	NSString *filePath = [[NSBundle mainBundle] pathForResource:_scheduleName ofType:SCHEDULE_EXTENSION_TYPE];
	NSString *fileContents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
	NSArray *lines = [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
	
	for (NSUInteger i = 0; i < lines.count; i++) {
		NSString *line = lines[i];
		
		NSArray *lineComponents = [line componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@":"]];
		
		if ([[lineComponents firstObject] isEqualToString:SCHEDULE_NUMBER_OF_MEETINGS_KEY]) {
			NSString *numberOfMeetingsStr = lineComponents[1];
			numberOfMeetings = [numberOfMeetingsStr integerValue];
		}
			
		else if ([[lineComponents firstObject] isEqualToString:SCHEDULE_NUMBER_OF_EMPLOYEES_KEY]) {
			NSString *numberOfEmployeesStr = lineComponents[1];
			numberOfEmployees = [numberOfEmployeesStr integerValue];
		}
		
		else if ([[lineComponents firstObject] isEqualToString:SCHEDULE_NUMBER_OF_TIME_SLOTS_KEY]) {
			NSString *numberOfTimeSlotsStr = lineComponents[1];
			numberOfTimeSlots = [numberOfTimeSlotsStr integerValue];
		}
		
		else if ([[lineComponents firstObject] isEqualToString:SCHEDULE_ASSIGNED_MEETINGS_KEY]) {
			NSUInteger meetingsIndex = i + 1;
			
			BOOL shouldContinue = YES;
			
			while (shouldContinue) {
				NSArray *meetingsLineComponents = [lines[meetingsIndex] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@":"]];
				
				NSNumber *employeeId;
				
				if (meetingsLineComponents.count > 1) {
					employeeId = [NSNumber numberWithUnsignedInteger:[[meetingsLineComponents firstObject] integerValue]];
					CSPEmployee *employee = [[CSPEmployee alloc] initWithEmployeeId:employeeId];
					
					NSString *meetingsStr = meetingsLineComponents[1];
					
					NSArray *meetingIds = [self parsedIdsFromSpaceDelimitedString:meetingsStr];
					
					for (NSNumber *meetingId in meetingIds) {
						CSPMeeting *meeting = [meetings objectForKey:meetingId];
						
						if (!meeting) {
							meeting = [[CSPMeeting alloc] initWithMeetingId:meetingId];
						}
						
						// add employeee relationship to meeting
						[meeting.employees addObject:employee];
						
						// add meeting relationship to employee
						[employee.meetings addObject:meeting];
						
						[meetings setObject:meeting forKey:meetingId];
					}
					
					[employees setObject:employee forKey:employeeId];
					
					if (employeeId.unsignedIntegerValue == numberOfEmployees) {
						shouldContinue = NO;
					}
				}
				
				meetingsIndex++;
			}
			
			i = meetingsIndex;
		}
		
		else if ([[lineComponents firstObject] isEqualToString:SCHEDULE_TRAVEL_TIME_BETWEEN_MEETINGS_KEY]) {
			NSUInteger assignedTravelTimeBetweenMeetingsIndex = i + 1;
			
			BOOL shouldContinue = YES;
			
			while (shouldContinue) {
				NSArray *travelTimeBetweenMeetingsLineComponents = [lines[assignedTravelTimeBetweenMeetingsIndex] componentsSeparatedByString:@":"];
				
				NSUInteger meetingNumber;
				
				if (travelTimeBetweenMeetingsLineComponents.count > 1) {
					meetingNumber = [[travelTimeBetweenMeetingsLineComponents firstObject] integerValue];
					
					NSString *travelTimeBetweenMeetingsStr = travelTimeBetweenMeetingsLineComponents[1];
					
					NSArray *travelTimeBetweenMeetingsRow = [self parsedIdsFromSpaceDelimitedString:travelTimeBetweenMeetingsStr];
					
					[travelTimeBetweenMeetings addObjectsFromArray:travelTimeBetweenMeetingsRow];
					
					if (meetingNumber == numberOfMeetings) {
						shouldContinue = NO;
					}
				}
				
				assignedTravelTimeBetweenMeetingsIndex++;
			}
			
			i = assignedTravelTimeBetweenMeetingsIndex;
		}
	}
	
	schedule = [[CSPSchedule alloc] initWithNumberOfMeetings:numberOfMeetings
										   numberOfEmployees:numberOfEmployees
										   numberOfTimeSlots:numberOfTimeSlots
												   employees:employees
													meetings:meetings
								   travelTimeBetweenMeetings:travelTimeBetweenMeetings];
	
	[self didFinishWithSchedule:schedule Error:error];
}

#pragma mark - Parse a Line of Space Delimited Ids

- (NSArray *)parsedIdsFromSpaceDelimitedString:(NSString *)string {
	NSMutableArray *assignedIds = [NSMutableArray array];
	
	for (NSUInteger i = 0; i < string.length; i++) {
		NSMutableArray *idComponents = [NSMutableArray array];
		
		while (i < string.length && [string characterAtIndex:i] != ' ') {
			char c = [string characterAtIndex:i];
			NSUInteger idComponent = c - '0';
			NSNumber *idComponentNumber = [NSNumber numberWithInteger:idComponent];
			[idComponents addObject:idComponentNumber];
			i += 1;
		}
		
		NSString *idStr = @"";
		NSNumber *idNumber;
		
		for (NSUInteger i = 0; i < idComponents.count; i++) {
			NSString *idComponentStr = [idComponents[i] stringValue];
			idStr = [idStr stringByAppendingString:idComponentStr];
		}
		
		if (idStr.length) {
			idNumber = [NSNumber numberWithUnsignedInteger:[idStr integerValue]];
			[assignedIds addObject:idNumber];
		}
	}
	
	return [assignedIds copy];
}

- (void)didFinishWithSchedule:(CSPSchedule *)schedule Error:(NSError *)error {
	if (self.scheduleParsingCompletionBlock) {
		self.scheduleParsingCompletionBlock(schedule, error);
	}
}

@end
