//
//  LMPAHeadViewCell.m
//  living
//
//  Created by Ding on 2016/12/6.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMPAHeadViewCell.h"
#import "FitConsts.h"
#define titleW titleLable.bounds.size.width
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
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 250)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:backView];
    

    
    _includeTF = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth- 20, 160)];
//    _includeTF.backgroundColor = [UIColor clearColor];
    _includeTF.returnKeyType = UIReturnKeyDone;
    _includeTF.font = TEXT_FONT_LEVEL_2;
    
    _textLab = [UILabel new];
    _textLab.text = @"请输入正文";
    _textLab.textColor = TEXT_COLOR_LEVEL_3;
    _textLab.font = TEXT_FONT_LEVEL_2;
    [_textLab sizeToFit];
    _textLab.frame = CGRectMake(0, 0, _textLab.bounds.size.width, 30);
    [_includeTF addSubview:_textLab];
    [self.contentView addSubview:_includeTF];
    
    
    _addButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 180, 70, 70)];
    [_addButton setImage:[UIImage imageNamed:@"addImage"] forState:UIControlStateNormal];
    [self.contentView addSubview:_addButton];
    
    
    _eventButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _eventButton.frame = CGRectMake(10, 180, 70, 70);
    [self.contentView addSubview:_eventButton];
    [_eventButton addTarget:self action:@selector(addImage:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 180, 70, 70)];
    [self.contentView addSubview:_imgView];
    
}

- (void)addImage:(id)sender
{
    if ([_delegate respondsToSelector:@selector(cellWilladdImage:)]) {
        [_delegate cellWilladdImage:self];
    }
}

- (void)textViewDidChange:(UITextView *)textView1
{
    if (textView1.text.length==0)
    {
        [_textLab setHidden:NO];
    }else{
        [_textLab setHidden:YES];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [self endEditing:YES];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
        
    }
    
    return YES;
}





@end
