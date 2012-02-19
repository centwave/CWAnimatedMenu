//
//  CWImage.m
//  CWAnimatedControlView
//
//  Created by Ku4n Cheang on 15/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//  Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php

#import "CWImageDelegate.h"

@implementation UIImage (CWImageDelegate)

// combine two images into one in order to create a new image
+ (UIImage *)imageButtonWithBackGround:(UIImage *)backgroundImage frontImage:(UIImage *)frontImage
{
  CGFloat backgroundWidth = backgroundImage.size.width;
  CGFloat backgroundHeight = backgroundImage.size.height;
  CGFloat frontWidth = frontImage.size.width;
  CGFloat frontHeight = frontImage.size.height;
  
  UIGraphicsBeginImageContextWithOptions(CGSizeMake(backgroundWidth, backgroundHeight), false, 0);
  CGContextRef context = UIGraphicsGetCurrentContext();
  
  UIGraphicsPushContext(context);
  [backgroundImage drawAtPoint:CGPointZero];
  [frontImage drawAtPoint:CGPointMake((backgroundWidth - frontWidth) / 2, (backgroundHeight - frontHeight) / 2)];
  UIGraphicsPopContext();                             
  
  // get a UIImage from the image context
  UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
  
  // clean up drawing environment
  UIGraphicsEndImageContext();
  
  return newImage;
}

@end
