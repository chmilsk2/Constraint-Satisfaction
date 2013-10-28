//
//  CSPBoardParsingOperation.m
//  CS440ConstraintSatisfactionGame
//
//  Created by Troy Chmieleski on 10/26/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "CSPBoardParsingOperation.h"
#import "CSPGameBoard.h"
#import "CSPGameBoardCell.h"

@implementation CSPBoardParsingOperation {
	NSString *_boardName;
}

- (id)initWithBoardName:(NSString *)boardName {
	self = [super init];
	
	if (self) {
		_boardName = boardName;
	}
	
	return self;
}

- (void)main {
	NSError *error;
	
	CSPGameBoard *gameBoard = [self parseBoard:&error];
	
	[self didFinishWithGameBoard:gameBoard error:error];
}

- (CSPGameBoard *)parseBoard:(NSError **)error {
	NSString *boardFilePath = [[NSBundle mainBundle] pathForResource:_boardName ofType:@"txt"];
	NSString *content = [NSString stringWithContentsOfFile:boardFilePath encoding:NSUTF8StringEncoding error:error];
	
	NSArray *lines = [content componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
	
	NSMutableArray *board = [NSMutableArray array];
	
	NSUInteger numberOfRows = 0;
	
	for (NSString *line in lines) {
		NSUInteger count = 0;
		NSScanner *scanner = [NSScanner scannerWithString:line];
		
		// set it to skip non-numeric characters
		[scanner setCharactersToBeSkipped:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]];
		
		int i;
		
		while([scanner scanInt:&i]) {
			NSUInteger weight = i;
			CSPGameBoardCell *cell = [[CSPGameBoardCell alloc] initWithWeight:weight];
			
			[board addObject:cell];
			
			if (!count) {
				numberOfRows++;
			}
			
			count++;
		}
	}
	
	NSUInteger numberOfCols = board.count/numberOfRows;
	
	CSPGameBoard *gameBoard = [[CSPGameBoard alloc] initWithBoard:board numberOfRows:numberOfRows numberOfCols:numberOfCols];
	
	return gameBoard;
}

- (void)didFinishWithGameBoard:(CSPGameBoard *)gameBoard error:(NSError *)error {
	if (self.boardParsingOperationCompletionBlock) {
		dispatch_async(dispatch_get_main_queue(), ^{
			self.boardParsingOperationCompletionBlock(gameBoard, error);
		});
	}
}

@end
