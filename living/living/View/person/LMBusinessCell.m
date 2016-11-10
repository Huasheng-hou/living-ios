//
//  LMBusinessCell.m
//  living
//
//  Created by Ding on 2016/11/10.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMBusinessCell.h"
#import "FitConsts.h"

@implementation LMBusinessCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubviews];
    }
    return self;
}
- (void)addSubviews{
    
    UILabel *_label=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, 40, 54.5)];
    [_label setText:@"联系姓名："];
    [_label sizeToFit];
    _label.frame = CGRectMake(15, 0, _label.bounds.size.width, 54.5);
    [_label setFont:TEXT_FONT_LEVEL_1];
    [self addSubview:_label];
    
    _NameTF=[[UITextField alloc]initWithFrame:CGRectMake(15+_label.bounds.size.width, 0, kScreenWidth-20-_label.bounds.size.width, 54.5)];
    [_NameTF setPlaceholder:@"请输入真实姓名"];
    [_NameTF setReturnKeyType:UIReturnKeyDone];
    [_NameTF setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_NameTF setFont:TEXT_FONT_LEVEL_2];
    [self addSubview:_NameTF];
    
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 54.5, kScreenWidth-10, 0.5)];
    lineView.backgroundColor = LINE_COLOR;
    [self addSubview:lineView];
    
    
    UILabel *_label2=[[UILabel alloc]initWithFrame:CGRectMake(15, 55, 40, 55)];
    [_label2 setText:@"电话号码："];
    [_label2 sizeToFit];
    _label2.frame = CGRectMake(15, 55, _label.bounds.size.width, 55);
    [_label2 setFont:TEXT_FONT_LEVEL_1];
    [self addSubview:_label2];
    _NumTF=[[UITextField alloc]initWithFrame:CGRectMake(15+_label.bounds.size.width, 55, kScreenWidth-20-_label.bounds.size.width, 55)];
    _NumTF.keyboardType=UIKeyboardTypePhonePad;
    [_NumTF setPlaceholder:@"请输入手机号码"];
    [_NumTF setReturnKeyType:UIReturnKeyDone];
    [_NumTF setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_NumTF setFont:TEXT_FONT_LEVEL_2];
    [self addSubview:_NumTF];
    
    
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
