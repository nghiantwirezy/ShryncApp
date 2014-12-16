//
//  FeelingCell.m
//  My Therapist
//
//  Created by Yexiong Feng on 11/28/13.
//  Copyright (c) 2013 stackbear. All rights reserved.
//

#import "FeelingCell.h"
#import "SubFeelingButton.h"
#import "UIImage+ImageWithColor.h"
#import "AppDelegate.h"
#import "HowDoYouFeelViewController.h"
#import "Feeling.h"
#import "UIColor+ColorUtilities.h"

@implementation FeelingCell {
  UIImageView *_upperSlidingImageView, *_feelingStrengthSliderBackgroundImageView, *_feelingIconStaticImageView, *_feelingIconAnimatedImageView;
  UILabel *_feelingNameStaticLabel, *_feelingNameAnimatedLabel, *_feelingSubtitleLabel;
  NSMutableArray *_feelingStrengthBackgrounds;
  UIView *_feelingStrengthContainerView;
  UIView *_upperSlidingContainerView;
  
  UIScrollView *_subFeelingScrollView;
  UIView *_subFeelingContainerView, *_subFeelingCoveringView;;
  NSMutableArray *_subFeelingButtons, *_subFeelingSelections;
  UIView *_middleSeparatorView, *_bottomSeparatorView;
}

#pragma mark - FeelingCell Management

