//
//  CSPScheduleParser.m
//  CS440ConstraintSatisfaction
//
//  Created by Troy Chmieleski on 10/21/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "CSPScheduleParsingOperation.h"
#import "CSPSchedule.h"

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
	NSMutableDictionary *assignedMeetingsDict = [NSMutableDictionary dictionary];
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
			NSUInteger assignedMeetingsIndex = i + 1;
			
			BOOL shouldContinue = YES;
			
			while (shouldContinue) {
				NSArray *assignedMeetingsLineComponents = [lines[assignedMeetingsIndex] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@":"]];
				
				NSUInteger employeeId;
				
				if (assignedMeetingsLineComponents.count > 1) {
					employeeId = [[assignedMeetingsLineComponents firstObject] integerValue];
					
					NSMutableArray *assignedMeetings = [NSMutableArray array];
					NSString *assignedMeetingsStr = assignedMeetingsLineComponents[1];
					
					for (NSUInteger i = 0; i < assignedMeetingsStr.length; i++) {
						NSMutableArray *meetingIdComponents = [NSMutableArray array];
						
						while (i < assignedMeetingsStr.length && [assignedMeetingsStr characterAtIndex:i] != ' ') {
							char c = [assignedMeetingsStr characterAtIndex:i];
							NSUInteger meetingIdComponent = c - '0';
							NSNumber *meetingIdComponentNumber = [NSNumber numberWithInteger:meetingIdComponent];
							[meetingIdComponents addObject:meetingIdComponentNumber];
							i += 1;
						}
						
						NSString *meetingIdStr = @"";
						NSNumber *meetingIdNumber;
						
						for (NSUInteger i = 0; i < meetingIdComponents.count; i++) {
							NSString *meetingIdComponentStr = [meetingIdComponents[i] stringValue];
							meetingIdStr = [meetingIdStr stringByAppendingString:meetingIdComponentStr];
						}
						
						if (meetingIdStr.length) {
							meetingIdNumber = [NSNumber numberWithUnsignedInteger:[meetingIdStr integerValue]];
							[assignedMeetings addObject:meetingIdNumber];
						}
					}
					
					[assignedMeetingsDict setObject:assignedMeetings forKey:[NSNumber numberWithUnsignedInteger:employeeId]];
					
					if (employeeId == numberOfEmployees) {
						shouldContinue = NO;
					}
				}
				
				assignedMeetingsIndex++;
			}
		}
		
		else if ([[lineComponents firstObject] isEqualToString:SCHEDULE_TRAVEL_TIME_BETWEEN_MEETINGS_KEY]) {
			NSLog(@"%@", [NSNumber numberWithUnsignedInteger:[assignedMeetingsDict allKeys].count]);
			NSUInteger assignedTravelTimeBetweenMeetingsIndex = i + 1;
		}
	}
	
	schedule = [[CSPSchedule alloc] initWithNumberOfMeetings:numberOfMeetings numberOfEmployees:numberOfEmployees numberOfTimeSlots:numberOfTimeSlots assignedMeetingsDict:assignedMeetingsDict travelTimeBetweenMeetings:travelTimeBetweenMeetings];
	
	[self didFinishWithSchedule:schedule Error:error];
}

- (void)didFinishWithSchedule:(CSPSchedule *)schedule Error:(NSError *)error {
	if (self.scheduleParsingCompletionBlock) {
		self.scheduleParsingCompletionBlock(schedule, error);
	}
}

@end
