//
//  LMCommentButton.m
//  living
//
//  Created by Ding on 16/9/29.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMCommentButton.h"
#import "FitConsts.h"

@implementation LMCommentButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        
    }
    return self;
    
}

-(UIImageView *)headImage {
    if (!_headImage) {
        _headImage = [[UIImageView alloc]init];
        _headImage.frame = CGRectMake(0, 5, 12, 14);
        [self addSubview:_headImage];
    }
    return _headImage;
}

-(UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc]init];
        _textLabel.font = TEXT_FONT_LEVEL_3;

        [self addSubview:_textLabel];
    }
    return _textLabel;
}

@end
