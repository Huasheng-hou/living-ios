//
//  DYChooseButton.m
//  dirty
//
//  Created by Ding on 16/8/24.
//  Copyright © 2016年 Huasheng. All rights reserved.
//

#import "LMChooseButton.h"
#import "FitConsts.h"

@implementation LMChooseButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        
    }
    return self;
    
}

-(UIImageView *)headImage {
    if (!_headImage) {
        _headImage = [[UIImageView alloc]init];
        _headImage.frame = CGRectMake(kScreenWidth/2-70, 20, 52, 48);
        [self addSubview:_headImage];
    }
    return _headImage;
}

-(UIImageView *)roolImage {
    if (!_roolImage) {
        _roolImage = [[UIImageView alloc]init];
        _roolImage.frame = CGRectMake(kScreenWidth/2-55.5, 90, 15, 15);
        [self addSubview:_roolImage];
    }
    return _roolImage;
}


@end
