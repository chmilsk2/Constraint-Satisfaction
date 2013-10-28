//
//  CSPWarGameMenuViewController.h
//  CS440ConstraintSatisfactionGame
//
//  Created by Troy Chmieleski on 10/26/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSPMenuDelegate.h"

@interface CSPWarGameMenuViewController : UITableViewController

@property (weak) id <CSPMenuDelegate> delegate;

@end
