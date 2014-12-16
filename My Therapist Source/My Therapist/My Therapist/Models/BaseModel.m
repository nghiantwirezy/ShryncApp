//
//  BaseModel.m
//  My Therapist
//

#import "BaseModel.h"

@implementation BaseModel

#pragma mark - BaseModel managements

+ (BaseModel *)shareBaseModel {
    // Singleton object
    static BaseModel *baseModel = nil;
    if (!baseModel) {
        baseModel = [[BaseModel alloc]init];
    }
    return baseModel;
}

#pragma mark - GET

- (void)getFollowEndPointWithParameters:(NSDictionary *)parameters completion:(ModelRequestCompletion)completion{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = INTERNET_TIMEOUT;
    [manager GET:URL_GET_FOLLOW_ENDPOINT parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completion) {
            completion(responseObject, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(nil, error);
        }
    }];
}

- (void)getFollowerEndPointWithParameters:(NSDictionary *)parameters completion:(ModelRequestCompletion)completion {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = INTERNET_TIMEOUT;
    [manager GET:URL_GET_FOLLOWER_ENDPOINT parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completion) {
            completion(responseObject, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(nil, error);
        }
    }];
    [manager.operationQueue setSuspended:YES];
}

- (void)getFollowingEndPointWithParameters:(NSDictionary *)parameters completion:(ModelRequestCompletion)completion {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = INTERNET_TIMEOUT;
    [manager GET:URL_GET_FOLLOWING_ENDPOINT parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completion) {
            completion(responseObject, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(nil, error);
        }
    }];
    [manager.operationQueue setSuspended:YES];
}

- (void)getUserEndPointWithParameters:(NSDictionary *)parameters completion:(ModelRequestCompletion)completion {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = INTERNET_TIMEOUT;
    [manager GET:URL_GET_USER_ENDPOINT parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completion) {
            completion(responseObject, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(nil, error);
        }
    }];
    [manager.operationQueue setSuspended:YES];
}

- (void)getUserAvatarWithParameters:(NSDictionary *)parameters completion:(ModelRequestCompletion)completion {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = INTERNET_TIMEOUT;
    manager.responseSerializer = [AFImageResponseSerializer serializer];
    [manager GET:URL_GET_AVATAR parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completion) {
            completion(responseObject, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(nil, error);
        }
    }];
}

- (void)downloadUserImageWithParameters:(NSDictionary *)parameters andImageKey:(NSString *)imageKey completion:(ModelRequestCompletion)completion {
    [self getUserEndPointWithParameters:parameters completion:^(id responseObject, NSError *error){
        if (!error) {
            NSDictionary *userDataDict = (NSDictionary *)[responseObject objectForKey:KEY_USER];
            NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_APPLICATION,(NSString *)[userDataDict objectForKey:imageKey]]];
            [[SDWebImageManager sharedManager] downloadImageWithURL:imageURL options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize){
            }completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL){
                if (!error) {
                    if (completion) {
                        completion(image, nil);
                    }
                }else {
                    if (completion) {
                        completion(nil, error);
                    }
                }
            }];
        }else {
            if (completion) {
                completion(nil, error);
            }
        }
    }];
}

- (void)downloadUserImageWithImageKey:(NSString *)imageKey andURLPathName:(NSString *)urlPathName completion:(ModelRequestCompletion)completion {
    NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_APPLICATION,urlPathName]];
    [[SDWebImageManager sharedManager] downloadImageWithURL:imageURL options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize){
    }completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL){
        if (!error) {
            if (completion) {
                completion(image, nil);
            }
        }else {
            if (completion) {
                completion(nil, error);
            }
        }
    }];
}

- (void)getFeelingDetailWithParameters:(NSDictionary *)parameters completion:(ModelRequestCompletion)completion {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = INTERNET_TIMEOUT;
    [manager GET:URL_GET_FEELING_DETAIL_ENDPOINT parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completion) {
            completion(responseObject, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(nil, error);
        }
    }];
    [manager.operationQueue setSuspended:YES];
}

- (void)getUserFriendWithParameters:(NSDictionary *)parameters completion:(ModelRequestCompletion)completion {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = INTERNET_TIMEOUT;
    [manager GET:URL_GET_FRIEND_ENDPOINT parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completion) {
            completion(responseObject, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(nil, error);
        }
    }];
    [manager.operationQueue setSuspended:YES];
}

- (void)getThumbnailWithParameters:(NSDictionary *)parameters completion:(ModelRequestCompletion)completion {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = INTERNET_TIMEOUT;
    manager.responseSerializer = [AFImageResponseSerializer serializer];
    [manager GET:URL_GET_FEELING_THUMBNAIL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completion) {
            completion(responseObject, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(nil, error);
        }
    }];
    [manager.operationQueue setSuspended:YES];
}

- (void)getSocialFriendWithParameters:(NSDictionary *)parameters completion:(ModelRequestCompletion)completion {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = INTERNET_TIMEOUT;
    [manager GET:URL_GET_CHECK_SOCIAL_FRIEND parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completion) {
            completion(responseObject, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(nil, error);
        }
    }];
    [manager.operationQueue setSuspended:YES];
}

#pragma mark - POST

- (void)postUserUpdateEndPointWithParameters:(NSDictionary *)parameters andURLAvatarTemp:(NSURL *)avatarTempFileURL andURLBimageTemp:(NSURL *)bimageTempFileURL completion:(ModelRequestOperationCompletion)completion {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = INTERNET_TIMEOUT;
    [manager POST:URL_POST_UPDATE_ENDPOINT parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (avatarTempFileURL != nil) {
            [formData appendPartWithFileURL:avatarTempFileURL name:KEY_AVATAR error:nil];
        }
        
        if (bimageTempFileURL != nil) {
            [formData appendPartWithFileURL:bimageTempFileURL name:KEY_IMAGE_COVER error:nil];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completion) {
            completion(responseObject, nil, operation);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(nil, error, operation);
        }
    }];
}

- (void)postUserUpdateEndPointWithParameters:(NSDictionary *)parameters completion:(ModelRequestCompletion)completion {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = INTERNET_TIMEOUT;
    [manager POST:URL_POST_UPDATE_ENDPOINT parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completion) {
            completion (responseObject, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion (nil, error);
        }
    }];
}

- (void)postFeelingHugEndPointWithParameters:(NSDictionary *)parameters completion:(ModelRequestCompletion)completion {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = INTERNET_TIMEOUT;
    [manager POST:URL_POST_FEELING_HUG_END_POINT parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completion) {
            completion (responseObject, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion (nil, error);
        }
    }];
}

- (void)postUpdateCheckinEndPointWithParameters:(NSDictionary *)parameters completion:(ModelRequestCompletion)completion {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = INTERNET_TIMEOUT;
    [manager POST:URL_POST_UPDATE_CHECKIN parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completion) {
            completion (responseObject, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion (nil, error);
        }
    }];
}

#pragma mark - DELETE

- (void)deleteAccountEndPointWithParameters:(NSDictionary *)parameters completion:(ModelRequestCompletion)completion {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = INTERNET_TIMEOUT;
    [manager DELETE:URL_DELETE_ACCOUNT_ENDPOINT parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completion) {
            completion (responseObject, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion (nil, error);
        }
    }];
}

- (void)deleteFeelingEndPointWithParameters:(NSDictionary *)parameters completion:(ModelRequestCompletion)completion {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = INTERNET_TIMEOUT;
    [manager DELETE:URL_DELETE_FEELING_ENDPOINT parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completion) {
            completion (responseObject, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion (nil, error);
        }
    }];
}

@end
