//
//  LMFriendCell.m
//  living
//
//  Created by Ding on 2016/11/4.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMFriendCell.h"
#import "FitConsts.h"
#import "UIImageView+WebCache.h"

@implementation LMFriendCell
{
    UIImageView * _handImage;
    
    UILabel * _endTime;
    
}

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
    _headImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 80, 80)];
    _headImage.layer.cornerRadius = 5;
    _headImage.contentMode = UIViewContentModeScaleAspectFill;
    _headImage.backgroundColor = BG_GRAY_COLOR;
    _headImage.clipsToBounds = YES;
    [self.contentView addSubview:_headImage];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(105, 0, 150, 30)];
    _nameLabel.font = TEXT_FONT_LEVEL_2;
    _nameLabel.textColor = TEXT_COLOR_LEVEL_1;
    [self.contentView addSubview:_nameLabel];
    
    _idLabel = [[UILabel alloc] initWithFrame:CGRectMake(105, 30, 150, 20)];
    _idLabel.font = TEXT_FONT_LEVEL_3;
    _idLabel.textColor = TEXT_COLOR_LEVEL_2;
    [self.contentView addSubview:_idLabel];
    
    _handImage = [[UIImageView alloc] initWithFrame:CGRectMake(105, 55, 15, 10)];
    _handImage.image = [UIImage imageNamed:@"握手"];
    [self.contentView addSubview:_handImage];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(125, 50, 120, 20)];
    _timeLabel.font = TEXT_FONT_LEVEL_3;
    _timeLabel.textColor = TEXT_COLOR_LEVEL_2;
    [self.contentView addSubview:_timeLabel];
    
    _endTime = [[UILabel alloc] initWithFrame:CGRectMake(105, 70, kScreenWidth/2, 20)];
    _endTime.textColor = TEXT_COLOR_LEVEL_2;
    _endTime.font = TEXT_FONT_LEVEL_3;
    [self.contentView addSubview:_endTime];
    
    _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-15-150, 50, 150, 20)];
    _addressLabel.font = TEXT_FONT_LEVEL_3;
    _addressLabel.textColor = TEXT_COLOR_LEVEL_2;
    _addressLabel.textAlignment = NSTextAlignmentRight;
    _addressLabel.text = @"浙江-杭州";
    [self.contentView addSubview:_addressLabel];
    
    _editBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-60, 0, 50, 30)];
    [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [_editBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    _editBtn.titleLabel.font = TEXT_FONT_LEVEL_2;
    [self addSubview:_editBtn];
    
}

- (void)setType:(NSInteger)type{
    _type = type;
    
    if (type == 1) {
        //课堂参加人员列表cell
        _handImage.hidden = YES;
        _editBtn.hidden = YES;
        
        _endTime.hidden = YES;
        _headImage.frame = CGRectMake(15, 10, 40, 40);
        _addressLabel.frame = CGRectMake(kScreenWidth-15-150, 30, 150, 20);
    }
    
    
    
}

-(void)setData:(LMFriendVO *)list
{
    [_headImage sd_setImageWithURL:[NSURL URLWithString:list.avatar]];
    
    if (_isEdit) {
        _nameLabel.text = list.nickname;
    }else{
        if (list.remark && list.remark != nil && ![list.remark isEqualToString:@""] && list.remark.length > 0) {
            _nameLabel.text = list.remark;
        }else{
            _nameLabel.text = list.nickname;
        }
    }
    
    _timeLabel.text = [list.addTime substringToIndex:10];
    
    _addressLabel.text = list.address;
    

    if (list.userId&&list.userId!=0) {
        _idLabel.text = [NSString stringWithFormat:@"ID:%d",list.userId];
    }else{
        _idLabel.text = @"ID:";
    }
    
    if (list.coupons.count > 0) {
        double  minTime = [[list.coupons[0] objectForKey:@"failtureTime"] doubleValue];;
        for (NSDictionary * dic in list.coupons) {
            double time = [dic[@"failtureTime"] doubleValue];
            if (minTime > time) {
                minTime = time;
            }
        }
        
        double timeInterval = [[NSDate date] timeIntervalSince1970];
        if (minTime / 1000 - timeInterval < 30 * 24 * 60 * 60) {
            _endTime.textColor = [UIColor redColor];
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"优惠券到期时间:%@", [self getDateStringFromSeconds:minTime]]];
            [attrStr addAttribute:NSForegroundColorAttributeName value:TEXT_COLOR_LEVEL_2 range:NSMakeRange(0, 8)];
            _endTime.attributedText = attrStr;
        } else {
        
            _endTime.text = [NSString stringWithFormat:@"优惠券到期时间:%@", [self getDateStringFromSeconds:minTime]];
        }
        
    }else {
        _endTime.text = @"无优惠券";
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [_nameLabel sizeToFit];
    [_idLabel sizeToFit];
    
    if (_type == 1) {
        
        _nameLabel.frame = CGRectMake(65, 7, _nameLabel.bounds.size.width, 25);
        _idLabel.frame = CGRectMake(65, 30, _idLabel.bounds.size.width, 20);
        return;
    }
    
    _nameLabel.frame = CGRectMake(105, 7, _nameLabel.bounds.size.width, 25);
    _idLabel.frame = CGRectMake(105, 30, _idLabel.bounds.size.width, 20);
    
}


- (NSString *)getDateStringFromSeconds:(double)second {
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:second/1000];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString * dateStr = [formatter stringFromDate:date];
    return dateStr;
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
