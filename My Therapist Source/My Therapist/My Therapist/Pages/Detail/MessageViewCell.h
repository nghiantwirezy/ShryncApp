//
//  MessageViewCell.h
//  Copyright (c) 2014 Shrync. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MessageViewCellDelegate <NSObject>

- (void)clickedMessageViewCell:(NSIndexPath *)indexPath;

@end

@interface MessageViewCell : UITableViewCell<UITextViewDelegate>{

}

@property (nonatomic,retain) id<MessageViewCellDelegate> delegate;
@property (nonatomic, retain) UIButton *btnClickMessage;

@property (weak, nonatomic) IBOutlet UIView *messageContentView;
@property (weak, nonatomic) IBOutlet UIImageView *imageUserComment;
@property (weak, nonatomic) IBOutlet UILabel *userComment;
@property (weak, nonatomic) IBOutlet UILabel *timeOfComment;
@property (weak, nonatomic) IBOutlet UILabel *usernameComment;
@property (weak, nonatomic) IBOutlet UITextView *commentMessageTextView;

@property (weak, nonatomic) IBOutlet UILabel *labelTest;
@property (weak, nonatomic) IBOutlet UIImageView *viewTest;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;

@end
