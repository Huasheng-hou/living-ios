//
//  LMOrderCell.m
//  living
//
//  Created by Ding on 16/10/10.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMOrderCell.h"
#import "FitConsts.h"

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
    UIView *cellView = [[UIView alloc] initWithFrame:CGRectMake(15, 15, kScreenWidth-30, 150)];
    cellView.backgroundColor = [UIColor whiteColor];
    cellView.layer.cornerRadius = 5;
    [self addSubview:cellView];
    
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
    
    _headImage.backgroundColor = [UIColor blueColor];
    [cellView addSubview:_headImage];
    
    _titleLabel = [UILabel new];
    _titleLabel.text = @"活动🔥名称活动🔥名称活动🔥名称活动🔥名称活动🔥名称活动🔥名称";
    _titleLabel.textColor = TEXT_COLOR_LEVEL_3;
    _titleLabel.font = TEXT_FONT_LEVEL_2;
    _titleLabel.numberOfLines = 2;
    [cellView addSubview:_titleLabel];
    
    _priceLabel = [UILabel new];
    _priceLabel.text = @"订单金额 ￥300";
    _priceLabel.font = TEXT_FONT_LEVEL_3;
    _priceLabel.textColor = LIVING_COLOR;
    [cellView addSubview:_priceLabel];
    
    
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0, 114.5, kScreenWidth-30, 0.5)];
    line3.backgroundColor = LINE_COLOR;
    [cellView addSubview:line3];
    
    
}

-(void)setData:(NSString *)data
{
    
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
    
    
    
    _orderNumLabel.frame = CGRectMake(10, 0, _orderNumLabel.bounds.size.width, 35);
    _paytypeLabel.frame = CGRectMake(kScreenWidth-40-_paytypeLabel.bounds.size.width, 0, _paytypeLabel.bounds.size.width, 35);
    _titleLabel.frame = CGRectMake(80, 45, kScreenWidth-120, _titleLabel.bounds.size.height*2);
    _priceLabel.frame = CGRectMake(kScreenWidth-40-_priceLabel.bounds.size.width, 90, _priceLabel.bounds.size.width, _priceLabel.bounds.size.height);
    
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
//完成
- (void)finishCell:(id)sender
{
    if ([_delegate respondsToSelector:@selector(cellWillfinish:)]) {
        [_delegate cellWillfinish:self];
    }
    
}
//再订
- (void)RefundCell:(id)sender
{
    if ([_delegate respondsToSelector:@selector(cellWillRefund:)]) {
        [_delegate cellWillRefund:self];
    }
    
}
//
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
