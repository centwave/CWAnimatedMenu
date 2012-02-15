//
//  CWAnimatedMenuController.m
//  CWAnimatedControlView
//
//  Created by Ku4n Cheang on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CWAnimatedMenuController.h"

@implementation CWAnimatedMenuController
@synthesize menuView = _menuView;

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

- (id)initWithMenuItems:(NSArray *)items style:(CWAnimatedMenuStyle)style position:(CWAnimatedMenuPosition)pos
{
  self = [super init];

  if (self) {
    CWAnimatedMenuView *view = [[CWAnimatedMenuView alloc] initWithStyle:style position:pos];
    
    if (items != nil){
      
      // set the menu items
      [items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CWAnimatedMenuItem *item = obj;
        if (item.tag == 0) {
          view.masterItem = item;
        }else {
          view.menuItem = item;
        }
      }];
      
    }
    
    view.delegate = self;
    self.view = view;
    [view release];
  }
  return self;
}

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

- (id)initWithMenuItems:(NSArray *)items
{
  return [self initWithMenuItems:items style:CWAnimatedMenuExpansion position:CWAnimatedMenuBottomLeft];
}

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

- (id)initWithMenuItems:(NSArray *)items radius:(CGFloat)radius gap:(CGFloat)gap beginAngle:(CGFloat)aAngle endAngle:(CGFloat)bAngle 
                  style:(CWAnimatedMenuStyle)style position:(CWAnimatedMenuPosition)pos
{
  self = [self initWithMenuItems:items style:style position:pos];
  self.menuView.beginAngle = aAngle;
  self.menuView.endAngle = bAngle;
  self.menuView.gap = gap;
  self.menuView.radius = radius;
  return self;
}

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
  [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
  // if menu is expanded, move the menu buttons to original position
  if ([self.menuView isExpanded]){
    [self.menuView moveMenuButtonsBack];
  }

  [self.menuView setMasterButtonAlpha:0];

}

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
  [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
  // it rotate move it to a new position
  [self.menuView setNeedsButtonPositioning];
  
  //fade in animation
  [UIView animateWithDuration:0.3 animations:^{
    [self.menuView setMasterButtonAlpha:1];
  } completion:^(BOOL finished) {
    
  }];
 
}

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

- (void)menuView:(CWAnimatedMenuView *)view withSelectedButton:(CWAnimatedMenuButton *)button
{

}

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

- (CWAnimatedMenuView *)menuView
{
  return (CWAnimatedMenuView *)self.view;
}

@end
