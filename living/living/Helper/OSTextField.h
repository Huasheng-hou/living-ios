//
//  OSTextField.h
//  KeyBoard
//
//  Created by mac on 16/8/3.
//  Copyright © 2016年 筒子家族. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ FinishBlock)(void);

@interface OSTextField : UITextView

// 头部提示字
@property (nonatomic,strong) NSString     *prompts;
@property (nonatomic,copy)   FinishBlock  block;

// 头部视图
- (void)initTopView;

// 输入限制位数
- (void)limitTextLength:(int)length;
@end
