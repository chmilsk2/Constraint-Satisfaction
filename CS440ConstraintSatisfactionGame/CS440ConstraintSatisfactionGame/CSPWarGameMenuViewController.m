//
//  CSPWarGameMenuViewController.m
//  CS440ConstraintSatisfactionGame
//
//  Created by Troy Chmieleski on 10/26/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "CSPWarGameMenuViewController.h"
#import "CSPMenuSectionItem.h"
#import "CSPMenuItem.h"
#import "CSPPlayer.h"

// Navigation
#define MENU_NAVIGATION_ITEM_TITLE @"Menu"
#define MENU_NAVIGATION_ITEM_TITLE_FONT_SIZE 20.0f

// Table
#define MENU_SECTION_HEIGHT 24.0f
#define MENU_ROW_HEIGHT 44.0f

// Menu Items

// Players
#define MENU_NUMBER_OF_PLAYERS 2

// Player Section
#define MENU_PLAYER_1_NAME @"Player 1"
#define MENU_PLAYER_2_NAME @"Player 2"

// Player Row
#define MENU_COMPUTER_NAME @"Computer"
#define MENU_HUMAN_NAME @"Human"

// First Player to Move Section
#define MENU_FIRST_PLAYER_TO_MOVE_NAME @"First Player to Move"

// Game Boards
#define MENU_GAME_BOARD_NAME_KEREN @"Keren"
#define MENU_GAME_BOARD_NAME_NARVIK @"Narvik"
#define MENU_GAME_BOARD_NAME_SEVASTOPOL @"Sevastopol"
#define MENU_GAME_BOARD_NAME_SMOLENSK @"Smolensk"
#define MENU_GAME_BOARD_NAME_WESTERPLATTE @"Westerplatte"

// Game Board Section
#define MENU_GAME_BOARD_NAME @"Game Board"

// Algorithms
#define MENU_ALGORITHM_MINIMAX_NAME @"Minimax"
#define MENU_ALGORITHM_ALPHA_BETA_NAME @"Alpha Beta"

// Computer 1 Algorithm Section
#define MENU_COMPUTER_1_ALGORITHM_NAME @"Computer 1 Algorithm"

// Computer 2 Algorithm Section
#define MENU_COMPUTER_2_ALGORITHM_NAME @"Computer 2 Algorithm"

#define WarGameTableViewCellIdentifier @"WarGameTableViewCellIdentifier"

@implementation CSPWarGameMenuViewController {
	NSArray *_menuItems;
	UIBarButtonItem *_doneButton;
	UIColor *_barBarTintColor;
	UIColor *_barTintColor;
	UIColor *_barTitleColor;
	UIColor *_cellTintColor;
}

