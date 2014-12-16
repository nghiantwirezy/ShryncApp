//
//  NSDictionary+JSON.m
//  My Therapist
//
//  Created by Yexiong Feng on 2/16/14.
//  Copyright (c) 2014 ApplePieHealing. All rights reserved.
//

#import "NSDictionary+JSON.h"

@implementation NSDictionary (JSON)

- (NSString *)serialize
{
  NSError *error = nil;
  NSData * data = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
  if (error != nil) {
    NSLog(@"Error on serialization: %@", error);
  }
  
  NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
  return string;
}

@end
