//
//  FitColorConvertFactory.m
//  FitTrainer
//
//  Created by JamHonyZ on 15/12/26.
//  Copyright (c) 2015年 Huasheng. All rights reserved.
//

#import "FitColorConvertFactory.h"

@implementation FitColorConvertFactory

+ (NSURL *)getThumUrl:(NSString *)imgUrl toScale:(NSInteger )scale
{
    NSString *thumbUrl;
    NSString *urlPath;
    NSUInteger length = [imgUrl length];
    NSUInteger imgNameSartPoint = 1;
    NSString *thumbPrefix = [NSString stringWithFormat:@"_size_%ldx", (long)scale];
    
    NSRange startPoint = [imgUrl rangeOfString:@"/"];
    while (startPoint.location != NSNotFound)
    {
        startPoint = [imgUrl rangeOfString:@"/" options:0 range:startPoint];
        
        if (startPoint.location != NSNotFound) {
            startPoint = NSMakeRange(startPoint.location + startPoint.length, length - (startPoint.location + startPoint.length));
            
            imgNameSartPoint = startPoint.location;
        }
    }
    
    if (imgNameSartPoint <= 1) {
        return nil;
    }
    
    urlPath = [imgUrl substringWithRange:NSMakeRange(0, imgNameSartPoint)];
    
    NSRange range = [imgUrl rangeOfString:@".jpg"];
    if (range.length > 1) {
        
        thumbUrl = [imgUrl substringWithRange:NSMakeRange(imgNameSartPoint, range.location - imgNameSartPoint)];
        
        thumbUrl = [urlPath stringByAppendingString:[[thumbUrl stringByAppendingString:thumbPrefix] stringByAppendingString:@".jpg"]];
        
        return [NSURL URLWithString:thumbUrl];
    }
    
    range = [imgUrl rangeOfString:@".JPG"];
    if (range.length > 1) {
        
        thumbUrl = [imgUrl substringWithRange:NSMakeRange(imgNameSartPoint, range.location - imgNameSartPoint)];
        
        thumbUrl = [urlPath stringByAppendingString:[[thumbUrl stringByAppendingString:thumbPrefix] stringByAppendingString:@".JPG"]];
        
        return [NSURL URLWithString:thumbUrl];
    }
    
    range = [imgUrl rangeOfString:@".jpeg"];
    if (range.length > 1) {
        thumbUrl = [imgUrl substringWithRange:NSMakeRange(imgNameSartPoint, range.location - imgNameSartPoint)];
        
        thumbUrl = [urlPath stringByAppendingString:[[thumbUrl stringByAppendingString:thumbPrefix] stringByAppendingString:@".jpeg"]];
        
        return [NSURL URLWithString:thumbUrl];
    }
    
    range = [imgUrl rangeOfString:@".JPEG"];
    if (range.length > 1) {
        
        thumbUrl = [imgUrl substringWithRange:NSMakeRange(imgNameSartPoint, range.location - imgNameSartPoint)];
        
        thumbUrl = [urlPath stringByAppendingString:[[thumbUrl stringByAppendingString:thumbPrefix] stringByAppendingString:@".JPEG"]];
        
        return [NSURL URLWithString:thumbUrl];
    }
    
    range = [imgUrl rangeOfString:@".png"];
    if (range.length > 1) {
        thumbUrl = [imgUrl substringWithRange:NSMakeRange(imgNameSartPoint, range.location - imgNameSartPoint)];
        
        thumbUrl = [urlPath stringByAppendingString:[[thumbUrl stringByAppendingString:thumbPrefix] stringByAppendingString:@".png"]];
        
        return [NSURL URLWithString:thumbUrl];
    }
    
    range = [imgUrl rangeOfString:@".gif"];
    if (range.length > 1) {
        thumbUrl = [imgUrl substringWithRange:NSMakeRange(imgNameSartPoint, range.location - imgNameSartPoint)];
        
        thumbUrl = [urlPath stringByAppendingString:[[thumbUrl stringByAppendingString:thumbPrefix] stringByAppendingString:@".gif"]];
        
        return [NSURL URLWithString:thumbUrl];
    }
    
    return [NSURL URLWithString:thumbUrl];
}

