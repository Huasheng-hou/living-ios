//
//  LMBlanceHeadCell.m
//  living
//
//  Created by Ding on 2016/10/30.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMBlanceHeadCell.h"
#import "FitConsts.h"

@interface LMBlanceHeadCell ()


@property(nonatomic, strong)UILabel *payOutLabel;
@property(nonatomic, strong)UILabel *chargeLabel;

@property(nonatomic, strong)UILabel *payCount;
@property(nonatomic, strong)UILabel *chargeCount;
@property(nonatomic, strong)UILabel *refundCount;

@property(nonatomic, strong)UIButton *dateButton;

@end

@implementation LMBlanceHeadCell


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
    _timeLabel = [UILabel new];
    _timeLabel.text = @"10/2016";
    _timeLabel.textColor = TEXT_COLOR_LEVEL_2;
    _timeLabel.font  = TEXT_FONT_LEVEL_2;
    [self.contentView addSubview:_timeLabel];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 45, kScreenWidth, 225)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:backView];
    
    _dateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_dateButton setImage:[UIImage imageNamed:@"date"] forState:UIControlStateNormal];
    _dateButton.frame = CGRectMake(kScreenWidth-50, 0, 50, 45);
    [_dateButton addTarget:self action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_dateButton];
    
    
    
    UILabel *listLabel = [UILabel new];
    listLabel.text = @"本月账单表";
    listLabel.font = TEXT_FONT_LEVEL_1;
    listLabel.textColor = TEXT_COLOR_LEVEL_2;
    [listLabel sizeToFit];
    listLabel.frame = CGRectMake(15, 0, listLabel.bounds.size.width, 55);
    [backView addSubview:listLabel];
    
    UILabel *payout = [UILabel new];
    payout.text = @"支出";
    payout.font = TEXT_FONT_LEVEL_1;
    payout.textColor = TEXT_COLOR_LEVEL_3;
    [payout sizeToFit];
    payout.frame = CGRectMake((kScreenWidth-payout.bounds.size.width)/2, 0, payout.bounds.size.width, 55/2);
    [backView addSubview:payout];
    
    UILabel *charge = [UILabel new];
    charge.text = @"充值";
    charge.font = TEXT_FONT_LEVEL_1;
    charge.textColor = TEXT_COLOR_LEVEL_3;
    [charge sizeToFit];
    charge.frame = CGRectMake((kScreenWidth-charge.bounds.size.width)/2, 55/2, charge.bounds.size.width, 55/2);
    [backView addSubview:charge];
    
    _payOutLabel = [UILabel new];
    _payOutLabel.text = @"-2525";
    _payOutLabel.textColor = TEXT_COLOR_LEVEL_2;
    _payOutLabel.font  = TEXT_FONT_LEVEL_1;
    [backView addSubview:_payOutLabel];
    
    _chargeLabel = [UILabel new];
    _chargeLabel.text = @"+2000";
    _chargeLabel.textColor = TEXT_COLOR_LEVEL_2;
    _chargeLabel.font  = TEXT_FONT_LEVEL_1;
    [backView addSubview:_chargeLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 54.5, kScreenWidth-10, 0.5)];
    lineView.backgroundColor = LINE_COLOR;
    [backView addSubview:lineView];
    
    
    UIView *payView = [[UIView alloc] initWithFrame:CGRectMake(10, 75, (kScreenWidth-40)/3, 140)];
    payView.backgroundColor = [UIColor colorWithRed:251/255.0 green:103/255.0 blue:95/255.0 alpha:1.0];
    [backView addSubview:payView];
    
    UIImageView *payImage = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-40)/6-20, 10, 40, 40)];
    payImage.image = [UIImage imageNamed:@"payout"];
    [payView addSubview:payImage];
    
    UILabel *payoutLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, (kScreenWidth-40)/3, 20)];
    payoutLabel.text = @"活动支出";
    payoutLabel.textAlignment = NSTextAlignmentCenter;
    payoutLabel.font = TEXT_FONT_LEVEL_3;
    payoutLabel.textColor = [UIColor whiteColor];
    [payView addSubview:payoutLabel];
    
    _payCount = [UILabel new];
    _payCount.text = @"￥ 6000";
    _payCount.textColor = [UIColor whiteColor];
    _payCount.textAlignment = NSTextAlignmentCenter;
    [payView addSubview:_payCount];
    
    
    UIView *chargeView = [[UIView alloc] initWithFrame:CGRectMake(20+(kScreenWidth-40)/3, 75, (kScreenWidth-40)/3, 140)];
    chargeView.backgroundColor = LIVING_COLOR;
    [backView addSubview:chargeView];
    
    UIImageView *chargeImage = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-40)/6-20, 10, 40, 40)];
    chargeImage.image = [UIImage imageNamed:@"charge"];
    [chargeView addSubview:chargeImage];
    
    UILabel *rechargeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, (kScreenWidth-40)/3, 20)];
    rechargeLabel.text = @"充值进账";
    rechargeLabel.textAlignment = NSTextAlignmentCenter;
    rechargeLabel.font = TEXT_FONT_LEVEL_3;
    rechargeLabel.textColor = [UIColor whiteColor];
    [chargeView addSubview:rechargeLabel];
    
    _chargeCount = [UILabel new];
    _chargeCount.text = @"￥ 6000";
    _chargeCount.textColor = [UIColor whiteColor];
    _chargeCount.textAlignment = NSTextAlignmentCenter;
    [chargeView addSubview:_chargeCount];
    
    
    UIView *refundView = [[UIView alloc] initWithFrame:CGRectMake(30+(kScreenWidth-40)*2/3, 75, (kScreenWidth-40)/3, 140)];
    refundView.backgroundColor = [UIColor colorWithRed:245/255.0 green:149/255.0 blue:43/255.0 alpha:1.0];
    [backView addSubview:refundView];
    
    UIImageView *refundImage = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-40)/6-20, 10, 40, 40)];
    refundImage.image = [UIImage imageNamed:@"refund"];
    [refundView addSubview:refundImage];
    
    UILabel *refundLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, (kScreenWidth-40)/3, 20)];
    refundLabel.text = @"退款金额";
    refundLabel.textAlignment = NSTextAlignmentCenter;
    refundLabel.font = TEXT_FONT_LEVEL_3;
    refundLabel.textColor = [UIColor whiteColor];
    [refundView addSubview:refundLabel];
    
    _refundCount = [UILabel new];
    _refundCount.text = @"￥ 6000";
    _refundCount.textColor = [UIColor whiteColor];
    _refundCount.textAlignment = NSTextAlignmentCenter;
    [refundView addSubview:_refundCount];
}

