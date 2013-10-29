//
//  CSPWarGameViewController.m
//  CS440ConstraintSatisfactionGame
//
//  Created by Troy Chmieleski on 10/26/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "CSPWarGameViewController.h"
#import "CSPWarGameMenuViewController.h"
#import "CSPPlayer.h"
#import "CSPGameBoardNames.h"
#import "CSPBoardParsingOperation.h"
#import "CSPGameBoard.h"
#import "CSPGameBoardCell.h"
#import "CSPGameBoardView.h"
#import "CSPCellOwner.h"
#import "CSPAlgorithmNames.h"
#import "CSPAlgorithmOperationFactory.h"
#import "CSPAlphaBetaOperation.h"

// Navigation
#define WAR_GAME_NAVIGATION_MENU_BUTTON_ITEM_NAME @"854-list"
#define WAR_GAME_NAVIGATION_ITEM_TITLE @"War Game"
#define WAR_GAME_NAVIGATION_ITEM_TITLE_FONT_SIZE 20.0f

// margin
#define WAR_GAME_BOARD_HORIZONTAL_MARGIN 16.0f

// Board Border
#define WAR_GAME_BOARD_BORDER_WIDTH 2.0f

// Player Labels
#define WAR_GAME_NUMBER_OF_PLAYER_LABELS 8
#define WAR_GAME_PLAYER_LABEL_HEIGHT 24.0f
#define WAR_GAME_LABEL_FONT_NAME @"Avenir-Heavy"
#define WAR_GAME_LABEL_FONT_SIZE 12.0f
#define WAR_GAME_LABEL_PLAYER_1_SCORE @"Player 1 Score: "
#define WAR_GAME_LABEL_PLAYER_1_TOTAL_NUM_NODES_EXP @"Player 1 Total Num Nodes Exp: "
#define WAR_GAME_LABEL_PLAYER_1_AVG_NUM_NODES_EXP_PER_MOVE @"Player 1 Avg Num Nodes Exp Per Move: "
#define WAR_GAME_LABEL_PLAYER_1_AVG_TIME_PER_MOVE @"Player 1 Avg Time Per Move: "
#define WAR_GAME_LABEL_PLAYER_2_SCORE @"Player 2 Score: "
#define WAR_GAME_LABEL_PLAYER_2_TOTAL_NUM_NODES_EXP @"Player 2 Total Num Nodes Exp: "
#define WAR_GAME_LABEL_PLAYER_2_AVG_NUM_NODES_EXP_PER_MOVE @"Player 2 Avg Num Nodes Exp Per Move: "
#define WAR_GAME_LABEL_PLAYER_2_AVG_TIME_PER_MOVE @"Player 2 Avg Time Per Move: "

@interface CSPWarGameViewController ()

@property (nonatomic, strong) UILabel *playerLabel;

@end

@implementation CSPWarGameViewController {
	NSOperationQueue *_queue;
	CSPGameBoard *_board;
	UIBarButtonItem *_menuButton;
	UIColor *_barBarTintColor;
	UIColor *_barTintColor;
	UIColor *_barTitleColor;
	UIColor *_boardBackgroundColor;
	UIColor *_boardBorderColor;
	CSPPlayer *_playingPlayer;
	CSPPlayer *_waitingPlayer;
	CSPGameBoardView *_boardView;
	NSMutableArray *_playerLabels;
}

- (id)init
{
    self = [super init];
	
    if (self) {
		_queue = [[NSOperationQueue alloc] init];
		[_queue setMaxConcurrentOperationCount:1];
		_playerLabels = [NSMutableArray array];
        _barBarTintColor = [UIColor blackColor];
		_barTintColor = [UIColor whiteColor];
		_barTitleColor = [UIColor whiteColor];
		_boardBackgroundColor = [UIColor colorWithWhite:.9 alpha:1.0];
		_boardBorderColor = [UIColor colorWithWhite:.2 alpha:1.0];
		
    }
	
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	[self setUpNav];
}

#pragma mark - Set Up Navigation

- (void)setUpNav {
	[self.navigationController.navigationBar setBarTintColor:_barBarTintColor];
	[self.navigationController.navigationBar setTintColor:_barTintColor];
	[self.navigationController.navigationBar setTranslucent:NO];
	[self.navigationItem setLeftBarButtonItem:self.menuButton];
	[self setTitle:WAR_GAME_NAVIGATION_ITEM_TITLE];
}

#pragma mark - Set Up Player Labels

