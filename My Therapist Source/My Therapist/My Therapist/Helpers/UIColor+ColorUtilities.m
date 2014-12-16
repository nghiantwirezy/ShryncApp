//
//  UIColor+ColorUtilities.m
//  My Therapist
//
//  Created by Josky on 11/5/14.
//  Copyright (c) 2014 ApplePieHealing. All rights reserved.
//

#import "UIColor+ColorUtilities.h"

@implementation UIColor (ColorUtilities)

#pragma mark - Colors

+ (UIColor *)color256WithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha{
    return [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:alpha];
}

// Feeling
+ (UIColor *)grayColor2{
    static UIColor *resultColor;
    static dispatch_once_t dispathOne;
    dispatch_once(&dispathOne, ^{
        resultColor = [self color256WithRed:186 green:186 blue:186 alpha:1];
    });
    return resultColor;
}

// CenterCircleImageView + ActivitySelectionViewController
+ (UIColor *)lightGrayColor3{
    static UIColor *resultColor;
    static dispatch_once_t dispathOne;
    dispatch_once(&dispathOne, ^{
        resultColor = [self color256WithRed:200 green:200 blue:200 alpha:1];
    });
    return resultColor;
}

// AudioPlayerViewController
+ (UIColor *)lightGrayColor2{
    static UIColor *resultColor;
    static dispatch_once_t dispathOne;
    dispatch_once(&dispathOne, ^{
        resultColor = [self color256WithRed:202 green:202 blue:202 alpha:1];
    });
    return resultColor;
}

// DetailCommentsViewController + PublicProfileViewController + SettingsViewController + AudioPlayerViewController + TextTherapiesViewController + HeaderView + MoreHugsUserViewController + MyFeelingsViewController + ContainedWebViewController + AttachmentFullscreenViewController + SignUpViewController + SignInViewController + FeelingCell + HowDoYouFeelViewController + ActivitySelectionViewController + AddCommentViewController + ProfileViewController
+ (UIColor *)veryLightGrayColor{
    static UIColor *resultColor;
    static dispatch_once_t dispathOne;
    dispatch_once(&dispathOne, ^{
        resultColor = [self color256WithRed:221 green:221 blue:221 alpha:1];
    });
    return resultColor;
}

// PublicProfileViewController + HeaderView + MyFeelingsViewController
+ (UIColor *)veryLightGrayColor2{
    static UIColor *resultColor;
    static dispatch_once_t dispathOne;
    dispatch_once(&dispathOne, ^{
        resultColor = [self color256WithRed:234 green:234 blue:234 alpha:1];
    });
    return resultColor;
}

// FeelingTextCell + AttachmentFullscreenViewController + AddCommentViewController
+ (UIColor *)veryLightGrayColor3{
    static UIColor *resultColor;
    static dispatch_once_t dispathOne;
    dispatch_once(&dispathOne, ^{
        resultColor = [self color256WithRed:222 green:222 blue:222 alpha:1];
    });
    return resultColor;
}

// HeaderView + HugCell + HugDetailViewCell + MyFeelingsViewController + SeparatorViewCell + UserInfoCell
+ (UIColor *)veryLightGrayColor4{
    static UIColor *resultColor;
    static dispatch_once_t dispathOne;
    dispatch_once(&dispathOne, ^{
        resultColor = [self color256WithRed:245 green:245 blue:245 alpha:1];
    });
    return resultColor;
}

// PublicFeelingsViewController
+ (UIColor *)veryLightGrayColor5{
    static UIColor *resultColor;
    static dispatch_once_t dispathOne;
    dispatch_once(&dispathOne, ^{
        resultColor = [self color256WithRed:235 green:235 blue:235 alpha:1];
    });
    return resultColor;
}

// UserInfoCell
+ (UIColor *)veryLightGrayColor6{
    static UIColor *resultColor;
    static dispatch_once_t dispathOne;
    dispatch_once(&dispathOne, ^{
        resultColor = [self color256WithRed:225 green:225 blue:225 alpha:1];
    });
    return resultColor;
}

// AudioPlayerViewController + FeelingSummaryCell + HugCell + LikeDetailViewCell + UserInfoCell + FeelingCell
+ (UIColor *)veryDarkGrayColor{
    static UIColor *resultColor;
    static dispatch_once_t dispathOne;
    dispatch_once(&dispathOne, ^{
        resultColor = [self color256WithRed:102 green:102 blue:102 alpha:1];
    });
    return resultColor;
}

