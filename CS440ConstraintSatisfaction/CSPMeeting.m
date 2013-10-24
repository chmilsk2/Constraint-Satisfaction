//
//  CSPMeeting.m
//  CS440ConstraintSatisfaction
//
//  Created by Troy Chmieleski on 10/24/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "CSPMeeting.h"

@implementation CSPMeeting

- (id)initWithMeetingId:(NSNumber *)meetingId {
	self = [super init];
	
	if (self) {
		_meetingId = meetingId;
		_employees = [NSMutableArray array];
	}
	
	return self;
}

@end
