//
//  LMQuestionTableViewCell.m
//  living
//
//  Created by Ding on 2016/12/19.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMQuestionTableViewCell.h"
#import "FitConsts.h"
#import "UIView+frame.h"
#import "UIImageView+WebCache.h"

@interface LMQuestionTableViewCell ()
{
    UIView *backView;
    UIImageView *headView;
    UILabel *contentLabel;
    UIImageView *headV;
    UILabel *nameLabel;
    UILabel *timeLabel;
    CGFloat contentHight;
    UIButton *clickButton;
;
}

@end

@implementation LMQuestionTableViewCell

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
    headView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 25, 30, 30)];
    headView.contentMode = UIViewContentModeScaleAspectFill;
    headView.clipsToBounds = YES;
    headView.layer.cornerRadius = 2;
    headView.backgroundColor = BG_GRAY_COLOR;
    [self.contentView addSubview:headView];
    
    
    headV = [[UIImageView alloc] initWithFrame:CGRectMake(80, 50, 20, 20)];
    headV.contentMode = UIViewContentModeScaleAspectFill;
    headV.clipsToBounds = YES;
    headV.layer.cornerRadius = 10;
    headV.backgroundColor = BG_GRAY_COLOR;
    [backView addSubview:headV];

    
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15+15+30, 25, 120, 30)];
    nameLabel.textColor = TEXT_COLOR_LEVEL_1;
    nameLabel.font = TEXT_FONT_LEVEL_1;
    [self.contentView addSubview:nameLabel];
    
    timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-120, 25 , 105, 30)];
    timeLabel.font = TEXT_FONT_LEVEL_3;
    timeLabel.textColor = TEXT_COLOR_LEVEL_3;
    [self.contentView addSubview:timeLabel];
    
    backView = [[UIView alloc] initWithFrame:CGRectMake(60, 45, kScreenWidth-75, 60)];
    backView.backgroundColor = BG_GRAY_COLOR;
    backView.layer.borderColor = LINE_COLOR.CGColor;
    backView.layer.borderWidth = 0.5;
    backView.layer.cornerRadius = 5;
    [self addSubview:backView];
    
    contentLabel = [UILabel new];
    contentLabel.numberOfLines = 0;
    contentLabel.textColor = TEXT_COLOR_LEVEL_2;
    contentLabel.font  = TEXT_FONT_LEVEL_2;
    [backView addSubview:contentLabel];
    
    clickButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [clickButton setImage:[UIImage imageNamed:@"guidance"] forState:UIControlStateNormal];
    [backView addSubview:clickButton];
    
}

-(void)setValue:(LMQuestionVO *)vo
{

    [headView sd_setImageWithURL:[NSURL URLWithString:vo.avatar]];
    nameLabel.text = vo.name;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init]; //初始化格式器。
    [formatter setDateFormat:@"MM-dd hh:mm"];//定义时间为这种格式： YYYY-MM-dd hh:mm:ss 。
    NSString *currentTime = [formatter stringFromDate:vo.time];
    [timeLabel setText:currentTime];
    
    contentLabel.text = vo.content;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    //参数1 代表文字自适应的范围 2代表 文字自适应的方式前三种 3代表文字在自适应过程中自适应的字体大小
    //   NSString *string =@"果然我问问我吩咐我跟我玩嗡嗡图文无关的身份和她和热稳定";
    contentHight = [vo.content boundingRectWithSize:CGSizeMake(kScreenWidth-105, 100000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size.height;
    
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [nameLabel sizeToFit];
    [timeLabel sizeToFit];
    [contentLabel sizeToFit];
    [backView sizeToFit];
    [contentLabel sizeToFit];
    [clickButton sizeToFit];
    nameLabel.frame = CGRectMake(15+15+30, 25, nameLabel.bounds.size.width, 30);
    timeLabel.frame = CGRectMake(kScreenWidth-timeLabel.bounds.size.width-15, 25, timeLabel.bounds.size.width, 30);
    backView.frame = CGRectMake(60, 55, kScreenWidth-75, contentHight+30+5);
    contentLabel.frame = CGRectMake(15, 15, kScreenWidth-105, contentHight);
    clickButton.frame = CGRectMake(kScreenWidth-75-40, contentHight+15, 30, 20);

}

+ (CGFloat)cellHigth:(NSString *)titleString
{
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    CGFloat conHigh = [titleString boundingRectWithSize:CGSizeMake(kScreenWidth-105, 100000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size.height;
    return (60+conHigh+35);
}

@end
