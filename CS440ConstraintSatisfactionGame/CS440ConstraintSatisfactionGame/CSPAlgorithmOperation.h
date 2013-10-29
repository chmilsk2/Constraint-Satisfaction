//
//  CSPAlgorithmOperation.h
//  CS440ConstraintSatisfactionGame
//
//  Created by Troy Chmieleski on 10/26/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CSPAlgorithmOperationHandler)(NSUInteger row, NSUInteger col, NSError *);

@interface CSPAlgorithmOperation : NSOperation

@property (copy)CSPAlgorithmOperationHandler aglorithmOperationCompletionBlock;

- (void)didFinishWithRow:(NSUInteger)row col:(NSUInteger)col error:(NSError *)error;

@end
