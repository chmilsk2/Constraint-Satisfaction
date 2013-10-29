//
//  CSPGameBoardCellView.h
//  CS440ConstraintSatisfactionGame
//
//  Created by Troy Chmieleski on 10/27/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSPBoardCellDelegate.h"
#import "CSPCellOwner.h"

@interface CSPGameBoardCellView : UIView

@property (nonatomic, weak) id <CSPBoardCellDelegate> delegate;

- (id)initWithFrame:(CGRect)frame weight:(NSString *)weight owner:(NSUInteger)owner backgroundColor:(UIColor *)backgroundColor borderColor:(UIColor *)borderColor;
- (void)updateWithOwner:(CSPOwner)owner;

@end
