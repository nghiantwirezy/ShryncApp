//
//  SessionManager.h
//  Copyright (c) 2013 stackbear. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserSession : NSObject

@property (readonly, nonatomic) NSDate *createdDate;
@property (strong, nonatomic) NSString *sessionToken, *userId, *username, *email, *userBiography;
@property (strong, nonatomic) UIImage *userAvatar;
@property (strong, nonatomic) UIImage *backgroundImage;
@property (strong, nonatomic) NSString *deviceToken;
@property (strong) NSArray *latestFeelingRecords;
@property (assign, nonatomic) BOOL userPublicProfile;
@property (assign, nonatomic) BOOL userPublicCheckin;
@property (readonly, nonatomic) BOOL isGuestSession;
@property (strong, nonatomic) NSString *facebookID, *facebookToken, *twitterID, *twitterToken;

+ (UserSession *)currentSession;
+ (UserSession *)signedInWithDictonary:(NSDictionary *)dictionary;
+ (UserSession *)signInAsGuest;
+ (void)updatedWithEmail:(NSString *)email avatar:(UIImage *)avatar biography:(NSString *)biography backgroundImage:(UIImage *)backgroundImage
       userPublicProfile:(BOOL)userPublicProfile userPublicCheckin:(BOOL)userPublicCheckin;
+ (void)updateFacebookInfoWithFaceBookID:(NSString *)facebookID facebookToken:(NSString *)facebookToken;
+ (void)updateTwitterInfoWithTwitterID:(NSString *)twitterID twitterToken:(NSString *)twitterToken;
+ (void)signOut;
- (void)saveSession;

@end