- (id)init {
    self = [super init];
	
    if (self) {
		// players
		
		CSPMenuSectionItem *player1Section;
		CSPMenuSectionItem *player2Section;
		
		for (NSUInteger i = 0; i < MENU_NUMBER_OF_PLAYERS; i++) {
			CSPMenuItem *computer = [[CSPMenuItem alloc] initWithName:MENU_COMPUTER_NAME isSelected:YES];
			CSPMenuItem *human = [[CSPMenuItem alloc] initWithName:MENU_HUMAN_NAME isSelected:NO];
			
			NSArray *playerItems = @[computer, human];
			
			if (!i) {
				player1Section = [[CSPMenuSectionItem alloc] initWithName:MENU_PLAYER_1_NAME rows:playerItems];
			}
			
			else {
				player2Section = [[CSPMenuSectionItem alloc] initWithName:MENU_PLAYER_2_NAME rows:playerItems];
			}
		}
		
		// first player to move
		CSPMenuItem *player1Item = [[CSPMenuItem alloc] initWithName:MENU_PLAYER_1_NAME isSelected:YES];
		CSPMenuItem *player2Item = [[CSPMenuItem alloc] initWithName:MENU_PLAYER_2_NAME isSelected:NO];
		
		NSArray *firstPlayerToMoveRows = @[player1Item, player2Item];
		
		CSPMenuSectionItem *firstPlayerToMoveSection = [[CSPMenuSectionItem alloc] initWithName:MENU_FIRST_PLAYER_TO_MOVE_NAME rows:firstPlayerToMoveRows];
		
		// game boards
		NSArray *gameBoardNames = @[MENU_GAME_BOARD_NAME_KEREN, MENU_GAME_BOARD_NAME_NARVIK, MENU_GAME_BOARD_NAME_SEVASTOPOL, MENU_GAME_BOARD_NAME_SMOLENSK, MENU_GAME_BOARD_NAME_WESTERPLATTE];
		
		NSMutableArray *gameBoardItems = [NSMutableArray array];
		
		for (NSUInteger i = 0; i < gameBoardNames.count; i++) {
			BOOL isSelected;
			
			if (!i) {
				isSelected = YES;
			}
			
			else {
				isSelected = NO;
			}
			
			CSPMenuItem *gameBoardItem = [[CSPMenuItem alloc] initWithName:gameBoardNames[i] isSelected:isSelected];
			[gameBoardItems addObject:gameBoardItem];
		}
		
		CSPMenuSectionItem *gameBoardSection = [[CSPMenuSectionItem alloc] initWithName:MENU_GAME_BOARD_NAME rows:gameBoardItems];
		
		CSPMenuItem *minimaxItem = [[CSPMenuItem alloc] initWithName:MENU_ALGORITHM_MINIMAX_NAME isSelected:YES];
		CSPMenuItem *alphaBetaItem = [[CSPMenuItem alloc] initWithName:MENU_ALGORITHM_ALPHA_BETA_NAME isSelected:NO];
		
		NSArray *algorithmRows = @[minimaxItem, alphaBetaItem];
		
		CSPMenuSectionItem *algorithmPlayer1Section = [[CSPMenuSectionItem alloc] initWithName:MENU_COMPUTER_1_ALGORITHM_NAME rows:algorithmRows];
		CSPMenuSectionItem *algorithmPlayer2Section = [[CSPMenuSectionItem alloc] initWithName:MENU_COMPUTER_2_ALGORITHM_NAME rows:algorithmRows];

		_menuItems = @[player1Section, player2Section, firstPlayerToMoveSection, gameBoardSection, algorithmPlayer1Section, algorithmPlayer2Section];
		
        _barBarTintColor = [UIColor blackColor];
		_barTintColor = [UIColor whiteColor];
		_barTitleColor = [UIColor whiteColor];
		_cellTintColor = [UIColor blackColor];
    }
	
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self setUpTable];
	[self setUpNav];
}

#pragma mark - Set Up Table

- (void)setUpTable {
	[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:WarGameTableViewCellIdentifier];
}

#pragma mark - Set Up Navigation

- (void)setUpNav {
	[self.navigationController.navigationBar setBarTintColor:_barBarTintColor];
	[self.navigationController.navigationBar setTintColor:_barTintColor];
	[self.navigationController.navigationBar setTranslucent:NO];
	[self.navigationItem setRightBarButtonItem:self.doneButton];
	[self setTitle:MENU_NAVIGATION_ITEM_TITLE];
}

#pragma mark - Custom Navigation Item Title

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    if (!titleView) {
        titleView = [[UILabel alloc] initWithFrame:CGRectZero];
        titleView.backgroundColor = [UIColor clearColor];
        titleView.font = [UIFont systemFontOfSize:MENU_NAVIGATION_ITEM_TITLE_FONT_SIZE];
		
        titleView.textColor = _barTitleColor;
		
        self.navigationItem.titleView = titleView;
    }
	
    titleView.text = title;
    [titleView sizeToFit];
}


