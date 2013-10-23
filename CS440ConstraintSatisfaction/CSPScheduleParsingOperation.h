//
//  CSPScheduleParser.h
//  CS440ConstraintSatisfaction
//
//  Created by Troy Chmieleski on 10/21/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CSPSchedule;

typedef void(^CSPScheduleParsingHandler)(CSPSchedule *, NSError *);

@interface CSPScheduleParsingOperation : NSOperation

@property (copy) CSPScheduleParsingHandler scheduleParsingCompletionBlock;

- (id)initWithScheduleName:(NSString *)scheduleName;

@end
