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

-(UILabel *)midLabel {
    if (!_midLabel) {
        _midLabel = [[UILabel alloc]init];
        _midLabel.text = @"会员1年";
        _midLabel.textAlignment = NSTextAlignmentCenter;
        _midLabel.textColor = LIVING_COLOR;
        _midLabel.font = TEXT_FONT_LEVEL_2;
        [_midLabel sizeToFit];
        _midLabel.frame = CGRectMake(0, 35, (kScreenWidth-40)/3, 15);
        [self addSubview:_midLabel];
    }
    return _downLabel;
}

- (void)setType:(NSInteger)type {
    _type = type;
    if (type == 1) {
        self.upLabel.frame = CGRectMake(0, 10, (kScreenWidth-40)/3, 25);
        self.downLabel.frame = CGRectMake(0, 55, (kScreenWidth-40)/3, 20);
    }
}


@end
