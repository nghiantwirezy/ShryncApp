//
//  PageCellData.h
//  My Therapist
//
//  Created by Yexiong Feng on 11/21/13.
//  Copyright (c) 2013 stackbear. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PageCellData : NSObject

@property (readonly, nonatomic) UIImage *image;
@property (readonly, nonatomic) NSString *text;
@property (readonly, nonatomic) UIViewController *page;

- (id)initWithImageName:(NSString *)imageName text:(NSString *)text page:(UIViewController *)page;
- (void)formatCell:(UITableViewCell *)cell;

@end
