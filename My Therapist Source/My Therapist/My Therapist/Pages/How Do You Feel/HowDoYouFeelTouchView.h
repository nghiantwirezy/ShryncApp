//
//  HowDoYouFeelTouchView.h
//  My Therapist
//

#import <UIKit/UIKit.h>

@interface HowDoYouFeelTouchView : UIView{
    CGPoint currentTouchPoint;
    BOOL needBringToHowDoYouFeel;
}
@property (weak, nonatomic) IBOutlet UIButton *plusButton;
- (IBAction)plusAction:(id)sender;

@end
