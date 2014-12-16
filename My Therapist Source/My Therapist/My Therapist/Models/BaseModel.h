//
//  BaseModel.h
//  My Therapist
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"
#import "UIImageView+WebCache.h"

typedef void (^ModelRequestCompletion)(id result, NSError *error);
typedef void (^ModelRequestOperationCompletion)(id result, NSError *error,id operation);

@interface BaseModel : NSObject

+ (BaseModel *)shareBaseModel;
// GET
- (void)getFollowEndPointWithParameters:(NSDictionary *)parameters completion:(ModelRequestCompletion)completion;
- (void)getFollowerEndPointWithParameters:(NSDictionary *)parameters completion:(ModelRequestCompletion)completion;
- (void)getFollowingEndPointWithParameters:(NSDictionary *)parameters completion:(ModelRequestCompletion)completion;
- (void)getUserEndPointWithParameters:(NSDictionary *)parameters completion:(ModelRequestCompletion)completion;
- (void)getUserAvatarWithParameters:(NSDictionary *)parameters completion:(ModelRequestCompletion)completion;
- (void)downloadUserImageWithParameters:(NSDictionary *)parameters andImageKey:(NSString *)imageKey completion:(ModelRequestCompletion)completion;
- (void)downloadUserImageWithImageKey:(NSString *)imageKey andURLPathName:(NSString *)urlPathName completion:(ModelRequestCompletion)completion;
- (void)getFeelingDetailWithParameters:(NSDictionary *)parameters completion:(ModelRequestCompletion)completion;
- (void)getUserFriendWithParameters:(NSDictionary *)parameters completion:(ModelRequestCompletion)completion;
- (void)getThumbnailWithParameters:(NSDictionary *)parameters completion:(ModelRequestCompletion)completion;
- (void)getSocialFriendWithParameters:(NSDictionary *)parameters completion:(ModelRequestCompletion)completion;

// POST
- (void)postUserUpdateEndPointWithParameters:(NSDictionary *)parameters andURLAvatarTemp:(NSURL *)avatarTempFileURL andURLBimageTemp:(NSURL *)bimageTempFileURL completion:(ModelRequestOperationCompletion)completion;
- (void)postUserUpdateEndPointWithParameters:(NSDictionary *)parameters completion:(ModelRequestCompletion)completion;
- (void)postFeelingHugEndPointWithParameters:(NSDictionary *)parameters completion:(ModelRequestCompletion)completion;
- (void)postUpdateCheckinEndPointWithParameters:(NSDictionary *)parameters completion:(ModelRequestCompletion)completion;

// DELETE
- (void)deleteAccountEndPointWithParameters:(NSDictionary *)parameters completion:(ModelRequestCompletion)completion;
- (void)deleteFeelingEndPointWithParameters:(NSDictionary *)parameters completion:(ModelRequestCompletion)completion;

@end
