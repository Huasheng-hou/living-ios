//
//  CncpStartTime.m
//  cnpc
//
//  Created by JamHonyZ on 2016/11/16.
//  Copyright © 2016年 Dlx. All rights reserved.
//

#import "CncpStartTime.h"

static CncpStartTime *_startTime;

@implementation CncpStartTime


+(CncpStartTime *)shareCncpStartTime
{
    if (!_startTime) {
        _startTime=[[CncpStartTime alloc]init];
    }
    return _startTime;
}

-(BOOL)outDate
{
    
    //首先创建格式化对象
    
     NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    //然后创建日期对象
    
    NSDate *date1 = [dateFormatter dateFromString:@"2016-11-20 00:00:00"];
    
    NSDate *date = [NSDate date];
    
    //计算时间间隔（单位是秒）
    
    NSTimeInterval time = [date1 timeIntervalSinceDate:date];
    
    //计算天数、时、分、秒
    
    int days = ((int)time)/(3600*24);
    
    int hours = ((int)time)%(3600*24)/3600;

    int minutes = ((int)time)%(3600*24)%3600/60;
    
    int seconds = ((int)time)%(3600*24)%3600%60;
    
    if (days<=0&&hours<=0&&minutes<=0&&seconds<=0) {
        return YES;
    }
    
    return NO;
}


@end
