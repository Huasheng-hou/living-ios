//
//  LMChooseButton.m
//  living
//
//  Created by Ding on 16/10/9.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMTimeButton.h"
#import "FitConsts.h"

@implementation LMTimeButton


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        
    }
    return self;
    
}


-(UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc]init];
        _textLabel.textAlignment = NSTextAlignmentLeft;
        _textLabel.textColor = TEXT_COLOR_LEVEL_3;
        _textLabel.font = TEXT_FONT_LEVEL_2;
        
        [self addSubview:_textLabel];
    }
    return _textLabel;
}
@end
