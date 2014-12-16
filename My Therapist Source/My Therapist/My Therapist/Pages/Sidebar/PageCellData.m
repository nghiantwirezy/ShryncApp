//
//  PageCellData.m
//  My Therapist
//
//  Created by Yexiong Feng on 11/21/13.
//  Copyright (c) 2013 stackbear. All rights reserved.
//

#import "PageCellData.h"

@implementation PageCellData

- (id)initWithImageName:(NSString *)imageName text:(NSString *)text page:(UIViewController *)page
{
  self = [super init];
  if (self) {
    _image = [UIImage imageNamed:imageName];
    _text = text;
    _page = page;
  }
  return self;
}

- (void)formatCell:(UITableViewCell *)cell
{
  cell.imageView.image = self.image;
  cell.textLabel.text = self.text;
}

@end
