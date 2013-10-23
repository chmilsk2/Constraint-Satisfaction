//
//  CSPListViewController.h
//  CS440ConstraintSatisfaction
//
//  Created by Troy Chmieleski on 10/21/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSPListDelegate.h"

@interface CSPListViewController : UITableViewController

@property (nonatomic, weak) id <CSPListDelegate> delegate;

@end