- (void)setUpPlayerLabels {
	NSUInteger boardWidth = _boardView.cellSize*_board.numberOfCols;
	NSUInteger boardHeight = _boardView.cellSize*_board.numberOfRows;
	NSUInteger labelWidth = boardWidth + 2*WAR_GAME_BOARD_BORDER_WIDTH;
	NSUInteger height = [UIScreen mainScreen].bounds.size.height - self.navigationController.navigationBar.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height ;
	NSUInteger remainingSpace = height - boardHeight - 2*WAR_GAME_BOARD_BORDER_WIDTH;
	remainingSpace = remainingSpace/2;
	NSUInteger halfLabelCount = WAR_GAME_NUMBER_OF_PLAYER_LABELS/2;
	NSUInteger verticalLabelMargin = (remainingSpace - WAR_GAME_PLAYER_LABEL_HEIGHT*halfLabelCount)/(halfLabelCount+1);
	
	for (NSUInteger i = 0; i < WAR_GAME_NUMBER_OF_PLAYER_LABELS; i++) {
		CGRect labelFrame = CGRectMake(WAR_GAME_BOARD_HORIZONTAL_MARGIN - WAR_GAME_BOARD_BORDER_WIDTH, i*(WAR_GAME_PLAYER_LABEL_HEIGHT + verticalLabelMargin) + verticalLabelMargin, labelWidth, WAR_GAME_PLAYER_LABEL_HEIGHT);
		
		
		if (i >= WAR_GAME_NUMBER_OF_PLAYER_LABELS/2) {
			labelFrame.origin.y += boardHeight + 2*WAR_GAME_BOARD_BORDER_WIDTH + verticalLabelMargin;
		}
		
		UILabel *playerLabel = [[UILabel alloc] initWithFrame:labelFrame];
		[_playerLabels addObject:playerLabel];
		
		[playerLabel setFont:[UIFont fontWithName:WAR_GAME_LABEL_FONT_NAME size:WAR_GAME_LABEL_FONT_SIZE]];
		[playerLabel setTextAlignment:NSTextAlignmentLeft];
		[self.view addSubview:playerLabel];
	}
	
	[self setTextForPlayerLabelsWithPlayer1:_playingPlayer player2:_waitingPlayer];
}

#pragma mark - Player Label Text

- (void)setTextForPlayerLabelsWithPlayer1:(CSPPlayer *)player1 player2:(CSPPlayer *)player2 {
	for (NSUInteger i = 0; i < WAR_GAME_NUMBER_OF_PLAYER_LABELS; i++) {
		UILabel *playerLabel = _playerLabels[i];
		
		NSString *text;
		
		if (i == CSPLabelTypePlayer1ScoreLabel) {
			text = [NSString stringWithFormat:@"%@%lu", WAR_GAME_LABEL_PLAYER_1_SCORE, (unsigned long)player1.score];
		}
		
		else if (i == CSPLabelTypePlayer1TotalNumberOfNodesExpandedLabel) {
			text = [NSString stringWithFormat:@"%@%lu", WAR_GAME_LABEL_PLAYER_1_TOTAL_NUM_NODES_EXP, (unsigned long)player1.totalNumberOfNodesExpanded];
		}
		
		else if (i == CSPLabelTypePlayer1AverageNumberOfNodesExpandedPerMove) {
			text = [NSString stringWithFormat:@"%@%lu", WAR_GAME_LABEL_PLAYER_1_AVG_NUM_NODES_EXP_PER_MOVE, (unsigned long)player1.averageNumberOfNodesExpandedPerMove];
		}
		
		else if (i == CSPLabelTypePlayer1AverageTimePerMove) {
			text = [NSString stringWithFormat:@"%@%lu", WAR_GAME_LABEL_PLAYER_1_AVG_TIME_PER_MOVE, (unsigned long)player1.averageTimePerMoveInSeconds];
		}
		
		else if (i == CSPLabelTypePlayer2ScoreLable) {
			text = [NSString stringWithFormat:@"%@%lu", WAR_GAME_LABEL_PLAYER_2_SCORE, player2.score];
		}
		
		else if (i == CSPLabelTypePlayer2TotalNumberOfNodesExpandedLabel) {
			text = [NSString stringWithFormat:@"%@%lu", WAR_GAME_LABEL_PLAYER_2_TOTAL_NUM_NODES_EXP, (unsigned long)player2.totalNumberOfNodesExpanded];
		}
		
		else if (i == CSPLabelTypePlayer2AverageNumberOfNodesExpandedPerMove) {
			text = [NSString stringWithFormat:@"%@%lu", WAR_GAME_LABEL_PLAYER_2_AVG_NUM_NODES_EXP_PER_MOVE, (unsigned long)player2.averageNumberOfNodesExpandedPerMove];
		}
		
		else if (i == CSPLabelTypePlayer2AverageTimePerMove) {
			text = [NSString stringWithFormat:@"%@%lu", WAR_GAME_LABEL_PLAYER_2_AVG_TIME_PER_MOVE, (unsigned long)player2.averageTimePerMoveInSeconds];
		}
		
		[playerLabel setText:text];
	}
}

