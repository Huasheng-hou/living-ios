//
//  LMFindCell.m
//  living
//
//  Created by Ding on 16/9/26.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMFindCell.h"
#import "FitConsts.h"
#import "UIView+frame.h"

@interface LMFindCell (){
    float _xScale;
    float _yScale;
}

//@property(nonatomic,retain)UIImageView *headImage;
//
//@property(nonatomic,retain)UILabel *questonLabel;
//
//@property(nonatomic,retain)UILabel *numLabel;

@end

@implementation LMFindCell

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
    
    //背景圆角白色view
    UIView *cellView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth-20, 135)];
    cellView.layer.cornerRadius = 5;
    cellView.layer.masksToBounds = YES;
    cellView.backgroundColor = [UIColor whiteColor];
    [self addSubview:cellView];
    //标题
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth-40, 20)];
    _titleLabel.font = TEXT_FONT_LEVEL_1;
    _titleLabel.textColor = TEXT_COLOR_LEVEL_2;
    _titleLabel.text = @"这是新功能标题";
    [cellView addSubview:_titleLabel];
    //内容
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, kScreenWidth-40, 60)];
    _contentLabel.font = TEXT_FONT_LEVEL_2;
    _contentLabel.textColor = TEXT_COLOR_LEVEL_3;
    _contentLabel.numberOfLines = 0;
    _contentLabel.textAlignment = NSTextAlignmentJustified;
    _contentLabel.text = @"这是新功能标题这是新功能标题这是新功能标题这是新功能标题这是新功能标题这是新功能标题这是新功能标题是新功";
    [cellView addSubview:_contentLabel];
    //lineLabel
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 105, kScreenWidth-40, 0.5)];
    lineLabel.backgroundColor = LINE_COLOR;
    [cellView addSubview:lineLabel];
    //奖杯图标
    UIImageView *cupIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 110, 17, 17)];
    [cupIV setImage:[UIImage imageNamed:@"zanIcon"]];
    [cellView addSubview:cupIV];
    //footLabel
    UILabel *footLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 110, kScreenWidth-100, 17)];
    footLabel.font = TEXT_FONT_LEVEL_3;
    footLabel.textColor = TEXT_COLOR_LEVEL_4;
    footLabel.text = @"下一个版本你做主";
    [cellView addSubview:footLabel];
    //点赞按钮
    UIImageView *thumbIV = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-70, 110, 17, 17)];
    [thumbIV setImage:[UIImage imageNamed:@"zanIcon-click"]];
    [cellView addSubview:thumbIV];
    //点赞数量
    _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-50, 110, 15, 117)];
    _numLabel.font = TEXT_FONT_LEVEL_3;
    _numLabel.textColor = TEXT_COLOR_LEVEL_4;
    _numLabel.text = @"300";
    [cellView addSubview:_numLabel];
}

-(void)setValue:(LMFindList *)list
{
//    _questonLabel.text = list.descrition;
    _numLabel.text = [NSString stringWithFormat:@"得赞数 %.0f",list.numberOfVotes];
    
}

- (void)setXScale:(float)xScale yScale:(float)yScale
{
    _xScale = xScale;
    _yScale = yScale;
}

//-(void)layoutSubviews
//{
//    [super layoutSubviews];
//    [_headImage sizeToFit];
//    [_questonLabel sizeToFit];
//    [_numLabel sizeToFit];
//
//    _headImage.frame =CGRectMake(22.5, 22.5, 50, 50);
//    _questonLabel.frame =CGRectMake(10, 5, kScreenWidth-116-20-15, 60);
//    _numLabel.frame =CGRectMake(0, 75, kScreenWidth-131-10, 20);
//    
//}



@end
