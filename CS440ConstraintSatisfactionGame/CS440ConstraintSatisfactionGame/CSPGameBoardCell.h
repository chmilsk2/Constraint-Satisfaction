//
//  CSPGameBoardCell.h
//  CS440ConstraintSatisfactionGame
//
//  Created by Troy Chmieleski on 10/27/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, CSPCellOwner) {
	CSPCellOwnerNone,
	CSPCellOwnerPlayer1,
	CSPCellOwnerPlayer2
};

@interface CSPGameBoardCell : NSObject

@property CSPCellOwner owner;
@property NSUInteger weight;

- (id)initWithWeight:(NSUInteger)weight;

@end
