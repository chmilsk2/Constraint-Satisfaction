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
#define WAR_GAME_NUMBER_OF_PLAYER_LABELS 6
#define WAR_GAME_PLAYER_LABEL_HEIGHT 30.0f

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
		[playerLabel setBackgroundColor:[UIColor blackColor]];
		[self.view addSubview:playerLabel];
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
		// solve the game using objective C++
		CSPAlgorithmOperation *algorithmOperation = [CSPAlgorithmOperationFactory algorithmOperationWithName:_playingPlayer.algorithmName];
		
		algorithmOperation.aglorithmOperationCompletionBlock = ^(NSUInteger row, NSUInteger col, NSError *error) {
			if (!error) {
				[self prepareToMoveAtRow:row col:col];
				[self finishedMove];
			}
			
			else {
				NSLog(@"Error performing %@ operation: %@", _playingPlayer.algorithmName, error);
			}
		};
	}
}

#pragma mark - Respond to Delegate

- (void)prepareToMoveAtRow:(NSUInteger)row col:(NSUInteger)col {
	if (_playingPlayer.playerType == CSPPlayerTypeHuman) {
		CSPGameBoardCell *cell = [_board cellForRow:row col:col];
		
		CSPOwner owner;
		
		if (_playingPlayer.playerNumber == CSPPlayerNumberOne) {
			owner = CSPOwnerPlayer1;
		}
		
		else {
			owner = CSPOwnerPlayer2;
		}
		
		if (cell.owner == CSPOwnerNone) {
			[_board setCellStateForRow:row col:col owner:owner];
			[_boardView updateCellViewForRow:row col:col];
			
			// update score
			NSUInteger weight = [_board weightForRow:row col:col];
			_playingPlayer.score += weight;
			[self finishedMove];
		}
	}
}

- (void)finishedMove {
	CSPPlayer *tempPlayer = _playingPlayer;
	_playingPlayer = _waitingPlayer;
	_waitingPlayer = tempPlayer;
	[self makeMove];
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
