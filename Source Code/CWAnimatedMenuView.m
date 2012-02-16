//
//  CWAnimatedMenuView.m
//  CWAnimatedControlView
//
//  Created by Ku4n Cheang on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CWAnimatedMenuView.h"
#import <QuartzCore/QuartzCore.h>
#import <math.h>

#define CW_MENU_PADDING 5
#define CW_MENU_DEFAULT_SCALE 5
#define DEGREES_TO_RADIANS(angle) (angle / 180.0 * M_PI)

@interface CWAnimatedMenuView (){
}
@property (nonatomic, retain) NSMutableArray *menuButtonItems;
@property (nonatomic, retain) CWAnimatedMenuButton *masterButtonItem;
@property (nonatomic) NSUInteger elemCount;

- (void)SortMenuItemsByTag;
- (void)initializeMenubuttonItemsAttribute;
- (void)placeToStylePosition;
- (void)setNeedsAngles;
@end

/*///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////*/ 

@implementation CWAnimatedMenuView
@synthesize gap = _gap;
@synthesize radius = _radius;
@synthesize beginAngle = _beginAngle;
@synthesize endAngle = _endAngle;
@synthesize menuItem = _menuItem;
@synthesize masterItem = _masterItem;
@synthesize menuButtonItems = _menuButtonItems;
@synthesize masterButtonItem = _masterButtonItem;
@synthesize style = _style;
@synthesize position = _position;
@synthesize elemCount = _elemCount;
@synthesize scale = _scale;
@synthesize delegate = _delegate;
@synthesize animationDuration = _animationDuration;
@synthesize animationDelay = _animationDelay;
@synthesize customMasterCenter = _customMasterCenter;
@synthesize masterButtonAnimationEnabled = _masterButtonAnimationEnabled;
@synthesize isExpanded = _isExpanded;
@synthesize expandDistanceScale = _expandDistanceScale;
@synthesize masterRotateAngle = _masterRotateAngle;

- (id)initWithStyle:(CWAnimatedMenuStyle)style position:(CWAnimatedMenuPosition)pos
{
  self = [self initWithOrbitalRadius:0 Gap:0 beginAngle:0 endAngle:180 frame:CGRectZero];
  self.style = style;
  self.position = pos;
  self.animationDuration = 0.3;
  [self setNeedsAngles];
  return self;
}

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

- (id)initWithGap:(CGFloat)gap beginAngle:(CGFloat)beginAngle endAngle:(CGFloat)endAngle frame:(CGRect)frame
{
  return  [self initWithOrbitalRadius:0.0 Gap:gap beginAngle:beginAngle endAngle:endAngle frame:frame];
}

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

- (id)initWithOrbitalRadius:(CGFloat)radius Gap:(CGFloat)gap beginAngle:(CGFloat)beginAngle 
                   endAngle:(CGFloat)endAngle frame:(CGRect)frame;
{
    self = [super initWithFrame:frame];
    if (self) {
      self.backgroundColor = [UIColor whiteColor];
      
      //orbital attributes
      self.gap = gap;
      self.radius = radius;
      self.beginAngle = beginAngle;
      self.endAngle = endAngle;
      self.expandDistanceScale = 1.3;
      //default style and position
      self.style = CWAnimatedMenuExpansion;
      self.position = CWAnimatedMenuBottomLeft;
      self.elemCount = 0;
      
      //initialize flag value
      _menuFlag.isAnimating = NO;
      _menuFlag.isExpanded = NO;
      
      //if you want to change the scale of enlarge animation of menu button. then set its value.
      self.scale = CW_MENU_DEFAULT_SCALE;
      
      self.animationDuration = 0;
      self.animationDelay = 0.015;
      
      //if the position style is customized then we need to set the customMasterCenter
      self.customMasterCenter = CGPointZero;
      
      self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin |UIViewAutoresizingFlexibleLeftMargin;
      
      //set it NO to disable the animation of master button
      self.masterButtonAnimationEnabled = YES; 
      
      //master rotation animation angle
      self.masterRotateAngle = -45;
    }
    return self;
}

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

- (void)dealloc {
  [_masterButtonItem release];
  [_menuButtonItems release];
  [super dealloc];
}

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

- (void)willMoveToSuperview:(UIView *)newSuperview
{
  [super willMoveToSuperview:newSuperview];
  
  [self initializeMenubuttonItemsAttribute];
  
  //make sure the master button is set
  NSAssert((self.masterButtonItem), @"Master button is not set");
  [self placeToStylePosition];
}


