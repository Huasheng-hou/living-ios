//
//  SXButton.m
//  ClassMatch
//
//  Created by 体团网 on 16/4/6.
//  Copyright © 2016年 tituanwang. All rights reserved.
//  筛选

#import "SXButton.h"

@implementation SXButton

//设置文字位置
- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    
    return CGRectMake(0, 0, self.frame.size.width*0.5+15, self.frame.size.height);
    
}

//设置图片的位置
- (CGRect)imageRectForContentRect:(CGRect)bounds{
    
    return CGRectMake(CGRectGetMaxX(self.titleLabel.frame), (self.frame.size.height-18)/2 , 18, 18);
    
}


- (id)initWithFrame:(CGRect)frame{
    
    if ([super initWithFrame:frame]) {
        
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;

    }
    
    return self;
}

@end
