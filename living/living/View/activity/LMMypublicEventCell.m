//
//  LMMypublicEventCell.m
//  living
//
//  Created by Ding on 2016/11/16.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMMypublicEventCell.h"
#import "FitConsts.h"
#import "UIImageView+WebCache.h"

@interface LMMypublicEventCell () {
    float _xScale;
    float _yScale;
    UIView *cellView;
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

@implementation LMMypublicEventCell

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
    
    
    cellView = [[UIView alloc] initWithFrame:CGRectMake(0.5, 0.5, kScreenWidth-30, 150)];
    cellView.backgroundColor = [UIColor whiteColor];
    cellView.layer.cornerRadius = 5;
    [cellbackView addSubview:cellView];
    
    //活动标题
    _orderNumLabel = [UILabel new];
    _orderNumLabel.font = [UIFont systemFontOfSize:15];
    _orderNumLabel.textColor = TEXT_COLOR_LEVEL_1;
    [cellView addSubview:_orderNumLabel];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 34.5, kScreenWidth-30, 0.5)];
    line.backgroundColor = LINE_COLOR;
    [cellView addSubview:line];
    
    //活动状态
    _paytypeLabel = [UILabel new];
    _paytypeLabel.textAlignment = NSTextAlignmentCenter;
    _paytypeLabel.font = TEXT_FONT_LEVEL_2;
    _paytypeLabel.textColor = LIVING_COLOR;
    [cellView addSubview:_paytypeLabel];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth-92, 5, 0.5, 25)];
    line2.backgroundColor = LINE_COLOR;
    [cellView addSubview:line2];
    
    _headImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 45, 60, 60)];
    _headImage.backgroundColor = BG_GRAY_COLOR;
    _headImage.layer.cornerRadius=5;
    _headImage.clipsToBounds = YES;
    _headImage.contentMode = UIViewContentModeScaleAspectFill;
    
    _headImage.backgroundColor = BG_GRAY_COLOR;
    [cellView addSubview:_headImage];
    
    //活动详情
    _titleLabel = [UILabel new];
    _titleLabel.textColor = TEXT_COLOR_LEVEL_2;
    _titleLabel.font = TEXT_FONT_LEVEL_2;
    _titleLabel.numberOfLines = 2;
    [cellView addSubview:_titleLabel];
    
    //报名人数
    _numLabel = [UILabel new];
    _numLabel.font = TEXT_FONT_LEVEL_3;
    _numLabel.textColor = TEXT_COLOR_LEVEL_3;
    [cellView addSubview:_numLabel];
    _numLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(joinMunber)];
    [_numLabel addGestureRecognizer:tap];
    
    _deductionImage = [UIImageView new];
    [cellView addSubview:_deductionImage];
    
    
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0, 114.5, kScreenWidth-30, 0.5)];
    line3.backgroundColor = LINE_COLOR;
    [cellView addSubview:line3];
    
    UIView *foot = [[UIView alloc] initWithFrame:CGRectMake(0, 115, kScreenWidth-30, 35)];
    foot.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
    [cellView addSubview:foot];
    
    _timeLabel = [UILabel new];
    _timeLabel.font = TEXT_FONT_LEVEL_3;
    _timeLabel.textColor = TEXT_COLOR_LEVEL_3;
    [cellView addSubview:_timeLabel];

}