/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

-(void)setMenuItem:(CWAnimatedMenuItem *)menuItem
{
  CWAnimatedMenuButton *menuButton = [[CWAnimatedMenuButton alloc] initWithCWAnimatedMenuItem:menuItem];
  [menuButton addTarget:self action:@selector(menuButtonTouchAction) forControlEvents:UIControlEventTouchUpInside];
  
  [self.menuButtonItems addObject:menuButton];
  self.elemCount += 1;
  // sort the item by tage because we need to ensure the items is an ancending order
  if (self.elemCount > 1)
    [self SortMenuItemsByTag];
  
  [self insertSubview:menuButton atIndex:1];
  [menuButton release];
}

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

- (void)setMasterItem:(CWAnimatedMenuItem *)masterItem
{
  if (_masterButtonItem){
    [self.masterButtonItem removeFromSuperview];
    self.masterButtonItem = nil;
  }
  _masterButtonItem = [[CWAnimatedMenuButton alloc] initWithCWAnimatedMenuItem:masterItem];
  [_masterButtonItem addTarget:self action:@selector(masterButtonTouchAction) forControlEvents:UIControlEventTouchUpInside];
  [self insertSubview:_masterButtonItem atIndex:2];
}

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

- (NSMutableArray *)menuButtonItems{
  if (!_menuButtonItems){
    _menuButtonItems = [[NSMutableArray alloc] init];
  }
  return _menuButtonItems;
}

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 


-(void)addSubview:(UIView *)view
{
  [super insertSubview:view atIndex:0];
}

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

- (void)disableSubViewUserInteraction:(UIView *)view
{
  view.userInteractionEnabled = NO;
}

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

- (void)enableSubViewUserInteraction:(UIView *)view
{
  view.userInteractionEnabled = YES;
}

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

- (void)enableMasterButton
{
  self.masterButtonItem.enabled = YES;
}

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

- (void)disableMasterButton
{
  self.masterButtonItem.enabled = NO;
}

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
  UIView *view = [super hitTest:point withEvent:event];
  if (_menuFlag.isExpanded){
    [self.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
      if (![obj isKindOfClass:[CWAnimatedMenuButton class]]){
        UIView *view = obj;
        [self disableSubViewUserInteraction:view];
        [self performSelector:@selector(enableSubViewUserInteraction:) withObject:view afterDelay:self.animationDuration];
      }
    }];
    
    if (![view isKindOfClass:[CWAnimatedMenuButton class]]){
      [self performSelector:@selector(masterButtonTouchAction)];
    }
  }
  return view;
}

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

- (CGFloat)animationDuration
{
  return (_animationDuration == 0)?  0.25 + self.elemCount * (self.animationDelay + 0.01) : _animationDuration;
}

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

- (void)setCustomMasterCenter:(CGPoint)customMasterCenter
{
  _customMasterCenter = customMasterCenter;
  if (self.superview){
    [self setNeedsButtonPositioning];
  }
}

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

- (void)setNeedsButtonPositioning
{
  [self placeToStylePosition];
}

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

- (BOOL)isExpanded
{
  return _menuFlag.isExpanded;
}


/*///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////*/ 
#pragma mark -
#pragma mark private method

-(void)resetIfMenuButtonSelected
{
  //reset the attribute of every menu items.
  for (CWAnimatedMenuButton *aButton in self.menuButtonItems) {
    aButton.hidden = YES;
    aButton.alpha = 1;
    aButton.center = aButton.originalCenter;
    aButton.transform = CGAffineTransformIdentity;
  }
  _menuFlag.isExpanded = NO;
}

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 


- (void)animateIfTouchMenuButton:(CWAnimatedMenuButton *)button
{
  [UIView animateWithDuration:0.4 animations:^{
    //scale the selected button by a scale value
    button.transform = CGAffineTransformMakeScale(self.scale, self.scale);
    button.alpha = 0.01;
    self.masterButtonItem.transform = CGAffineTransformIdentity;
    for (CWAnimatedMenuButton *otherButton in self.menuButtonItems) {
      if (button.tag != otherButton.tag){
        otherButton.transform = CGAffineTransformMakeScale(0.01, 0.01);
        otherButton.alpha = 0.01;
      }
    }
  } completion:^(BOOL finished) {
    [self resetIfMenuButtonSelected];
  }];

}

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

