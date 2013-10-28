//
//  CSPMenuSectionItem.h
//  CS440ConstraintSatisfactionGame
//
//  Created by Troy Chmieleski on 10/27/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSPMenuSectionItem : NSObject

@property NSString *name;
@property NSArray *rows;

- (id)initWithName:(NSString *)name rows:(NSArray *)rows;

@end
