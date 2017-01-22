//
//  LMChoseCounponButton.m
//  living
//
//  Created by Ding on 2017/1/22.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMChoseCounponButton.h"
#import "FitConsts.h"

@implementation LMChoseCounponButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        
    }
    return self;
    
}

-(UIImageView *)chooseImage {
    if (!_chooseImage) {
        _chooseImage = [[UIImageView alloc]init];
        _chooseImage.frame = CGRectMake(0, 8, 12, 12);
        _chooseImage.contentMode = UIViewContentModeScaleAspectFill;
        _chooseImage.clipsToBounds = YES;
        _chooseImage.layer.cornerRadius = 6;
        _chooseImage.layer.borderWidth = 0.5;
        _chooseImage.layer.borderColor = [UIColor whiteColor].CGColor;

        [self addSubview:_chooseImage];
    }
    return _chooseImage;
}

-(UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc]init];
        _textLabel.text = @"是";
        _textLabel.textAlignment = NSTextAlignmentLeft;
        _textLabel.textColor = TEXT_COLOR_LEVEL_3;
        _textLabel.font = TEXT_FONT_LEVEL_2;
        [_textLabel sizeToFit];
        _textLabel.frame = CGRectMake(15, 0, _textLabel.bounds.size.width, 30);
        
        [self addSubview:_textLabel];
    }
    return _textLabel;
}

@end
