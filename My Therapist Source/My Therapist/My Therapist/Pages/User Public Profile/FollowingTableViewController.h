//
//  FollowingTableViewController.h
//  Copyright (c) 2014 Shrync. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FollowObject;

@protocol FollowingTableViewControllerDelegate <NSObject>
@optional
- (void)didScrollFollowing:(UIScrollView *)scrollView;
- (void)didSelectFollowingUser:(FollowObject*)followObject;
@end

@interface FollowingTableViewController : UITableViewController

@property (strong, nonatomic) NSNumber *currenttIndexPath;
@property (strong, nonatomic) NSMutableArray *arrayFollowing;
@property (strong, nonatomic) NSMutableArray *arrayFollowingMeMe;
@property (strong, nonatomic) NSMutableArray *arrayOfMe;

@property (nonatomic, retain) NSDictionary *dicParamPublic;
@property (nonatomic, retain) NSDictionary *listsFollowingDicts;
@property (strong, nonatomic) NSString *userId;

@property (nonatomic,assign) id<FollowingTableViewControllerDelegate> delegate;

-(void)compareListFollowingTwo;
    
@end
