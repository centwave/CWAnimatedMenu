//
//  CWAnimatedMenuButtonItem.h
//  CWAnimatedControlView
//
//  Created by Ku4n Cheang on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface CWAnimatedMenuItem : NSObject{
  NSString *_title;
  NSUInteger _tag;
}

@property (nonatomic, readonly) NSString *title;
@property (nonatomic, assign) NSUInteger tag;
@property (nonatomic, readonly) UIImage *normalImage;
@property (nonatomic, readonly) UIImage *pressedImage;


- (id)initMasterButtonWithImage:(UIImage *)image pressedImage:(UIImage *)pressedImage;

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

- (id)initWithImage:(UIImage *)image PressedImage:(UIImage *)pressedImage tag:(NSUInteger)tag;

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

- (id)initMasterButtonWithImage:(UIImage *)image;

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

- (id)initMasterButtonWithTitle:(NSString *)title image:(UIImage *)image;

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

- (id)initWithTitle:(NSString *)title image:(UIImage *)image tag:(NSUInteger)tag;

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

- (id)initWithImage:(UIImage *)image tag:(NSUInteger)tag;

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

- (id)initWithTitle:(NSString *)title normalStateImage:(UIImage *)normImg pressedStateImage:(UIImage *)pressedImg tag:(NSUInteger)tag;

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

@end