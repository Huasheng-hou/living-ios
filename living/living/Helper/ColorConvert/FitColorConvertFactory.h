//
//  FitColorConvertFactory.h
//  FitTrainer
//
//  Created by JamHonyZ on 15/12/26.
//  Copyright (c) 2015年 Huasheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FitColorConvertFactory : NSObject

+ (NSString *) getThumbUrl:(NSString *)imgUrl;

+ (NSURL *)getThumUrl:(NSString *)imgUrl toScale:(NSInteger )scale;

+ (NSURL *)getThumUrl:(NSString *)imgUrl toWidth:(NSInteger )width toHeight:(NSInteger )height;

@end
