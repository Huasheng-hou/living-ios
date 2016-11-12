//
//  HcbAmountChecker.m
//  living
//
//  Created by 戚秋民 on 16/11/12.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "HcbAmountChecker.h"

@implementation HcbAmountChecker

+ (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // * 不能仅仅输入0或者"."作为金额的开头
    
    if (range.location == 0 && ([string isEqualToString:@"0"] || [string isEqualToString:@"."])) {
        
        return NO;
    }
    
    // * 不能在金额中输入两个"."
    
    if (textField.text && [textField.text containsString:@"."] && [string isEqualToString:@"."]) {
        
        return NO;
    }
    
    // * 金额不超过999999999元（不超过9位数）
    
    if (textField.text.length == 9 && ![string isEqualToString:@""]) {
        
        return NO;
    }
    
    // * 小数部分不能超过两位
    
    if (textField.text && [textField.text containsString:@"."]) {
        
        NSRange dotRange  = [textField.text rangeOfString:@"."];
        
        if (textField.text.length - dotRange.location >= 3 && range.location > dotRange.location && ![string isEqualToString:@""]) {
            
            return NO;
        }
    }
    
    // * 不能通过删除将金额变成开头为0或者"."
    
    if (range.location == 0 && [string isEqualToString:@""] && textField.text.length >= 2
        && ([[textField.text substringWithRange:NSMakeRange(1, 1)] isEqualToString:@"0"]
            || [[textField.text substringWithRange:NSMakeRange(1, 1)] isEqualToString:@"."])) {
            
            return NO;
        }
    
    return YES;
}

@end
