//
//  CWAminatedMenuButton.m
//  CWAnimatedControlView
//
//  Created by Ku4n Cheang on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CWAnimatedMenuButton.h"

#define DEGREES_TO_RADIANS(angle) (angle / 180.0 * M_PI)

@interface CWAnimatedMenuButton (){
  CWAnimatedMenuItem *_item;
}
@property (nonatomic, retain) CWAnimatedMenuItem *item;
@end

/*///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////*/ 

@implementation CWAnimatedMenuButton
@synthesize item = _item;
@synthesize radius = _radius;
@synthesize angle = _angle;
@synthesize origin = _origin;
@synthesize destCenter = _destCenter;
@synthesize originalCenter = _originalCenter;
@synthesize move = _move;
@synthesize reverse = _reverse;
@synthesize maxDuration = _maxDuration;
@synthesize expandFactor = _expandFactor;

- (id)initWithCWAnimatedMenuItem:(CWAnimatedMenuItem *)item{
  CGSize size = item.normalImage.size;
  self = [super initWithFrame:CGRectMake(0, 0, size.width, size.height)];
  if (self){
    self.item = item;
    [self setImage:self.item.normalImage forState:UIControlStateNormal];
    
    if (self.item.pressedImage){
      [self setImage:self.item.pressedImage forState:UIControlStateSelected];
      [self setImage:self.item.pressedImage forState:UIControlStateHighlighted];
    }
    
    self.tag = self.item.tag;
    self.radius = self.frame.size.width / 2;
    self.angle = 0.0;
    self.reverse = NO;
    self.destCenter = CGPointZero;
    _move = NO;

  }
  return self;
}

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

- (void)dealloc {
  [_item release];
  [super dealloc];
}

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 


-(void)setOrigin:(CGPoint)origin
{
  CGRect frame = self.frame;
  frame.origin = origin;
  self.frame = frame;
}

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

- (CGPoint)origin{
  return self.frame.origin;
}

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

- (void)moveToDestination:(BOOL)move
{
  _move = move;
  if (_move){
    self.center = self.destCenter;
  }else{
    self.center = self.originalCenter;
  }
}

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

- (BOOL)isMoved
{
  // show the button is whether in target position
  if ((self.center.x != self.destCenter.x) || (self.center.y != self.destCenter.y)){
    _move = NO;
  }else if ((self.center.x == self.destCenter.x) && (self.center.y == self.destCenter.y)){
    _move = YES;
  }
  
  return _move;
}

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

- (void)setOriginalCenter:(CGPoint)originalCenter
{
  self.center = originalCenter;
  _originalCenter = originalCenter;
}

/*///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////*/ 

#pragma mark - 
#pragma mark private method

- (CGPoint)directionDistanceWithScale:(CGFloat)scale
{
  // calculate the point at the orbital arc with a specfic radius
  CGFloat radianAngle = DEGREES_TO_RADIANS(self.angle);
  CGFloat xCosValue = scale * self.radius * cosf(radianAngle);
  CGFloat ySinValue = scale * self.radius * sinf(radianAngle);
  return CGPointMake(xCosValue, -ySinValue);
}

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

- (void)animateExpandAtBeginTime:(float)beginTime withReverse:(BOOL)reverse
{
  self.reverse = reverse;
  if (!reverse){
    NSString *key = @"expansion";
    CAAnimationGroup *expandAnimation = (CAAnimationGroup *) [self.layer animationForKey:key];
    if (!expandAnimation){
      
      //ratate animation 
      CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
      [rotationAnimation setFromValue:[NSNumber numberWithDouble:0]];
      [rotationAnimation setToValue:[NSNumber numberWithDouble:-2 * M_PI]];
      rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];;
      rotationAnimation.beginTime = beginTime;
      rotationAnimation.removedOnCompletion = NO;
      
       //move animation
      CGMutablePathRef thePath = CGPathCreateMutable();
      
      CGPathMoveToPoint(thePath,NULL,self.originalCenter.x, self.originalCenter.y);
      
      // calculate the point at the orbital arc with a specfic radius
      CGPoint offset = [self directionDistanceWithScale:self.expandFactor];
      
      CGPathAddLineToPoint(thePath, nil, self.originalCenter.x + offset.x, self.originalCenter.y + offset.y);
      CGPathAddLineToPoint(thePath, nil, self.destCenter.x, self.destCenter.y);
      
      CAKeyframeAnimation * moveAnimation;
      moveAnimation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
      moveAnimation.path=thePath;
      // set the duration to 5.0 seconds
      moveAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
      moveAnimation.beginTime = beginTime;
      moveAnimation.removedOnCompletion = NO;
      
      CFRelease(thePath);
      
      //group two animations in order to run at the same time
      CAAnimationGroup *group = [CAAnimationGroup animation];
      group.animations = [NSArray arrayWithObjects: moveAnimation, rotationAnimation, nil];
      group.duration = self.maxDuration + beginTime + 0.05;
      group.removedOnCompletion = NO;
      group.delegate = self;
      group.fillMode = kCAFillModeForwards;
      
      [self.layer addAnimation:group forKey:key];
    }
  }else {
    NSString *key = @"Contraction";
    CAAnimationGroup *contractionAnimation = (CAAnimationGroup *)[self.layer animationForKey:@"Contraction"];
    if (!contractionAnimation){
    
      // rotate animation
      CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
      [rotationAnimation setFromValue:[NSNumber numberWithDouble:0]];
      [rotationAnimation setToValue:[NSNumber numberWithDouble:2 * M_PI]];
      rotationAnimation.beginTime = self.tag * 0.020;
      rotationAnimation.speed = 1.6;
      rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];;
      
      // move animation
      CGMutablePathRef thePath = CGPathCreateMutable();
      CGPathMoveToPoint(thePath,NULL,self.destCenter.x, self.destCenter.y);
      CGPoint offset = [self directionDistanceWithScale:self.expandFactor];
      CGPathAddLineToPoint(thePath, nil, self.originalCenter.x + offset.x, self.originalCenter.y + offset.y);
      CGPathAddLineToPoint(thePath, nil, self.originalCenter.x, self.originalCenter.y);
      
      CAKeyframeAnimation * moveAnimation;
      moveAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
      moveAnimation.path = thePath;
      moveAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
      // release the path
      CFRelease(thePath);
      
      //group together
      CAAnimationGroup *group = [CAAnimationGroup animation];
      group.delegate = self;
      group.animations = [NSArray arrayWithObjects: moveAnimation, rotationAnimation, nil];
      group.duration = self.maxDuration + beginTime;
      group.removedOnCompletion = NO;
      group.fillMode = kCAFillModeForwards;
      
      [self.layer addAnimation:group forKey:key];
    }

  }
}

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

- (void)animationDidStart:(CAAnimation *)anim
{
  self.hidden = NO;
}

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
  if (self.reverse){
    self.hidden = YES;
    [self moveToDestination:NO];
  }else {
    [self moveToDestination:YES];
  }
  [self.layer removeAllAnimations];
}


@end
