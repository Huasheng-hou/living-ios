//
//  HcbObjectTable.m
//  FitTrainer
//
//  Created by 赵洋 on 15/9/1.
//  Copyright (c) 2015年 Huasheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HcbObjectTable.h"

@interface HcbTriple : NSObject
@property (retain, nonatomic) NSObject * obj;
@property (assign, nonatomic) int        column;
@property (assign, nonatomic) int        row;
@end
@implementation HcbTriple

@end

@implementation HcbObjectTable
{
    NSMutableArray  *  _list;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _list = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)putObject:(NSObject *)obj AtColumn:(int)col AndRow:(int)row
{
    HcbTriple *triple = [self findObject:obj];
    if (triple==nil) {
        triple = [[HcbTriple alloc] init];
        triple.obj = obj;
        [_list addObject:triple];
    }
    triple.column = col;
    triple.row    = row;
}

- (NSObject*)queryWithColumn:(int)col AndRow:(int)row
{
    for (HcbTriple* triple  in _list) {
        if (triple.column == col && triple.row == row) {
            return triple.obj;
        }
    }
    return nil;
}

- (HcbTriple*)findObject:(NSObject*)obj
{
    for (HcbTriple* triple in _list) {
        if (triple.obj == obj) {
            return triple;
        }
    }
    return nil;
}

@end