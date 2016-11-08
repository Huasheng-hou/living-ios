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
    _numLabel.text = @"订单金额 ￥300";
    _numLabel.font = TEXT_FONT_LEVEL_2;
    _numLabel.textColor = TEXT_COLOR_LEVEL_3;
    [cellView addSubview:_numLabel];
    
    
    _priceLabel = [UILabel new];
    _priceLabel.text = @"订单金额 ￥300";
    _priceLabel.font = TEXT_FONT_LEVEL_3;
    _priceLabel.textColor = LIVING_COLOR;
    [cellView addSubview:_priceLabel];
    
    
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0, 114.5, kScreenWidth-30, 0.5)];
    line3.backgroundColor = LINE_COLOR;
    [cellView addSubview:line3];
    
    UIView *foot = [[UIView alloc] initWithFrame:CGRectMake(0, 115, kScreenWidth-30, 35)];
    foot.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
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

-(void)setValue:(LMOrderVO *)list
{
    [_headImage sd_setImageWithURL:[NSURL URLWithString:list.eventImg]];
    _timeLabel.text = [NSString stringWithFormat:@"订购时间：%@",list.orderingTime];
    NSString *textstr = [NSString stringWithFormat:@"订单金额 ￥%@",list.orderAmount];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:textstr];
    [str addAttribute:NSForegroundColorAttributeName value:TEXT_COLOR_LEVEL_2 range:NSMakeRange(0,4)];
    [str addAttribute:NSForegroundColorAttributeName value:LIVING_COLOR range:NSMakeRange(4,str.length-4)];
     _priceLabel.attributedText = str;
    
    _titleLabel.text = list.eventName;
    _orderNumLabel.text = list.orderNumber;
    
    _numLabel.text =[NSString stringWithFormat:@"x %d",list.number];
    
    
    
    int payNum = [list.payStatus intValue];
        switch (payNum) {
            case 0:
                _paytypeLabel.text = @"待支付";
                [_payButton setTitle:@"付款" forState:UIControlStateNormal];
                [_payButton addTarget:self action:@selector(payCell:) forControlEvents:UIControlEventTouchUpInside];
                break;
            case 1:
                _paytypeLabel.text = @"待确认";
                break;
            case 2:
                _paytypeLabel.text = @"已付款";
                [_payButton setTitle:@"退款" forState:UIControlStateNormal];
                [_payButton addTarget:self action:@selector(RefundCell:) forControlEvents:UIControlEventTouchUpInside];
                break;
            case 3:
                _paytypeLabel.text = @"退款中";
                break;
            case 4:
                _paytypeLabel.text = @"已退款";
                [_payButton setTitle:@"再订" forState:UIControlStateNormal];
                [_payButton addTarget:self action:@selector(rebookCell:) forControlEvents:UIControlEventTouchUpInside];
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

-(void)layoutSubviews
{
    [super layoutSubviews];
    [_orderNumLabel sizeToFit];
    [_paytypeLabel sizeToFit];
    [_titleLabel sizeToFit];
    [_priceLabel sizeToFit];
    [_timeLabel sizeToFit];
    [_deleteButton sizeToFit];
    [_payButton sizeToFit];
    [_numLabel sizeToFit];
    
    
    
    _orderNumLabel.frame = CGRectMake(10, 0, _orderNumLabel.bounds.size.width, 35);
    _paytypeLabel.frame = CGRectMake(kScreenWidth-40-_paytypeLabel.bounds.size.width, 0, _paytypeLabel.bounds.size.width, 35);
    _titleLabel.frame = CGRectMake(80, 45, kScreenWidth-120, _titleLabel.bounds.size.height*2);
    _priceLabel.frame = CGRectMake(kScreenWidth-40-_priceLabel.bounds.size.width, 90, _priceLabel.bounds.size.width, _priceLabel.bounds.size.height);
    _timeLabel.frame = CGRectMake(10, 115, _timeLabel.bounds.size.width, 35);
    
    _deleteButton.frame = CGRectMake(kScreenWidth-_deleteButton.bounds.size.width*2-50, 120, _deleteButton.bounds.size.width, 25);
    
    _payButton.frame = CGRectMake(kScreenWidth-_payButton.bounds.size.width-40, 120, _payButton.bounds.size.width, 25);
    
    _numLabel.frame = CGRectMake(80, 90, _numLabel.bounds.size.width,  _priceLabel.bounds.size.height);
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



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
