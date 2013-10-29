//
//  CSPAlgorithmOperation.m
//  CS440ConstraintSatisfactionGame
//
//  Created by Troy Chmieleski on 10/26/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "CSPAlgorithmOperation.h"

@implementation CSPAlgorithmOperation

- (void)didFinishWithRow:(NSUInteger)row col:(NSUInteger)col error:(NSError *)error {
	if (self.aglorithmOperationCompletionBlock) {
		self.aglorithmOperationCompletionBlock(row, col, error);
	}
}

@end