- (void)menuButtonTouchAction
{
  for (CWAnimatedMenuButton *button in self.menuButtonItems) {
    if (button.isTouchInside){
      if ([self respondsToSelector:@selector(menuButton:touchForControlEvent:)]){
        [self performSelector:@selector(menuButton:touchForControlEvent:) withObject:button
                   withObject:[NSNumber numberWithInt:UIControlEventTouchUpInside]];
      }
      break;
    }
  }
}

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

- (void)menuButton:(CWAnimatedMenuButton *)button touchForControlEvent:(NSNumber *)numObj
{
  if ([numObj intValue] == UIControlEventTouchUpInside){
    
    [self animateIfTouchMenuButton:button];
    if ([_delegate respondsToSelector:@selector(menuView:withSelectedButton:)]){
      [_delegate performSelector:@selector(menuView:withSelectedButton:) withObject:self withObject:button];
    }
  }
}

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

- (CGFloat)predictArcLength
{
  CGFloat predictArcLength = 0.0;
  NSUInteger elemsCount = self.elemCount;
  NSUInteger diffAngle = self.endAngle - self.beginAngle;
  // this for a rough prediction of arc length.
  // we want to calculate the radius of orbit on which every menu button is not collide with each other.
  for (NSUInteger idx = 0; idx < elemsCount; idx++) {
    CWAnimatedMenuButton *elem = [self.menuButtonItems objectAtIndex:idx];
    if ((idx == 0 || idx == elemsCount - 1) && (diffAngle % 360 != 0)){
      // if the button is the first and last position , we just need its half of width. In this case called radius.
      predictArcLength += elem.radius;
    }else{
      predictArcLength += (elem.radius * 2);
    }
  }
  
  // if the gap value is set, then adding in the predictArcLength value.
  return predictArcLength + (elemsCount - 1) * self.gap;
}

/*-----------------------------------------------------------------------------------------------------------------------------------*/

- (CGFloat)radiusOfButtonAtIndex:(NSUInteger)idx
{
  return [[self.menuButtonItems objectAtIndex:idx] radius];
}

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

- (NSArray *)angleSectorsWithDegreePerUnit:(CGFloat)degreePerUnit
{
  // If there is a button with different size, we need to assign a different sector angle for that button
  // This is why we are using the arc length * degree per unit to calculate
  
  NSUInteger elemsCount = self.elemCount;
  NSMutableArray *sectors = [NSMutableArray arrayWithCapacity:elemsCount - 1];
  CGFloat previousValue = [self radiusOfButtonAtIndex:0];
  
  // calculate the value of each sector angle. sector angle means the angle between two buttons at the master button.
  for (NSUInteger idx = 1; idx < elemsCount; idx++) {
    CGFloat nextValue = [self radiusOfButtonAtIndex:idx];
    // use the rough predict arc multiple with the value of degree per pixel.
    // degreePerUnit can be obtained by calculating the difference of beginAngle and endAngle.
    CGFloat sectorAngle = (nextValue + previousValue + self.gap) * degreePerUnit;
    [sectors addObject:[NSNumber numberWithFloat:sectorAngle]];
    previousValue = nextValue;
  }
  
  return sectors;
}

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

- (void)prepareButtonAngle:(NSArray *)sectors
{
  NSUInteger idx = 0;
  CGFloat sumOfAngle = self.endAngle;
  
  // Every button has it own angle, we have to set it for later use.
  for (CWAnimatedMenuButton *elem in self.menuButtonItems) {
    
    if (idx == 0){
      elem.angle = self.endAngle;
    }else{
      NSNumber *num = [sectors objectAtIndex:idx - 1];
      sumOfAngle -= [num floatValue];
      elem.angle = sumOfAngle;
    }
    idx++;
    
  }
}

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

- (void)initializeMenubuttonItemsAttribute
{  
  //if only one button, no need to calculate the sector angle
  if (self.menuButtonItems.count  <= 1){
    return;
  }
  
  //calcuate the basic information
  CGFloat predictArcLength = [self predictArcLength];
  CGFloat angle = fabs(self.endAngle - self.beginAngle);
  CGFloat degreePerUnit = angle / predictArcLength;
  NSArray *sector = [self angleSectorsWithDegreePerUnit:degreePerUnit];

  // initalize the button angle for later use.
  [self prepareButtonAngle:sector];
  
  // calculate the minimum value of orbital radius.
  if (self.radius == 0.0){
    CGFloat sectorAngleInDegree = [[sector objectAtIndex:0] floatValue];
    CGFloat sectorAngle = DEGREES_TO_RADIANS(sectorAngleInDegree);
    CGFloat baseAngle = DEGREES_TO_RADIANS((180 - sectorAngleInDegree) / 2);
    CGFloat length = [self radiusOfButtonAtIndex:0] + [self radiusOfButtonAtIndex:1] + self.gap;
    self.radius = (length / sinf(sectorAngle)) * sinf(baseAngle);
  }
}


