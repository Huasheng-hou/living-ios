//
//  LMChargeButton.m
//  living
//
//  Created by Ding on 2016/11/3.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMChargeButton.h"
#import "FitConsts.h"

@implementation LMChargeButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        
    }
    return self;
    
}


-(UILabel *)upLabel {
    if (!_upLabel) {
        _upLabel = [[UILabel alloc]init];
        _upLabel.text = @"10000元";
        _upLabel.textAlignment = NSTextAlignmentCenter;
        _upLabel.textColor = TEXT_COLOR_LEVEL_2;
        _upLabel.font = [UIFont systemFontOfSize:18];
        [_upLabel sizeToFit];
        _upLabel.frame = CGRectMake(0, 10, (kScreenWidth-40)/3, 30);
        [self addSubview:_upLabel];
    }
    return _upLabel;
}

-(UILabel *)downLabel {
    if (!_downLabel) {
        _downLabel = [[UILabel alloc]init];
        _downLabel.text = @"升级会员";
        _downLabel.textAlignment = NSTextAlignmentCenter;
        _downLabel.textColor = TEXT_COLOR_LEVEL_2;
        _downLabel.font = TEXT_FONT_LEVEL_2;
        [_downLabel sizeToFit];
        _downLabel.frame = CGRectMake(0, 40, (kScreenWidth-40)/3, 20);
        [self addSubview:_downLabel];
    }
    return _downLabel;
}


@end
