//
//  CSPAlgorithmOperationFactory.h
//  CS440ConstraintSatisfactionGame
//
//  Created by Troy Chmieleski on 10/28/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSPAlgorithmOperation.h"

@class CSPNode;

@interface CSPAlgorithmOperationFactory : NSObject

+ (CSPAlgorithmOperation *)algorithmOperationWithName:(NSString *)name root:(CSPNode *)root;

@end