/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

- (void)SortMenuItemsByTag
{
  // make sure the menu items is in ancending order.
  [self.menuButtonItems sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
    CWAnimatedMenuButton * button1 = obj1;
    CWAnimatedMenuButton * button2 = obj2;
    if (button1.tag > button2.tag){
      return YES;
    }
    return NO;
  }];
}

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

- (void)placeMenuButtonItemsByStyle:(CWAnimatedMenuStyle)style
{

  CGFloat radius = self.radius;
  CGPoint masterCenter = self.masterButtonItem.center;
  
  //according to the animation style, place each menu button in the orbital location.
  for (CWAnimatedMenuButton *button in self.menuButtonItems) {
    button.radius = radius;
    
    CGFloat radianAngle = DEGREES_TO_RADIANS(button.angle);
    CGFloat xCosValue = radius * cosf(radianAngle);
    CGFloat ySinValue = radius * sinf(radianAngle);
    CGFloat centerXOffset = masterCenter.x + xCosValue;
    CGFloat centerYOffset = masterCenter.y - ySinValue;
    button.destCenter = CGPointMake(centerXOffset, centerYOffset);
    
    if (style == CWAnimatedMenuFadeOut){
      button.originalCenter = button.destCenter;
      [button moveToDestination:YES];
    }else{
      button.originalCenter = self.masterButtonItem.center;
    }
    
    //the menu button should hidden at first.
    button.hidden = YES;
  }
}

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

- (void)setNeedsAngles
{
  //base on the style of positioning. place the master button in specific location
  switch (self.position) {
    case CWAnimatedMenuTopLeft:{
      self.beginAngle = 270;
      self.endAngle = 360;
    }
      break;
    case CWAnimatedMenuTopCenter:{
      self.beginAngle = 200;
      self.endAngle = 340;
    }
      break;
    case CWAnimatedMenuTopRight:{
      self.beginAngle = 180;
      self.endAngle = 270;
    }
      break;
    case CWAnimatedMenuMiddleCenter:{
      self.beginAngle = 0;
      self.endAngle = 360;
    }
      break;
    case CWAnimatedMenuBottomLeft:{
      self.beginAngle = 0;
      self.endAngle = 90;
    }
      break;
    case CWAnimatedMenuBottomCenter:{
      self.beginAngle = 20;
      self.endAngle = 160;
    }
      break;
    case CWAnimatedMenuBottomRight:{
      self.beginAngle = 90;
      self.endAngle = 180;
    }
      break;
    default:{
      self.beginAngle = 0; 
      self.endAngle = 180;
    }
      break;
  }
}

/*-----------------------------------------------------------------------------------------------------------------------------------*/  

- (void)placeMasterButtonToTopLeft{

  CGFloat xOffset = CW_MENU_PADDING;
  CGFloat yOffset = CW_MENU_PADDING;
  self.masterButtonItem.origin = CGPointMake(xOffset, yOffset);
}


/*-----------------------------------------------------------------------------------------------------------------------------------*/  

- (void)placeMasterButtonToTopCenter{
  CGFloat xOffset = (self.bounds.size.width - self.masterButtonItem.radius * 2) / 2;
  CGFloat yOffset = CW_MENU_PADDING;
  self.masterButtonItem.origin = CGPointMake(xOffset, yOffset);
}

/*-----------------------------------------------------------------------------------------------------------------------------------*/  

- (void)placeMasterButtonToTopRight{
  CGFloat xOffset = self.bounds.size.width - self.masterButtonItem.radius * 2 - CW_MENU_PADDING;
  CGFloat yOffset = CW_MENU_PADDING;
  self.masterButtonItem.origin = CGPointMake(xOffset, yOffset);
}

/*-----------------------------------------------------------------------------------------------------------------------------------*/  

- (void)placeMasterButtonToMiddleCenter{
  self.masterButtonItem.center = self.center;
}

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

