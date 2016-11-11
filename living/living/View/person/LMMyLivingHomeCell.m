//
//  LMMyLivingHomeCell.m
//  living
//
//  Created by Ding on 2016/10/25.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMMyLivingHomeCell.h"
#import "FitConsts.h"
#import "UIImageView+WebCache.h"
#import "LMRechargeButton.h"

@interface LMMyLivingHomeCell () {
    float _xScale;
    float _yScale;
}

@property(nonatomic,strong)UIImageView *imgView;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *detailLable;
@property(nonatomic,strong)UILabel *balanceLabel;
@property(nonatomic,strong)UILabel *joinLable;



@end

@implementation LMMyLivingHomeCell


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
    _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 190)];
    _imgView.backgroundColor = BG_GRAY_COLOR;
    _imgView.image = [UIImage imageNamed:@"112"];
    [self.contentView addSubview:_imgView];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 190)];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.5;
    [_imgView addSubview:backView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, kScreenWidth, 45)];
    _titleLabel.text = @"杭州荑凝生活馆";
    [_titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:_titleLabel];
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(65, 95, kScreenWidth-130, 2)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:whiteView];
    
    _detailLable = [[UILabel alloc] initWithFrame:CGRectMake(15, 115, kScreenWidth-30, 20)];
    _detailLable.text = @"荑凝生活馆,只为做更好的自己";
    _detailLable.textColor = [UIColor whiteColor];
    _detailLable.font = TEXT_FONT_LEVEL_2;
    _detailLable.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_detailLable];
    
    UIView *footView =[[UIView alloc] initWithFrame:CGRectMake(0, 200, kScreenWidth, 35)];
    footView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:footView];
    
    
    _balanceLabel = [UILabel new];
    _balanceLabel.text = @"余额 ￥306";
    _balanceLabel.font = TEXT_FONT_LEVEL_2;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:_balanceLabel.text];
    [str addAttribute:NSForegroundColorAttributeName value:TEXT_COLOR_LEVEL_2 range:NSMakeRange(0,3)];
    [str addAttribute:NSForegroundColorAttributeName value:LIVING_REDCOLOR range:NSMakeRange(3,str.length-3)];
    _balanceLabel.attributedText = str;
    [footView addSubview:_balanceLabel];
    
    
    _joinLable = [UILabel new];
    _joinLable.text = @"已参加 6次";
    _joinLable.font = TEXT_FONT_LEVEL_2;
    NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:_joinLable.text];
    [str2 addAttribute:NSForegroundColorAttributeName value:TEXT_COLOR_LEVEL_2 range:NSMakeRange(0,4)];
    [str2 addAttribute:NSForegroundColorAttributeName value:LIVING_COLOR range:NSMakeRange(4,str2.length-4)];
    _joinLable.attributedText = str2;
    [footView addSubview:_joinLable];
    
    
    
    LMRechargeButton *recharge = [LMRechargeButton buttonWithType:UIButtonTypeSystem];
    recharge.frame = CGRectMake(kScreenWidth-80, 0, 80, 35);
    recharge.leftLabel.text = @"立即充值";
    recharge.rightView.image = [UIImage imageNamed:@"Recharge-1"];
    [footView addSubview: recharge];
    
    [recharge addTarget:self action:@selector(rechargeAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
}
- (void)setXScale:(float)xScale yScale:(float)yScale
{
    _xScale = xScale;
    _yScale = yScale;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [_balanceLabel sizeToFit];
    [_joinLable sizeToFit];
    
    _balanceLabel.frame = CGRectMake(15, 0, _balanceLabel.bounds.size.width, 35);
    _joinLable.frame = CGRectMake(kScreenWidth/2-_joinLable.bounds.size.width/2, 0, _joinLable.bounds.size.width, 35);
    
}


-(void)rechargeAction:(id)sender
{
    if ([_delegate respondsToSelector:@selector(cellWillpay:)]) {
        [_delegate cellWillpay:self];
    }
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
