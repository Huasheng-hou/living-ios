//
//  LMOrderCell.m
//  living
//
//  Created by Ding on 16/10/10.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMOrderCell.h"
#import "FitConsts.h"
#import "UIImageView+WebCache.h"

@interface LMOrderCell () {
    float _xScale;
    float _yScale;
}

@property(nonatomic, strong)UILabel *orderNumLabel;

@property(nonatomic, strong)UILabel *paytypeLabel;

@property(nonatomic, strong)UILabel *titleLabel;

@property(nonatomic, strong)UIImageView *headImage;

@property(nonatomic, strong)UILabel *priceLabel;

@property(nonatomic, strong)UILabel *timeLabel;

@property(nonatomic, strong)UIButton *deleteButton;

@property(nonatomic, strong)UIButton *payButton;

@property(nonatomic, strong)UILabel *numLabel;

@property(nonatomic, strong)UIImageView *deductionImage;
@property(nonatomic, strong)UILabel *couponLabel;

@end

@implementation LMOrderCell

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
    UIView *cellbackView = [[UIView alloc] initWithFrame:CGRectMake(14.5, 14.5, kScreenWidth-29, 151)];
    cellbackView.backgroundColor = LINE_COLOR;
    cellbackView.layer.cornerRadius = 5;
    [self addSubview:cellbackView];
    
    
    UIView *cellView = [[UIView alloc] initWithFrame:CGRectMake(0.5, 0.5, kScreenWidth-30, 150)];
    cellView.backgroundColor = [UIColor whiteColor];
    cellView.layer.cornerRadius = 5;
    [cellbackView addSubview:cellView];
    
    _orderNumLabel = [UILabel new];
    _orderNumLabel.text = @"订单：1234567891234564789123456";
    _orderNumLabel.font = TEXT_FONT_LEVEL_2;
    _orderNumLabel.textColor = TEXT_COLOR_LEVEL_2;
    [cellView addSubview:_orderNumLabel];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 34.5, kScreenWidth-30, 0.5)];
    line.backgroundColor = LINE_COLOR;
    [cellView addSubview:line];
    
    _paytypeLabel = [UILabel new];
    _paytypeLabel.textAlignment = NSTextAlignmentCenter;
    _paytypeLabel.text = @"未付款";
    _paytypeLabel.font = TEXT_FONT_LEVEL_2;
    _paytypeLabel.textColor = LIVING_COLOR;
    [cellView addSubview:_paytypeLabel];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth-92, 5, 0.5, 25)];
    line2.backgroundColor = LINE_COLOR;
    [cellView addSubview:line2];
    
    _headImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 45, 60, 60)];
    _headImage.backgroundColor = BG_GRAY_COLOR;
    _headImage.layer.cornerRadius=5;
    _headImage.clipsToBounds = YES;
    _headImage.contentMode = UIViewContentModeScaleAspectFill;
    
    _headImage.backgroundColor = BG_GRAY_COLOR;
    [cellView addSubview:_headImage];
    
    _titleLabel = [UILabel new];
    _titleLabel.text = @"活动🔥名称活动🔥名称活动🔥名称活动🔥名称活动🔥名称活动🔥名称";
    _titleLabel.textColor = TEXT_COLOR_LEVEL_2;
    _titleLabel.font = TEXT_FONT_LEVEL_2;
    _titleLabel.numberOfLines = 2;
    [cellView addSubview:_titleLabel];
    
    _numLabel = [UILabel new];
    _numLabel.text = @"x1份";
    _numLabel.font = TEXT_FONT_LEVEL_2;
    _numLabel.textColor = TEXT_COLOR_LEVEL_3;
    [cellView addSubview:_numLabel];
    
    _deductionImage = [UIImageView new];
    [cellView addSubview:_deductionImage];
    
    _couponLabel = [UILabel new];
    _couponLabel.font = TEXT_FONT_LEVEL_2;
    _couponLabel.textColor = LIVING_REDCOLOR;
    [cellView addSubview:_couponLabel];
    
    _priceLabel = [UILabel new];
    _priceLabel.font = TEXT_FONT_LEVEL_3;
    _priceLabel.textColor = LIVING_COLOR;
    [cellView addSubview:_priceLabel];
    
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0, 114.5, kScreenWidth-30, 0.5)];
    line3.backgroundColor = LINE_COLOR;
    [cellView addSubview:line3];
    
    UIView *foot = [[UIView alloc] initWithFrame:CGRectMake(0, 115, kScreenWidth-30, 35)];
    foot.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
    foot.backgroundColor = [UIColor whiteColor];
    [cellView addSubview:foot];
    
    _timeLabel = [UILabel new];
    _timeLabel.text = @"订购时间：2016-12-24 12:30:20";
    _timeLabel.font = TEXT_FONT_LEVEL_3;
    _timeLabel.textColor = TEXT_COLOR_LEVEL_2;
    [cellView addSubview:_timeLabel];
    

    _deleteButton = [UIButton buttonWithType:UIButtonTypeSystem];
    //        _topBtn.backgroundColor = _COLOR_N(red);
    [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [_deleteButton setTintColor:TEXT_COLOR_LEVEL_3];
    _deleteButton.showsTouchWhenHighlighted = YES;
    _deleteButton.frame = CGRectMake(0, 0, 48.f, 48.f);
    [_deleteButton addTarget:self action:@selector(deleteCell:) forControlEvents:UIControlEventTouchUpInside];
    [cellView addSubview:_deleteButton];
    
    
    _payButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [_payButton setTintColor:LIVING_COLOR];
    _payButton.showsTouchWhenHighlighted = YES;
    _payButton.frame = CGRectMake(0, 0, 48.f, 48.f);
    
    [cellView addSubview:_payButton];
}

