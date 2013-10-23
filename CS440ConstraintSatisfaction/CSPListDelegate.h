//
//  CSPListDelegate.h
//  CS440ConstraintSatisfaction
//
//  Created by Troy Chmieleski on 10/21/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CSPListDelegate <NSObject>

- (void)didSelectScheduleWithName:(NSString *)name;

@end
