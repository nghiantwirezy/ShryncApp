//
//  ActivitySelectionViewController.m
//  My Therapist
//
//  Created by Yexiong Feng on 12/13/13.
//  Copyright (c) 2013 stackbear. All rights reserved.
//

#import "ActivitySelectionViewController.h"
#import "AddCommentViewController.h"
#import "AppDelegate.h"

#import "FeelingRecord.h"

#define TITLE @"WHAT ARE YOU DOING?"

@interface ActivitySelectionViewController ()

@end

@implementation ActivitySelectionViewController {
  UIBarButtonItem *_backButtonItem;
}

- (void)popBack
{
  [self.navigationController popViewControllerAnimated:YES];
}

- (id)initWithStyle:(UITableViewStyle)style
{
  self = [super initWithStyle:style];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // Uncomment the following line to preserve selection between presentations.
  // self.clearsSelectionOnViewWillAppear = NO;
  
  // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
  // self.navigationItem.rightBarButtonItem = self.editButtonItem;
  
  UIImage *backImage = [UIImage imageNamed:@"back button.png"];
  UIButton *backButton = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, backImage.size.width, backImage.size.height)];
  [backButton setBackgroundImage:backImage forState:UIControlStateNormal];
  [backButton addTarget:self action:@selector(popBack) forControlEvents:UIControlEventTouchUpInside];
  _backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
  
  UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 35)];
  titleLabel.font = [UIFont fontWithName:@"LeagueGothic-Regular" size:21.0f];
  titleLabel.text = NSLocalizedString(TITLE, nil);
  titleLabel.textColor = [UIColor colorWithRed:221.0 / 255 green:221.0 / 255 blue:221.0 / 255 alpha:1];
  titleLabel.textAlignment = NSTextAlignmentCenter;
  self.navigationItem.titleView = titleLabel;
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  [self.navigationController setNavigationBarHidden:NO animated:YES];
  self.navigationItem.leftBarButtonItem = _backButtonItem;
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  // Return the number of sections.
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  // Return the number of rows in the section.
  return [FeelingRecord activityNames].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"ActivitySelectionCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont fontWithName:@"BebasNeue" size:17.0];
    cell.textLabel.textColor = [UIColor colorWithRed:200.0 / 255 green:200.0 / 255 blue:200.0 / 255 alpha:1];
  }
  
  // Configure the cell...
  cell.textLabel.text = [FeelingRecord activityNameForIndex:indexPath.row];
  
  AddCommentViewController *controller = (AddCommentViewController *)myAppDelegate.addCommentViewController;
  if (indexPath.row == controller.feelingRecord.activityIndex) {
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
  } else {
    cell.accessoryType = UITableViewCellAccessoryNone;
  }
  
  return cell;
}

#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  AddCommentViewController *controller = (AddCommentViewController *)myAppDelegate.addCommentViewController;
  
  if (indexPath.row != controller.feelingRecord.activityIndex) {
    [controller setActivityIndex:indexPath.row];
    
    [self.tableView reloadData];
  }
  
  [self performSelector:@selector(popBack) withObject:nil afterDelay:0.1];
}

@end
