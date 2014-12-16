//
//  Constants.h
//  My Therapist
//

#ifndef My_Therapist_Constants_h
#define My_Therapist_Constants_h

#pragma mark - All Constants define here
//  Application
#define myAppDelegate ((AppDelegate*)[[UIApplication sharedApplication] delegate])
#define TITLE_APPLICATION @"SHRYNC"
#define INDEX_START_BY_1(x) (x + 1)
#define MAX_NUMBER_BADGE 99
#define FACEBOOK_PERMISSIONS @[@"public_profile, user_friends"]
#define TWITTER_CONSUMER_KEY @"NdMa1BJu5ZTgn2hCmkFj62o8Y"
#define TWITTER_CONSUMER_SECRET @"0rcwprtkRKFQkQ43shEjMwYcFlGfCapEvmbJQyDJJMnXAdMBk9"

#define FACEBOOK_TYPE @"1"
#define TWITTER_TYPE @"2"

// FONT & SIZE
#define SIZE_FONT_VERY_BIG 30
#define SIZE_FONT_BIG 18
#define SIZE_FONT_MEDIUM 16
#define SIZE_FONT_SMALL 13
#define SIZE_BATCH 10
#define SIZE_TITLE_DEFAULT 21

#define COMMON_BEBAS_FONT(fontSize) [UIFont fontWithName : @"BebasNeue" size : fontSize]
#define COMMON_LEAGUE_GOTHIC_FONT(fontSize) [UIFont fontWithName : @"LeagueGothic-Regular" size : fontSize]
#define END_TIME 32503680000
#define INTERNET_TIMEOUT 10800
#define NUMBER_MAX_DATA_DOWNLOAD 100

// Image Name
#define DEFAULT_USER_IMAGE_NAME @"signup default user image"
#define IMAGE_NAME_FOLLOW @"follow"
#define IMAGE_NAME_BACK_BUTTON @"back button"
#define IMAGE_NAME_UNFOLLOW @"unfollow"
#define IMAGE_NAME_HEART_64 @"heart-64"
#define IMAGE_NAME_HEART_64_SELECTED @"heart-64 selected"
#define IMAGE_NAME_THUMB_UP @"thumb up"
#define IMAGE_NAME_THUMB_UP_SELECTED @"thumb up selected"
#define IMAGE_NAME_COMMENT_32 @"comment32"
#define IMAGE_NAME_COMMENT_32_NORMAL @"comment32 normal"
#define IMAGE_NAME_AUTUMN_COLOR @"default_background_image"
#define IMAGE_NAME_YES @"yes"
#define IMAGE_NAME_NO @"no"
#define IMAGE_NAME_REVEAL_SETTING_ICON @"reveal setting icon"
#define IMAGE_NAME_FEELING_TOP_CONTAINER_BACKGROUND @"feeling top container background"
#define IMAGE_NAME_FACEBOOK_24 @"facebook-24"
#define IMAGE_NAME_FACEBOOK_48 @"facebook-48"
#define IMAGE_NAME_TWITTER_24 @"twitter-24"
#define IMAGE_NAME_TWITTER_48 @"twitter-48"
#define IMAGE_NAME_SEARCH_24 @"search-24"
#define IMAGE_NAME_SEARCH_48 @"search-48"
#define IMAGE_NAME_PLUS_ICON @"plusIconRed"
#define IMAGE_NAME_REVEAL_MENU_BUTTON @"reveal menu button"

// Cell identifier
#define IDENTIFIER_USER_INFO_CELL @"identifierUserInfoCell"
#define IDENTIFIER_FEELING_CELL @"identifierFeelingCell"
#define IDENTIFIER_COMMENT_CELL @"identifierCommentCell"
#define IDENTIFIER_ATTACHMENT_CELL @"identifierAttachmentCell"
#define IDENTIFIER_HUG_CELL @"identifierHugCell"
#define IDENTIFIER_FEELING_SUMMARY_FIRST_ROW_CELL @"identifierFeelingSummaryFirstRowCell"
#define IDENTIFIER_FEELING_SUMMARY_CELL @"identifierFeelingSummaryCell"
#define IDENTIFIER_HUG_DETAIL_CELL @"identifierHugDetailCell"
#define IDENTIFIER_LIKE_DETAIL_CELL @"identifierLikeDetailCell"
#define IDENTIFIER_FEELING_TEXT_CELL @"identifierFeelingTextCell"
#define IDENTIFIER_MESSAGE_CELL @"identifierMessageCell"
#define IDENTIFIER_IMAGE_ATTACHMENT_CELL @"identifierImageAttachmentCell"
#define IDENTIFIER_SEPARATOR_CELL @"identifierSeparatorCell"
#define IDENTIFIER_LIST_FRIENDS_TABLE_VIEW_CELL @"identifierListFriendsTableViewCell"
#define IDENTIFIER_MORE_HUGS_USER_VIEW_CELL @"identifierMoreHugsUserViewCell"
#define IDENTIFIER_MORE_LINK_CELL @"identifierMoreLinkCell"

#pragma mark - TEXT
// TEXT
#define TEXT_SENDING @"Sending..."
#define TEXT_CONNECT_TO_FACEBOOK @"Connect to Facebook"
#define TEXT_DISCONNECT_TO_FACEBOOK @"Disconnect from Facebook"
#define TEXT_CONNECT_TO_TWITTER @"Connect to Twitter "
#define TEXT_DISCONNECT_TO_TWITTER @"Disconnect from Twitter"

