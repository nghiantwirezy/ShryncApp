//
//  HowDoYouFeelTouchView.m
//  My Therapist
//

#import "HowDoYouFeelTouchView.h"
#import "AppDelegate.h"
#import "HowDoYouFeelViewController.h"
#import "PPRevealSideViewController.h"

@interface HowDoYouFeelTouchView ()

@end

@implementation HowDoYouFeelTouchView

- (id)initWithFrame:(CGRect)frame
{
    CGRect originalFrame = [[UIScreen mainScreen] bounds];
    self = [[[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil] objectAtIndex:0];
    self.frame = originalFrame;
    needBringToHowDoYouFeel = YES;
    [self initPlusButtonAction];
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGRect plusButtonFrame = CGRectMake(self.frame.size.width - MARGIN_EDGE - WIGHT_PLUS_BUTTON, MARGIN_EDGE + HEIGHT_PLUS_BUTTON, WIGHT_PLUS_BUTTON, HEIGHT_PLUS_BUTTON);
    _plusButton.frame = plusButtonFrame;
    UIImage *plusButtonImage = [UIImage imageNamed:IMAGE_NAME_PLUS_ICON];
    [_plusButton setImage:plusButtonImage forState:UIControlStateNormal];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


#pragma mark - Touch Events

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    for (UIView * view in [self subviews]) {
        if (view.userInteractionEnabled && [view pointInside:[self convertPoint:point toView:view] withEvent:event]) {
            return YES;
        }
    }
    return NO;
}


#pragma mark - Action

- (IBAction)plusAction:(id)sender
{
    if (needBringToHowDoYouFeel) {
        [self bringToHowDoYouFeel];
    }
    
    [self bringPlusButtonToTheEdge];
    needBringToHowDoYouFeel = YES;
}

- (IBAction)imageMoved:(id)sender withEvent:(UIEvent *) event
{
    UIControl *control = sender;
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint pPrev = [touch previousLocationInView:control];
    CGPoint p = [touch locationInView:control];
    
    CGPoint center = control.center;
    center.x += p.x - pPrev.x;
    center.y += p.y - pPrev.y;
    needBringToHowDoYouFeel = (CGPointEqualToPoint(control.center, center))?YES:NO;
    control.center = center;
}

- (IBAction)plusTouchCancelAction:(id)sender{
    [self bringPlusButtonToTheEdge];
    needBringToHowDoYouFeel = YES;
}

#pragma mark - Custom Methods

- (void)initPlusButtonAction
{
    [_plusButton addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [_plusButton addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragOutside];
    [_plusButton addTarget:self action:@selector(plusTouchCancelAction:) forControlEvents:UIControlEventTouchCancel];
}

- (void)bringToHowDoYouFeel
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (![[appDelegate.navigationController topViewController] isKindOfClass:[appDelegate.howDoYouFeelViewController class]]) {
        UIViewController *topViewController = appDelegate.navigationController.topViewController;
        [topViewController dismissViewControllerAnimated:YES completion:^{
            [appDelegate.revealSideViewController popViewControllerAnimated:YES];
        }];
        [appDelegate.navigationController setViewControllers:[NSArray arrayWithObject:appDelegate.howDoYouFeelViewController] animated:YES];
    }
}

- (void)bringPlusButtonToTheEdge
{
    CGFloat currentCenterPostionX = _plusButton.frame.origin.x + (HALF_OF(_plusButton.frame.size.width));
    CGFloat currentCenterPostionY = _plusButton.frame.origin.y + (HALF_OF(_plusButton.frame.size.height));
    CGRect originalFrame = [[UIScreen mainScreen] bounds];
    
    BOOL plusButtonIsOnTop = (currentCenterPostionY < PLUS_BUTTON_SCALE_RATIO(_plusButton.frame.size.height));
    BOOL plusButtonIsOnBottom = (currentCenterPostionY > (originalFrame.size.height - PLUS_BUTTON_SCALE_RATIO(_plusButton.frame.size.height)));
    BOOL plusButtonIsOnLeft = (currentCenterPostionX < HALF_OF(originalFrame.size.width));
    
    CGRect framePlusButtonAfterMove;
    
    CGFloat originXPosition = _plusButton.frame.origin.x;
    CGFloat positionXToTheRight = originalFrame.size.width - MARGIN_EDGE - _plusButton.frame.size.width;
    CGFloat positionYToTheBottom = originalFrame.size.height - MARGIN_EDGE - _plusButton.frame.size.height;
    originXPosition = (originXPosition < MARGIN_EDGE)?MARGIN_EDGE:originXPosition;
    originXPosition = (originXPosition > positionXToTheRight)?positionXToTheRight:originXPosition;
    
    if (plusButtonIsOnTop) {
        // Move to Top
        framePlusButtonAfterMove = CGRectMake(originXPosition, MARGIN_EDGE, _plusButton.frame.size.width, _plusButton.frame.size.height);
    }else if (plusButtonIsOnBottom) {
        // Move to Bottom
        framePlusButtonAfterMove = CGRectMake(originXPosition, positionYToTheBottom, _plusButton.frame.size.width, _plusButton.frame.size.height);
    }else if (plusButtonIsOnLeft) {
        // Move to Left
        framePlusButtonAfterMove = CGRectMake(MARGIN_EDGE, _plusButton.frame.origin.y, _plusButton.frame.size.width, _plusButton.frame.size.height);
    }else {
        // Move to Right
        framePlusButtonAfterMove = CGRectMake(positionXToTheRight, _plusButton.frame.origin.y, _plusButton.frame.size.width, _plusButton.frame.size.height);
    }
    
    [UIView animateWithDuration:TIME_MOVE_PLUS_BUTTON_TO_EDGE animations:^{
        _plusButton.frame = framePlusButtonAfterMove;
    }];
}

@end
