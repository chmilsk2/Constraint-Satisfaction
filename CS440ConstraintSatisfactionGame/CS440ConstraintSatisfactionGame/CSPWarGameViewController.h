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
	CSPLabelTypePlayer2ScoreLable,
	CSPLabelTypePlayer1TotalNumberOfNodesExpandedLabel,
	CSPLabelTypePlayer2TotalNumberOfNodesExpandedLabel,
	CSPLabelTypePlayer1AverageNumberOfNodesExpandedPerMove,
	CSPLabelTypePlayer2AverageNumberOfNodesExpandedPerMove,
	CSPLabelTypePlayer1AverageTimePerMove,
	CSPLabelTypePlayer2AverageTimePerMove
};

@interface CSPWarGameViewController : UIViewController <CSPMenuDelegate, CSPBoardDataSource, CSPBoardDelegate>

@end
