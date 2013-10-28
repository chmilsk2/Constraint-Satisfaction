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

@interface CSPPlayer : NSObject

@property CSPPlayerType playerType;
@property BOOL isFirstToMove;
@property NSString *algorithmName;

- (id)initWithPlayerType:(CSPPlayerType)playerType isFirstToMove:(BOOL)isFirstToMove;

@end
