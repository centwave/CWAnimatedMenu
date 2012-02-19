//
//  CWAnimatedMenuController.h
//  CWAnimatedControlView
//
//  Created by Ku4n Cheang on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//  Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php

#import <UIKit/UIKit.h>
#import "CWAnimatedMenuView.h"

@interface CWAnimatedMenuController : UIViewController <CWAnimateMenuDelegate>

@property (nonatomic, readonly) CWAnimatedMenuView *menuView;

- (id)initWithMenuItems:(NSArray *)items;

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

- (id)initWithMenuItems:(NSArray *)items style:(CWAnimatedMenuStyle)style position:(CWAnimatedMenuPosition)pos;

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

- (id)initWithMenuItems:(NSArray *)items radius:(CGFloat)radius gap:(CGFloat)gap beginAngle:(CGFloat)aAngle endAngle:(CGFloat)bAngle 
                  style:(CWAnimatedMenuStyle)style position:(CWAnimatedMenuPosition)pos;

@end
