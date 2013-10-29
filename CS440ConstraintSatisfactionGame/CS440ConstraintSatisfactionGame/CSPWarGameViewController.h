//
//  CSPWarGameViewController.h
//  CS440ConstraintSatisfactionGame
//
//  Created by Troy Chmieleski on 10/26/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSPMenuDelegate.h"
#import "CSPBoardDataSource.h"
#import "CSPBoardDelegate.h"

typedef NS_ENUM(NSUInteger, CSPLabelType) {
	CSPLabelTypePlayer1ScoreLabel,
	CSPLabelTypePlayer1TotalNumberOfNodesExpandedLabel,
	CSPLabelTypePlayer1AverageNumberOfNodesExpandedPerMove,
	CSPLabelTypePlayer1AverageTimePerMove,
	CSPLabelTypePlayer2ScoreLable,
	CSPLabelTypePlayer2TotalNumberOfNodesExpandedLabel,
	CSPLabelTypePlayer2AverageNumberOfNodesExpandedPerMove,
	CSPLabelTypePlayer2AverageTimePerMove
};

@interface CSPWarGameViewController : UIViewController <CSPMenuDelegate, CSPBoardDataSource, CSPBoardDelegate>

@end
