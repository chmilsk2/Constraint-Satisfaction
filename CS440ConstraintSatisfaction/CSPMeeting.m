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

- (BOOL)isEqualToMeeting:(CSPMeeting *)meeting {
	BOOL isEqualToMeeting = NO;
	
	if ([_meetingId isEqualToNumber:meeting.meetingId]) {
		isEqualToMeeting = YES;
	}
	
	return isEqualToMeeting;
}

- (BOOL)isEqual:(id)object {
	if (self == object) {
		return YES;
	}
	
	if (![object isKindOfClass:[CSPMeeting class]]) {
		return NO;
	}
	
	return [self isEqualToMeeting:(CSPMeeting *)object];
}

@end