#pragma mark - URL
// Services URL
#define URL_APPLICATION @"https://secure.shrync.com"
#define URL_GET_USER_ENDPOINT @"https://secure.shrync.com/api/user/get"
#define URL_GET_FOLLOW_ENDPOINT @"https://secure.shrync.com/api/user/follow"
#define URL_GET_FOLLOWER_ENDPOINT @"https://secure.shrync.com/api/user/getfollowers"
#define URL_GET_FOLLOWING_ENDPOINT @"https://secure.shrync.com/api/user/getfollowing"
#define URL_GET_AVATAR @"https://secure.shrync.com/api/user/getavatar"
#define URL_GET_FEELING_DETAIL_ENDPOINT @"https://secure.shrync.com/api/feelings/detail"
#define URL_GET_FRIEND_ENDPOINT @"https://secure.shrync.com/api/user/getfriend"
#define URL_GET_SEARCH_FRIEND_ENDPOINT @"https://secure.shrync.com/api/user/searchfriend"
#define URL_GET_FEELING_THUMBNAIL @"https://secure.shrync.com/api/feelings/thumb"
#define URL_GET_CHECK_SOCIAL_FRIEND @"http://secure.shrync.com/api/user/checkSocialfriend"

#define URL_POST_CHECK_FACEBOOK_FRIEND @"http://secure.shrync.com/api/user/checkFBfriend"
#define URL_POST_UPDATE_ENDPOINT @"https://secure.shrync.com/api/user/update"
#define URL_POST_FEELING_HUG_END_POINT @"https://secure.shrync.com/api/feelings/hug"
#define URL_POST_UPDATE_CHECKIN @"https://secure.shrync.com/api/feelings/updatecheckin/"

#define URL_DELETE_ACCOUNT_ENDPOINT @"https://secure.shrync.com/api/user/delete"
#define URL_DELETE_FEELING_ENDPOINT @"https://secure.shrync.com/api/feelings/delete/"

// Custom URL
#define URL_EMOTIONS_IMAGE_PLIST @"EmotionsIconList"
#define URL_EMOTIONS_DEFAULT_PLIST @"EmotionsDefaultList"
#define URL_THERAPIST_SITE @"http://m.therapists.psychologytoday.com/rms/prof_results.php?zipdist=5&zipcode="
#define URL_FACEBOOK_GRAPH_FRIENDS_INSTALLED @"me/friends?fields=installed"

#pragma mark - KEY
// Services KEY
#define KEY_TOKEN_PARAM @"token"
#define KEY_SUCESS @"success"
#define KEY_USER @"user"
#define KEY_USER_ID @"userid"
#define KEY_USER_NAME @"username"
#define KEY_ID @"id"
#define KEY_TOU_ID @"touid"
#define KEY_BIOGRAPHY @"bio"
#define KEY_NICK_NAME @"nickname"
#define KEY_FEELING @"feeling"
#define KEY_FEELINGS @"feelings"
#define KEY_COMMENTS @"comments"
#define KEY_COMMENT @"comment"
#define KEY_STATUS @"status"
#define KEY_END_PARAM @"end"
#define KEY_COUNT @"count"
#define KEY_IMAGE_COVER @"image_cover"
#define KEY_AVATAR @"avatar"
#define KEY_PROFILE_PUBLIC @"profile_public"
#define KEY_CHECKIN_PUBLIC @"checkin_public"
#define KEY_APPTENTIVE @"755ffd82a9d2102d601fe3fde7902ded3e7f078d6bae48e391206372ebc94268"
#define KEY_MASSAGE @"massage"
#define KEY_FEELING_ID @"feelingid"
#define KEY_TYPE @"type"
#define KEY_DATA @"data"
#define KEY_TIME @"time"
#define KEY_ACTIVITY_INDEX @"activityIndex"
#define KEY_LATITUDE @"latitude"
#define KEY_LONGITUDE @"longitude"
#define KEY_THUMBNAIL @"thumb"
#define KEY_CODE @"code"
#define KEY_IS_PUBLIC @"is_public"
#define KEY_HUGGERS @"huggers"
#define KEY_LIKERS @"likers"
#define KEY_CITY @"city"
#define KEY_STATE @"state"
#define KEY_DEVICE_TOKEN @"device_token"
#define KEY_FACEBOOK_ID @"facebok_id"
#define KEY_FACEBOOK_TOKEN @"facebook_token"
#define KEY_TWITTER_ID @"twitter_id"
#define KEY_TWITTER_TOKEN @"twitter_token"
#define KEY_GOOGLE_ID @"google_id"
#define KEY_GOOGLE_TOKEN @"googleplus_token"
#define KEY_INSTALLED @"installed"
#define KEY_ID_SOCIAL @"id_social"
#define KEY_IDS @"ids"
// Custom KEY
#define KEY_ID_UPPERCASE @"ID"
#define KEY_SHOW @"Show"
#define KEY_URL @"URL"
#define KEY_GROUP @"Group"
#define KEY_CUSTOM_ICON @"Custom Icon"
#define KEY_MAIN_FEELING_INDEX @"mainFeelingIndex"
#define KEY_FEELING_STRENGTH @"feelingStrength"
#define KEY_SUB_FEELING_INDEXES @"subFeelingIndexes"
#define KEY_ICON_ID_UPPERCASE @"iconId"
#define KEY_MAIN_FEELING_STRING @"mainFeelingString"
#define KEY_SUB_FEELING_STRINGS @"subFeelingString"
//Emotion Key
#define KEY_EMOTION_ICON_GROUP @"Group"
#define KEY_EMOTION_ICON_ID @"ID"
#define KEY_EMOTION_ICON_URL @"URL"
#define KEY_EMOTION_ICON_SHOW @"Show"
#define KEY_EMOTION_ICON_COLOR @"Color"
#define KEY_EMOTION_ICON_COLOR_RED @"Red"
#define KEY_EMOTION_ICON_COLOR_GREEN @"Green"
#define KEY_EMOTION_ICON_COLOR_BLUE @"Blue"
#define KEY_EMOTION_ICON_COLOR_ALPHA @"Alpha"

