//
//  animatedMenuController.m
//  CWAnimatedControlView
//
//  Created by Ku4n Cheang on 16/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "animatedMenuController.h"

@implementation animatedMenuController

// customized menu view 
- (id)initWithMenuItems:(NSArray *)items
{
  self = [super initWithMenuItems:items];
  if (self){
    //config the animated menu attributes.
    
    // you don't need to set a radius, it will automatically calculate
    //the minimum radius for menu buttons without colliding with others
//    self.menuView.radius = 125;
    
    // whole animation duration. 
    self.menuView.animationDuration = 0.3;
    // the delay for next button animate.
    self.menuView.animationDelay = 0.02;
    
    // two style support, fadeOut and expansion
    self.menuView.style = CWAnimatedMenuExpansion;
    
    // the position for master button.
    // if you set the position of menu view, you no need to set the begin angle and end angle.
    // However, if you want to do so, then it uses your beginAngle and endAngle value to arrange the menu buttons
    self.menuView.position = CWAnimatedMenuBottomLeft;
    
    self.menuView.beginAngle = 0;
    self.menuView.endAngle = 90;
    
    // the distance between two buttons along the orbit.
    // if you set the radius, then it will not take any effect.
//    self.menuView.gap = 20;
    
    // if master button animation enabled then you can set the value of degree for rotation animation.
    // the default value is -45
    self.menuView.masterRotateAngle = -90;
    
    // disable the master button animation
//    self.menuView.masterButtonAnimationEnabled = NO;
  }
  return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

- (void)menuView:(CWAnimatedMenuView *)view withSelectedButton:(CWAnimatedMenuButton *)button
{
  NSLog(@"button with tag:%d is touched", button.tag);
}

@end
