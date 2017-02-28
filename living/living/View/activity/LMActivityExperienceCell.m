//
//  LMActivityExperienceCell.m
//  living
//
//  Created by WangShengquan on 2017/2/22.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMActivityExperienceCell.h"
#import "FitConsts.h"
#import "LMActivityExperienceBtn.h"

@interface LMActivityExperienceCell ()

@property (nonatomic, strong) UIImageView *bKGImageView; // 背景图片
@property (nonatomic, strong) UILabel *titleLbl; // 主题
@property (nonatomic, strong) UILabel *detailLbl; // 详情
@property (nonatomic, strong) LMActivityExperienceBtn *likeBtn; // 点赞按钮
@property (nonatomic, strong) LMActivityExperienceBtn *commentBtn; // 评论按钮
@property (nonatomic, strong) LMActivityExperienceBtn *shareBtn;  // 分享按钮
@property (nonatomic, strong) UIButton *gradeBtn; // 评分按钮

@end


@implementation LMActivityExperienceCell

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
    self.backgroundColor = [UIColor whiteColor];
    
    _bKGImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, kScreenWidth - 20, 185)];
    _bKGImageView.backgroundColor = [UIColor blueColor];
    [self.contentView addSubview:_bKGImageView];
    
    _titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 114, kScreenWidth - 60, 19)];
    _titleLbl.text = @"动手吧！好吃到飞起来的料理";
    _titleLbl.font = TEXT_FONT_LEVEL_1;
    _titleLbl.textColor = [UIColor whiteColor];
    [self.contentView addSubview:_titleLbl];
    
    _detailLbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 142.5, kScreenWidth - 60, 30)];
    _detailLbl.numberOfLines = 0;
    _detailLbl.text = @"新年新计划，是时候开展一个属于你的音乐之旅，年后让你周围的小伙伴眼前一亮哦";
    _detailLbl.font = TEXT_FONT_LEVEL_3;
    _detailLbl.textColor = [UIColor whiteColor];
    [self.contentView addSubview:_detailLbl];
    
    _gradeBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 73, 195, 63, 23)];
    [_gradeBtn setTitle:@"评一下" forState:UIControlStateNormal];
    _gradeBtn.titleLabel.font = TEXT_FONT_LEVEL_2;
    [_gradeBtn setTitleColor:ORANGE_COLOR forState:UIControlStateNormal];
    _gradeBtn.layer.borderWidth = 0.5;
    _gradeBtn.layer.borderColor = ORANGE_COLOR.CGColor;
    [_gradeBtn addTarget:self action:@selector(grandeBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_gradeBtn];
    
    _shareBtn = [[LMActivityExperienceBtn alloc]initWithFrame:CGRectMake(kScreenWidth - 138, 195, 55, 23) actionTitle:@"分享" IconImage:nil];
    [_shareBtn addTarget:self action:@selector(shareBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_shareBtn];
    
    _commentBtn = [[LMActivityExperienceBtn alloc]initWithFrame:CGRectMake(kScreenWidth - 203, 195, 55, 23) actionTitle:@"评论" IconImage:nil];
    [_commentBtn addTarget:self action:@selector(commentBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_commentBtn];
    
    _likeBtn = [[LMActivityExperienceBtn alloc]initWithFrame:CGRectMake(kScreenWidth - 268, 195, 55, 23) actionTitle:@"点赞" IconImage:nil];
    [_likeBtn addTarget:self action:@selector(likeBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_likeBtn];
    
}

- (void)grandeBtnPressed:(UIButton *)button
{
    [self.delegate grade];
}

- (void)shareBtnPressed:(LMActivityExperienceBtn *)button
{
    [self.delegate share];
}

- (void)commentBtnPressed:(LMActivityExperienceBtn *)button
{
    [self.delegate comment];
}

- (void)likeBtnPressed:(LMActivityExperienceBtn *)button
{
    [self.delegate like];
}


@end
