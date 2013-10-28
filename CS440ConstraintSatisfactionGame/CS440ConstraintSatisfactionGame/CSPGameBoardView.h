//
//  CSPGameBoardView.h
//  CS440ConstraintSatisfactionGame
//
//  Created by Troy Chmieleski on 10/27/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSPBoardDataSource.h"

@interface CSPGameBoardView : UIView

@property (nonatomic, weak) id <CSPBoardDataSource> dataSource;

- (id)initWithFrame:(CGRect)frame backgroundColor:(UIColor *)backgroundColor borderColor:(UIColor *)borderColor;

@end
