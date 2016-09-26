//
//  HelpTool.h
//  cheba
//
//  Created by Ding on 14-10-9.
//  Copyright (c) 2014年 Ding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageHelpTool : NSObject

+ (UIImage *)scaleImage:(UIImage *)image;
+ (UIImage *)scaleAvatar:(UIImage *)avatar;
+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize;
+ (UIImage *)scaleImagexy:(UIImage *)image toScalexy:(CGSize )scaleSize;
+ (UIImage *)imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size;

+(void)showImage:(UIImageView*)avatarImageView;
+ (UIImage *)imageWithColor:(UIColor *)color;


@end