//Feelings Default Key
#define KEY_FEELING_INDEX_DEFAULT @"FeelingIndex"
#define KEY_FEELING_NAME_DEFAULT @"FeelingName"
#define KEY_FEELING_SUBTITLE_DEFAULT @"FeelingSubTitle"
#define KEY_FEELING_SUBFEELINGS_DEFAULT @"FeelingSubFeelings"
#define KEY_FEELING_ACTIVE_ICON_ID_DEFAULT @"FeelingActiveIconID"
#define KEY_FEELING_INACTIVE_ICON_ID_DEFAULT @"FeelingInactiveIconID"

#pragma mark - HowDoYouFeelTouchView

#define HEIGHT_PLUS_BUTTON 40
#define WIGHT_PLUS_BUTTON 40
#define HALF_OF(x) x/2
#define MARGIN_EDGE 5
#define PLUS_BUTTON_SCALE_RATIO(x) x*1.5
#define TIME_MOVE_PLUS_BUTTON_TO_EDGE 0.5

#pragma mark - UserProfileView
#define USER_PROFILE_HEADER_DEFAULT_HEIGHT 128
#define USER_PROFILE_HEADER_DEFAULT_HEIGHT_WITHOUT_BOTTOM_VIEW 95
#define HEIGHT_MAX_BIOGRAPHY_TEXT_VIEW 51
#define TIME_TO_EXPAND_PROFILE_VIEW 0.5

#pragma mark - PublicProfileView
// Text
#define TITLE_PUBLIC_PROFILE_VIEW @"PUBLIC PROFILE"
#define TEXT_LOADING_PUBLIC_PROFILE_VIEW @"Loading..."
#define TEXT_LOAD_FAILED_PUBLIC_PROFILE_VIEW @"Loading failed!"
#define TEXT_I_WAS_PUBLIC_PROFILE_VIEW @"I Was "
#define TEXT_FOLLOWED_PUBLIC_PROFILE_VIEW @"followed"
#define TEXT_FRIEND_PUBLIC_PROFILE_VIEW @"friend"
#define TEXT_UNFOLLOWED_PUBLIC_PROFILE_VIEW @"Unfollowed"
#define TEXT_FOLLOW_PUBLIC_PROFILE_VIEW @"Follow"

// Frame & Font Size
#define FRAME_BACK_BUTTON_PUBLIC_PROFILE_VIEW CGRectMake(0, 0, 28, 28)
#define FRAME_TITLE_LABEL_PUBLIC_PROFILE_VIEW CGRectMake(0, 0, 100, 35)
#define FRAME_FOLLOWS_BUTTON_PUBLIC_PROFILE_VIEW CGRectMake(0, 0, 28, 28)
#define FONT_SIZE_TITLE_PUBLIC_PROFILE_VIEW 21.0
#define FONT_SIZE_LOADING_TEXT_LABEL_PUBLIC_PROFILE_VIEW 11.0
#define FONT_SIZE_USER_INFO_CELL_PUBLIC_PROFILE_VIEW 17.0

#pragma mark - SettingViewController
// SettingViewController
#define TITLE_SETTINGS @"SETTINGS"
#define TITLE_PROFILE_SETTINGS @"Profile"
#define TITLE_FRIENDS_SETTINGS @"Friends"
#define TITLE_SHARE_SETTINGS @"Share"
#define TITLE_SUPPORT_AND_FEEDBACK_SETTINGS @"Support and Feedback"
#define TITLE_RATE_SETTINGS @"Rate"
#define TITLE_APP_INFORMATION_SETTINGS @"App Information"
#define DEFAULT_CHECKS_IN @"DEFAULT_CHECKINS_PUBLIC_PRIVATE"
#define DEFAULT_PROFILE @"DEFAULT_PROFILE_PUBLIC_PRIVATE"

#define SIZE_FONT_TITLE_SETTINGS 21
#define SIZE_FONT_LABEL_SMALL 11
#define FRAME_TITLE_SETTINGS CGRectMake(0, 0, 100, 35)

#define TAG_ALERT_DELETE_ACCOUNT_SETTNGS 20
#define TAG_ALERT_SIGN_OUT_SETTNGS 21
#define TAG_ALERT_SIGN_OUT_FACEBOOK_SETTNGS 22
#define TAG_ALERT_SIGN_OUT_TWITTER_SETTNGS 23

