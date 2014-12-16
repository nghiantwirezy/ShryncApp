//
//  FollowerTableViewController.h
//  Copyright (c) 2014 Shrync. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FollowObject;

@protocol FollowerTableViewControllerDelegate <NSObject>
@optional
- (void)didUpdateFollowerSuccessful:(UIButton *)btnFollower;
- (void)didScrollFollower:(UIScrollView *)scrollView;
- (void)didSelectFollowerUser:(FollowObject*)followObject;
@end

@interface FollowerTableViewController : UITableViewController

@property (nonatomic,assign) id<FollowerTableViewControllerDelegate> delegate;

@property (strong, nonatomic) NSNumber *currenttIndexPath;
@property (strong, nonatomic) NSMutableArray *arrayFollower;
@property (strong, nonatomic) NSMutableArray *arrayFollowingMe;
@property (strong, nonatomic) NSMutableArray *arrayMe;

@property (strong, nonatomic) NSMutableArray *listFollowMe;
@property (nonatomic, retain) NSDictionary *dicParamPublic;
@property (nonatomic, retain) NSDictionary *listsFollowerDicts;
@property (strong, nonatomic) NSString *userId;

- (void) compareListFollowing;
- (void) compareListFollowingTwo;
@end