- (void)setValue:(LMOrderVO *)list
{
    if (list .type&&[list.type isEqualToString:@"voice"]) {
        _titleLabel.text = list.voiceTitle;
        [_headImage sd_setImageWithURL:[NSURL URLWithString:list.voiceImages]];
    }
    
    if (list .type&&[list.type isEqualToString:@"event"]) {
        _titleLabel.text = list.eventName;
        [_headImage sd_setImageWithURL:[NSURL URLWithString:list.eventImg]];
    }
    
    _timeLabel.text = [NSString stringWithFormat:@"订购时间：%@",list.orderingTime];
    
    
    _orderNumLabel.text = list.orderNumber;
    
    _numLabel.text =[NSString stringWithFormat:@"x %d份",list.number];
    
    NSString *textstr;
    
    if (list.hasCoupon==YES) {
        
        _deductionImage.image   = [UIImage imageNamed:@"deduction"];
        _couponLabel.text       = [NSString stringWithFormat:@"￥%@",list.couponMoney];
        textstr = [NSString stringWithFormat:@"订单金额 ￥%@",list.discountMoney];
    }else{
        
        _couponLabel.text   = @"";
        textstr = [NSString stringWithFormat:@"订单金额 ￥%@",list.orderAmount];
    }
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:textstr];
    
    [str addAttribute:NSForegroundColorAttributeName value:TEXT_COLOR_LEVEL_2 range:NSMakeRange(0,4)];
    [str addAttribute:NSForegroundColorAttributeName value:LIVING_COLOR range:NSMakeRange(4,str.length-4)];
    
    _priceLabel.attributedText = str;
    
    int payNum = [list.payStatus intValue];
    
    switch (payNum) {
        case 0:
            _paytypeLabel.text = @"待支付";
            [_payButton setTitle:@"付款" forState:UIControlStateNormal];
            [_payButton addTarget:self action:@selector(payCell:) forControlEvents:UIControlEventTouchUpInside];
            break;
        case 1:
            _paytypeLabel.text = @"待确认";
            _deleteButton.hidden = YES;
            break;
        case 2:
            _paytypeLabel.text = @"已付款";
            [_payButton setTitle:@"退款" forState:UIControlStateNormal];
            [_payButton addTarget:self action:@selector(RefundCell:) forControlEvents:UIControlEventTouchUpInside];
            break;
        case 3:
            _paytypeLabel.text = @"退款中";
            _deleteButton.hidden = YES;
            break;
        case 4:
            _paytypeLabel.text = @"已退款";
            [_payButton setTitle:@"再订" forState:UIControlStateNormal];
            [_payButton addTarget:self action:@selector(rebookCell:) forControlEvents:UIControlEventTouchUpInside];
            break;
        case 5:
            _paytypeLabel.text = @"失效";
            [_payButton setTitle:@"删除" forState:UIControlStateNormal];
            [_payButton addTarget:self action:@selector(deleteCell:) forControlEvents:UIControlEventTouchUpInside];
            _deleteButton.hidden = YES;
            break;
        case 6:
            _paytypeLabel.text = @"进行中";
            _deleteButton.hidden = YES;
            break;
        case 7:
            _paytypeLabel.text = @"已完结";
            [_payButton setTitle:@"删除" forState:UIControlStateNormal];
            [_payButton addTarget:self action:@selector(deleteCell:) forControlEvents:UIControlEventTouchUpInside];
            _deleteButton.hidden = YES;
            break;
            
        default:
            break;
    }
}