#pragma mark - Table

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [_menuItems count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [((CSPMenuSectionItem *)_menuItems[section]).rows count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return MENU_SECTION_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return MENU_ROW_HEIGHT;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return ((CSPMenuSectionItem *)_menuItems[section]).name;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:WarGameTableViewCellIdentifier forIndexPath:indexPath];

	CSPMenuSectionItem *sectionItem = _menuItems[indexPath.section];
	NSArray *menuItems = sectionItem.rows;
	CSPMenuItem *menuItem = menuItems[indexPath.row];

	[cell.textLabel setText:menuItem.name];
	
	if (menuItem.isSelected) {
		[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
	}
	
	else {
		[cell setAccessoryType:UITableViewCellAccessoryNone];
	}
	
	[cell setTintColor:_cellTintColor];
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	CSPMenuSectionItem *sectionItem = _menuItems[indexPath.section];
	NSArray *menuItems = sectionItem.rows;
	
	for (CSPMenuItem *menuItem in menuItems) {
		[menuItem setIsSelected:NO];
	}
	
	CSPMenuItem *menuItem = menuItems[indexPath.row];
	[menuItem setIsSelected:YES];
	
	if ([sectionItem.name isEqualToString:MENU_PLAYER_1_NAME]) {
		if ([menuItem.name isEqualToString:MENU_COMPUTER_NAME]) {
			[self addAlgorithmsToMenuItemsWithSectionName:MENU_COMPUTER_1_ALGORITHM_NAME];
		}
		
		else {
			[self removeAlgorithmsFromMenuItemsWithSectionName:MENU_COMPUTER_1_ALGORITHM_NAME];
		}
	}
	
	if ([sectionItem.name isEqualToString:MENU_PLAYER_2_NAME]) {
		if ([menuItem.name isEqualToString:MENU_COMPUTER_NAME]) {
			[self addAlgorithmsToMenuItemsWithSectionName:MENU_COMPUTER_2_ALGORITHM_NAME];
		}
		
		else {
			[self removeAlgorithmsFromMenuItemsWithSectionName:MENU_COMPUTER_2_ALGORITHM_NAME];
		}
	}
	
	[self.tableView reloadData];
}

- (void)addAlgorithmsToMenuItemsWithSectionName:(NSString *)sectionName {
	NSMutableArray *tempMenuItems = [_menuItems mutableCopy];
	
	NSUInteger numberOfSectionsToCheck = 2;
	
	BOOL algorithmPlayer1SectionExists = NO;
	BOOL algorithmPlayer2SectionExists = NO;
	
	// if the algorithm section does not already exist then add it
	for (NSUInteger i = tempMenuItems.count - 1; i > tempMenuItems.count - 1 - numberOfSectionsToCheck; i--) {
		CSPMenuSectionItem *sectionItem = tempMenuItems[i];
		
		if ([sectionItem.name isEqualToString:MENU_COMPUTER_1_ALGORITHM_NAME]) {
			algorithmPlayer1SectionExists = YES;
		}
		
		if ([sectionItem.name isEqualToString:MENU_COMPUTER_2_ALGORITHM_NAME]) {
			algorithmPlayer2SectionExists = YES;
		}
	}
	
	CSPMenuItem *miniMaxAlgorithmItem = [[CSPMenuItem alloc] initWithName:MENU_ALGORITHM_MINIMAX_NAME isSelected:YES];
	CSPMenuItem *alphaBetaAlgorithmItem = [[CSPMenuItem alloc] initWithName:MENU_ALGORITHM_ALPHA_BETA_NAME isSelected:NO];
	
	NSArray *algorithmRows = @[miniMaxAlgorithmItem, alphaBetaAlgorithmItem];
	
	CSPMenuSectionItem *newSectionItem;
	
	if ((!algorithmPlayer1SectionExists && !algorithmPlayer2SectionExists) || !algorithmPlayer2SectionExists) {
		newSectionItem = [[CSPMenuSectionItem alloc] initWithName:sectionName rows:algorithmRows];
		[tempMenuItems addObject:newSectionItem];
	}
	
	else if (!algorithmPlayer1SectionExists) {
		if ([sectionName isEqualToString:MENU_COMPUTER_1_ALGORITHM_NAME]) {
			newSectionItem = [[CSPMenuSectionItem alloc] initWithName:sectionName rows:algorithmRows];
			
			CSPMenuSectionItem *lastSectionItem = [tempMenuItems lastObject];
			[tempMenuItems replaceObjectAtIndex:tempMenuItems.count - 1 withObject:newSectionItem];
			[tempMenuItems addObject:lastSectionItem];
		}
	}
	
	_menuItems = [tempMenuItems copy];
}

- (void)removeAlgorithmsFromMenuItemsWithSectionName:(NSString *)sectionName {
	NSMutableArray *tempMenuItems = [_menuItems mutableCopy];
	NSUInteger index = 0;
	
	for (CSPMenuSectionItem *sectionItem in _menuItems) {
		if ([sectionItem.name isEqualToString:sectionName]) {
			[tempMenuItems removeObjectAtIndex:index];
		}
		
		index++;
	}
	
	_menuItems = [tempMenuItems copy];
}

#pragma mark - Done Button

- (UIBarButtonItem *)doneButton {
	if (!_doneButton) {
		_doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonTouched)];
	}
	
	return _doneButton;
}

