//
//  CWAppDelegate.m
//  CWAnimatedControlView
//
//  Created by Ku4n Cheang on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CWAppDelegate.h"
#import "animatedMenuController.h"


@implementation CWAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

- (void)dealloc
{
  [_window release];
  [_viewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
  // Override point for customization after application launch.
 
  UIImage *addImage = [UIImage imageNamed:@"story-add-button.png"];
  UIImage *addPressImage = [UIImage imageNamed:@"story-add-plus-pressed.png"];
  UIImage *buttonImage = [UIImage imageNamed:@"story-button.png"];
  UIImage *camera = [UIImage imageNamed:@"story-camera.png"];
  UIImage *music = [UIImage imageNamed:@"story-music.png"];
  UIImage *people = [UIImage imageNamed:@"story-people.png"];
  UIImage *place = [UIImage imageNamed:@"story-place.png"];
  UIImage *sleep = [UIImage imageNamed:@"story-sleep.png"];
  UIImage *thought = [UIImage imageNamed:@"story-thought.png"];
  
  NSMutableArray *array = [NSMutableArray array];
  [array addObject:[[[CWAnimatedMenuItem alloc] initMasterButtonWithImage:[UIImage imageButtonWithBackGround:addImage frontImage:addPressImage]] autorelease]];
  [array addObject:[[[CWAnimatedMenuItem alloc] initWithImage:[UIImage imageButtonWithBackGround:buttonImage frontImage:camera] tag:1] autorelease]];
  [array addObject:[[[CWAnimatedMenuItem alloc] initWithImage:[UIImage imageButtonWithBackGround:buttonImage frontImage:music] tag:2] autorelease]];
  [array addObject:[[[CWAnimatedMenuItem alloc] initWithImage:[UIImage imageButtonWithBackGround:buttonImage frontImage:people] tag:3]autorelease]];
  [array addObject:[[[CWAnimatedMenuItem alloc] initWithImage:[UIImage imageButtonWithBackGround:buttonImage frontImage:place] tag:4]autorelease]];
  [array addObject:[[[CWAnimatedMenuItem alloc] initWithImage:[UIImage imageButtonWithBackGround:buttonImage frontImage:sleep] tag:5]autorelease]];
  [array addObject:[[[CWAnimatedMenuItem alloc] initWithImage:[UIImage imageButtonWithBackGround:buttonImage frontImage:thought] tag:6]autorelease]];
  
  self.viewController = [[[animatedMenuController alloc] initWithMenuItems:array] autorelease];
  self.window.rootViewController = [[[UINavigationController alloc] initWithRootViewController:self.viewController] autorelease];
  [self.window makeKeyAndVisible];
  
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
