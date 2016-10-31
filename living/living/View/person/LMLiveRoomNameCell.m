
//
//  LMLiveRoomNameCell.m
//  living
//
//  Created by JamHonyZ on 2016/10/31.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMLiveRoomNameCell.h"
#import "FitConsts.h"

@implementation LMLiveRoomNameCell

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
    _chooseView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 20, 20)];
//    _chooseView.image = [UIImage imageNamed:@"choose-no"];
    [self.contentView addSubview:_chooseView];
    
    UIImageView *headImage = [[UIImageView alloc] initWithFrame:CGRectMake(40, 10, 30, 30)];
    headImage.backgroundColor = [UIColor lightGrayColor];
    headImage.layer.cornerRadius = 5;
    [self.contentView addSubview:headImage];
    
    _nameLabel = [UILabel new];
//    _nameLabel.text = @"杭州换吧网络科技生活馆";
    _nameLabel.textColor = TEXT_COLOR_LEVEL_2;
    _nameLabel.font = TEXT_FONT_LEVEL_2;
//    [_nameLabel sizeToFit];
    _nameLabel.frame = CGRectMake(80, 0, kScreenWidth-80-10, 50);
    [self.contentView addSubview:_nameLabel];
 
    
}


@end
