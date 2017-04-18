//
//  LMYGBDetailCell.m
//  living
//
//  Created by hxm on 2017/3/21.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMYGBDetailCell.h"
#import "FitConsts.h"
@implementation LMYGBDetailCell
{
    UILabel * title;
    UILabel * number;
    UILabel * type;
    UILabel * dateTime;
    UILabel * line;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubViews];
    }
    return self;
}

- (void)addSubViews{
    UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 70)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:backView];
    
    
    title = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth-20, 20)];
    title.text = @"这是果币收支说明";
    title.textColor = TEXT_COLOR_LEVEL_3;
    title.font = TEXT_FONT_BOLD_16;
    [backView addSubview:title];
    
    
    number = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(title.frame)+10, 40, 20)];
    number.text = @"腰果币:";
    number.textColor = TEXT_COLOR_LEVEL_4;
    number.font = TEXT_FONT_BOLD_14;
    [number sizeToFit];
    [backView addSubview:number];
    
    type = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(number.frame)+2, CGRectGetMinY(number.frame), 50, 15)];
    type.text = @"+1";
    type.textColor = ORANGE_COLOR;
    type.font = TEXT_FONT_BOLD_16;
    [backView addSubview:type];
    
    
    dateTime = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/2, CGRectGetMaxY(title.frame)+10, kScreenWidth/2-10, 20)];
    dateTime.text = @"2017-3-10 16:27:30";
    dateTime.textColor = TEXT_COLOR_LEVEL_4;
    dateTime.font = TEXT_FONT_BOLD_14;
    dateTime.textAlignment = NSTextAlignmentRight;
    [backView addSubview:dateTime];
    
    line = [[UILabel alloc] initWithFrame:CGRectMake(0, 69, kScreenWidth, 1)];
    line.backgroundColor = BG_GRAY_COLOR;
    [backView addSubview:line];
}

- (void)setValue:(LMYGBDetailVO *)vo{
    
    title.text = vo.title;
    dateTime.text = vo.dateTime;
    
    if ([vo.type isEqualToString:@"1"]) {
        type.text = [NSString stringWithFormat:@"+%@", vo.numbers];
    }else if ([vo.type isEqualToString:@"2"]){
        type.text = [NSString stringWithFormat:@"-%@", vo.numbers];
    }
    
    
}

@end
