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
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 250)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:backView];
    

    
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
    [self.contentView addSubview:_includeTF];
    
    
    _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 170, kScreenWidth, 70)];
    _backView.userInteractionEnabled = YES;
    [self.contentView addSubview:_backView];
    _eventButton = [[UIButton alloc]initWithFrame:CGRectMake(15, 10, 70, 70)];
    [_eventButton setBackgroundImage:[UIImage imageNamed:@"addImage"] forState:UIControlStateNormal];
    [_backView addSubview:_eventButton];
    
    
    NSArray *arr = @[@"findpage",@"findpage",@"findpage",@"findpage",@"findpage"];
    
    
    EditImageView *imageV = [[EditImageView alloc] initWithStartY:10 andImageArray:arr];
    [_backView addSubview:imageV];
    
//    _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 70, 70)];
//    [_backView addSubview:_imgView];
//    [_eventButton addTarget:self action:@selector(addImage:) forControlEvents:UIControlEventTouchUpInside];
//    _deleteBt=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-30, 15, 22, 22)];
//    [_deleteBt setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
//    [self addSubview:_deleteBt];
    
}

- (void)addImage:(id)sender
{
    if ([_delegate respondsToSelector:@selector(cellWilladdImage:)]) {
        [_delegate cellWilladdImage:self];
    }
}


- (UITableView *)tableView
{
    UIView *tableView = self.superview;
    while (![tableView isKindOfClass:[UITableView class]] && tableView) {
        tableView = tableView.superview;
    }
    return (UITableView *)tableView;
}



@end
