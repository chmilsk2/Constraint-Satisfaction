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
#import "CSPMeeting.h"

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
			
			backtrackingSearchOperation.backtrackingSearchCompletionBlock = ^(NSArray *assignment, NSUInteger numberOfAssignments, NSTimeInterval executionTime, NSError *error) {
				if (!error) {
					[self prettyPrintAssignment:assignment];
					NSLog(@"number of assignments: %lu", (unsigned long)numberOfAssignments);
					[self prettyPrintExecutionTime:executionTime];
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

- (void)prettyPrintAssignment:(NSArray *)assignment {
	NSString *assignmentStr = @"Final Assignment: ";
	
	for (NSUInteger i = 0; i < assignment.count; i++) {
		NSArray *timeSlotAssignment = assignment[i];
		NSString *timeSlotAssignmentStr = @"[";
		
		if (timeSlotAssignment.count) {
			for (NSUInteger j = 0; j < timeSlotAssignment.count; j++) {
				CSPMeeting *meeting = timeSlotAssignment[j];
				
				if (![meeting isEqual:timeSlotAssignment.lastObject]) {
					timeSlotAssignmentStr = [timeSlotAssignmentStr stringByAppendingString:[NSString stringWithFormat:@"%@, ", [meeting.meetingId stringValue]]];
				}
				
				else {
					timeSlotAssignmentStr = [timeSlotAssignmentStr stringByAppendingString:[NSString stringWithFormat:@"%@]", [meeting.meetingId stringValue]]];
				}
			}
		}
		
		else {
			timeSlotAssignmentStr = [timeSlotAssignmentStr stringByAppendingString:@"]"];
		}
		
		assignmentStr = [assignmentStr stringByAppendingString:[NSString stringWithFormat:@"%lu: %@ ", (unsigned long)(i+1), timeSlotAssignmentStr]];
	}
	
	NSLog(@"%@", assignmentStr);
}

- (void)prettyPrintExecutionTime:(NSTimeInterval)exeuctionTime {
	NSUInteger timeIntervalMilliSeconds = (NSInteger)exeuctionTime;
	NSUInteger timeIntervalSeconds = timeIntervalMilliSeconds/1000;
	NSUInteger milliSeconds = timeIntervalMilliSeconds % 1000;
	NSUInteger seconds = timeIntervalSeconds % 60;
    NSUInteger minutes = (timeIntervalSeconds / 60) % 60;
    NSUInteger hours = (timeIntervalSeconds / 3600);
    NSLog(@"%@", [NSString stringWithFormat:@"%02lu:%02lu:%02lu:%04lu", (unsigned long)hours, (unsigned long)minutes, (unsigned long)seconds, (unsigned long)milliSeconds]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
