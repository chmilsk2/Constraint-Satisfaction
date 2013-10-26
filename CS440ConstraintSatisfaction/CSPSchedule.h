//
//  CSPSchedule.h
//  CS440ConstraintSatisfaction
//
//  Created by Troy Chmieleski on 10/23/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CSPMeeting;

@interface CSPSchedule : NSObject

@property (nonatomic) NSUInteger numberOfMeetings;
@property (nonatomic) NSUInteger numberOfEmployees;
@property (nonatomic) NSUInteger numberOfTimeSlots;
@property (nonatomic) NSDictionary *employees;
@property (nonatomic) NSDictionary *meetings;
@property (nonatomic) NSArray *travelTimeBetweenMeetings;

- (id)initWithNumberOfMeetings:(NSUInteger)numberOfMeetings
			 numberOfEmployees:(NSUInteger)numberOfEmployees
			 numberOfTimeSlots:(NSUInteger)numberOfTimeSlots
					 employees:(NSDictionary *)employees
					  meetings:(NSDictionary *)meetings
	 travelTimeBetweenMeetings:(NSArray *)travelTimeBetweenMeetings;

- (NSUInteger)travelTimeBetweenMeeting1:(CSPMeeting *)meeting1 meeting2:(CSPMeeting *)meeting2;

@end
