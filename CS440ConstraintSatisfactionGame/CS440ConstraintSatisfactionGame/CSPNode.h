//
//  CSPNode.h
//  CS440ConstraintSatisfactionGame
//
//  Created by Troy Chmieleski on 10/28/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSPGameBoard.h"

@interface CSPNode : NSObject

@property NSInteger value;
@property NSUInteger row;
@property NSUInteger col;
@property NSArray *children;
@property CSPGameBoard *board;
@property BOOL isMaximizingPlayer;

- (id)initWithBoard:(CSPGameBoard *)board isMaximizingPlayer:(BOOL)isMaximizingPlayer;

@end
