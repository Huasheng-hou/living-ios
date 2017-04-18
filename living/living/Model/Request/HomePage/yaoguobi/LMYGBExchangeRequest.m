//
//  LMYGBExchangeRequest.m
//  living
//
//  Created by hxm on 2017/3/23.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMYGBExchangeRequest.h"

@implementation LMYGBExchangeRequest

- (instancetype)initWithAmount:(NSString *)amount andNumbers:(int)numbers{
    if (self = [super init]) {
        NSMutableDictionary * body = [NSMutableDictionary new];
        
        if (amount) {
            [body setObject:amount forKey:@"amount"];
        }
        
        if (numbers != -1) {
            [body setObject:[NSString stringWithFormat:@"%d", numbers] forKey:@"numbers"];
        }
        
        NSMutableDictionary * param = [self params];
        [param setObject:body forKey:@"body"];
        
    }
    return self;
}


- (BOOL)isPost{
    return YES;
}

- (NSString *)methodPath{
    
    return @"coin/exchange";
}
@end
