//
//  LMEventDetailJudgeListCell.m
//  living
//
//  Created by hxm on 2017/3/28.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMEventDetailJudgeListCell.h"
#import "FitConsts.h"
#import "UIImageView+WebCache.h"
@implementation LMEventDetailJudgeListCell
{
    
    UIImageView * _icon;
    
    UILabel * _name;
    
    UILabel * _content;
    
    UIView * _imageBack;
    
    
    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubViews];
    }
    return self;
}

- (void)addSubViews{
    
    _icon = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 40, 40)];
    _icon.backgroundColor = BG_GRAY_COLOR;
    _icon.clipsToBounds = YES;
    _icon.layer.cornerRadius = 3;
    [self.contentView addSubview:_icon];
    
    
    _name = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_icon.frame)+15, 10, 100, 40)];
    _name.text = @"世纪东方";
    _name.textColor = TEXT_COLOR_LEVEL_2;
    _name.font = TEXT_FONT_LEVEL_2;
    [self.contentView addSubview:_name];
    
    _content = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_name.frame)+10, kScreenWidth-20, 0)];
    //_content.text = @"世纪东方";
    [self.contentView addSubview:_content];
    
    
}

- (void)setData:(LMEventCommentVO *)vo{
    
    [_icon sd_setImageWithURL:[NSURL URLWithString:vo.avatar]];
    
    _name.text = vo.nickName;
    
    _content.text = vo.commentContent;
    _content.textColor = TEXT_COLOR_LEVEL_2;
    _content.font = TEXT_FONT_LEVEL_2;
    _content.numberOfLines = -1;
    [_content sizeToFit];

}



@end