#define TEXT_DELETING_SETTINGS @"Deleting..."
#define TEXT_LINK_CONNECT_SETTINGS @"Link"
#define TEXT_UNLINK_CONNECT_SETTINGS @"Unlink"
#define TEXT_CONNECTED_SETTINGS @"Connected"
#define TEXT_NOT_CONNECTED_SETTINGS @"Not Connected"

#pragma mark - UserSession
// User Session

#define IS_GUEST_MODE_KEY @"IsGuestMode"

#define JSON_SESSION_KEY @"token"
#define JSON_USER_DICT_KEY @"user"
#define JSON_USER_ID_KEY @"id"
#define JSON_NICKNAME_KEY @"nickname"
#define JSON_EMAIL_KEY @"email"
#define JSON_CREATED_DATE_KEY @"created_date"
#define JSON_DEVICE_TOKEN @"device_token"
#define JSON_BIOGRAPHY_KEY @"bio"
#define JSON_CHECKIN_PUBLIC_KEY @"checkin_public"
#define JSON_PROFILE_PUBLIC_KEY @"profile_public"
#define JSON_IMAGE_COVER @"image_cover"

#define USER_AVATAR_FILE_NAME @"/user.png"
#define BACKGROUND_IMAGE_FILE_NAME @"/backgroundimage.png"
#define DEFAULT_BACKGROUND_IMAGE_NAME @"autumnColor.png"
#define DEFAULT_CHECKS_IN @"DEFAULT_CHECKINS_PUBLIC_PRIVATE"
#define DEFAULT_PROFILE @"DEFAULT_PROFILE_PUBLIC_PRIVATE"

#define SESSION_STORAGE_KEY @"UserSession"
#define GUEST_EMAIL @"-"
#define GUEST_SESSION_TOKEN @"GuestSession"
#define GUEST_ID @"GuestId"
#define GUEST_NICKNAME @"Guest"
#define GUEST_TOKEN @"GuestToken"
#define GUEST_BIOGRAPHY @""
#define GUEST_PUBLIC_PROFILE @"YES"
#define GUEST_PUBLIC_CHECKIN @""

#define SIGNOUT_ENDPOINT @"https://secure.shrync.com/api/user/logout"
#define SIGNOUT_TOKEN_PARAM @"token"

#define FEELING_CACHE_KEY @"CachedFeelings"
#define MAX_CACHE_FEELINGS_COUNT 10

#pragma mark - ProfileViewController

// ProfileViewController
#define PHOTO_SOURCE_PICKER_TITLE @"Attach a Picture"
#define PHOTO_SOURCE_CAMERA @"From Camera"
#define PHOTO_SOURCE_ALBUM @"From Photo Album"
#define PHOTO_SOURCE_PICKER_CANCEL @"Cancel"

#define TITLE_MYPROFILE @"MY PROFILE"
#define MEMBER_SINCE_LABEL @"Member since: "
#define PASSWORD_MASK @"●●●●●●●●●●"
#define USER_BIOGRAPHY_MASK @"UPDATE USER BIOGRAPHY"
#define USER_AVATAR_FILE_NAME @"/user.png"
#define BACKGROUND_IMAGE_FILE_NAME @"/backgroundimage.png"

#define TOKEN_REQUEST_KEY @"token"
#define PASSWORD_REQUEST_KEY @"password"
#define EMAIL_REQUEST_KEY @"email"
#define USER_PHOTO_REQUEST_KEY @"avatar"
#define USER_BIOGRAPHY_REQUEST_KEY @"bio"
#define PUBLIC_CHECKIN_REQUEST_KEY @"checkin_public"
#define PUBLIC_PROFILE_REQUEST_KEY @"profile_public"
#define BACKGROUND_IMAGE_REQUEST_KEY @"image_cover"
#define USER_REQUEST_KEY @"user"

#define WRONG_TOKEN_CODE 501
#define LONGEST_EDGE 960

#define UPDATE_IN_PROGRESS @"Updating..."
#define UPDATE_SUCCEEDED @"Updated!"
#define ERROR_WRONG_TOKEN @"Session expired! Please login again."
#define ERROR_GENERAL @"Unable to contact server!"

#define UPDATE_ENDPOINT @"https://secure.shrync.com/api/user/update"

#define DEFAULT_VISIBILITY_KEY @"DEFAULT_VISIBILITY_KEY"
#define DEFAULT_CHECKS_IN @"DEFAULT_CHECKINS_PUBLIC_PRIVATE"
#define DEFAULT_PROFILE @"DEFAULT_PROFILE_PUBLIC_PRIVATE"

#define AlertAvatar 222
#define AlertBackgroundImage 223
#define AlertImagepickerAvatar 224
#define AlertImagepickerBackgroundImage 225

#pragma mark - AddCommentViewController
// AddCommentViewController

#define FEELING_SUMMARY_FIRST_ROW_CELL_REUSE_ID @"FEELING_SUMMARY_FIRST_ROW_CELL_REUSE_ID"
#define FEELING_SUMMARY_CELL_REUSE_ID @"FEELING_SUMMARY_CELL_REUSE_ID"

#define ATTACHED_IMAGE_NAME @"/attachment.jpg"

#define TITLE_ADD_COMMENT @"SHRYNC"
#define HEADER_TITLE @"HOW DO YOU FEEL?"
#define ACTIVITY_DEFAULT_LABEL @"CHOOSE SELECTION"
#define COMMENT_PLACE_HOLDER @"ADD COMMENT"

