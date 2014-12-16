//
//  SessionManager.m
//  Copyright (c) 2013 stackbear. All rights reserved.
//

#import "UserSession.h"
#import "AFHTTPRequestOperationManager.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "FeelingRecord.h"
#import "NSString+JSON.h"
#import "NSDictionary+JSON.h"
#import "NSArray+JSON.h"
#import "AFHTTPRequestOperationManager.h"
#import "FHSTwitterEngine.h"

static UserSession *_currentSession;
static NSDateFormatter *_createdDateFormatter;

@implementation UserSession {
    NSMutableArray *_latestFeelingRecords;
}

+ (void)initialize
{
    _createdDateFormatter = [[NSDateFormatter alloc] init];
    [_createdDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
}

- (id)initWithSessionToken:(NSString *)sessionToken
                    userId:(NSString *)userId
                  nickname:(NSString *)nickname
                     email:(NSString *)email
                    avatar:(UIImage *)avatar
               createdDate:(NSDate *)createdDate
               deviceToken:(NSString *)deviceToken
             userBiography:(NSString *)userBiography
                facebookID:(NSString *)facebookID
             facebookToken:(NSString *)facebookToken
                 twitterID:(NSString *)twitterID
              twitterToken:(NSString *)twitterToken
           backgroundImage:(UIImage *)backgroundImage
         userPublicProfile: (BOOL)userPublicProfile
         userPublicCheckin:(BOOL)userPublicCheckin
{
    self = [super init];
    if (self) {
        _sessionToken = sessionToken;
        _userId = userId;
        _username = (nickname != (id)[NSNull null])?nickname:@"";
        _email = (email != (id)[NSNull null])?email:@"";
        _userAvatar = avatar;
        _createdDate = createdDate;
        _deviceToken = deviceToken;
        _userBiography = (userBiography != (id)[NSNull null])?userBiography:@"";
        _facebookID = (facebookID != (id)[NSNull null])?facebookID:@"";
        _facebookToken = (facebookToken != (id)[NSNull null])?facebookToken:@"";
        _twitterID = (twitterID != (id)[NSNull null])?twitterID:@"";
        _twitterToken = (twitterToken != (id)[NSNull null])?twitterToken:@"";
        _backgroundImage = backgroundImage;
        _userPublicCheckin = userPublicCheckin;
        _userPublicProfile = userPublicProfile;
    }
    return self;
}

- (BOOL)isGuestSession
{
    return [self.sessionToken isEqualToString:GUEST_SESSION_TOKEN];
}

- (NSDictionary *)toJSONDictionary
{
    NSDictionary *dict = @{ JSON_SESSION_KEY: self.sessionToken,
                            JSON_USER_ID_KEY: self.userId,
                            JSON_NICKNAME_KEY: self.username,
                            JSON_EMAIL_KEY: self.email,
                            JSON_CREATED_DATE_KEY: [_createdDateFormatter stringFromDate:self.createdDate] ,
                            JSON_DEVICE_TOKEN:self.deviceToken ,
                            JSON_PROFILE_PUBLIC_KEY: [NSNumber numberWithBool:_currentSession.userPublicProfile ],
                            JSON_CHECKIN_PUBLIC_KEY: [NSNumber numberWithBool:_currentSession.userPublicCheckin],
                            KEY_BIOGRAPHY: (self.userBiography)?self.userBiography:@"",
                            KEY_FACEBOOK_ID: (self.facebookID)?self.facebookID:@"",
                            KEY_FACEBOOK_TOKEN: (self.facebookToken)?self.facebookToken:@"",
                            KEY_TWITTER_ID: (self.twitterID)?self.twitterID:@"",
                            KEY_TWITTER_TOKEN: (self.twitterToken)?self.twitterToken:@""
                            };
    return dict;
}

+ (UIImage *)loadLocalAvatar
{
    NSString *localFilePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingString:USER_AVATAR_FILE_NAME];
    UIImage *avatar = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:localFilePath]) {
        avatar = [UIImage imageWithContentsOfFile:localFilePath];
    } else {
        avatar = [UIImage imageNamed:DEFAULT_USER_IMAGE_NAME];
    }
    return avatar;
}

+ (UIImage *)loadLocalBackgroundImage
{
    NSString *localFilePath2 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingString:BACKGROUND_IMAGE_FILE_NAME];
    UIImage *backgroundImage = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:localFilePath2]) {
        backgroundImage = [UIImage imageWithContentsOfFile:localFilePath2];
    }
    return backgroundImage;
}