#pragma mark - Custom Navigation Item Title

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    if (!titleView) {
        titleView = [[UILabel alloc] initWithFrame:CGRectZero];
        titleView.backgroundColor = [UIColor clearColor];
        titleView.font = [UIFont systemFontOfSize:WAR_GAME_NAVIGATION_ITEM_TITLE_FONT_SIZE];
		
        titleView.textColor = _barTitleColor;
		
        self.navigationItem.titleView = titleView;
    }
	
    titleView.text = title;
    [titleView sizeToFit];
}

#pragma mark - Menu Button

- (UIBarButtonItem *)menuButton {
	if (!_menuButton) {
		_menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:WAR_GAME_NAVIGATION_MENU_BUTTON_ITEM_NAME] style:UIBarButtonItemStylePlain target:self action:@selector(menuButtonTouched)];
	}
	
	return _menuButton;
}

- (void)menuButtonTouched {
	CSPWarGameMenuViewController *menuViewController = [[CSPWarGameMenuViewController alloc] init];
	[menuViewController setDelegate:self];
	
	UINavigationController *menuNavController = [[UINavigationController alloc] initWithRootViewController:menuViewController];
	
	[self presentViewController:menuNavController animated:YES completion:nil];
}

#pragma mark - Menu Delegate

- (void)didSelectPlayer1:(CSPPlayer *)player1 player2:(CSPPlayer *)player2 gameBoardName:(NSString *)gameBoardName {
	// parse the game board
	CSPBoardParsingOperation *boardParsingOperation = [[CSPBoardParsingOperation alloc] initWithBoardName:gameBoardName];
	
	boardParsingOperation.boardParsingOperationCompletionBlock = ^(CSPGameBoard *gameBoard, NSError *error) {
		if (!error) {
			_board = gameBoard;
			
			if (player1.isFirstToMove) {
				_playingPlayer = player1;
				_waitingPlayer = player2;
			}
			
			else {
				_playingPlayer = player2;
				_waitingPlayer = player1;
			}
			
			[self displayBoard];
			[self setUpPlayerLabels];
			[self beginGame];
		}
		
		else {
			NSString *altertViewTitle = [NSString stringWithFormat:@"Could not parse board: %@", gameBoard];
			UIAlertView *av = [[UIAlertView alloc] initWithTitle:altertViewTitle
														 message:[error localizedDescription]
														delegate:nil
											   cancelButtonTitle:nil
											   otherButtonTitles:nil];
			[av show];
		}
	};
	
	[_queue addOperation:boardParsingOperation];
}

#pragma mark - Display Board

- (void)displayBoard {
	CGFloat width = [UIScreen mainScreen].bounds.size.width;
	CGFloat height = [UIScreen mainScreen].bounds.size.height - self.navigationController.navigationBar.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height;
	
	width -= 2*WAR_GAME_BOARD_HORIZONTAL_MARGIN;
	
	NSUInteger cellSize = width/_board.numberOfCols;
	
	CGFloat yPos = (height - cellSize*_board.numberOfRows)/2;
	
	CGFloat boardWidth = cellSize*_board.numberOfCols;
	CGFloat boardHeight = cellSize*_board.numberOfRows;
	
	CGRect boardFrame = CGRectMake(WAR_GAME_BOARD_HORIZONTAL_MARGIN, yPos, boardWidth, boardHeight);
	
	_boardView = [[CSPGameBoardView alloc] initWithFrame:boardFrame backgroundColor:_boardBackgroundColor borderColor:_boardBorderColor];
	[_boardView setDataSource:self];
	[_boardView setDelegate:self];
	[_boardView createBoardView];
	
	// add border
	UIView *borderView = [[UIView alloc] initWithFrame:CGRectMake(WAR_GAME_BOARD_HORIZONTAL_MARGIN - WAR_GAME_BOARD_BORDER_WIDTH, yPos - WAR_GAME_BOARD_BORDER_WIDTH, boardWidth + 2*WAR_GAME_BOARD_BORDER_WIDTH, boardHeight + 2*WAR_GAME_BOARD_BORDER_WIDTH)];
	[borderView setBackgroundColor:_boardBorderColor];
	
	[self.view addSubview:borderView];
	[self.view addSubview:_boardView];
}

#pragma mark - Begin Game

- (void)beginGame {
	[self makeMove];
}

#pragma mark - Make Move

