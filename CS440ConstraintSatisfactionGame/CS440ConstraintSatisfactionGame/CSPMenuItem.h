//
//  CSPMenuItem.h
//  CS440ConstraintSatisfactionGame
//
//  Created by Troy Chmieleski on 10/27/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSPMenuItem : NSObject

@property NSString *name;
@property BOOL isSelected;

- (id)initWithName:(NSString *)name isSelected:(BOOL)isSelected;

@end
