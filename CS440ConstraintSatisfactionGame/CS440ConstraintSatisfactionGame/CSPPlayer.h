//
//  CSPPlayer.h
//  CS440ConstraintSatisfactionGame
//
//  Created by Troy Chmieleski on 10/26/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, CSPPlayerType) {
	CSPPlayerTypeComputer,
	CSPPlayerTypeHuman
};

typedef NS_ENUM(NSUInteger, CSPPlayerNumber) {
	CSPPlayerNumberOne,
	CSPPlayerNumberTwo
};

@interface CSPPlayer : NSObject

@property CSPPlayerType playerType;
@property CSPPlayerNumber playerNumber;
@property BOOL isFirstToMove;
@property NSString *algorithmName;
@property NSUInteger score;
@property NSUInteger totalNumberOfNodesExpanded;
@property NSUInteger averageNumberOfNodesExpandedPerMove;
@property NSUInteger averageTimePerMoveInSeconds;

- (id)initWithPlayerType:(CSPPlayerType)playerType playerNumber:(CSPPlayerNumber)playerNumber isFirstToMove:(BOOL)isFirstToMove;

@end