- (void)makeMove {
	if (_playingPlayer.playerType == CSPPlayerTypeComputer) {
		BOOL isMaximizingPlayer = NO;
		
		// player 1 is maximizing player, player 2 is minimizing player
		if (_playingPlayer.playerNumber == CSPPlayerNumberOne) {
			isMaximizingPlayer = YES;
		}
		
		CSPNode *root = [[CSPNode alloc] initWithBoard:[_board copy] isMaximizingPlayer:isMaximizingPlayer];
		
		CSPAlgorithmOperation *algorithmOperation = [CSPAlgorithmOperationFactory algorithmOperationWithName:_playingPlayer.algorithmName root:root];
		
		algorithmOperation.aglorithmOperationCompletionBlock = ^(NSUInteger row, NSUInteger col, NSError *error) {
			if (!error) {
				dispatch_async(dispatch_get_main_queue(), ^{
					[self moveToRow:row col:col];
				});
			}
			
			else {
				NSLog(@"Error performing %@ operation: %@", _playingPlayer.algorithmName, error);
			}
		};
		
		[_queue addOperation:algorithmOperation];
	}
}

- (void)moveToRow:(NSUInteger)row col:(NSUInteger)col {
	CSPGameBoardCell *cell = [_board cellForRow:row col:col];
	
	CSPOwner owner;
	
	if (_playingPlayer.playerNumber == CSPPlayerNumberOne) {
		owner = CSPOwnerPlayer1;
	}
	
	else {
		owner = CSPOwnerPlayer2;
	}
	
	if (cell.owner == CSPOwnerNone) {
		// set the current cell
		[_board setCellStateForRow:row col:col owner:owner];
		[_boardView updateCellViewForRow:row col:col];
		NSUInteger weight = [_board weightForRow:row col:col];
		_playingPlayer.score += weight;
		
		// retrieve conquerable neighbors if any exist
		NSArray *conquerableNeighborCellLocations = [_board conquerableNeighborCellLocationsFromRow:row col:col];
		
		for (NSValue *location in conquerableNeighborCellLocations) {
			NSUInteger conquerableNeighborRow = location.CGPointValue.x;
			NSUInteger conquerableNeighborCol = location.CGPointValue.y;
			NSUInteger conquerableNeighborWeight;
			
			[_board setCellStateForRow:conquerableNeighborRow col:conquerableNeighborCol owner:owner];
			[_boardView updateCellViewForRow:conquerableNeighborRow col:conquerableNeighborCol];
			conquerableNeighborWeight = [_board weightForRow:conquerableNeighborRow col:conquerableNeighborCol];
			
			_playingPlayer.score += conquerableNeighborWeight;
			_waitingPlayer.score -= conquerableNeighborWeight;
		}
		
		if (!conquerableNeighborCellLocations.count) {
			NSLog(@"Player%lu: paradrop col:%lu, row:%lu", (unsigned long)_playingPlayer.playerNumber + 1, (unsigned long)col, (unsigned long)row);
		}
		
		else {
			NSLog(@"Player%lu: blitz col:%lu, row:%lu", (unsigned long)_playingPlayer.playerNumber + 1, (unsigned long)col, (unsigned long)row);
		}
		
		[self reloadPlayerLabels];
		[self finishedMove];
	}
}

#pragma mark - Respond to Delegate

- (void)prepareToMoveAtRow:(NSUInteger)row col:(NSUInteger)col {
	if (_playingPlayer.playerType == CSPPlayerTypeHuman) {
		dispatch_async(dispatch_get_main_queue(), ^{
			[self moveToRow:row col:col];
		});
	}
}

- (void)finishedMove {
	CSPPlayer *tempPlayer = _playingPlayer;
	_playingPlayer = _waitingPlayer;
	_waitingPlayer = tempPlayer;
	[self makeMove];
}

- (void)reloadPlayerLabels {
	CSPPlayer *player1;
	CSPPlayer *player2;
	
	if (_playingPlayer.playerNumber == CSPPlayerNumberOne) {
		player1 = _playingPlayer;
		player2 = _waitingPlayer;
	}
	
	else {
		player1 = _waitingPlayer;
		player2 = _playingPlayer;
	}
	
	[self setTextForPlayerLabelsWithPlayer1:player1 player2:player2];
}

#pragma mark - Board Data Source

- (NSUInteger)numberOfRows {
	return _board.numberOfRows;
}

- (NSUInteger)numberOfCols {
	return _board.numberOfCols;
}

- (NSUInteger)weightForRow:(NSUInteger)row col:(NSUInteger)col {
	CSPGameBoardCell *cell = [_board cellForRow:row col:col];
	return cell.weight;
}

- (NSUInteger)ownerForRow:(NSUInteger)row col:(NSUInteger)col {
	CSPGameBoardCell *cell = [_board cellForRow:row col:col];
	return cell.owner;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end
