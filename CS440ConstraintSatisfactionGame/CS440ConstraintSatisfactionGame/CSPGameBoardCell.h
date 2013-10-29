//
//  CSPGameBoardCell.h
//  CS440ConstraintSatisfactionGame
//
//  Created by Troy Chmieleski on 10/27/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSPCellOwner.h"

@interface CSPGameBoardCell : NSObject <NSCopying>

@property CSPOwner owner;
@property NSUInteger weight;

- (id)initWithWeight:(NSUInteger)weight;

@end