+ (NSURL *)getThumUrl:(NSString *)imgUrl toWidth:(NSInteger)width toHeight:(NSInteger)height
{
    NSString *thumbUrl;
    NSString *urlPath;
    NSUInteger length = [imgUrl length];
    NSUInteger imgNameSartPoint = 1;
    NSString *thumbPrefix = [NSString stringWithFormat:@"_size_w%ldh%ld", (long)width, height];
    
    NSRange startPoint = [imgUrl rangeOfString:@"/"];
    while (startPoint.location != NSNotFound)
    {
        startPoint = [imgUrl rangeOfString:@"/" options:0 range:startPoint];
        
        if (startPoint.location != NSNotFound) {
            startPoint = NSMakeRange(startPoint.location + startPoint.length, length - (startPoint.location + startPoint.length));
            
            imgNameSartPoint = startPoint.location;
        }
    }
    
    if (imgNameSartPoint <= 1) {
        return nil;
    }
    
    urlPath = [imgUrl substringWithRange:NSMakeRange(0, imgNameSartPoint)];
    
    NSRange range = [imgUrl rangeOfString:@".jpg"];
    if (range.length > 1) {
        
        thumbUrl = [imgUrl substringWithRange:NSMakeRange(imgNameSartPoint, range.location - imgNameSartPoint)];
        
        thumbUrl = [urlPath stringByAppendingString:[[thumbUrl stringByAppendingString:thumbPrefix] stringByAppendingString:@".jpg"]];
        
        return [NSURL URLWithString:thumbUrl];
    }
    
    range = [imgUrl rangeOfString:@".JPG"];
    if (range.length > 1) {
        
        thumbUrl = [imgUrl substringWithRange:NSMakeRange(imgNameSartPoint, range.location - imgNameSartPoint)];
        
        thumbUrl = [urlPath stringByAppendingString:[[thumbUrl stringByAppendingString:thumbPrefix] stringByAppendingString:@".JPG"]];
        
        return [NSURL URLWithString:thumbUrl];
    }
    
    range = [imgUrl rangeOfString:@".jpeg"];
    if (range.length > 1) {
        thumbUrl = [imgUrl substringWithRange:NSMakeRange(imgNameSartPoint, range.location - imgNameSartPoint)];
        
        thumbUrl = [urlPath stringByAppendingString:[[thumbUrl stringByAppendingString:thumbPrefix] stringByAppendingString:@".jpeg"]];
        
        return [NSURL URLWithString:thumbUrl];
    }
    
    range = [imgUrl rangeOfString:@".JPEG"];
    if (range.length > 1) {
        
        thumbUrl = [imgUrl substringWithRange:NSMakeRange(imgNameSartPoint, range.location - imgNameSartPoint)];
        
        thumbUrl = [urlPath stringByAppendingString:[[thumbUrl stringByAppendingString:thumbPrefix] stringByAppendingString:@".JPEG"]];
        
        return [NSURL URLWithString:thumbUrl];
    }
    
    range = [imgUrl rangeOfString:@".png"];
    if (range.length > 1) {
        thumbUrl = [imgUrl substringWithRange:NSMakeRange(imgNameSartPoint, range.location - imgNameSartPoint)];
        
        thumbUrl = [urlPath stringByAppendingString:[[thumbUrl stringByAppendingString:thumbPrefix] stringByAppendingString:@".png"]];
        
        return [NSURL URLWithString:thumbUrl];
    }
    
    range = [imgUrl rangeOfString:@".gif"];
    if (range.length > 1) {
        thumbUrl = [imgUrl substringWithRange:NSMakeRange(imgNameSartPoint, range.location - imgNameSartPoint)];
        
        thumbUrl = [urlPath stringByAppendingString:[[thumbUrl stringByAppendingString:thumbPrefix] stringByAppendingString:@".gif"]];
        
        return [NSURL URLWithString:thumbUrl];
    }
    
    return [NSURL URLWithString:thumbUrl];
}