- (id)initWithFeeling:(Feeling *)feeling
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    if (self) {
        self.clipsToBounds = YES;
        _feeling = feeling;

        self.selectionStyle = UITableViewCellSelectionStyleNone;

        _upperContainerView = [[UIView alloc] initWithFrame:FRAME_UPPER_CONTAINER_VIEW_FEELING_CELL];
        _lowerContainerView = [[UIView alloc] initWithFrame:FRAME_LOWER_CONTAINER_VIEW_FEELING_CELL];

        _middleSeparatorView = [[UIView alloc] initWithFrame:FRAME_MIDDLE_SEPARATOR_VIEW_FEELING_CELL];
        _bottomSeparatorView = [[UIView alloc] initWithFrame:FRAME_BOTTOM_SEPARATOR_VIEW_FEELING_CELL];
        _middleSeparatorView.backgroundColor = _bottomSeparatorView.backgroundColor = [UIColor veryLightGrayColor];
        _contentContainerView = [[UIView alloc] initWithFrame:FRAME_CONTENT_CONTAINER_VIEW_FEELING_CELL];
        [_contentContainerView addSubview:_upperContainerView];
        [_contentContainerView addSubview:_lowerContainerView];
        [_contentContainerView addSubview:_middleSeparatorView];
        [_contentContainerView addSubview:_bottomSeparatorView];

        _feelingStrengthBackgrounds = [[NSMutableArray alloc] init];
        for (int i = 0; i <= FEELING_STRENGTH_MAX; ++i) {
            NSString *imageName = [NSString stringWithFormat:@"feeling slider background %d.png", i];
            UIImage *image = [UIImage imageNamed:imageName];
            [_feelingStrengthBackgrounds addObject:image];
        }
        _upperSlidingImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IMAGE_NAME_FEELING_TOP_CONTAINER_BACKGROUND]];
        _upperSlidingImageView.userInteractionEnabled = YES;
        _upperSlidingImageView.translatesAutoresizingMaskIntoConstraints = NO;
        _feelingStrengthContainerView = [[UIView alloc] initWithFrame:FRAME_FEELING_STRENGTH_CONTAINER_VIEW_FEELING_CELL];
        _feelingStrengthSliderBackgroundImageView = [[UIImageView alloc] initWithFrame:FRAME_FEELING_STRENGTH_SLIDER_BACKGROUND_IMAGE_VIEW_FEELING_CELL];
        _feelingStrengthSliderBackgroundImageView.image = [_feelingStrengthBackgrounds objectAtIndex:0];
        _feelingStrengthSlider = [[UISlider alloc] initWithFrame:FRAME_FEELING_STRENGTH_SLIDER_FEELING_CELL];
        UIImage *sliderThumbImage = [UIImage imageWithColor:[UIColor veryDarkGrayColor4WithAlpha:ALPHA_SLIDER_THUMB_IMAGE_FEELING_CELL] andSize:SIZE_SLIDER_THUMB_IMAGE_FEELING_CELL];
        _feelingStrengthSlider.minimumValue = FEELING_STRENGTH_MIN;
        _feelingStrengthSlider.maximumValue = FEELING_STRENGTH_MAX;
        _feelingStrengthSlider.value = _feelingStrengthSlider.minimumValue;

        [_feelingStrengthSlider setThumbImage:sliderThumbImage forState:UIControlStateNormal];
        [_feelingStrengthSlider setThumbImage:sliderThumbImage forState:UIControlStateHighlighted];
        [_feelingStrengthSlider setMinimumTrackImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
        [_feelingStrengthSlider setMaximumTrackImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
        [_feelingStrengthSlider addTarget:self action:@selector(feelingStrengthSliderValueChanged) forControlEvents:UIControlEventValueChanged];
        [_feelingStrengthSlider addTarget:self action:@selector(feelingStrengthSliderTouchUp) forControlEvents:UIControlEventTouchUpInside];
        [_feelingStrengthContainerView addSubview:_feelingStrengthSliderBackgroundImageView];
        [_feelingStrengthContainerView addSubview:_feelingStrengthSlider];

        _upperSlidingContainerView = [[UIView alloc] initWithFrame:_upperSlidingImageView.bounds];
        _upperSlidingContainerView.userInteractionEnabled = YES;
        [_upperSlidingContainerView addSubview:_upperSlidingImageView];
        [_upperSlidingContainerView addSubview:_feelingStrengthContainerView];

        _feelingIconStaticImageView = [[UIImageView alloc] initWithFrame:FRAME_FEELING_ICON_STATIC_IMAGE_VIEW_FEELING_CELL];
        _feelingIconStaticImageView.image = _feeling.feelingInactiveIcon;
        _feelingIconAnimatedImageView = [[UIImageView alloc] initWithFrame:_feelingIconStaticImageView.frame];
        _feelingIconAnimatedImageView.alpha = 0;

        _feelingNameStaticLabel = [[UILabel alloc] initWithFrame:FRAME_FEELING_NAME_STATIC_LABEL_FEELING_CELL];
        _feelingNameStaticLabel.font = COMMON_BEBAS_FONT(SIZE_FONT_FEELING_NAME_STATIC_LABEL_FEELING_CELL);
        _feelingNameStaticLabel.textColor = _feeling.feelingNameInactiveColor;
        _feelingNameStaticLabel.text = feeling.mainFeelingName;

        _feelingNameAnimatedLabel = [[UILabel alloc] initWithFrame:_feelingNameStaticLabel.frame];
        _feelingNameAnimatedLabel.font = _feelingNameStaticLabel.font;
        _feelingNameAnimatedLabel.textColor = _feeling.feelingNameActiveColor;
        _feelingNameAnimatedLabel.text = feeling.mainFeelingName;
        _feelingNameAnimatedLabel.alpha = 0;

        _feelingSubtitleLabel = [[UILabel alloc] initWithFrame:FRAME_FEELING_SUBTITLE_LABEL_FEELING_CELL];
        _feelingSubtitleLabel.font = COMMON_BEBAS_FONT(SIZE_FONT_FEELING_SUBTITLE_LABEL_FEELING_CELL);
        _feelingSubtitleLabel.textColor = [UIColor veryDarkGrayColor];
        _feelingSubtitleLabel.text = _feeling.mainFeelingSubtitle;

        [_upperContainerView addSubview:_upperSlidingContainerView];
        [_upperContainerView addSubview:_feelingIconStaticImageView];
        [_upperContainerView addSubview:_feelingIconAnimatedImageView];
        [_upperContainerView addSubview:_feelingNameStaticLabel];
        [_upperContainerView addSubview:_feelingNameAnimatedLabel];
        [_upperContainerView addSubview:_feelingSubtitleLabel];

        _subFeelingSelections = [[NSMutableArray alloc] init];
        for (int i = 0; i < _feeling.subFeelingNames.count; ++i) {
            [_subFeelingSelections addObject:[NSNumber numberWithBool:NO]];
        }
        
        _subFeelingButtons = [[NSMutableArray alloc] init];
        for (NSString *subFeelingText in _feeling.subFeelingNames) {
            SubFeelingButton *button = [[SubFeelingButton alloc] initWithIndex:_subFeelingButtons.count title:subFeelingText];
            [button addTarget:self action:@selector(tapedSubFeelingButton:) forControlEvents:UIControlEventTouchUpInside];
            [_subFeelingButtons addObject:button];
        }
        
            CGFloat subFeelingContainerViewWidth = _subFeelingButtons.count * (WIDTH_SUB_FEELING_BUTTON_FEELING_CELL);
            _subFeelingContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, subFeelingContainerViewWidth, HEIGHT_SUB_FEELING_CONTAINER_VIEW)];
        for (SubFeelingButton *button in _subFeelingButtons) {
            [_subFeelingContainerView addSubview:button];
        }
        _subFeelingContainerView.backgroundColor = [UIColor veryLightGrayColor];
        _subFeelingScrollView = [[UIScrollView alloc] initWithFrame:FRAME_SUB_FEELING_SCROLL_VIEW_FEELING_CELL];
        _subFeelingScrollView.contentSize = _subFeelingContainerView.bounds.size;
        _subFeelingScrollView.delaysContentTouches = YES;
        _subFeelingScrollView.canCancelContentTouches = YES;
        _subFeelingScrollView.showsHorizontalScrollIndicator = NO;
        _subFeelingScrollView.userInteractionEnabled = YES;
        _subFeelingScrollView.clipsToBounds = NO;
        _subFeelingScrollView.delegate = self;
        _subFeelingCoveringView = [[UIView alloc] initWithFrame:FRAME_SUB_FEELING_COVERING_VIEW_FEELING_CELL];
        _subFeelingCoveringView.backgroundColor = [UIColor whiteColor];
        _subFeelingCoveringView.alpha = ALPHA_SUBFEELING_COVERING_FEELING_CELL;
        _subFeelingCoveringView.userInteractionEnabled = YES;
        [_subFeelingScrollView addSubview:_subFeelingContainerView];
        [_lowerContainerView addSubview:_subFeelingScrollView];
        [_lowerContainerView addSubview:_subFeelingCoveringView];

        [self.contentView addSubview:self.contentContainerView];

        [self feelingStrengthSliderValueChanged];
        _isUserChangeStrengthSlider = NO;
    }
    return self;
}