+ (UserSession *)fromJSONString:(NSString *)JSONString
{
    NSDictionary *dict = [JSONString deserialize];
    NSString *sessionToken = [dict objectForKey:JSON_SESSION_KEY];
    NSString *userId = [dict objectForKey:JSON_USER_ID_KEY];
    NSString *nickname = [dict objectForKey:JSON_NICKNAME_KEY];
    NSString *email = [dict objectForKey:JSON_EMAIL_KEY];
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"DEVICE_TOKEN"];
    NSDate *createdDate = [_createdDateFormatter dateFromString:[dict objectForKey:JSON_CREATED_DATE_KEY]];
    
    UIImage *avatar = [UserSession loadLocalAvatar];
    UIImage *backgroundImage = [UserSession loadLocalBackgroundImage];
    
    NSString *userBiography = [dict objectForKey:JSON_BIOGRAPHY_KEY];
    NSString *facebookID = [dict objectForKey:KEY_FACEBOOK_ID];
    NSString *facebookToken = [dict objectForKey:KEY_FACEBOOK_TOKEN];
    NSString *twitterID = [dict objectForKey:KEY_TWITTER_ID];
    NSString *twitterToken = [dict objectForKey:KEY_TWITTER_TOKEN];
    
    UserSession *userSession = [[UserSession alloc] initWithSessionToken:sessionToken
                                                                  userId:userId
                                                                nickname:nickname
                                                                   email:email
                                                                  avatar:avatar
                                                             createdDate:createdDate
                                                             deviceToken:deviceToken
                                                           userBiography:userBiography
                                                              facebookID:facebookID
                                                           facebookToken:facebookToken
                                                               twitterID:twitterID
                                                            twitterToken:twitterToken
                                                         backgroundImage:backgroundImage
                                                       userPublicProfile:[[dict objectForKey:JSON_PROFILE_PUBLIC_KEY]boolValue]
                                                       userPublicCheckin:[[dict objectForKey:JSON_CHECKIN_PUBLIC_KEY]boolValue]];
    return userSession;
}

- (void)saveSession
{
    NSDictionary *dict = [self toJSONDictionary];
    NSString *string = [dict serialize];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:string forKey:SESSION_STORAGE_KEY];
    [defaults synchronize];
    NSLog(@"bool = %d, 2 =%d",_userPublicCheckin,_userPublicProfile);
}

+ (UserSession *)loadSession
{
    UserSession *session = nil;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *string = [defaults objectForKey:SESSION_STORAGE_KEY];
    if (string.length > 0) {
        session = [UserSession fromJSONString:string];
    }
    
    return session;
}

+ (UserSession *)currentSession
{
    if (_currentSession == nil) {
        _currentSession = [UserSession loadSession];
    }
    return _currentSession;
}

+ (UserSession *)signedInWithDictonary:(NSDictionary *)dictionary
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:SESSION_STORAGE_KEY];
    [defaults synchronize];
    
    NSDictionary *responseDict = dictionary;
    NSDictionary *userDict = [responseDict objectForKey:JSON_USER_DICT_KEY];
    
    NSString *sessionToken = [responseDict objectForKey:JSON_SESSION_KEY];
    NSString *userId = [userDict objectForKey:JSON_USER_ID_KEY];
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"DEVICE_TOKEN"];
    NSString *username = [userDict objectForKey:JSON_NICKNAME_KEY];
    NSString *email = [userDict objectForKey:JSON_EMAIL_KEY];
    NSDate *createdDate = [_createdDateFormatter dateFromString:[userDict objectForKey:JSON_CREATED_DATE_KEY]];
    NSString *userBiography = [userDict objectForKey:JSON_BIOGRAPHY_KEY];
    UIImage *avatar = [UserSession loadLocalAvatar];
    UIImage *backgroundImage = [UserSession loadLocalBackgroundImage];
    
    NSString *facebookID = [userDict objectForKey:KEY_FACEBOOK_ID];
    NSString *facebookToken = [userDict objectForKey:KEY_FACEBOOK_TOKEN];
    NSString *twitterID = [userDict objectForKey:KEY_TWITTER_ID];
    NSString *twitterToken = [userDict objectForKey:KEY_TWITTER_TOKEN];

    UserSession *userSession = [[UserSession alloc] initWithSessionToken:sessionToken
                                                                  userId:userId
                                                                nickname:username
                                                                   email:email
                                                                  avatar:avatar
                                                             createdDate:createdDate
                                                             deviceToken:deviceToken
                                                           userBiography:userBiography
                                                              facebookID:facebookID
                                                           facebookToken:facebookToken
                                                               twitterID:twitterID
                                                            twitterToken:twitterToken
                                                         backgroundImage:backgroundImage
                                                       userPublicProfile:[[userDict objectForKey:JSON_PROFILE_PUBLIC_KEY]boolValue]
                                                       userPublicCheckin:[[userDict objectForKey:JSON_CHECKIN_PUBLIC_KEY]boolValue]
                                ];
    _currentSession = userSession;
    [_currentSession saveSession];
    
    NSLog(@"User token: %@", [UserSession currentSession].sessionToken);
    
    return _currentSession;
}

