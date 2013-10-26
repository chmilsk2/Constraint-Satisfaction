//
//  CSPEmployee.h
//  CS440ConstraintSatisfaction
//
//  Created by Troy Chmieleski on 10/24/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSPEmployee : NSObject

@property (nonatomic) NSNumber *employeeId;
@property (nonatomic) NSMutableArray *meetings;

- (id)initWithEmployeeId:(NSNumber *)employeeId;

@end
