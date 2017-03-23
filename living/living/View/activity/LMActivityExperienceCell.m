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
#import "UIImageView+WebCache.h"
@interface LMActivityExperienceCell ()

@property (nonatomic, strong) UIImageView *bKGImageView; // 背景图片
@property (nonatomic, strong) UILabel *titleLbl; // 主题
@property (nonatomic, strong) UILabel *detailLbl; // 详情
@property (nonatomic, strong) UIView *shadow;
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
- (void)setVO:(LMEventListVO *)list{
    
    [_bKGImageView sd_setImageWithURL:[NSURL URLWithString:list.eventImg] placeholderImage:nil];
    _bKGImageView.contentMode = UIViewContentModeScaleAspectFill;
    _bKGImageView.clipsToBounds = YES;

    _titleLbl.text = list.eventName;
    _detailLbl.text = list.address;
    
}
- (void)initLayout
{
    self.backgroundColor = [UIColor whiteColor];
    
    _bKGImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, kScreenWidth - 20, 185)];
    _bKGImageView.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:_bKGImageView];
    
    _shadow = [[UIView alloc] initWithFrame:_bKGImageView.frame];
    _shadow.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [self.contentView addSubview:_shadow];
    
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
    
}



@end
