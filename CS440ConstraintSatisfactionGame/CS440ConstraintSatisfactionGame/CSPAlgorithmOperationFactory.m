//
//  CSPAlgorithmOperationFactory.m
//  CS440ConstraintSatisfactionGame
//
//  Created by Troy Chmieleski on 10/28/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "CSPAlgorithmOperationFactory.h"
#import "CSPAlgorithmOperation.h"
#import "CSPMiniMaxOperation.h"
#import "CSPAlphaBetaOperation.h"
#import "CSPAlgorithmNames.h"

@implementation CSPAlgorithmOperationFactory

+ (CSPAlgorithmOperation *)algorithmOperationWithName:(NSString *)name {
	CSPAlgorithmOperation *algorithmOperation;
	
	if ([name isEqualToString:ALGORITHM_MINIMAX_NAME]) {
		algorithmOperation = [[CSPMiniMaxOperation alloc] init];
	}
	
	else if ([name isEqualToString:ALGORITHM_ALPHA_BETA_NAME]) {
		algorithmOperation = [[CSPAlphaBetaOperation alloc] init];
	}
	
	return algorithmOperation;
}

@end
