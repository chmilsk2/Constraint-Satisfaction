//
//  CSPBoardDelegate.h
//  CS440ConstraintSatisfactionGame
//
//  Created by Troy Chmieleski on 10/27/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CSPBoardDelegate <NSObject>

- (void)prepareToMoveAtRow:(NSUInteger)row col:(NSUInteger)col;

@end
