
//
//  FitThumbImageHelper.h
//  FitTrainer
//
//  Created by Huasheng on 15/9/26.
//  Copyright © 2015年 Huasheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FitThumbImageHelper : NSObject

+ (NSString *) getThumbUrl:(NSString *)imgUrl;

+ (NSURL *)getThumUrl:(NSString *)imgUrl toScale:(NSInteger )scale;

+ (NSURL *)getThumUrl:(NSString *)imgUrl toWidth:(NSInteger )width toHeight:(NSInteger )height;

@end