- (void)setXScale:(float)xScale yScale:(float)yScale
{
    _xScale = xScale;
    _yScale = yScale;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [_orderNumLabel sizeToFit];
    [_paytypeLabel sizeToFit];
    
    [_priceLabel sizeToFit];
    [_timeLabel sizeToFit];
    [_deleteButton sizeToFit];
    [_payButton sizeToFit];
    [_numLabel sizeToFit];
    [_deductionImage sizeToFit];
    [_couponLabel sizeToFit];
    
    CGFloat     titleHeight = ceil([_titleLabel.text boundingRectWithSize:CGSizeMake(kScreenWidth - 120, 50)
                                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                                               attributes:[NSDictionary dictionaryWithObject:_titleLabel.font forKey:NSFontAttributeName]
                                                                  context:[[NSStringDrawingContext alloc] init]].size.height);
    
    if (titleHeight > 35) {
        
        titleHeight     = 35;
    }
    
    _orderNumLabel.frame = CGRectMake(10, 0, _orderNumLabel.bounds.size.width, 35);
    _paytypeLabel.frame = CGRectMake(kScreenWidth-40-_paytypeLabel.bounds.size.width, 0, _paytypeLabel.bounds.size.width, 35);
    
    _titleLabel.frame = CGRectMake(80, 45, kScreenWidth-120, titleHeight);
    _priceLabel.frame = CGRectMake(kScreenWidth-40-_priceLabel.bounds.size.width, 90, _priceLabel.bounds.size.width, _priceLabel.bounds.size.height);
    _timeLabel.frame = CGRectMake(10, 115, _timeLabel.bounds.size.width, 35);
    
    _deleteButton.frame = CGRectMake(kScreenWidth-_deleteButton.bounds.size.width*2-50, 120, _deleteButton.bounds.size.width, 25);
    
    _payButton.frame = CGRectMake(kScreenWidth-_payButton.bounds.size.width-40, 120, _payButton.bounds.size.width, 25);
    
    _numLabel.frame = CGRectMake(80, 90, _numLabel.bounds.size.width,  _priceLabel.bounds.size.height);
    _deductionImage.frame = CGRectMake(95+_numLabel.bounds.size.width, 90, 16, 16);
    _couponLabel.frame = CGRectMake(95+_numLabel.bounds.size.width+20, 90, _couponLabel.bounds.size.width, _couponLabel.bounds.size.height);
}

//删除
- (void)deleteCell:(id)sender
{
    if ([_delegate respondsToSelector:@selector(cellWilldelete:)]) {
        [_delegate cellWilldelete:self];
    }
    
}
//付款
- (void)payCell:(id)sender
{
    if ([_delegate respondsToSelector:@selector(cellWillpay:)]) {
        [_delegate cellWillpay:self];
    }
    
}

//退款
- (void)RefundCell:(id)sender
{
    if ([_delegate respondsToSelector:@selector(cellWillRefund:)]) {
        [_delegate cellWillRefund:self];
    }
    
}
//再订
- (void)rebookCell:(id)sender
{
    if ([_delegate respondsToSelector:@selector(cellWillrebook:)]) {
        [_delegate cellWillrebook:self];
    }
    
}

@end
