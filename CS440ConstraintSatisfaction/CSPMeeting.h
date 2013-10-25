//
//  CSPMeeting.h
//  CS440ConstraintSatisfaction
//
//  Created by Troy Chmieleski on 10/24/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSPMeeting : NSObject

@property NSNumber *meetingId;
@property NSNumber *timeSlot;
@property NSMutableArray *employees;

- (id)initWithMeetingId:(NSNumber *)meetingId;

@end
