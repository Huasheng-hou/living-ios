//
//  LMEventDetailJudgeHeadCell.m
//  living
//
//  Created by hxm on 2017/3/28.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMEventDetailJudgeHeadCell.h"
#import "FitConsts.h"
@implementation LMEventDetailJudgeHeadCell
{
    
    UILabel * title;
    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    
        [self addSubViews];
    }
    return self;
}

- (void)addSubViews{
    
    _judge = [[UIButton alloc] initWithFrame:CGRectMake(30, 20, kScreenWidth-60, 40)];
    [_judge setTitle:@"评价" forState:UIControlStateNormal];
    [_judge setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_judge setBackgroundColor:[UIColor orangeColor]];
    _judge.titleLabel.textAlignment = NSTextAlignmentCenter;
    _judge.titleLabel.font = TEXT_FONT_BOLD_16;
    _judge.clipsToBounds = YES;
    _judge.layer.cornerRadius = 3;
    [self.contentView addSubview:_judge];
    
    
    title = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_judge.frame)+10, kScreenWidth-20, 20)];
    title.text = @"评价列表";
    title.textColor = TEXT_COLOR_LEVEL_2;
    title.font = TEXT_FONT_LEVEL_2;
    title.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:title];
    
    
}

@end
