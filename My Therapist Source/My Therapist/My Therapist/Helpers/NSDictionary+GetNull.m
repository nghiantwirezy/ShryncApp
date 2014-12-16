//
//  NSDictionary+GetNull.m
//  My Therapist
//
//  Created by Yexiong Feng on 8/12/14.
//  Copyright (c) 2014 ApplePieHealing. All rights reserved.
//

#import "NSDictionary+GetNull.h"

@implementation NSDictionary (GetNull)

- (id)objectForKeyNotNull:(id)key {
  id object = [self objectForKey:key];
  if (object == [NSNull null])
    return nil;
  
  return object;
}

@end