- (void)setActivityList:(ActivityListVO *)list
{
    [_headImage sd_setImageWithURL:[NSURL URLWithString:list.EventImg]];
    
    if (list.createTime&&![list.createTime isEqual:@""]) {
        _timeLabel.text = [NSString stringWithFormat:@"创建时间：%@",list.createTime];
    }else{
        _timeLabel.text =@"创建时间：";
    }
    
    
    _titleLabel.text = list.eventDetail;
    _orderNumLabel.text = list.EventName;
    
    if ([list.TotalNumber isEqual:@""]||list.TotalNumber==nil) {
     _numLabel.text = @"报名人数";
    }else{
       NSString  *text =[NSString stringWithFormat:@"报名人数:%@/%@人",[list.joinNum stringValue],[list.TotalNumber stringValue]];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
        
        [str addAttribute:NSForegroundColorAttributeName value:TEXT_COLOR_LEVEL_2 range:NSMakeRange(0,5)];
        [str addAttribute:NSForegroundColorAttributeName value:LIVING_COLOR range:NSMakeRange(5,str.length-5)];
        
        _numLabel.attributedText = str;
    }
    _payButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [_payButton setTintColor:[UIColor colorWithRed:16.0/255.0 green:142.0/255.0 blue:252.0/255.0 alpha:1.0]];
    _payButton.showsTouchWhenHighlighted = YES;
    _payButton.frame = CGRectMake(0, 0, 48.f, 48.f);
    
    [cellView addSubview:_payButton];
    
    int payNum = [list.Status intValue];
    
    switch (payNum) {
        case 1:
            _paytypeLabel.text = @"正报名";
            [_payButton setTitle:@"开始" forState:UIControlStateNormal];
            [_payButton addTarget:self action:@selector(beginCell:) forControlEvents:UIControlEventTouchUpInside];
            break;
        case 2:
            _paytypeLabel.text = @"正报名";
            [_payButton setTitle:@"开始" forState:UIControlStateNormal];
            [_payButton addTarget:self action:@selector(beginCell:) forControlEvents:UIControlEventTouchUpInside];
            break;
        case 3:
            _paytypeLabel.text = @"已开始";
            [_payButton setTitle:@"结束" forState:UIControlStateNormal];
            [_payButton addTarget:self action:@selector(finishCell:) forControlEvents:UIControlEventTouchUpInside];
            break;
        case 4:
            _paytypeLabel.text = @"已结束";
            [_payButton setTitle:@"删除" forState:UIControlStateNormal];
            [_payButton addTarget:self action:@selector(deleteCell:) forControlEvents:UIControlEventTouchUpInside];
            break;
        case 5:
            _paytypeLabel.text = @"已结束";
            [_payButton setTitle:@"删除" forState:UIControlStateNormal];
            [_payButton addTarget:self action:@selector(deleteCell:) forControlEvents:UIControlEventTouchUpInside];
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
    [_titleLabel sizeToFit];
    [_priceLabel sizeToFit];
    [_timeLabel sizeToFit];
    [_payButton sizeToFit];
    [_numLabel sizeToFit];
    
    _orderNumLabel.frame = CGRectMake(10, 0, kScreenWidth-10-92, 35);
    _paytypeLabel.frame = CGRectMake(kScreenWidth-40-_paytypeLabel.bounds.size.width, 0, _paytypeLabel.bounds.size.width, 35);
    _titleLabel.frame = CGRectMake(80, 35, kScreenWidth-120, 60);
    _timeLabel.frame = CGRectMake(10, 115, _timeLabel.bounds.size.width, 35);
    _payButton.frame = CGRectMake(kScreenWidth-_payButton.bounds.size.width-40, 120, _payButton.bounds.size.width, 25);
    _numLabel.frame = CGRectMake(80, 84, _numLabel.bounds.size.width,  _numLabel.bounds.size.height+5);
}

//删除
- (void)deleteCell:(id)sender
{
    if ([_delegate respondsToSelector:@selector(cellWilldelete:)]) {
        [_delegate cellWilldelete:self];
    }
    
}
//付款
- (void)beginCell:(id)sender
{
    if ([_delegate respondsToSelector:@selector(cellWillbegin:)]) {
        [_delegate cellWillbegin:self];
    }
    
}

//退款
- (void)finishCell:(id)sender
{
    if ([_delegate respondsToSelector:@selector(cellWillfinish:)]) {
        [_delegate cellWillfinish:self];
    }
    
}

-(void)joinMunber
{
    if ([_delegate respondsToSelector:@selector(cellWillclick:)]) {
        [_delegate cellWillclick:self];
    }
}

@end