+ (NSString *)getThumbUrl:(NSString *)imgUrl
{
    NSString *thumbUrl;
    NSString *urlPath;
    NSUInteger length = [imgUrl length];
    NSUInteger imgNameSartPoint = 1;
    
    NSRange startPoint = [imgUrl rangeOfString:@"/"];
    while (startPoint.location != NSNotFound)
    {
        startPoint = [imgUrl rangeOfString:@"/" options:0 range:startPoint];
        
        if (startPoint.location != NSNotFound) {
            startPoint = NSMakeRange(startPoint.location + startPoint.length, length - (startPoint.location + startPoint.length));
            
            imgNameSartPoint = startPoint.location;
        }
    }
    
    if (imgNameSartPoint <= 1) {
        return nil;
    }
    
    urlPath = [imgUrl substringWithRange:NSMakeRange(0, imgNameSartPoint)];
    
    NSRange range = [imgUrl rangeOfString:@".jpg"];
    if (range.length > 1) {
        
        thumbUrl = [imgUrl substringWithRange:NSMakeRange(imgNameSartPoint, range.location - imgNameSartPoint)];
        
        thumbUrl = [urlPath stringByAppendingString:[[@"thumb_" stringByAppendingString:thumbUrl] stringByAppendingString:@".jpg"]];
        
        return thumbUrl;
    }
    
    range = [imgUrl rangeOfString:@".JPG"];
    if (range.length > 1) {
        
        thumbUrl = [imgUrl substringWithRange:NSMakeRange(imgNameSartPoint, range.location - imgNameSartPoint)];
        
        thumbUrl = [urlPath stringByAppendingString:[[@"thumb_" stringByAppendingString:thumbUrl] stringByAppendingString:@".JPG"]];
        
        return thumbUrl;
    }
    
    range = [imgUrl rangeOfString:@".jpeg"];
    if (range.length > 1) {
        thumbUrl = [imgUrl substringWithRange:NSMakeRange(imgNameSartPoint, range.location - imgNameSartPoint)];
        
        thumbUrl = [urlPath stringByAppendingString:[[@"thumb_" stringByAppendingString:thumbUrl] stringByAppendingString:@".jpeg"]];
        
        return thumbUrl;
    }
    
    range = [imgUrl rangeOfString:@".JPEG"];
    if (range.length > 1) {
        
        thumbUrl = [imgUrl substringWithRange:NSMakeRange(imgNameSartPoint, range.location - imgNameSartPoint)];
        
        thumbUrl = [urlPath stringByAppendingString:[[@"thumb_" stringByAppendingString:thumbUrl] stringByAppendingString:@".JPEG"]];
        
        return thumbUrl;
    }
    
    range = [imgUrl rangeOfString:@".png"];
    if (range.length > 1) {
        thumbUrl = [imgUrl substringWithRange:NSMakeRange(imgNameSartPoint, range.location - imgNameSartPoint)];
        
        thumbUrl = [urlPath stringByAppendingString:[[@"thumb_" stringByAppendingString:thumbUrl] stringByAppendingString:@".png"]];
        
        return thumbUrl;
    }
    
    range = [imgUrl rangeOfString:@".gif"];
    if (range.length > 1) {
        thumbUrl = [imgUrl substringWithRange:NSMakeRange(imgNameSartPoint, range.location - imgNameSartPoint)];
        
        thumbUrl = [urlPath stringByAppendingString:[[@"thumb_" stringByAppendingString:thumbUrl] stringByAppendingString:@".gif"]];
        
        return thumbUrl;
    }
    
    return thumbUrl;
}


@end
