//
//  NSString+JSON.m
//  My Therapist
//
//  Created by Yexiong Feng on 2/16/14.
//  Copyright (c) 2014 ApplePieHealing. All rights reserved.
//

#import "NSString+JSON.h"

@implementation NSString (JSON)

- (id)deserialize
{
  NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
  
  NSError *error = nil;
  id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
  if (error != nil) {
    NSLog(@"Error on deserialization: %@", error);
  }
  
  return object;
}

@end
