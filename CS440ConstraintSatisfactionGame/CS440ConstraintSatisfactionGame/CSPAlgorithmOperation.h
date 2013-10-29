//
//  CSPAlgorithmOperation.h
//  CS440ConstraintSatisfactionGame
//
//  Created by Troy Chmieleski on 10/26/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSPGameBoard.h"
#import "CSPNode.h"

@class CSPNode;

typedef void(^CSPAlgorithmOperationHandler)(NSUInteger row, NSUInteger col, NSError *);

@interface CSPAlgorithmOperation : NSOperation

@property (copy)CSPAlgorithmOperationHandler aglorithmOperationCompletionBlock;
@property CSPNode *root;

- (id)initWithRoot:(CSPNode *)root;
- (BOOL)isTerminalNode:(CSPNode *)node;
- (NSArray *)childrenForNode:(CSPNode *)node;
- (NSInteger)heuristicValueOfNode:(CSPNode *)node;
- (CSPNode *)findOptimalNode;
- (CGPoint)optimalLocationForNode:(CSPNode *)node;
- (void)didFinishWithRow:(NSUInteger)row col:(NSUInteger)col error:(NSError *)error;

@end
