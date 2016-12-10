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

+ (void)showImage:(UIImageView*)avatarImageView;

// * 传入颜色，生成纯色的图片
//
+ (UIImage *)imageWithColor:(UIColor *)color;

// * 改变图片的颜色
//
+ (UIImage *)imageWithColor:(UIColor *)color andImage:(UIImage *)image;

@end