#pragma mark - Actions

- (void)tapedSubFeelingButton:(SubFeelingButton *)button
{
    BOOL updatedSelectionValue = !button.subFeelingSelected;
    button.subFeelingSelected = updatedSelectionValue;
    if (button.subFeelingSelected) {
        _isUserChangeStrengthSlider = YES;
    }
}

#pragma mark - Custom Methods

- (void)reset
{
    for (int i = 0; i < _subFeelingSelections.count; ++i) {
        [_subFeelingSelections replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:NO]];
    }
    
    for (SubFeelingButton *button in _subFeelingButtons) {
        button.subFeelingSelected = NO;
    }
    _feelingStrengthSlider.value = 0;
    [self feelingStrengthSliderValueChanged];
    
    [_feeling reset];
    self.cellExpanded = NO;
    _isUserChangeStrengthSlider = NO;
}

- (void)prepareForCheckIn
{
    [_feeling.selectedSubFeelingIndexes removeAllObjects];
    for (int i = 0; i < _subFeelingButtons.count; ++i) {
        SubFeelingButton *button = [_subFeelingButtons objectAtIndex:i];
        if (button.subFeelingSelected) {
            [_feeling.selectedSubFeelingIndexes addObject:[NSNumber numberWithInt:i]];
        }
    }
}

- (void)setCellExpanded:(BOOL)cellExpanded
{
    _cellExpanded = cellExpanded;
    
    NSInteger upperFrameOffset = cellExpanded  ? OFFSET_X_CELL_EXPANDED_FEELING_CELL : 0;
    NSInteger cellHeight = cellExpanded ? HEIGHT_CELL_EXPAND_FEELING_CELL : HEIGHT_CELL_COLLAPSE_FEELING_CELL;
    
    [UIView animateWithDuration:TIME_EXPAND_CELL_FEELING_CELL animations:^{
        CGRect upperFrame = _upperSlidingContainerView.frame;
        upperFrame.origin.x = upperFrameOffset;
        _upperSlidingContainerView.frame = upperFrame;
        
        CGRect containerFrame = _contentContainerView.frame;
        containerFrame.size.height = cellHeight;
        _contentContainerView.frame = containerFrame;
    }];
    
    if (!cellExpanded) {
        BOOL isSubFeelingSelected = NO;
        for (int i = 0; i < _subFeelingButtons.count; ++i) {
            SubFeelingButton *button = [_subFeelingButtons objectAtIndex:i];
            if (button.subFeelingSelected) {
                isSubFeelingSelected = YES;
                break;
            }
        }
        if (!isSubFeelingSelected && !_isUserChangeStrengthSlider) {
            _feelingStrengthSlider.value = 0;
            [self didChangeValueSlider];
            _isUserChangeStrengthSlider = NO;
        }
    }
}

