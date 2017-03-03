
//
//  HcbAmountChecker.h
//  living
//
//  Created by 戚秋民 on 16/11/12.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HcbAmountChecker : NSObject

+ (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

@end