-(void)setDic:(NSDictionary *)dic
{
    LMBalanceBillVO *dict = [[LMBalanceBillVO alloc] initWithDictionary:dic];
    _payOutLabel.text = dict.expenditure;
    _chargeLabel.text = dict.recharges;
    _payCount.text = dict.eventsBill;
    _chargeCount.text = dict.rechargesBill;
    _refundCount.text = dict.refundsBill;
    
}




-(void)layoutSubviews
{
    [super layoutSubviews];
    [_timeLabel sizeToFit];
    [_payOutLabel sizeToFit];
    [_chargeLabel sizeToFit];
    
    [_payCount sizeToFit];
    [_chargeCount sizeToFit];
    [_refundCount sizeToFit];
    
    _timeLabel.frame = CGRectMake(10, 0, _timeLabel.bounds.size.width, 45);
    _payOutLabel.frame = CGRectMake(kScreenWidth-10-_payOutLabel.bounds.size.width, 0, _payOutLabel.bounds.size.width, 55/2);
    _chargeLabel.frame = CGRectMake(kScreenWidth-10-_chargeLabel.bounds.size.width, 55/2, _chargeLabel.bounds.size.width, 55/2);
    _payCount.frame = CGRectMake(0, 90, (kScreenWidth-40)/3, 30);
    _chargeCount.frame = CGRectMake(0, 90, (kScreenWidth-40)/3, 30);
    _refundCount.frame = CGRectMake(0, 90, (kScreenWidth-40)/3, 30);
}


-(void)clickAction
{
    if ([_delegate respondsToSelector:@selector(cellWillclick:)]) {
        [_delegate cellWillclick:self];
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
