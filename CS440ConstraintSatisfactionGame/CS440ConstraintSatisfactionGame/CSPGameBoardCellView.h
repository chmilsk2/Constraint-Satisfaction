//
//  CSPGameBoardCellView.h
//  CS440ConstraintSatisfactionGame
//
//  Created by Troy Chmieleski on 10/27/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSPGameBoardCellView : UIView

- (id)initWithFrame:(CGRect)frame weight:(NSString *)weight owner:(NSUInteger)owner backgroundColor:(UIColor *)backgroundColor borderColor:(UIColor *)borderColor;

@end
