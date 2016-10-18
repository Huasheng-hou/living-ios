//
//  LMRePayCell.m
//  living
//
//  Created by Ding on 16/10/18.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMRePayCell.h"
#import "FitConsts.h"

@implementation LMRePayCell



-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubviews];
    }
    return self;
}
- (void)addSubviews{
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 65)];
    [bgView setBackgroundColor:BG_GRAY_COLOR];
    [self addSubview:bgView];
    
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 10, kScreenWidth, 45)];
    [view setBackgroundColor:[UIColor whiteColor]];
    [bgView addSubview:view];
    
    UILabel *line=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    [line setBackgroundColor:LINE_COLOR];
    [view  addSubview:line];
    
    UILabel *lineDown=[[UILabel alloc]initWithFrame:CGRectMake(0, view.frame.size.height-0.5, kScreenWidth, 0.5)];
    [lineDown setBackgroundColor:LINE_COLOR];
    [view  addSubview:lineDown];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 40, 45)];
    [label setText:@"金额"];
    [label setFont:TEXT_FONT_LEVEL_1];
    [view addSubview:label];
    
    _payNum=[[UITextField alloc]initWithFrame:CGRectMake(50, 0, kScreenWidth-60, 45)];
    [_payNum setPlaceholder:@"请输入要充值的金额"];
    _payNum.keyboardType=UIKeyboardTypeDecimalPad;
    [_payNum setReturnKeyType:UIReturnKeyDone];
    [_payNum setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_payNum setFont:TEXT_FONT_LEVEL_2];
    [view addSubview:_payNum];

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