- (void)doneButtonTouched {
	CSPPlayerType player1Type = CSPPlayerTypeHuman;
	CSPPlayerType player2Type = CSPPlayerTypeHuman;
	NSString *gameBoardName;
	NSString *algorithmPlayer1Name;
	NSString *algorithmPlayer2Name;
	
	BOOL isPlayer1FirstToMove;
	
	for (NSUInteger i = 0; i < _menuItems.count; i++) {
		CSPMenuSectionItem *sectionItem = _menuItems[i];
		NSArray *menuItems = sectionItem.rows;
		
		for (CSPMenuItem *menuItem in menuItems) {
			if (menuItem.isSelected) {
				if ([sectionItem.name isEqualToString:MENU_PLAYER_1_NAME]) {
					if ([menuItem.name isEqualToString:MENU_COMPUTER_NAME]) {
						player1Type = CSPPlayerTypeComputer;
					}
				}
				
				else if ([sectionItem.name isEqualToString:MENU_PLAYER_2_NAME]) {
					if ([menuItem.name isEqualToString:MENU_COMPUTER_NAME]) {
						player2Type = CSPPlayerTypeComputer;
					}
				}
				
				else if ([sectionItem.name isEqualToString:MENU_FIRST_PLAYER_TO_MOVE_NAME]) {
					if ([menuItem.name isEqualToString:MENU_PLAYER_1_NAME]) {
						isPlayer1FirstToMove = YES;
					}
				}
				
				else if ([sectionItem.name isEqualToString:MENU_GAME_BOARD_NAME]) {
					gameBoardName = menuItem.name;
				}
				
				else if ([sectionItem.name isEqualToString:MENU_COMPUTER_1_ALGORITHM_NAME]) {
					algorithmPlayer1Name = menuItem.name;
				}
				
				else if ([sectionItem.name isEqualToString:MENU_COMPUTER_2_ALGORITHM_NAME]) {
					algorithmPlayer2Name = menuItem.name;
				}
			}
		}
	}
	
	CSPPlayer *player1 = [[CSPPlayer alloc] initWithPlayerType:player1Type isFirstToMove:isPlayer1FirstToMove];
	CSPPlayer *player2 = [[CSPPlayer alloc] initWithPlayerType:player2Type isFirstToMove:!isPlayer1FirstToMove];
	
	if (player1Type == CSPPlayerTypeComputer) {
		[player1 setAlgorithmName:algorithmPlayer1Name];
	}
	
	if (player2Type == CSPPlayerTypeComputer) {
		[player2 setAlgorithmName:algorithmPlayer2Name];
	}
	
	[self informDelegateOfSelectedPlayer1:(CSPPlayer *)player1 player2:(CSPPlayer *)player2 gameBoardName:(NSString *)gameBoardName];
}

- (void)informDelegateOfSelectedPlayer1:(CSPPlayer *)player1 player2:(CSPPlayer *)player2 gameBoardName:(NSString *)gameBoardName {
	if ([self.delegate respondsToSelector:@selector(didSelectPlayer1:player2:gameBoardName:)]) {
		[self.delegate didSelectPlayer1:player1 player2:player2 gameBoardName:gameBoardName];
		
		[self dismissViewControllerAnimated:YES completion:nil];
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
