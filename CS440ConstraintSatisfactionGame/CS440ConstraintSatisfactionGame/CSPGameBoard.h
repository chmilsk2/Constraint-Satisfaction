//
//  CSPGameBoard.h
//  CS440ConstraintSatisfactionGame
//
//  Created by Troy Chmieleski on 10/26/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSPCellOwner.h"

@class CSPGameBoardCell;

@interface CSPGameBoard : NSObject

@property NSUInteger numberOfRows;
@property NSUInteger numberOfCols;
@property NSArray *board;

- (id)initWithBoard:(NSArray *)board numberOfRows:(NSUInteger)numberOfRows numberOfCols:(NSUInteger)numberOfCols;
- (CSPGameBoardCell *)cellForRow:(NSUInteger)row col:(NSUInteger)col;
- (void)setCellStateForRow:(NSUInteger)row col:(NSUInteger)col owner:(CSPOwner)playerOwner;
- (NSUInteger)weightForRow:(NSUInteger)row col:(NSUInteger)col;

@end