- (void)didChangeValueSlider {
    float sliderValue = _feelingStrengthSlider.value;
    NSInteger floor = floorf(sliderValue);
    NSInteger ceil = ceilf(sliderValue);
    NSInteger roundedValue = VALUE_ROUNDED_FEELING_CELL;
    
    if (sliderValue - floor <= VALUE_FLOORF_SLIDER_FEELING_CELL) {
        roundedValue = floor;
    }else if (ceil - sliderValue <= VALUE_FLOORF_SLIDER_FEELING_CELL) {
        roundedValue = ceil;
    }
    if (roundedValue != _feeling.feelingStrength && roundedValue != VALUE_ROUNDED_FEELING_CELL) {
        UIImage *background = [_feelingStrengthBackgrounds objectAtIndex:roundedValue];
        _feelingStrengthSliderBackgroundImageView.image = background;
        if (roundedValue == 0) {
            for (SubFeelingButton *button in _subFeelingButtons) {
                button.subFeelingSelected = NO;
            }
            _feelingIconStaticImageView.image = _feeling.feelingInactiveIcon;
            _feelingIconAnimatedImageView.image = _feeling.feelingActiveIcon;
            
            _feelingNameStaticLabel.textColor = [Feeling feelingNameInactiveColor];
            _feelingNameAnimatedLabel.textColor = _feeling.feelingNameActiveColor;
            
            _feelingNameAnimatedLabel.alpha = _feelingIconAnimatedImageView.alpha = 1;
            [UIView animateWithDuration:TIME_EXPAND_CELL_FEELING_CELL animations:^{
                _feelingIconAnimatedImageView.alpha = 0;
                _feelingNameAnimatedLabel.alpha = 0;
            }];
        } else if (_feeling.feelingStrength == 0) {
            _feelingIconStaticImageView.image = _feeling.feelingActiveIcon;
            _feelingIconAnimatedImageView.image = _feeling.feelingInactiveIcon;
            
            _feelingNameStaticLabel.textColor = _feeling.feelingNameActiveColor;
            _feelingNameAnimatedLabel.textColor = [Feeling feelingNameInactiveColor];
            
            _feelingNameAnimatedLabel.alpha = _feelingIconAnimatedImageView.alpha = 1;
            [UIView animateWithDuration:TIME_EXPAND_CELL_FEELING_CELL animations:^{
                _feelingIconAnimatedImageView.alpha = 0;
                _feelingNameAnimatedLabel.alpha = 0;
            }];
        }
        
        _feeling.feelingStrength = roundedValue;
    }
    
    if (_feeling.feelingStrength == 0) {
        [_subFeelingSelections removeAllObjects];
        
        if (_subFeelingCoveringView.alpha == 0) {
            [UIView animateWithDuration:TIME_EXPAND_CELL_FEELING_CELL animations:^{
                _subFeelingCoveringView.alpha = ALPHA_SUBFEELING_COVERING_FEELING_CELL;
                [_subFeelingScrollView setContentOffset:CGPointZero animated:YES];
            }];
        }
    } else {
        if (_subFeelingCoveringView.alpha > 0) {
            [UIView animateWithDuration:TIME_EXPAND_CELL_FEELING_CELL animations:^{
                _subFeelingCoveringView.alpha = 0;
            }];
        }
    }
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    HowDoYouFeelViewController *controller = (HowDoYouFeelViewController *)delegate.howDoYouFeelViewController;
    BOOL controllerButtonsEnabled = NO;
    if ([controller.howYouFeelTextField.text length] > 0) {
        controllerButtonsEnabled = YES;
    }else{
        for (Feeling *feeling in controller.feelings) {
            if (feeling.feelingStrength > 0) {
                controllerButtonsEnabled = YES;
                break;
            }
        }
    }
    [controller setButtonsEnabled:controllerButtonsEnabled];
}

#pragma mark - Sliders

- (void)feelingStrengthSliderValueChanged
{
    [self didChangeValueSlider];
    _isUserChangeStrengthSlider = (_feelingStrengthSlider.value == 0)?NO:YES;
}

- (void)feelingStrengthSliderTouchUp
{
    _feelingStrengthSlider.value = _feeling.feelingStrength;
    _isUserChangeStrengthSlider = (_feelingStrengthSlider.value == 0)?NO:YES;
}


@end
