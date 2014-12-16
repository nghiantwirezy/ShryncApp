//
//  ImageAreaSelectionViewController.m
//  My Therapist
//
//  Created by Yexiong Feng on 2/2/14.
//  Copyright (c) 2014 ApplePieHealing. All rights reserved.
//

#import "ImageAreaSelectionViewController.h"
#import "TouchCapturingView.h"
#import "MaskDrawingLayer.h"
#import "UIImage+ScaleImage.h"
#import "UIImage+FixOrientation.h"

#define TOOLBAR_TIP @"Drag to select part of the picture as you profile image."
#define PROFILE_PICTURE_EDGE 256.0

@interface ImageAreaSelectionViewController ()

@end

@implementation ImageAreaSelectionViewController {
  CGPoint _pointA;
  CGRect _selectedArea;
}

- (CGAffineTransform)transformForImage:(UIImage *)image
{
  CGAffineTransform transform = CGAffineTransformIdentity;
  
  switch (image.imageOrientation) {
    case UIImageOrientationDown:
    case UIImageOrientationDownMirrored:
      transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height);
      transform = CGAffineTransformRotate(transform, M_PI);
      break;
      
    case UIImageOrientationLeft:
    case UIImageOrientationLeftMirrored:
      transform = CGAffineTransformTranslate(transform, image.size.height, 0);
      transform = CGAffineTransformRotate(transform, M_PI_2);
      break;
      
    case UIImageOrientationRight:
    case UIImageOrientationRightMirrored:
      transform = CGAffineTransformTranslate(transform, 0, image.size.width);
      transform = CGAffineTransformRotate(transform, 0 - M_PI_2);
      break;
      
    default:
      break;
  }
  
  return transform;
}

- (void)imageSelected
{
  CGFloat scale = _image.size.width / _touchCapturingView.frame.size.width;
  
  CGRect imageArea = CGRectMake(_selectedArea.origin.x * scale, _selectedArea.origin.y * scale, _selectedArea.size.width * scale, _selectedArea.size.height * scale);
  
  CGAffineTransform areaTransform = [self transformForImage:_image];
  imageArea = CGRectApplyAffineTransform(imageArea, areaTransform);
  
  CGImageRef imageRef = CGImageCreateWithImageInRect([_image CGImage], imageArea);
  UIImage *selectedImage = [UIImage imageWithCGImage:imageRef scale:1.0 orientation:_image.imageOrientation];
  CGImageRelease(imageRef);
  
  CGFloat resizingScale = PROFILE_PICTURE_EDGE / MAX(selectedImage.size.height, selectedImage.size.width);
  CGSize resizingSize = CGSizeMake(selectedImage.size.width * resizingScale, selectedImage.size.height * resizingScale);
  
  UIImage *scaledImage = [UIImage imageWithImage:selectedImage scaledToSize:resizingSize];
  
  scaledImage = [scaledImage fixOrientation];
  
  [self.delegate setAreaSelectedImage:scaledImage];
  
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  self.imageView.contentMode = UIViewContentModeScaleAspectFit;
  self.touchCapturingView.delegate = self;
  self.navigationController.interactivePopGestureRecognizer.enabled = NO;
  
  UIBarButtonItem *toolbarLeftSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
  UIBarButtonItem *toolbarRightSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
  
  UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 40)];
  label.font = [UIFont fontWithName:@"LeagueGothic-Regular" size:15.0f];
  label.textColor = [UIColor darkGrayColor];
  label.text = TOOLBAR_TIP;
  label.textAlignment = NSTextAlignmentCenter;
  UIBarButtonItem *toolbarLabel = [[UIBarButtonItem alloc] initWithCustomView:label];
  
  NSArray *toolbarItems = [NSArray arrayWithObjects:toolbarLeftSpace, toolbarLabel, toolbarRightSpace, nil];
  [self setToolbarItems:toolbarItems];
  
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(imageSelected)];
}

- (void)viewWillAppear:(BOOL)animated
{
  self.navigationController.toolbarHidden = NO;
  self.navigationController.toolbar.translucent = NO;
  
  self.navigationItem.rightBarButtonItem.enabled = NO;
  
  [self.touchCapturingView.drawingLayer clearMask];
  self.imageView.image = self.image;
}

- (void)viewDidAppear:(BOOL)animated
{
  CGSize imageSize = self.image.size;
  if (imageSize.width > imageSize.height) {
    CGFloat width = self.containerView.frame.size.width;
    CGFloat height = imageSize.height / imageSize.width * width;
    
    self.touchCapturingView.frame = CGRectMake(0, (self.containerView.frame.size.height - height) / 2.0, width, height);
  } else {
    CGFloat height = self.containerView.frame.size.height;
    CGFloat width = imageSize.width / imageSize.height * height;
    
    self.touchCapturingView.frame = CGRectMake((self.containerView.frame.size.width - width) / 2.0, 0, width, height);
  }
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)areaTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  _selectedArea = CGRectZero;
  self.navigationItem.rightBarButtonItem.enabled = NO;
  [self.touchCapturingView.drawingLayer clearMask];
    
  // Only handle single touch.
  if (touches.count == 1) {
    UITouch *touch = [touches anyObject];
    // Only handle single tap.
    if (touch.tapCount == 1) {
      _pointA = [touch locationInView:touch.view];
    }
  }
}

- (CGPoint)getPointBWithTouch:(UITouch *)touch
{
  CGPoint point = [touch locationInView:touch.view];
  CGRect rect = touch.view.bounds;
  
  if (point.x > rect.size.width) {
    point.x = rect.size.width;
  } else if (point.x < 0) {
    point.x = 0;
  }
  
  if (point.y > rect.size.height) {
    point.y = rect.size.height;
  } else if (point.y < 0) {
    point.y = 0;
  }
  
  return point;
}

- (void)areaTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
  if (touches.count == 1) {
    UITouch *touch = [touches anyObject];
    MaskDrawingLayer *drawingLayer = self.touchCapturingView.drawingLayer;
    
    // Update the touch coordinate.
    CGPoint pointB = [self getPointBWithTouch:touch];
    
    // Calculate the masking rect.
    _selectedArea = CGRectMake(MIN(_pointA.x, pointB.x), MIN(_pointA.y, pointB.y), ABS(_pointA.x - pointB.x), ABS(_pointA.y - pointB.y));
    
    [drawingLayer drawMaskInRect:_selectedArea];
    
    self.navigationItem.rightBarButtonItem.enabled = YES;
  }
}

- (void)areaTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{

}

- (void)areaTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
  
}

@end