// FeelingTextCell
+ (UIColor *)veryDarkGrayColor2{
    static UIColor *resultColor;
    static dispatch_once_t dispathOne;
    dispatch_once(&dispathOne, ^{
        resultColor = [self color256WithRed:83 green:83 blue:83 alpha:1];
    });
    return resultColor;
}

// UserInfoCell
+ (UIColor *)veryDarkGrayColor3{
    static UIColor *resultColor;
    static dispatch_once_t dispathOne;
    dispatch_once(&dispathOne, ^{
        resultColor = [self color256WithRed:62 green:62 blue:62 alpha:1];
    });
    return resultColor;
}

// FeelingCell
+ (UIColor *)veryDarkGrayColor4{
    static UIColor *resultColor;
    static dispatch_once_t dispathOne;
    dispatch_once(&dispathOne, ^{
        resultColor = [self color256WithRed:1 green:1 blue:1 alpha:1];
    });
    return resultColor;
}

+ (UIColor *)veryDarkGrayColor4WithAlpha:(CGFloat)alpha{
    static UIColor *resultColor;
    static dispatch_once_t dispathOne;
    dispatch_once(&dispathOne, ^{
        resultColor = [self color256WithRed:1 green:1 blue:1 alpha:alpha];
    });
    return resultColor;
}

// ProfileViewController
+ (UIColor *)veryDarkGrayColor5{
    static UIColor *resultColor;
    static dispatch_once_t dispathOne;
    dispatch_once(&dispathOne, ^{
        resultColor = [self color256WithRed:112 green:112 blue:112 alpha:1];
    });
    return resultColor;
}

// FollowerTableViewController + MoreHugsUserViewController
+ (UIColor *)pureCyanColor{
    static UIColor *resultColor;
    static dispatch_once_t dispathOne;
    dispatch_once(&dispathOne, ^{
        resultColor = [self color256WithRed:0 green:176 blue:225 alpha:1];
    });
    return resultColor;
}

// SubFeelingButton
+ (UIColor *)darkCyanColor{
    static UIColor *resultColor;
    static dispatch_once_t dispathOne;
    dispatch_once(&dispathOne, ^{
        resultColor = [self color256WithRed:0 green:128 blue:142 alpha:1];
    });
    return resultColor;
}

// AppDelegate
+ (UIColor *)mostlyDesaturatedDarkCyanColor{
    static UIColor *resultColor;
    static dispatch_once_t dispathOne;
    dispatch_once(&dispathOne, ^{
        resultColor = [self color256WithRed:109 green:162 blue:171 alpha:1];
    });
    return resultColor;
}

// DetailCommentsViewController + InviteFriendsViewController + PublicProfileViewController + HeaderView + HugCell + MyFeelingsViewController + PublicFeelingsViewController
+ (UIColor *)darkModerateCyanColor{
    static UIColor *resultColor;
    static dispatch_once_t dispathOne;
    dispatch_once(&dispathOne, ^{
        resultColor = [self color256WithRed:91 green:163 blue:174 alpha:1];
    });
    return resultColor;
}

// FeelingSummaryCell + HugDetailViewCell + AttachmentFullscreenViewController + AddCommentViewController
+ (UIColor *)darkModerateCyanColor2{
    static UIColor *resultColor;
    static dispatch_once_t dispathOne;
    dispatch_once(&dispathOne, ^{
        resultColor = [self color256WithRed:80 green:144 blue:155 alpha:1];
    });
    return resultColor;
}

+ (UIColor *)darkModerateCyanColor3{
    static UIColor *resultColor;
    static dispatch_once_t dispathOne;
    dispatch_once(&dispathOne, ^{
        resultColor = [self color256WithRed:64 green:126 blue:137 alpha:1];
    });
    return resultColor;
}

// UserInfoCell
+ (UIColor *)strongRedColor{
    static UIColor *resultColor;
    static dispatch_once_t dispathOne;
    dispatch_once(&dispathOne, ^{
        resultColor = [self color256WithRed:186 green:27 blue:21 alpha:1];
    });
    return resultColor;
}

// RevealMenuViewController
+ (UIColor *)veryDarkBlueColor{
    static UIColor *resultColor;
    static dispatch_once_t dispathOne;
    dispatch_once(&dispathOne, ^{
        resultColor = [self color256WithRed:42 green:45 blue:50 alpha:1];
    });
    return resultColor;
}

// RevealMenuViewController
+ (UIColor *)veryDarkGrayishBlueColor{
    static UIColor *resultColor;
    static dispatch_once_t dispathOne;
    dispatch_once(&dispathOne, ^{
        resultColor = [self color256WithRed:59 green:61 blue:66 alpha:1];
    });
    return resultColor;
}

@end
