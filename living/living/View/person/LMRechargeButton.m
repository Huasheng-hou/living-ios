//
//  LMRechargeButton.m
//  living
//
//  Created by Ding on 2016/10/25.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMRechargeButton.h"
#import "FitConsts.h"

@implementation LMRechargeButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        
    }
    return self;
    
}


-(UILabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc]init];
        _leftLabel.text = @"立即充值";
        _leftLabel.textColor = LIVING_REDCOLOR;
        _leftLabel.font = TEXT_FONT_LEVEL_3;
        [_leftLabel sizeToFit];
        _leftLabel.frame = CGRectMake(5, 0, _leftLabel.bounds.size.width, self.bounds.size.height);
        [self addSubview:_leftLabel];
    }
    return _leftLabel;
}

-(UIImageView *)rightView {
    if (!_rightView) {
        _rightView = [[UIImageView alloc]init];
        _rightView.image = [UIImage imageNamed:@"Recharge-1"];

        [_rightView sizeToFit];
        _rightView.frame = CGRectMake(5+_leftLabel.bounds.size.width, self.bounds.size.height/2-7, 14, 14);
        [self addSubview:_rightView];
    }
    return _rightView;
}


@end
