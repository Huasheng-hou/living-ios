//
//  LMFindCell.m
//  living
//
//  Created by Ding on 16/9/26.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMFindCell.h"
#import "FitConsts.h"
#import "UIView+frame.h"
#import "UIImageView+WebCache.h"

@interface LMFindCell ()

@end

@implementation LMFindCell

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
    
    //背景圆角白色view
    UIView *cellView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth-20, 155)];
    cellView.layer.cornerRadius = 5;
    cellView.layer.masksToBounds = YES;
    cellView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:cellView];
    //标题
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, kScreenWidth-40, 20)];
    _titleLabel.font = TEXT_FONT_LEVEL_1;
    _titleLabel.textColor = TEXT_COLOR_LEVEL_2;
//    _titleLabel.text = @"这是新功能标题";
    [self.contentView addSubview:_titleLabel];
    
    
    _imageview = [[UIImageView alloc] initWithFrame:CGRectMake(20, 40, 110, 80)];
    
    _imageview.backgroundColor = BG_GRAY_COLOR;
    
    _imageview.contentMode = UIViewContentModeScaleAspectFill;
    
    _imageview.clipsToBounds = YES;
    
    [self.contentView addSubview:_imageview];
    
    
    
    
    
    //内容
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 40, kScreenWidth-160, 80)];
    _contentLabel.font = TEXT_FONT_LEVEL_2;
    _contentLabel.textColor = TEXT_COLOR_LEVEL_3;
    _contentLabel.numberOfLines = 0;
//    _contentLabel.textAlignment = NSTextAlignmentJustified;
//    _contentLabel.text = @"这是新功能标题这是新功能标题这是新功能标题这是新功能标题这是新功能标题这是新功能标题这是新功能标题是新功";
    [self.contentView addSubview:_contentLabel];
    //lineLabel
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 135, kScreenWidth-40, 0.5)];
    lineLabel.backgroundColor = LINE_COLOR;
    [self.contentView addSubview:lineLabel];
    //奖杯图标
    UIImageView *cupIV = [[UIImageView alloc] initWithFrame:CGRectMake(20, 140, 17, 17)];
    [cupIV setImage:[UIImage imageNamed:@"cupIcon"]];
    [self.contentView addSubview:cupIV];
    //footLabel
    UILabel *footLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 140, kScreenWidth-100, 17)];
    footLabel.font = TEXT_FONT_LEVEL_3;
    footLabel.textColor = TEXT_COLOR_LEVEL_4;
    footLabel.text = @"下一个版本你做主";
    [self.contentView addSubview:footLabel];
    //点赞按钮
    _thumbIV = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-70, 140, 17, 17)];
    [self.contentView addSubview:_thumbIV];
    //点赞数量
    _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-50, 140, 40, 17)];
    _numLabel.font = TEXT_FONT_LEVEL_3;
    _numLabel.textColor = TEXT_COLOR_LEVEL_4;
    _numLabel.text = @"300";
    [self.contentView addSubview:_numLabel];
    
    _praiseBt=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-70, 140, 60, 17)];
    [self addSubview:_praiseBt];
    
    [_praiseBt addTarget:self action:@selector(praiseBtton:) forControlEvents:UIControlEventTouchUpInside];
    
}


-(void)setValue:(LMFindVO *)list
{
    [_imageview sd_setImageWithURL:[NSURL URLWithString:list.images] placeholderImage:[UIImage imageNamed:@"BackImage"]];
    
    _titleLabel.text = list.title;
    
    _contentLabel.text = list.descrition;
    
    _numLabel.text = [NSString stringWithFormat:@"%d",list.numberOfVotes];
    
    if (list.hasPraised==0) {
        
        [_thumbIV setImage:[UIImage imageNamed:@"zanIcon"]];
    }else{
        
        [_thumbIV setImage:[UIImage imageNamed:@"zanIcon-click"]];
    }
    
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    
    
}


-(void)praiseBtton:(id)sender
{

    if ([_delegate respondsToSelector:@selector(cellWillClick:)]) {
        [_delegate cellWillClick:self];
    }
    
}



@end
