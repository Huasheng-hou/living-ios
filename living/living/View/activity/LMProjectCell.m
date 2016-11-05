//
//  LMProjectCell.m
//  living
//
//  Created by JamHonyZ on 2016/11/5.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMProjectCell.h"
#import "FitConsts.h"

@implementation LMProjectCell

#define titleW titleLable.bounds.size.width

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
    //活动标题
    UILabel *titleLable = [UILabel new];
    titleLable.text = @"项目标题";
    titleLable.font = TEXT_FONT_LEVEL_1;
    titleLable.textColor = TEXT_COLOR_LEVEL_2;
    [titleLable sizeToFit];
    titleLable.frame = CGRectMake(10, 5, titleLable.bounds.size.width, 30);
    [self addSubview:titleLable];
    
    //梅花
    UIImageView *keyImage = [[UIImageView alloc] initWithFrame:CGRectMake(titleLable.bounds.size.width+10, 10, 6, 5)];
    keyImage.image = [UIImage imageNamed:@"key"];
    [self addSubview:keyImage];
    
    _title = [[UITextField alloc] initWithFrame:CGRectMake(titleW+20, 5, kScreenWidth- titleW-25-50, 30)];
    _title.font = TEXT_FONT_LEVEL_2;
    _title.placeholder = @"请输入项目标题";
    [_title setKeyboardType:UIKeyboardTypeDefault];
    _title.returnKeyType = UIReturnKeyDone;
    //    _titleTF.delegate = self;
    [self addSubview:_title];
    
    _deleteBt=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-30, 9, 22, 22)];
    [_deleteBt setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [self addSubview:_deleteBt];
    
    
    //分割线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(20+titleW, 40, kScreenWidth-25-titleW-50, 0.5)];
    lineView.backgroundColor = LINE_COLOR;
    [self addSubview:lineView];
    
    //项目介绍
    UILabel *phoneLable = [UILabel new];
    phoneLable.text = @"项目介绍";
    phoneLable.font = TEXT_FONT_LEVEL_1;
    phoneLable.textColor = TEXT_COLOR_LEVEL_2;
    [phoneLable sizeToFit];
    phoneLable.frame = CGRectMake(10, 50, titleW, 30);
    [self addSubview:phoneLable];
    
    //项目图片
    UILabel *imageLable = [UILabel new];
    imageLable.text = @"项目图片";
    imageLable.font = TEXT_FONT_LEVEL_1;
    imageLable.textColor = TEXT_COLOR_LEVEL_2;
    [imageLable sizeToFit];
    imageLable.frame = CGRectMake(10, 210, imageLable.bounds.size.width, 30);
    [self addSubview:imageLable];
    
    UILabel *imagemsgLable = [UILabel new];
    imagemsgLable.text = @"(建议尺寸：750*330)";
    imagemsgLable.font = TEXT_FONT_LEVEL_3;
    imagemsgLable.textColor = TEXT_COLOR_LEVEL_3;
    [imagemsgLable sizeToFit];
    imagemsgLable.frame = CGRectMake(15+imageLable.bounds.size.width, 210, imagemsgLable.bounds.size.width, 30);
    [self addSubview:imagemsgLable];
    
    
    UIView *TFview = [[UIView alloc] initWithFrame:CGRectMake(titleW+20, 50, kScreenWidth- titleW-30, 160)];
    TFview.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
    [self addSubview:TFview];
    
    _includeTF = [[UITextView alloc] initWithFrame:CGRectMake(5, 0, kScreenWidth- titleW-35, 160)];
    _includeTF.backgroundColor = [UIColor clearColor];
    _includeTF.returnKeyType = UIReturnKeyDone;
    _includeTF.font = TEXT_FONT_LEVEL_2;
    
    _textLab = [UILabel new];
    _textLab.text = @"请输入项目详情";
    _textLab.textColor = TEXT_COLOR_LEVEL_3;
    _textLab.font = TEXT_FONT_LEVEL_2;
    [_textLab sizeToFit];
    _textLab.frame = CGRectMake(5, 0, _textLab.bounds.size.width, 30);
    [_includeTF addSubview:_textLab];
    [TFview addSubview:_includeTF];
    
    
    UIView *imgBackView = [[UIView alloc] initWithFrame:CGRectMake(10, 240, 70, 70)];
    imgBackView.layer.borderColor = LINE_COLOR.CGColor;
    imgBackView.layer.borderWidth=0.5;
    [self addSubview:imgBackView];
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(25, 23, 20, 22)];
    image.image = [UIImage imageNamed:@"publicProgram"];
    [imgBackView addSubview:image];
    
    
    _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 240, 70, 70)];
    [self addSubview:_imgView];

    _eventButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 240, 70, 70)];
    [self addSubview:_eventButton];
   

    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 330, kScreenWidth, 10)];
    footView.backgroundColor = BG_GRAY_COLOR;
    [self.contentView addSubview:footView];
}


@end
