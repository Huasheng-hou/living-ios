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
    _headImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 40, 40)];
    _headImage.layer.cornerRadius = 5;
    _headImage.contentMode = UIViewContentModeScaleAspectFill;
    _headImage.backgroundColor = BG_GRAY_COLOR;
    _headImage.clipsToBounds = YES;
    [self.contentView addSubview:_headImage];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 0, 150, 60)];
    _nameLabel.font = TEXT_FONT_LEVEL_2;
    _nameLabel.textColor = TEXT_COLOR_LEVEL_1;
    _nameLabel.text = @"高琛";
    [self.contentView addSubview:_nameLabel];
    
    _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-15-150, 0, 150, 60)];
    _addressLabel.font = TEXT_FONT_LEVEL_2;
    _addressLabel.textColor = TEXT_COLOR_LEVEL_2;
    _addressLabel.textAlignment = NSTextAlignmentRight;
    _addressLabel.text = @"浙江-杭州";
    [self.contentView addSubview:_addressLabel];
    

    
}

-(void)setData:(LMFriendVO *)list
{
    [_headImage sd_setImageWithURL:[NSURL URLWithString:list.avatar]];
    _nameLabel.text = list.nickname;
    _addressLabel.text = list.address;
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
