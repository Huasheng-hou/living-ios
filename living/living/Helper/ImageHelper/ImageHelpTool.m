//
//  HelpTool.m
//  cheba
//
//  Created by Ding on 14-10-9.
//  Copyright (c) 2014年 Ding. All rights reserved.
//

#import "ImageHelpTool.h"
static CGRect oldframe;

@implementation ImageHelpTool

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGFloat imageW = 3;
    CGFloat imageH = 3;
    // 1.开启基于位图的图形上下文
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(imageW, imageH), NO, 0.0);
    // 2.画一个color颜色的矩形框
    [color set];
    UIRectFill(CGRectMake(0, 0, imageW, imageH));
    
    // 3.拿到图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 4.关闭上下文
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)scaleImage:(UIImage *)image
{
    CGSize  size = image.size;
    CGFloat scaleSize;
    UIImage *scaledImage;
    
    if (size.height > size.width) {
        scaleSize = 640 / size.height;
        
        UIGraphicsBeginImageContext(CGSizeMake(floorf(image.size.width * scaleSize), floorf(image.size.height * scaleSize)));
        [image drawInRect:CGRectMake(0, 0, floorf(image.size.width * scaleSize), floorf(image.size.height * scaleSize))];
        UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return scaledImage;
    } else if (size.height <= size.width) {
        scaleSize = 640 / size.width;
        
        UIGraphicsBeginImageContext(CGSizeMake(floorf(image.size.width * scaleSize), floorf(image.size.height * scaleSize)));
        [image drawInRect:CGRectMake(0, 0, floorf(image.size.width * scaleSize), floorf(image.size.height * scaleSize))];
        UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return scaledImage;
    }
    
    return scaledImage;
}

+ (UIImage *)scaleAvatar:(UIImage *)avatar
{
    CGSize  size = avatar.size;
    CGFloat scaleSize;
    UIImage *scaledImage;
    
    if (size.height > size.width) {
        scaleSize = 400 / size.height;
        
        UIGraphicsBeginImageContext(CGSizeMake(floorf(avatar.size.width * scaleSize), floorf(avatar.size.height * scaleSize)));
        [avatar drawInRect:CGRectMake(0, 0, floorf(avatar.size.width * scaleSize), floorf(avatar.size.height * scaleSize))];
        UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return scaledImage;
    } else if (size.height <= size.width) {
        scaleSize = 400 / size.width;
        
        UIGraphicsBeginImageContext(CGSizeMake(floorf(avatar.size.width * scaleSize), floorf(avatar.size.height * scaleSize)));
        [avatar drawInRect:CGRectMake(0, 0, floorf(avatar.size.width * scaleSize), floorf(avatar.size.height * scaleSize))];
        UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return scaledImage;
    }
    
    return scaledImage;
}

+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize

{
    
    UIGraphicsBeginImageContext(CGSizeMake(floorf(image.size.width * scaleSize), floorf(image.size.height * scaleSize)));
    [image drawInRect:CGRectMake(0, 0, floorf(image.size.width * scaleSize), floorf(image.size.height * scaleSize))];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
    
}

+ (UIImage *)scaleImagexy:(UIImage *)image toScalexy:(CGSize )scaleSize

{

    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize.width, image.size.height * scaleSize.height));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize.width, image.size.height * scaleSize.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
    
}


+ (UIImage *)imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size{
    
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if(CGSizeEqualToSize(imageSize, size) == NO){
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
            
        }
        else{
            
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if(widthFactor > heightFactor){
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    return newImage;
}




+(void)showImage:(UIImageView *)avatarImageView{
    UIImage *image=avatarImageView.image;
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    UIView *backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    oldframe=[avatarImageView convertRect:avatarImageView.bounds toView:window];
    backgroundView.backgroundColor=[UIColor blackColor];
    backgroundView.alpha=0;
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:oldframe];
    imageView.image=image;
    imageView.tag=1;
    [backgroundView addSubview:imageView];
    [window addSubview:backgroundView];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [backgroundView addGestureRecognizer: tap];
    
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=CGRectMake(0,([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
        
        backgroundView.alpha=1;
    } completion:^(BOOL finished) {
        
    }];
}

+(void)hideImage:(UITapGestureRecognizer*)tap{
    UIView *backgroundView=tap.view;
    UIImageView *imageView=(UIImageView*)[tap.view viewWithTag:1];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=oldframe;
        backgroundView.alpha=0;
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
    }];
}


@end