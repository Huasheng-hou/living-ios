//
//  UIImage+ImageFromArrayUtils.h
//  FitTrainer
//
//  Created by Huasheng on 15/9/13.
//  Copyright (c) 2015年 Huasheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ImageFromArrayUtils)

+ (UIImage *)verticalImageFromArray:(NSArray *)imagesArray;
+ (CGSize)verticalAppendedTotalImageSizeFromImagesArray:(NSArray *)imagesArray;

@end
