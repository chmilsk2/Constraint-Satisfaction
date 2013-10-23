//
//  CSPSchedule.h
//  CS440ConstraintSatisfaction
//
//  Created by Troy Chmieleski on 10/23/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSPSchedule : NSObject

@property NSUInteger numberOfMeetings;
@property NSUInteger numberOfEmployees;
@property NSUInteger numberOfTimeSlots;
@property NSDictionary *assignedMeetingsDict;
@property NSArray *travelTimeBetweenMeetings;

- (id)initWithNumberOfMeetings:(NSUInteger)numberOfMeetings numberOfEmployees:(NSUInteger)numberOfEmployees numberOfTimeSlots:(NSUInteger)numberOfTimeSlots assignedMeetingsDict:(NSDictionary *)assignedMeetingsDict travelTimeBetweenMeetings:(NSArray *)travelTimeBetweenMeetings;

@end
