//
//  AvatarHelper.m
//  Copyright (c) 2014 Shrync. All rights reserved.
//

#import "AvatarHelper.h"
#define USER_ID_PARAM @"userid"
#define DEFAULT_USER_IMAGE_NAME @"signup default user image.png"
#define GET_AVATAR_URL @"https://secure.shrync.com/api/user/getavatar"

@implementation AvatarHelper

+(void)setAvatarForImageView:(UIImageView *)imageView withKey :(NSString *)key{
   NSCache  *_avatarCache = [[NSCache alloc] init];
    UIImage *avatar = [_avatarCache objectForKey:key];
    if (!avatar) {
        NSDictionary *param = @{USER_ID_PARAM:key};
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFImageResponseSerializer serializer];
        [manager GET:GET_AVATAR_URL parameters:param
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 UIImage *avatar = responseObject;
                 if (avatar == nil) {
                     avatar = [UIImage imageNamed:DEFAULT_USER_IMAGE_NAME];
                 } else {
                     [_avatarCache setObject:responseObject forKey:key];
                 }
                 [imageView setImage:avatar];
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             }];
    } else {
        [imageView setImage:avatar];
    }
}

@end
