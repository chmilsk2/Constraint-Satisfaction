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

+ (CSPAlgorithmOperation *)algorithmOperationWithName:(NSString *)name root:(CSPNode *)root {
	CSPAlgorithmOperation *algorithmOperation;
	
	if ([name isEqualToString:ALGORITHM_MINIMAX_NAME]) {
		algorithmOperation = [[CSPMiniMaxOperation alloc] initWithRoot:root];
	}
	
	else if ([name isEqualToString:ALGORITHM_ALPHA_BETA_NAME]) {
		algorithmOperation = [[CSPAlphaBetaOperation alloc] initWithRoot:root];
	}
	
	return algorithmOperation;
}

@end
