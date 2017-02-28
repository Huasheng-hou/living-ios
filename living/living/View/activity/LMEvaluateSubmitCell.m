//
//  LMEvaluateSubmitCell.m
//  living
//
//  Created by WangShengquan on 2017/2/24.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMEvaluateSubmitCell.h"
#import "FitConsts.h"

@interface LMEvaluateSubmitCell ()

@property (nonatomic, strong) UIButton *submitBtn;

@end

@implementation LMEvaluateSubmitCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayout];
    }
    return self;
}

- (void)initLayout
{
    self.backgroundColor = BG_GRAY_COLOR;
    
    _submitBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, 8, kScreenWidth - 60, 44)];
    [_submitBtn setTitle:@"提交评价" forState:UIControlStateNormal];
    _submitBtn.backgroundColor = ORANGE_COLOR;
    _submitBtn.layer.cornerRadius = 5;
    [_submitBtn addTarget:self action:@selector(submintBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_submitBtn];
}

- (void)submintBtnPressed:(UIButton *)btn
{
    self.submitSelectedBlock();
}


- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