#define PHOTO_SOURCE_PICKER_TITLE @"Attach a Picture"
#define PHOTO_SOURCE_CAMERA @"From Camera"
#define PHOTO_SOURCE_ALBUM @"From Photo Album"
#define PHOTO_SOURCE_PICKER_CANCEL @"Cancel"

#define LONGEST_EDGE 960

#define DEFAULT_ROW_COUNT 2
#define COMMENT_CHARACTER_LIMIT 115

#define LOCATION_THRESHOLD 100
#define TIME_OUT 10

#define TOKEN_NOT_FOUND_CODE 501

#define CHECKIN_IN_PROGRESS @"Checking in..."
#define ERROR_WRONG_TOKEN @"Session expired! Please login again."
#define ERROR_GENERAL @"Unable to contact server!"

#define TOKEN_REQUEST_KEY @"token"
#define IMAGE_REQUEST_KEY @"image"
#define FEELING_REQUEST_KEY @"feeling"

#define FEELING_CODE_KEY @"code"
#define CHECKIN_ENDPOINT @"https://secure.shrync.com/api/feelings/checkin/"

#define DEFAULT_VISIBILITY_KEY @"DEFAULT_VISIBILITY_KEY"
#define DEFAULT_SHARE_FEELING @"DEFAULT_SHARE_FEELING"

#define DEFAULT_PROFILE @"DEFAULT_PROFILE_PUBLIC_PRIVATE"
#define DEFAULT_CHECKS_IN @"DEFAULT_CHECKINS_PUBLIC_PRIVATE"

#pragma mark - MyFeelingsViewController
// MyFeelingsViewController

#define TITLE_HEADER_MY_FEELINGS @"My Feelings"
#define TEXT_LOADING_MY_FEELINGS @"Loading..."
#define TEXT_LOAD_FAILED_MY_FEELINGS @"Loading failed!"
#define TEXT_I_WAS_MY_FEELINGS @"I Was "
#define SIZE_FONT_LABEL_TITLE_MY_FEELINGS 21
#define SIZE_FONT_LABEL_LOADING_TEXT_MY_FEELINGS 11
#define SIZE_FONT_LABEL_COMMENT_MY_FEELINGS 17
#define HEIGHT_TABLE_ROW_MY_FEELINGS 42
#define WIDTH_LABEL_COMMENT_MY_FEELINGS 280
#define FRAME_TITLE_LABEL_MY_FEELINGS CGRectMake(0, 0, 100, 35)
#define MAX_RECORD_TO_LOAD_MY_FEELINGS 30
#define TIME_DELAY_HIDE_HUD 2.0

#pragma mark - ProfileViewController
// ProfileViewController
#define FRAME_LABEL_TITLE_PROFILE_VIEW CGRectMake(0, 0, 100, 35)
#define FRAME_BUTTON_ADD_MESSAGE_PROFILE_VIEW CGRectMake(0, 0, 28, 28)
#define SIZE_FONT_LABEL_TITLE_PROFILE_VIEW 21
#define SIZE_FONT_LABEL_USER_NAME_PROFILE_VIEW 17
#define SIZE_FONT_LABEL_COMMON_PROFILE_VIEW 17
#define SIZE_FONT_LABEL_BUTTON_COMMON_PROFILE_VIEW 15

#pragma mark - HowDoYouFeelViewController
// HowDoYouFeelViewController
#define TITLE_HEADER_HOW_DO_YOU_FEEL @"HOW DO YOU FEEL?"
#define FEELING_STRENGTH_DEFAULT 3
#define FEELING_STRENGTH_MIN 0
#define FEELING_STRENGTH_MAX 5
#define NUMBER_ICON_IN_ROW_EMOTION_HOW_DO_YOU_FEEL 5
#define TIME_SHOW_HIDE_EMOTION_HOW_DO_YOU_FEEL 0.3
#define INDEX_FEELING_FROM_TEXT 10
#define ALPHA_LABEL_CHECKIN_COVERING_VIEW_HOW_DO_YOU_FEEL 0.7
#define ALPHA_EMOTION_BACKGROUND_HOW_DO_YOU_FEEL 0.7

#define FRAME_LABEL_TITLE_HOW_DO_YOU_FEEL CGRectMake(0, 0, 100, 35)
#define HEIGHT_INPUT_FEELING_HOW_DO_YOU_FEEL 42

#define WIDTH_EMOTION_SCROLL_VIEW_HOW_DO_YOU_FEEL 296
#define HEIGHT_EMOTION_SCROLL_VIEW_HOW_DO_YOU_FEEL 184
#define WIDTH_EMOTION_BUTTON_HOW_DO_YOU_FEEL 40
#define HEIGHT_EMOTION_BUTTON_HOW_DO_YOU_FEEL 40
#define MARGIN_EMOTION_BUTTON_HOW_DO_YOU_FEEL 16
#define SIZE_FONT_LABEL_CHECKIN_HOW_DO_YOU_FEEL 17
#define HEIGHT_FEELING_CELL_EXPAND_HOW_DO_YOU_FEEL 92
#define HEIGHT_FEELING_CELL_COLLAPSE_HOW_DO_YOU_FEEL 51