+ (UserSession *)signInAsGuest
{
    UserSession *userSession =[[UserSession alloc] initWithSessionToken:GUEST_SESSION_TOKEN
                                                                 userId:GUEST_ID
                                                               nickname:GUEST_NICKNAME
                                                                  email:GUEST_EMAIL
                                                                 avatar:[UIImage imageNamed:DEFAULT_USER_IMAGE_NAME]
                                                            createdDate:[NSDate date]
                                                            deviceToken:GUEST_TOKEN
                                                          userBiography:GUEST_BIOGRAPHY
                                                             facebookID:@""
                                                          facebookToken:@""
                                                              twitterID:@""
                                                           twitterToken:@""
                                                        backgroundImage:[UIImage imageNamed:DEFAULT_BACKGROUND_IMAGE_NAME]
                                                      userPublicProfile:NO userPublicCheckin:NO];
    _currentSession = userSession;
    [_currentSession saveSession];
    
    return _currentSession;
}

+ (void)updatedWithEmail:(NSString *)email avatar:(UIImage *)avatar biography:(NSString *)biography backgroundImage:(UIImage *)backgroundImage userPublicProfile:(BOOL)userPublicProfile userPublicCheckin:(BOOL)userPublicCheckin
{
    if (email.length != 0) {
        _currentSession.email = email;
    }
    
    if (avatar != nil) {
        _currentSession.userAvatar = avatar;
    }
    
    if (backgroundImage != nil) {
        _currentSession.backgroundImage = backgroundImage;
    }
    
    _currentSession.userPublicCheckin = userPublicCheckin;
    
    _currentSession.userPublicProfile = userPublicProfile;
    
    _currentSession.userBiography = biography;
    
    [_currentSession saveSession];
}

+ (void)updateFacebookInfoWithFaceBookID:(NSString *)facebookID facebookToken:(NSString *)facebookToken {
    _currentSession.facebookID = facebookID;
    _currentSession.facebookToken = facebookToken;
    [_currentSession saveSession];
}

+ (void)updateTwitterInfoWithTwitterID:(NSString *)twitterID twitterToken:(NSString *)twitterToken {
    _currentSession.twitterID = twitterID;
    _currentSession.twitterToken = twitterToken;
    [_currentSession saveSession];
}

+ (void)signOut
{
    if (_currentSession == nil) {
        return;
    }
    
    if (!_currentSession.isGuestSession) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *parameters = @{SIGNOUT_TOKEN_PARAM: _currentSession.sessionToken};
        [manager GET:SIGNOUT_ENDPOINT parameters:parameters success:nil failure:nil];
    }
    [FBSession.activeSession closeAndClearTokenInformation];
    [[FHSTwitterEngine sharedEngine]clearAccessToken];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate resetViewControllers];
    
    NSString *localFilePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingString:USER_AVATAR_FILE_NAME];
    if ([[NSFileManager defaultManager] fileExistsAtPath:localFilePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:localFilePath error:nil];
    }
    
    NSString *localFilePath2 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingString:BACKGROUND_IMAGE_FILE_NAME];
    if ([[NSFileManager defaultManager] fileExistsAtPath:localFilePath2]) {
        [[NSFileManager defaultManager] removeItemAtPath:localFilePath2 error:nil];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:SESSION_STORAGE_KEY];
    [defaults synchronize];
    _currentSession = nil;
}

- (void)setLatestFeelingRecords:(NSArray *)latestFeelingRecords
{
    if (latestFeelingRecords != (id)[NSNull null] && latestFeelingRecords.count > 0) {
        int count = (int)MIN(MAX_CACHE_FEELINGS_COUNT, latestFeelingRecords.count);
        
        NSMutableArray *serializedFeelings = [[NSMutableArray alloc] initWithCapacity:count];
        for (int i = 0; i < count; ++i) {
            FeelingRecord *feeling = [latestFeelingRecords objectAtIndex:i];
            NSDictionary *dictionary = [feeling toJSONDictionary];
            [serializedFeelings addObject:dictionary];
        }
        
        NSString *serializedFeelingsJSON = [serializedFeelings serialize];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:serializedFeelingsJSON forKey:FEELING_CACHE_KEY];
        [defaults synchronize];
    } else {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults removeObjectForKey:FEELING_CACHE_KEY];
        [defaults synchronize];
    }
}

- (NSArray *)latestFeelingRecords
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *json = [defaults objectForKey:FEELING_CACHE_KEY];
    if (!json) {
        return nil;
    }
    
    NSMutableArray *latestFeelingRecords = [[NSMutableArray alloc] init];
    NSArray *feelingRecordDicts = [json deserialize];
    for (NSDictionary *feelingRecordDict in feelingRecordDicts) {
        FeelingRecord *feelingRecord = [FeelingRecord fromDictionary:feelingRecordDict];
        [latestFeelingRecords addObject:feelingRecord];
    }
    return latestFeelingRecords;
}

@end
