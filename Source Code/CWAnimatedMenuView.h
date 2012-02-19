//
//  CWAnimatedMenuView.h
//  CWAnimatedControlView
//
//  Created by Ku4n Cheang on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//  Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php

#import <UIKit/UIKit.h>
#import "CWAnimatedMenuButton.h"
#import "CWImageDelegate.h"
typedef enum {
  CWAnimatedMenuFadeOut,
  CWAnimatedMenuExpansion,
} CWAnimatedMenuStyle;

typedef enum {
  CWAnimatedMenuTopLeft,
  CWAnimatedMenuTopCenter,
  CWAnimatedMenuTopRight,
  CWAnimatedMenuMiddleCenter,
  CWAnimatedMenuBottomLeft,
  CWAnimatedMenuBottomCenter,
  CWAnimatedMenuBottomRight,
  CWAnimatedMenuCustom

} CWAnimatedMenuPosition;

@protocol CWAnimateMenuDelegate;


@interface CWAnimatedMenuView : UIView{
@public
  id <CWAnimateMenuDelegate> _delegate;
  
@package 
  CWAnimatedMenuButton *_masterButtonItem;
  NSMutableArray *_menuButtonItems;
  
  struct {
    unsigned int isExpanded:1;
    unsigned int isAnimating:1;
  } _menuFlag;
  
}
@property (nonatomic, assign) id<CWAnimateMenuDelegate> delegate;
@property (nonatomic, assign) CWAnimatedMenuItem *masterItem;
@property (nonatomic, assign) CWAnimatedMenuItem *menuItem;

@property (nonatomic) CGFloat gap;
@property (nonatomic) CGFloat beginAngle;
@property (nonatomic) CGFloat endAngle;
@property (nonatomic) CGFloat radius;
@property (nonatomic) CGFloat animationDuration;
@property (nonatomic) CGFloat expandDistanceScale;
@property (nonatomic) CGFloat animationDelay;
@property (nonatomic) CGFloat masterRotateAngle;
@property (nonatomic) CWAnimatedMenuStyle style;
@property (nonatomic) CWAnimatedMenuPosition position;
@property (nonatomic, setter = setScaleFactorIfButtonSelected:) CGFloat scale;
@property (nonatomic) CGPoint customMasterCenter;
@property (nonatomic) BOOL masterButtonAnimationEnabled;
@property (nonatomic, readonly) BOOL isExpanded;


- (id)initWithStyle:(CWAnimatedMenuStyle)style position:(CWAnimatedMenuPosition)pos;
/*///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////*/ 

- (id)initWithOrbitalRadius:(CGFloat)radius Gap:(CGFloat)gap beginAngle:(CGFloat)beginAngle
                   endAngle:(CGFloat)endAngle frame:(CGRect)frame;

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

- (id)initWithGap:(CGFloat)gap beginAngle:(CGFloat)beginAngle endAngle:(CGFloat)endAngle frame:(CGRect)frame;

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

- (void)setNeedsButtonPositioning;

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

- (void)moveMenuButtonsBack;

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

- (void)setMasterButtonAlpha:(CGFloat)alpha;

@end

/*///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////*/ 

@protocol CWAnimateMenuDelegate <NSObject>
- (void)menuView:(CWAnimatedMenuView *)view withSelectedButton:(CWAnimatedMenuButton *)button; 
@end