- (void)placeMasterButtonToBottomLeft{
  CGRect frame = self.masterButtonItem.frame;
  CGFloat xOffset = CW_MENU_PADDING;
  CGFloat yOffset = self.bounds.size.height - frame.size.height - CW_MENU_PADDING;
  self.masterButtonItem.origin = CGPointMake(xOffset, yOffset);
}


/*-----------------------------------------------------------------------------------------------------------------------------------*/  

- (void)placeMasterButtonToBottomCenter{
  CGRect frame = self.masterButtonItem.frame;
  CGFloat xOffset = (self.bounds.size.width - self.masterButtonItem.radius * 2) / 2;
  CGFloat yOffset = self.bounds.size.height - frame.size.height - CW_MENU_PADDING;
  self.masterButtonItem.origin = CGPointMake(xOffset, yOffset);
}

/*-----------------------------------------------------------------------------------------------------------------------------------*/  

- (void)placeMasterButtonToBottomRight{
  CGRect frame = self.masterButtonItem.frame;
  CGFloat xOffset = self.bounds.size.width - self.masterButtonItem.radius * 2 - CW_MENU_PADDING;
  CGFloat yOffset = self.bounds.size.height - frame.size.height - CW_MENU_PADDING;
  self.masterButtonItem.origin = CGPointMake(xOffset, yOffset);
}

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

- (void)placeToStylePosition
{
  //base on the style of positioning. place the master button in specific location
  switch (self.position) {
    case CWAnimatedMenuTopLeft:
      [self placeMasterButtonToTopLeft];
      break;
    case CWAnimatedMenuTopCenter:
      [self placeMasterButtonToTopCenter];
      break;
    case CWAnimatedMenuTopRight:
      [self placeMasterButtonToTopRight];
      break;
    case CWAnimatedMenuMiddleCenter:
      [self placeMasterButtonToMiddleCenter];
      break;
    case CWAnimatedMenuBottomLeft:
      [self placeMasterButtonToBottomLeft];
      break;
    case CWAnimatedMenuBottomCenter:
      [self placeMasterButtonToBottomCenter];
      break;
    case CWAnimatedMenuBottomRight:
      [self placeMasterButtonToBottomRight];
      break;
    default:{
       self.masterButtonItem.center = self.customMasterCenter;
    }
      break;
  }

  [self placeMenuButtonItemsByStyle:self.style];
}

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

- (CGAffineTransform )resizeWithScale:(CGFloat)scale
{
  return CGAffineTransformMake(scale, 0, 0, scale, 0, 0);
}

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

- (void)animationComplete
{
  _menuFlag.isAnimating = NO;
}

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

- (void)animationStart
{
  _menuFlag.isAnimating = YES;
}

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

- (void)animateExpandStyle
{
  if (self.animationDuration == 0){
    self.animationDuration = 0.25 + self.elemCount * self.animationDelay;
  }
  
  [self.menuButtonItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    CWAnimatedMenuButton *button = obj;
    button.maxDuration = self.animationDuration;
    button.expandFactor = self.expandDistanceScale;
    [button animateExpandAtBeginTime:(idx * self.animationDelay) withReverse:NO];
  }];
  
  [self performSelector:@selector(animationComplete) withObject:nil afterDelay:self.animationDuration + 0.15];
}

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

- (void)reverseAnimateExpandStyle
{
  
  for (NSUInteger i = self.elemCount, j = 0; i > 0; i--, j++) {
    CWAnimatedMenuButton *button = [self.menuButtonItems objectAtIndex:i - 1];
    button.expandFactor = self.expandDistanceScale;
    [button animateExpandAtBeginTime:(j * (self.animationDelay + 0.01)) withReverse:YES];
  }
  
  [self performSelector:@selector(animationComplete) withObject:nil afterDelay:self.animationDuration + 0.15];
}

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

