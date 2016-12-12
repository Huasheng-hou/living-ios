//
//  LMClassroomCell.m
//  living
//
//  Created by Ding on 2016/12/12.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMClassroomCell.h"
#import "FitConsts.h"
#import "UIView+frame.h"
#import "UIImageView+WebCache.h"

@interface LMClassroomCell ()
{
    UIView *backView;
    UIImageView *headView;
    UILabel *titleLabel;
    UIImageView *headV;
    UILabel *nameLabel;
    UILabel *priceLabel;
    UILabel *timeLabel;
    UILabel *numberLabel;
}

@end

@implementation LMClassroomCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self    = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setBackgroundColor:BG_GRAY_COLOR];
        [self addSubviews];
    }
    return self;
}

-(void)addSubviews
{
    backView = [[UIView alloc] initWithFrame:CGRectMake(15, 15, kScreenWidth-30, 120)];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.cornerRadius = 5;
    [self addSubview:backView];
    
    headView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, kScreenWidth, 60)];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 15, self.frame.size.width-90, 30)];
    titleLabel.textColor = TEXT_COLOR_LEVEL_2;
    titleLabel.font = TEXT_FONT_LEVEL_1;
    [backView addSubview:titleLabel];
    
    
    
}

-(void)setValue:(ClassroomVO *)list
{
    titleLabel.text = list.voiceTitle;
    
}


@end
