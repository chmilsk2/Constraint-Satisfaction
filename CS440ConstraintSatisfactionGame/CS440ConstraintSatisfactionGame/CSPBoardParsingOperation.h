//
//  CSPBoardParsingOperation.h
//  CS440ConstraintSatisfactionGame
//
//  Created by Troy Chmieleski on 10/26/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CSPGameBoard;

typedef void(^CSPBoardParsingOperationHandler)(CSPGameBoard *, NSError *);

@interface CSPBoardParsingOperation : NSOperation

@property (copy) CSPBoardParsingOperationHandler boardParsingOperationCompletionBlock;

- (id)initWithBoardName:(NSString *)boardName;

@end