- (void)animateFadeOutWithButton:(CWAnimatedMenuButton *)button animateAfterDelay:(NSTimeInterval)delay reverse:(BOOL)reverse
{
  // animate the fade out style 
  NSUInteger step = (reverse)? -1 : 1;
  CGFloat startAlpha = 0.01;
  CGFloat endAplha = 1;
  BOOL nextAnimate = ((button.tag < self.elemCount && !reverse) || (button.tag - 1 > 0 && reverse))? YES : NO;
  
  if (!reverse){
    CGFloat animationTime = (self.animationDuration == 0)? 0.1: self.animationDuration / 3;
    
    button.hidden = NO;
    button.alpha = startAlpha;
    button.transform = [self resizeWithScale:0.001];
    [UIView animateWithDuration:animationTime
                          delay:delay 
                        options:UIViewAnimationOptionCurveEaseIn 
                     animations:^{
                       button.alpha = endAplha;
                       button.transform = [self resizeWithScale:1.1];
                     } completion:^(BOOL finished) {
                       [UIView animateWithDuration:animationTime
                                        animations:^{
                                          button.transform = [self resizeWithScale:0.8];
                                        } completion:^(BOOL finished) {
                                          [UIView animateWithDuration:animationTime
                                                           animations:^{
                                                             button.transform = CGAffineTransformIdentity;
                                                           } completion:^(BOOL finished) {
                                                             if (!nextAnimate){
                                                               [self performSelector:@selector(animationComplete)];
                                                             }
                                                           }];
                                        }];
                     }];

  }else{
    CGFloat animationTime = (self.animationDuration == 0)? 0.15: self.animationDuration / 2;
    button.alpha = endAplha;
    [UIView animateWithDuration:animationTime
                          delay:delay 
                        options:UIViewAnimationOptionCurveEaseIn 
                     animations:^{
                       button.transform = [self resizeWithScale:1.3];
                     } completion:^(BOOL finished) {
                       [UIView animateWithDuration:animationTime
                                        animations:^{
                                          button.alpha = startAlpha;
                                          button.transform = [self resizeWithScale:0.001];
                                        } completion:^(BOOL finished) {
                                          if (!nextAnimate){
                                            [self performSelector:@selector(animationComplete)];
                                          }
                                          button.hidden = YES;
                                          button.transform = CGAffineTransformIdentity;
                                        }];
                     }];
  }
  
  if (nextAnimate){
    [self animateFadeOutWithButton:[self.menuButtonItems objectAtIndex:button.tag - 1 + step] 
                 animateAfterDelay:delay + self.animationDelay
                           reverse:reverse];
  }
  
}

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

- (void)reverseAnimateFadeOutStyle
{
  if (self.menuButtonItems.count == 0){
    return;
  }
  [self animateFadeOutWithButton:[self.menuButtonItems objectAtIndex:self.elemCount - 1] animateAfterDelay:0 reverse:YES];
}

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

- (void)animateFadeOutStyle
{
  if (self.menuButtonItems.count == 0){
    return;
  }
  [self animateFadeOutWithButton:[self.menuButtonItems objectAtIndex:0] animateAfterDelay:0 reverse:NO];
}

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

- (void)animateMenuButtonWithStyle:(CWAnimatedMenuStyle)style isReversed:(BOOL)reverse
{
  [self performSelector:@selector(animationStart)];
  //make sure the master button is in the front view
  [self bringSubviewToFront:self.masterButtonItem];
  
  switch (style) {
    case CWAnimatedMenuExpansion:
      if (reverse){
        [self reverseAnimateExpandStyle];
      }else{
        [self animateExpandStyle];
      }
      break;
      
    case CWAnimatedMenuFadeOut:
      if (reverse){
        [self reverseAnimateFadeOutStyle];
      }else{
        [self animateFadeOutStyle];
      }
      break;
  }
  _menuFlag.isExpanded = !reverse;
}

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

- (void)animateMasterButtonWithExpand:(BOOL)expand withAngle:(CGFloat)angle duration:(CGFloat)duration
{

  [UIView animateWithDuration:duration animations:^{
      CGFloat degree = (expand)? 0: angle;
    self.masterButtonItem.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(degree));
  } completion:^(BOOL finished) {
  }];
}

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

- (void)masterButtonTouchAction
{
  if (!_menuFlag.isAnimating){
    // if it has been expand then reverse the animation.
    BOOL reverse = _menuFlag.isExpanded;
    if (self.masterButtonAnimationEnabled){
      [self animateMasterButtonWithExpand:reverse withAngle:self.masterRotateAngle duration:0.3];
    }
    [self animateMenuButtonWithStyle:self.style isReversed:reverse];
  }
}

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

- (void)moveMenuButtonsBack
{
  [self masterButtonTouchAction];
}

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

- (void)setMasterButtonAlpha:(CGFloat)alpha
{
  self.masterButtonItem.alpha = alpha;
}

@end
