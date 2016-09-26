//
//  DYAgeChooseButton.m
//  dirty
//
//  Created by Ding on 16/8/24.
//  Copyright © 2016年 Huasheng. All rights reserved.
//

#import "LMAgeChooseButton.h"

#import "FitConsts.h"

@implementation LMAgeChooseButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        
    }
    return self;
    
}

-(UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc]init];
        _textLabel.frame = CGRectMake(10, 0, kScreenWidth-90-50, 30);
        _textLabel.textColor = TEXT_COLOR_LEVEL_3;
        _textLabel.font = TEXT_FONT_LEVEL_2;
        _textLabel.textAlignment=NSTextAlignmentLeft;
        [self addSubview:_textLabel];
    }
    return _textLabel;
}

@end
