//
//  CSPBacktrackingSearchOperation.h
//  CS440ConstraintSatisfaction
//
//  Created by Troy Chmieleski on 10/23/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CSPBacktrackingSearchHandler)(NSArray *assignment, NSUInteger, NSTimeInterval, NSError *);

@class CSPSchedule;

@interface CSPBacktrackingSearchOperation : NSOperation

@property (copy) CSPBacktrackingSearchHandler backtrackingSearchCompletionBlock;

- (id)initWithSchedule:(CSPSchedule *)schedule;

@end
