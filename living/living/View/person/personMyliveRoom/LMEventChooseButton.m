//
//  LMEventChooseButton.m
//  living
//
//  Created by Ding on 2016/11/17.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMEventChooseButton.h"
#import "FitConsts.h"

@implementation LMEventChooseButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
    
}


-(UILabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc]init];
        _leftLabel.textColor = TEXT_COLOR_LEVEL_3;
        _leftLabel.font = TEXT_FONT_LEVEL_3;
        _leftLabel.frame = CGRectMake(0, 35, kScreenWidth/2, 20);
        _leftLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_leftLabel];
    }
    return _leftLabel;
}

-(UIImageView *)rightView {
    if (!_rightView) {
        _rightView = [[UIImageView alloc]init];
        [_rightView sizeToFit];
        _rightView.frame = CGRectMake(kScreenWidth/4-10, 10, 22, 22);
        [self addSubview:_rightView];
    }
    return _rightView;
}
@end
