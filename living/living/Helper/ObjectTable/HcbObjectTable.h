//
//  HcbObjectTable.h
//  FitTrainer
//
//  Created by 赵洋 on 15/9/1.
//  Copyright (c) 2015年 Huasheng. All rights reserved.
//

@interface HcbObjectTable : NSObject

- (void)putObject:(NSObject*)obj AtColumn:(int)col AndRow:(int)row;
- (NSObject*)queryWithColumn:(int)col AndRow:(int)row;

@end
