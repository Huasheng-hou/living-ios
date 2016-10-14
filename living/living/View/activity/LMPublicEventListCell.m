//
//  LMPublicEventListCell.m
//  living
//
//  Created by Ding on 16/10/14.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMPublicEventListCell.h"
#import "FitConsts.h"

#define titleW titleLable.bounds.size.width
@implementation LMPublicEventListCell

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
    //活动标题
    UILabel *titleLable = [UILabel new];
    titleLable.text = @"项目标题";
    titleLable.font = TEXT_FONT_LEVEL_1;
    titleLable.textColor = TEXT_COLOR_LEVEL_2;
    [titleLable sizeToFit];
    titleLable.frame = CGRectMake(10, 5, titleLable.bounds.size.width, 30);
    [self.contentView addSubview:titleLable];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(20+titleW, 40, kScreenWidth-25-titleW, 1.0)];
    lineView.backgroundColor = LINE_COLOR;
    [self.contentView addSubview:lineView];
    
    //项目介绍
    UILabel *phoneLable = [UILabel new];
    phoneLable.text = @"项目介绍";
    phoneLable.font = TEXT_FONT_LEVEL_1;
    phoneLable.textColor = TEXT_COLOR_LEVEL_2;
    [phoneLable sizeToFit];
    phoneLable.frame = CGRectMake(10, 50, titleW, 30);
    [self.contentView addSubview:phoneLable];
    
    //项目图片
    UILabel *imageLable = [UILabel new];
    imageLable.text = @"项目图片";
    imageLable.font = TEXT_FONT_LEVEL_1;
    imageLable.textColor = TEXT_COLOR_LEVEL_2;
    [imageLable sizeToFit];
    imageLable.frame = CGRectMake(10, 210, imageLable.bounds.size.width, 30);
    [self.contentView addSubview:imageLable];
    
    UILabel *imagemsgLable = [UILabel new];
    imagemsgLable.text = @"(建议尺寸：750*330)";
    imagemsgLable.font = TEXT_FONT_LEVEL_3;
    imagemsgLable.textColor = TEXT_COLOR_LEVEL_3;
    [imagemsgLable sizeToFit];
    imagemsgLable.frame = CGRectMake(15+imageLable.bounds.size.width, 210, imagemsgLable.bounds.size.width, 30);
    [self.contentView addSubview:imagemsgLable];
    
    
    
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
