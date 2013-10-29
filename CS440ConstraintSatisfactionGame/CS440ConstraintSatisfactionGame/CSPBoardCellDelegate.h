//
//  CSPBoardCellDelegate.h
//  CS440ConstraintSatisfactionGame
//
//  Created by Troy Chmieleski on 10/27/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CSPBoardCellDelegate <NSObject>

- (void)touchedCellFrame:(CGRect)frame;

@end