#pragma mark - FeelingCell
// FeelingCell
#define FRAME_UPPER_CONTAINER_VIEW_FEELING_CELL CGRectMake(0, 0, 320, 50)
#define FRAME_LOWER_CONTAINER_VIEW_FEELING_CELL CGRectMake(0, 51, 320, 40)
#define FRAME_MIDDLE_SEPARATOR_VIEW_FEELING_CELL CGRectMake(0, 50, 320, 1)
#define FRAME_BOTTOM_SEPARATOR_VIEW_FEELING_CELL CGRectMake(0, 91, 320, 1)
#define FRAME_CONTENT_CONTAINER_VIEW_FEELING_CELL CGRectMake(0, 0, 320, 51)
#define FRAME_FEELING_STRENGTH_CONTAINER_VIEW_FEELING_CELL CGRectMake(490, 13, 135, 24)
#define FRAME_FEELING_STRENGTH_SLIDER_BACKGROUND_IMAGE_VIEW_FEELING_CELL CGRectMake(0, 2, 135, 20)
#define FRAME_FEELING_STRENGTH_SLIDER_FEELING_CELL CGRectMake(0, 2, 135, 20)
#define FRAME_FEELING_ICON_STATIC_IMAGE_VIEW_FEELING_CELL CGRectMake(14, 9, 32, 32)
#define FRAME_FEELING_NAME_STATIC_LABEL_FEELING_CELL CGRectMake(52, 12, 100, 12)
#define FRAME_FEELING_SUBTITLE_LABEL_FEELING_CELL CGRectMake(52, 27, 100, 9)
#define FRAME_SUB_FEELING_SCROLL_VIEW_FEELING_CELL CGRectMake(0, 0, 320, 40)
#define FRAME_SUB_FEELING_COVERING_VIEW_FEELING_CELL CGRectMake(0, 0, 320, 40)

#define OFFSET_X_CELL_EXPANDED_FEELING_CELL -320
#define SIZE_FONT_FEELING_SUBTITLE_LABEL_FEELING_CELL 11.0
#define SIZE_FONT_FEELING_NAME_STATIC_LABEL_FEELING_CELL 15.0
#define HEIGHT_SUB_FEELING_CONTAINER_VIEW 40
#define HEIGHT_CELL_EXPAND_FEELING_CELL 92
#define HEIGHT_CELL_COLLAPSE_FEELING_CELL 51
#define WIDTH_SUB_FEELING_BUTTON_FEELING_CELL 101
#define TIME_EXPAND_CELL_FEELING_CELL 0.25
#define TIME_DELAY_SCOLL_CELL_FEELING_CELL 0.1
#define VALUE_FLOORF_SLIDER_FEELING_CELL 0.2
#define VALUE_ROUNDED_FEELING_CELL -1
#define ALPHA_SUBFEELING_COVERING_FEELING_CELL 0.4

#define SIZE_SLIDER_THUMB_IMAGE_FEELING_CELL CGSizeMake(20, 20)
#define ALPHA_SLIDER_THUMB_IMAGE_FEELING_CELL 1/255

#pragma mark - DetailCommentsViewController
// DetailCommentsViewController
#define TITLE_DETAIL_COMMENTS @"Hugs Likes & Comments"
#define TITLE_PLACE_HOLDER_DETAIL_COMMENTS @"Write a comment"

#define TEXT_HUG_DETAIL_COMMENTS @"Hug"
#define TEXT_HUGS_DETAIL_COMMENTS @"Hugs"
#define TEXT_LIKE_DETAIL_COMMENTS @"Like"
#define TEXT_LIKES_DETAIL_COMMENTS @"Likes"
#define TEXT_COMMENT_DETAIL_COMMENTS @"Comment"
#define TEXT_COMMENTS_DETAIL_COMMENTS @"Comments"
#define TEXT_HEADER_TITLE_DETAIL_COMMENT @"How Do You Feel"
#define HEIGHT_FEELING_SUMARY_SECTION_HEADER_VIEW 44
#define SHIFT_HEIGHT_BY_KEYBOARD_DETAIL_COMMENTS 215
#define HEIGHT_CELL_INFO_DETAIL_COMMENTS 48
#define HEIGHT_CELL_HUG_DETAIL_COMMENTS 25
#define HEIGHT_CELL_LIKE_DETAIL_COMMENTS 30
#define HEIGHT_CELL_MESSAGE_DETAIL_COMMENTS 20
#define WIDTH_FEELING_TEXT_CELL_DETAIL_COMMENTS 280
#define HEIGHT_TEXTFEILD_CONTAINER_DETAIL_COMMENTS 215
#define WIDTH_PLACE_HOLDER_DETAIL_COMMENTS 110
#define HIGHT_PLACE_HOLDER_DETAIL_COMMENTS 13
#define HEIGHT_CELL_DETAIL_COMMENTS 32.0

#define FRAME_BACK_BUTTON_DETAIL_COMMENTS CGRectMake(0, 0, 28, 28)
#define FRAME_TITLE_LABEL_DETAIL_COMMENTS CGRectMake(0, 0, 100, 35)
#define FRAME_PLACE_HOLDER_DETAIL_COMMENTS CGRectMake(5,10, WIDTH_PLACE_HOLDER_DETAIL_COMMENTS, HIGHT_PLACE_HOLDER_DETAIL_COMMENTS)
#define CORNER_RADIUS_SEND_MESSAGE_BUTTON 10
#define TIME_SHOW_KEYBOARD_DETAIL_COMMENT 0.25
#define SIZE_FONT_FEELING_CELL_DETAIL_COMMENT 17
#define WIDTH_FEELING_CELL_CONTENT_DETAIL_COMMENT 280
#define SPACE_FEELING_CELL_CONTENT_DETAIL_COMMENT 5

