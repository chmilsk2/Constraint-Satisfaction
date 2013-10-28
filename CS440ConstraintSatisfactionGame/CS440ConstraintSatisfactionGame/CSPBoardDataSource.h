//
//  CSPBoardDataSource.h
//  CS440ConstraintSatisfactionGame
//
//  Created by Troy Chmieleski on 10/27/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CSPBoardDataSource <NSObject>

- (NSUInteger)numberOfRows;
- (NSUInteger)numberOfCols;
- (NSUInteger)weightForRow:(NSUInteger)row col:(NSUInteger)col;
- (NSUInteger)ownerForRow:(NSUInteger)row col:(NSUInteger)col;

@end
