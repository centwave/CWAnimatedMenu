//
//  CWAnimatedMenuButtonItem.m
//  CWAnimatedControlView
//
//  Created by Ku4n Cheang on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//  Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php


#import "CWAnimatedMenuItem.h"

typedef struct ImageSet{
  UIImage *normalStateImage;
  UIImage *pressedStateImage;
}UIImageSet;

@interface CWAnimatedMenuItem(){
  UIImageSet *_imageSet;
}
- (UIImageSet *)newImageSet;
- (void)releaseImageSet;
- (BOOL)isNULL:(id)obj;
@end

/*///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////*/ 

@implementation CWAnimatedMenuItem
@synthesize tag = _tag;
@synthesize title = _title;


- (id)initMasterButtonWithImage:(UIImage *)image pressedImage:(UIImage *)pressedImage
{
  return [self initWithTitle:nil normalStateImage:image pressedStateImage:pressedImage tag:0];
}


/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

- (id)initMasterButtonWithImage:(UIImage *)image
{
  return [self initWithTitle:nil normalStateImage:image pressedStateImage:nil tag:0];
}

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

- (id)initMasterButtonWithTitle:(NSString *)title image:(UIImage *)image
{

  return [self initWithTitle:title normalStateImage:image pressedStateImage:nil tag:0];
}

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

- (id)initWithTitle:(NSString *)title image:(UIImage *)image tag:(NSUInteger)tag
{
  
  return [self initWithTitle:title normalStateImage:image pressedStateImage:nil tag:tag];
}

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

- (id)initWithImage:(UIImage *)image tag:(NSUInteger)tag
{
  return [self initWithTitle:nil normalStateImage:image pressedStateImage:nil tag:tag];
}

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

- (id)initWithImage:(UIImage *)image PressedImage:(UIImage *)pressedImage tag:(NSUInteger)tag
{
  return [self initWithTitle:nil normalStateImage:image pressedStateImage:pressedImage tag:tag];
}

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

- (id)initWithTitle:(NSString *)title normalStateImage:(UIImage *)normImg pressedStateImage:(UIImage *)pressedImg tag:(NSUInteger)tag
{
  self =[super init];
  if (self){
    _title = [title copy];
    _imageSet = [self newImageSet];
    _imageSet->normalStateImage = [normImg retain];
    _imageSet->pressedStateImage = [pressedImg retain];
    self.tag = tag;
  }
  return self;
}

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

- (void)dealloc
{
  [self releaseImageSet];
  [_title release];
  [super dealloc];
}

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

- (UIImage *)normalImage{
  UIImage *image = nil;
  if (_imageSet){
    image = _imageSet->normalStateImage;
  }
  return image;
}

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

- (UIImage *)pressedImage{
  UIImage *image = nil;
  if (_imageSet){
    image = _imageSet->pressedStateImage;
  }
  return image;
}

/*///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////*/ 

#pragma mark -
#pragma mark private method

- (UIImageSet *)newImageSet
{
  UIImageSet *imageSet =  malloc(sizeof(UIImageSet));
  NSAssert((imageSet != nil), @"image Set fail to malloc");
  return imageSet;
}

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

- (void)releaseImageSet
{
  if (_imageSet != nil){
    if (![self isNULL:_imageSet->normalStateImage]){
      [_imageSet->normalStateImage release];
    }
    if (![self isNULL:_imageSet->pressedStateImage]){
      [_imageSet->pressedStateImage release];
    }
    free(_imageSet);
  }
}

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

- (BOOL)isNULL:(id)obj
{
  if (obj != nil){
    return NO;
  }
  return YES;
}

/*-----------------------------------------------------------------------------------------------------------------------------------*/ 

@end
