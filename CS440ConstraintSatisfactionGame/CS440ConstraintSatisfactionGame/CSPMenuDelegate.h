//
//  CSPMenuDelegate.h
//  CS440ConstraintSatisfactionGame
//
//  Created by Troy Chmieleski on 10/26/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CSPPlayer;

@protocol CSPMenuDelegate <NSObject>

- (void)didSelectPlayer1:(CSPPlayer *)player1 player2:(CSPPlayer *)player2 gameBoardName:(NSString *)gameBoardName;

@end