#pragma mark - ListFriendsTableViewCell
//ListFriendsTableViewCell
#define RADIUS_CORNER_IMAGE_USER_FRIENDS_LIST_FRIENDS_TABLE_VIEW_CELL 12.5
#define RADIUS_CORNER_BUTTON_FOLLOW_LIST_FRIENDS_TABLE_VIEW_CELL 10

#pragma mark - SearchUsersFriendsViewController
// SearchUsersFriendsViewController
#define TITLE_SEARCH_USERS_FRIENDS @"FIND FRIENDS"
#define HEIGHT_CELL_TABLE_VIEW_SEARCH_USERS_FRIENDS 35
#define FRAME_TITLE_LABEL_SEARCH_USERS_FRIENDS CGRectMake(0, 0, 100, 35)
#define FRAME_BACK_BUTTON_SEARCH_USERS_FRIENDS CGRectMake(0, 0, 28, 28)

#pragma mark - FeelingRecord
#define NAMES_ACTIVITY_FEELING_RECORD @"Cooking,Driving,Eating,In Traffic,Listening to Music,Lying Down,Nothing,On Vacation,Partying,Playing,Reading,Relaxing,Running,Shopping,Sitting,Travelling,Walking,Watching a Movie,Watching TV,With Friends,Working"

#pragma mark - InviteFriendsViewController 
// InviteFriendsViewController
#define TITLE_INVITE_FRIENDS @"FIND FRIENDS"
#define FRAME_TITLE_LABEL_INVITE_FRIENDS CGRectMake(0, 0, 100, 35)
#define FRAME_BACK_BUTTON_INVITE_FRIENDS CGRectMake(0, 0, 28, 28)
#define CORNER_RADIUS_COMMON_INVITE_FRIEND 10
#define CONSTRAINT_HEIGHT_EXPAND_CONTENT_SOCIAL_NETWORK_INVITE_FRIENDS 100
#define CONSTRAINT_HEIGHT_COLLAPSE_CONTENT_SOCIAL_NETWORK_INVITE_FRIENDS 50
#define TIME_EXPAND_COLLAPSE_VIEW_INVITE_FRIENDS 0.25

#define IDENTIFIER_LIST_FRIENDS_TABLE_VIEW_CELL_FOR_FACEBOOK_TABLE_VIEW @"identifierListFriendsTableViewCellForFacebookTableView"
#define IDENTIFIER_LIST_FRIENDS_TABLE_VIEW_CELL_FOR_TWITTER_TABLE_VIEW @"identifierListFriendsTableViewCellForTwitterTableView"
#define IDENTIFIER_LIST_FRIENDS_TABLE_VIEW_CELL_FOR_SEARCH_FRIEND_TABLE_View @"identifierListFriendsTableViewCellForSearchFriendTableView"


#pragma mark - HugCell
// HugCell
#define HEIGHT_CELL_HUG_CELL 32.0
#define HEIGHT_SPACE_CELL_HUG_CELL 5
#define BUTTON_TOP_GAP_HUG_CELL 5
#define BUTTON_TOP_GAP_2_HUG_CELL 7
#define BUTTON_LEFT_GAP_HUG_CELL 12
#define WIDTH_COMMENT_TEXT_LABEL_HUG_CELL 70
#define HEIGHT_HUGGER_LABEL_HUG_CELL 16
#define TEXT_LABEL_HUG_HUG_CELL @"Hug"
#define TEXT_LABEL_LIKE_HUG_CELL @"Like"
#define TEXT_LABEL_COMMENT_HUG_CELL @"Comment"

#define BUTTON_LIKE_LEFT_GAP_HUG_CELL 120
#define BUTTON_COMMENT_LEFT_GAP_HUG_CELL 219
#define HUG_TEXT_LABEL_LEFT_GAP_HUG_CELL 4
#define HUG_TEXT_LABEL_TOP_GAP_HUG_CELL 10
#define HEIGHT_HUG_TEXT_LABEL_HUG_CELL 16
#define WIDTH_HUG_TEXT_LABEL_HUG_CELL 30
#define WIDTH_LIKE_TEXT_LABEL_HUG_CELL 30
#define HUGGER_LABEL_TOP_GAP_HUG_CELL 10
#define WIDTH_HUGGER_LABEL_BY_HUG_CELL 20
#define WIDTH_HUGGER_LABEL_HUG_CELL 480
#define WIDTH_HUGGER_LABEL_APTER_HUG_CELL 60 //55
#define WIDTH_HUGGER_LABEL_COUNT_HUG_CELL 20
#define WIDTH_LIKE_LABEL_APTER_HUG_CELL 170 //165
#define WIDTH_COMMENT_LABEL_APTER_HUG_CELL 290 //285
#define MIN_HUG_TO_SHOW_HUG_CELL 1
#define MAX_HUG_TO_SHOW_HUG_CELL 99
#define MIN_LIKE_TO_SHOW_HUG_CELL 1
#define TYPE_KEY_HUG_HUG_CELL 1
#define TYPE_KEY_COMMENT_HUG_CELL 2
#define TYPE_KEY_LIKE_HUG_CELL 3

