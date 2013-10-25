//
//  CSPListViewController.m
//  CS440ConstraintSatisfaction
//
//  Created by Troy Chmieleski on 10/21/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "CSPListViewController.h"
#import "CSPListSection.h"

// title
#define LIST_TITLE @"Settings"

// sections
#define LIST_SECTION_HEADER_TITLE @"Scheduling"
#define LIST_SECTION_HEADER_HEIGHT 30.0f

// rows
#define LIST_ROW_HEIGHT 60.0f

// cell
#define LIST_CELL_REUSE_IDENTIFIER @"ListCellReuseIdentifier"

// schedules
#define LIST_SCHEDULES_COUNT 4
#define LIST_SCHEDULE_PREFIX @"problem"

@interface CSPListViewController ()

@end

@implementation CSPListViewController {
	NSArray *_sections;
	NSMutableArray *_scheduleNames;
	UIBarButtonItem *_doneButton;
	UIColor *_barBarTintColor;
	UIColor *_barTintColor;
	NSInteger _selectedSection;
	NSInteger _selectedScheduleIndex;
}

- (id)init {
	self = [super init];
	
	if (self) {
		// sections
		_sections = @[LIST_SECTION_HEADER_TITLE];
		
		// schedule names
		_scheduleNames = [NSMutableArray array];

		for (NSUInteger i = 1; i <= LIST_SCHEDULES_COUNT; i++) {
			[_scheduleNames addObject:[NSString stringWithFormat:@"problem%lu", (unsigned long)i]];
		}
		
		// selected schedule index
		_selectedScheduleIndex = 0;
		
		// nav colors
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
	[self setUpTable];
}

#pragma mark - Set Up Navigation

- (void)setUpNav {
	[self.navigationController.navigationBar setBarTintColor:_barBarTintColor];
	[self.navigationController.navigationBar setTintColor:_barTintColor];
	[self.navigationController.navigationBar setTranslucent:NO];
	[self.navigationItem setRightBarButtonItem:self.doneButton];
}

#pragma mark - Set Up Table

- (void)setUpTable {
	[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:LIST_CELL_REUSE_IDENTIFIER];
}

#pragma mark - Table Configuration

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [_sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSInteger numberOfRows = 0;
	
	if (section == CSPSectionSceduling) {
		numberOfRows = [_scheduleNames count];
	}
	
	return numberOfRows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return LIST_ROW_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return LIST_SECTION_HEADER_HEIGHT;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	NSString *sectionHeaderTitle;
	
	if (section == CSPSectionSceduling) {
		sectionHeaderTitle = LIST_SECTION_HEADER_TITLE;
	}
	
	return sectionHeaderTitle;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:LIST_CELL_REUSE_IDENTIFIER forIndexPath:indexPath];
	
	NSString *text;

	if (indexPath.section == CSPSectionSceduling) {
		if (indexPath.row == _selectedScheduleIndex) {
			[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
		}
		
		else {
			[cell setAccessoryType:UITableViewCellAccessoryNone];
		}
		
		text = _scheduleNames[indexPath.row];
	}
	
	[cell.textLabel setText:text];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == CSPSectionSceduling) {
		_selectedScheduleIndex = indexPath.row;
	}
}

#pragma mark - Done Button

- (UIBarButtonItem *)doneButton {
	if (!_doneButton) {
		_doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonTouched)];
	}
	
	return _doneButton;
}

- (void)doneButtonTouched {
	if (_selectedSection == CSPSectionSceduling) {
		if ([self.delegate respondsToSelector:@selector(didSelectScheduleWithName:)]) {
			[self.delegate didSelectScheduleWithName:_scheduleNames[_selectedScheduleIndex]];
		}
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
