//
//  AudioTrack.h
//  My Therapist
//
//  Created by Yexiong Feng on 7/30/14.
//  Copyright (c) 2014 ApplePieHealing. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Feeling;

@interface AudioTrack : NSObject

@property (strong, nonatomic) Feeling *feeling;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *trackDesc;
@property (strong, nonatomic) NSURL *url;

@end
