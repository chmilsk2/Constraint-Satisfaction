//
//  CSPGameBoardView.h
//  CS440ConstraintSatisfactionGame
//
//  Created by Troy Chmieleski on 10/27/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSPBoardDataSource.h"
#import "CSPBoardDelegate.h"
#import "CSPBoardCellDelegate.h"
#import "CSPCellOwner.h"

@interface CSPGameBoardView : UIView <CSPBoardCellDelegate>

@property (nonatomic, weak) id <CSPBoardDataSource> dataSource;
@property (nonatomic, weak) id <CSPBoardDelegate> delegate;
@property (nonatomic) NSUInteger cellSize;

- (id)initWithFrame:(CGRect)frame backgroundColor:(UIColor *)backgroundColor borderColor:(UIColor *)borderColor;
- (void)createBoardView;
- (void)updateCellViewForRow:(NSUInteger)row col:(NSUInteger)col;

@end
