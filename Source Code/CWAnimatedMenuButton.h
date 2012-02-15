//
//  CWAminatedMenuButton.h
//  CWAnimatedControlView
//
//  Created by Ku4n Cheang on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import "CWAnimatedMenuItem.h"

@interface CWAnimatedMenuButton : UIButton{
}

@property (nonatomic) CGFloat radius;
@property (nonatomic) CGFloat angle;
@property (nonatomic) CGPoint origin;
@property (nonatomic) CGPoint destCenter;
@property (nonatomic) CGPoint originalCenter;
@property (nonatomic) CGFloat expandFactor;
@property (nonatomic, setter = moveToDestination:, getter = isMoved) BOOL move;
@property (nonatomic) BOOL reverse;
@property (nonatomic) CGFloat maxDuration;

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

- (id)initWithCWAnimatedMenuItem:(CWAnimatedMenuItem *)item;

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

- (void)animateExpandAtBeginTime:(float)beginTime withReverse:(BOOL)reverse;

@end