#pragma mark - MoreHugsUserViewController
// MoreHugsUserViewController
#define TITLE_MORE_HUGS_USER @"Huggers & Likers"
#define TITLE_HUGGER_MORE_USER @"Hugs"
#define TITLE_LIKERS_MORE_USER @"Likes"
#define HEIGHT_CELL_MORE_HUGS_USER 35
#define FRAME_TITLE_LABEL_MORE_HUGS_USER CGRectMake(0, 0, 100, 35)
#define FRAME_BACK_BUTTON_MORE_HUGS_USER CGRectMake(0, 0, 28, 28)

#pragma mark - PublicFeelingsViewController
// PublicFeelingsViewController
#define TITLE_PUBLIC_FEELINGS @"ALL FEELINGS"
#define TIME_DELAY_HUG_PUBLIC_FEELINGS 2.0
#define HEIGHT_CELL_DEFAULT_PUBLIC_FEELINGS 42
#define SIZE_FONT_COMMENT_CELL_PUBLIC_FEELINGS 17
#define WIDTH_COMMENT_CELL_PUBLIC_FEELINGS 280
#define SPACE_COMMENT_CELL_PUBLIC_FEELINGS 5

#pragma mark - MyTherapyViewController
// MyTherapyViewController
#define TITLE_HEADER_MY_THERAPY @"HOW DO YOU FEEL?"
#define TEXT_LOCATION_UNAVAILABLE_MY_THERAPY @"LOCATION UNAVAILABLE"
#define TEXT_FAILED_TOTOGGLE_SHARED_MY_THERAPY @"Failed to toggle sharing!"
#define TOTAL_ROW_DEFAULT_MY_THERAPY 2
#define HEIGHT_MAP_CONTAINER_MY_THERAPY 100
#define HEIGHT_ATTACHMENT_CONTAINER_MY_THERAPY 100
#define HEIGHT_SHORTCUT_CONTAINER_MY_THERAPY 150
#define HEIGHT_DELETE_CONTAINER_MY_THERAPY 60
#define HEIGHT_SHARE_CONTAINER_MY_THERAPY 50
#define HEIGHT_TOTAL_OFFSET_MY_THERAPY 460
#define HEIGHT_HEADER_TABLE_VIEW_MY_THERAPY 44
#define HEIGHT_FOOTER_TABLE_VIEW_MY_THERAPY 10
#define HEIGHT_FEELING_CELL_TABLE_VIEW_MY_THERAPY 42
#define HEIGHT_SHOW_MORE_LINK_CELL_TABLE_VIEW_MY_THERAPY 20
#define TIME_UPDATE_TABLE_VIEW_MY_THERAPY 0.3
#define LATITUDINAL_METERS_MY_THERAPY 20000
#define LONGITUDINAL_METERS_MY_THERAPY 20000
#define NUMBER_SECTION_TABLE_VIEW_MY_THERAPY 1
#define WIDTH_TEXT_CELL_TABLE_VIEW_MY_THERAPY 280
#define TIME_DELAY_HUD_MY_THERAPY 2.0
#define SIZE_FONT_COMMON_LABEL_MY_THERAPY 15.0
#define SIZE_FONT_COMMON_LABEL_SUB_MY_THERAPY 11.0
#define SIZE_FONT_SHARE_FEELING_LABEL_MY_THERAPY 17
#define SIZE_FONT_MAP_PLACEHOLDER_LABLE_MY_THERAPY 22
#define FRAME_TITLE_LABEL_MY_THERAPY CGRectMake(0, 0, 100, 35)
#define FRAME_BUTTON_MORE_FEELING_MY_THERAPY CGRectMake(100, 0, 120, 20)
#define FRAME_MORE_LINK_CONTAINER_VIEW CGRectMake(0, 0, 320, 20)
#define FRAME_FOOTER_SEPARATOR_VIEW CGRectMake(0, 9, 320, 1)
#define FRAME_FOOTER_CONTAINER_VIEW CGRectMake(0, 0, 320, 10)

#define CONSTRAINT_TOP_DEFAULT_TABLE_VIEW_MY_THERAPY 95
#define CONSTRAINT_HEIGHT_ATTACHMENT_CONTAINER_MY_THERAPY 100
#define CONSTRAINT_HEIGHT_TOTAL_INNER_DEFAULT_MY_THERAPY 655
#define TIME_TO_CHANGE_CONSTRAINT 0.25

#pragma mark - ReferralFinder
// ReferralFinder
#define DISTANCEFILTER_REFERRAL_FINDER 100
#define LOCATION_TIME_OUT_REFERRAL_FINDER 10
#define TEXT_FIND_THERAPISTS_IN_PROGRESS_REFERRAL_FINDER @"FINDING NEARBY THERAPISTS..."
#define ZIPCODE_QUESTION_REFERRAL_FINDER @"What is your current Zipcode?"
#define TITLE_THERAPIST_SITE_REFERRAL_FINDER @"MY NEARBY THERAPISTS"
#define REGEX_TEXT_ZIPCODE_INPUT_REFERRAL_FINDER @"^(\\d{5}(-\\d{4})?|[a-z]\\d[a-z][- ]*\\d[a-z]\\d)$"
#define MAX_LOCATION_AGE 10.0
#define TIME_TO_SHOW_ZIP_CODE_POP_UP 0.2

#endif
