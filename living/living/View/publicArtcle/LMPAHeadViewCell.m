//
//  LMPAHeadViewCell.m
//  living
//
//  Created by Ding on 2016/12/6.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMPAHeadViewCell.h"
#import "FitConsts.h"
#import "EditImageView.h"
#define titleW titleLable.bounds.size.width


@interface LMPAHeadViewCell ()
<UITextViewDelegate>
{
    UIView *whiteView;
}

@end

@implementation LMPAHeadViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self    = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self addSubviews];
        
    }
    return self;
}

-(void)addSubviews
{
    
    whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, (kScreenWidth-10*5)/4+170)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:whiteView];
    

    
    _includeTF = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth- 20, 160)];
//    _includeTF.backgroundColor = [UIColor clearColor];
    _includeTF.returnKeyType = UIReturnKeyDone;
    _includeTF.delegate = self;
    _includeTF.font = TEXT_FONT_LEVEL_2;
    
    _textLab = [UILabel new];
    _textLab.text = @"请输入正文";
    _textLab.textColor = TEXT_COLOR_LEVEL_3;
    _textLab.font = TEXT_FONT_LEVEL_2;
    [_textLab sizeToFit];
    _textLab.frame = CGRectMake(0, 0, _textLab.bounds.size.width, 30);
    [_includeTF addSubview:_textLab];
    [whiteView addSubview:_includeTF];
    
    _imageV = [[EditImageView alloc] initWithStartY:180 andImageArray:nil];
    [whiteView addSubview:_imageV];
    
    
}


-(void)setArray:(NSMutableArray *)array
{
    _array = array;
    
    if ([_array isEqual:@""]) {
        _array = nil;
    }
    [_imageV contentWithView:_array andY:180];
    
    whiteView.frame = CGRectMake(0, 10, kScreenWidth, _imageV.frame.size.height+180);
    
}



@end
