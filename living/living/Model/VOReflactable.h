//
//  VOReflactable.h
//  FitTrainer
//
//  Created by 赵洋 on 15/8/31.
//  Copyright (c) 2015年 Huasheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VOReflactable <NSObject>

+ (id)objFromDictionary:(NSDictionary *)dictionary;

@end