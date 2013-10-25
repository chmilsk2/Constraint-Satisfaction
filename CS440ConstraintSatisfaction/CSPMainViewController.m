//
//  CSPMainViewController.m
//  CS440ConstraintSatisfaction
//
//  Created by Troy Chmieleski on 10/21/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "CSPMainViewController.h"
#import "CSPListViewController.h"
#import "CSPListSection.h"
#import "CSPScheduleParsingOperation.h"
#import "CSPBacktrackingSearchOperation.h"
#import "CSPSchedule.h"

#define LIST_BUTTON_ITEM_NAME @"854-list"

@implementation CSPMainViewController {
	NSOperationQueue *_queue;
	UIBarButtonItem *_listButton;
	UIColor *_barBarTintColor;
	UIColor *_barTintColor;
}

- (id)init
{
    self = [super init];
	
    if (self) {
		_queue = [[NSOperationQueue alloc] init];
		
		_barBarTintColor = [UIColor blackColor];
        _barTintColor = [UIColor whiteColor];
    }
	
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	[self setUpNav];
}

- (void)setUpNav {
	[self.navigationController.navigationBar setBarTintColor:_barBarTintColor];
	[self.navigationController.navigationBar setTintColor:_barTintColor];
	[self.navigationController.navigationBar setTranslucent:NO];
	[self.navigationItem setLeftBarButtonItem:self.listButton];
}

- (UIBarButtonItem *)listButton {
	if (!_listButton) {
		_listButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:LIST_BUTTON_ITEM_NAME] style:UIBarButtonItemStylePlain target:self action:@selector(listButtonTouched)];
	}
	
	return _listButton;
}

- (void)listButtonTouched {
	CSPListViewController *listViewController = [[CSPListViewController alloc] init];
	[listViewController setDelegate:self];
	
	UINavigationController *listNavController = [[UINavigationController alloc] initWithRootViewController:listViewController];
	
	[self presentViewController:listNavController animated:YES completion:nil];
}

#pragma mark - List Selection Delegate

- (void)didSelectScheduleWithName:(NSString *)name {
	// parse the selected maze
	CSPScheduleParsingOperation *scheduleParsingOperation = [[CSPScheduleParsingOperation alloc] initWithScheduleName:name];
	
	scheduleParsingOperation.scheduleParsingCompletionBlock = ^(CSPSchedule *schedule, NSError *error) {
		if (!error) {
			CSPBacktrackingSearchOperation *backtrackingSearchOperation = [[CSPBacktrackingSearchOperation alloc] initWithSchedule:schedule];
			
			backtrackingSearchOperation.backtrackingSearchCompletionBlock = ^(NSArray *assignment, NSError *error) {
				if (!error) {
					NSLog(@"finished backtacking search: assignment: %@", assignment);
				}
				
				else {
					NSLog(@"Error performing backtracking search: %@", [error localizedDescription]);
				}
			};
			
			[_queue addOperation:backtrackingSearchOperation];
		}
		
		else {
			NSLog(@"Error Parsing Schedule: %@: %@", name, [error localizedDescription]);
		}
	};
	
	[_queue addOperation:scheduleParsingOperation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
