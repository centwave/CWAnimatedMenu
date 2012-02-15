//
//  CWViewController.m
//  CWAnimatedControlView
//
//  Created by Ku4n Cheang on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CWViewController.h"
@interface CWViewController ()

@end

@implementation CWViewController

- (void)menuView:(CWAnimatedMenuView *)view withSelectedButton:(CWAnimatedMenuButton *)button
{
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  UIImage *addImage = [UIImage imageNamed:@"story-add-button.png"];
  UIImage *addPressImage = [UIImage imageNamed:@"story-add-plus-pressed.png"];
  UIImage *buttonImage = [UIImage imageNamed:@"story-button.png"];
  UIImage *camera = [UIImage imageNamed:@"story-camera.png"];
  UIImage *music = [UIImage imageNamed:@"story-music.png"];
  UIImage *people = [UIImage imageNamed:@"story-people.png"];
  UIImage *place = [UIImage imageNamed:@"story-place.png"];
  UIImage *sleep = [UIImage imageNamed:@"story-sleep.png"];
  UIImage *thought = [UIImage imageNamed:@"story-thought.png"];
  
  
  CWAnimatedMenuView * view = [[CWAnimatedMenuView alloc] initWithStyle:CWAnimatedMenuExplode position:CWAnimatedMenuBottomLeft];
  view.masterItem = [[[CWAnimatedMenuItem alloc] initMasterButtonWithImage:[self imageButtonWithBackGround:addImage frontImage:addPressImage]] autorelease];
  view.menuItem = [[[CWAnimatedMenuItem alloc] initWithImage:[self imageButtonWithBackGround:buttonImage frontImage:camera] tag:1] autorelease];
  view.menuItem = [[[CWAnimatedMenuItem alloc] initWithImage:[self imageButtonWithBackGround:buttonImage frontImage:music] tag:2] autorelease];
  view.menuItem = [[[CWAnimatedMenuItem alloc] initWithImage:[self imageButtonWithBackGround:buttonImage frontImage:people] tag:3]autorelease];
  view.menuItem = [[[CWAnimatedMenuItem alloc] initWithImage:[self imageButtonWithBackGround:buttonImage frontImage:place] tag:4]autorelease];
  view.menuItem = [[[CWAnimatedMenuItem alloc] initWithImage:[self imageButtonWithBackGround:buttonImage frontImage:sleep] tag:5]autorelease];
  view.menuItem = [[[CWAnimatedMenuItem alloc] initWithImage:[self imageButtonWithBackGround:buttonImage frontImage:thought] tag:6]autorelease];
  view.delegate = self;
  self.view = view;
  [view release];
//  
  UITableView * tableview = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
  [self.view addSubview:tableview];
  [tableview release];
	// Do any additional setup after loading the view, typically from a nib.
  
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
