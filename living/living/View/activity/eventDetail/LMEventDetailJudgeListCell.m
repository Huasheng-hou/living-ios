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
    
    UILabel * _botLine;
    
    CGFloat frameH;
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
    [self.contentView addSubview:_content];
    
    _imageBack = [UIView new];
    _imageBack.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_imageBack];
    
}

- (void)setData:(LMEventCommentVO *)vo{
    
    frameH = [self getHeightWithContent:vo.commentContent andImageCount:vo.images.count] + 90;
    
    
    [_icon sd_setImageWithURL:[NSURL URLWithString:vo.avatar]];
    
    _name.text = vo.nickName;
    
    _content.text = vo.commentContent;
    _content.textColor = TEXT_COLOR_LEVEL_2;
    _content.font = TEXT_FONT_LEVEL_2;
    _content.numberOfLines = -1;
    [_content sizeToFit];

    
    if (vo.images.count > 0) {
        _imageBack.frame = CGRectMake(0, CGRectGetMaxY(_content.frame), kScreenWidth, 30);
        
        for (int i=0; i<vo.images.count; i++) {
            NSString * url = [vo.images[i] objectForKey:@"url"];
            
            UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(10+i*30, 5, 25, 25)];
            [image sd_setImageWithURL:[NSURL URLWithString:url]];
            image.clipsToBounds = YES;
            image.contentMode = UIViewContentModeScaleAspectFill;
            [_imageBack addSubview:image];
            
        }
    }
    
    
    _botLine = [[UILabel alloc] initWithFrame:CGRectMake(0, frameH-5, kScreenWidth, 1)];
    _botLine.backgroundColor = BG_GRAY_COLOR;
    [self.contentView addSubview:_botLine];
}

#pragma mark - 根据内容cell自适应
- (NSInteger)getHeightWithContent:(NSString *)content andImageCount:(NSInteger)count{
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-20, 0)];
    label.text = content;
    label.font = TEXT_FONT_LEVEL_2;
    label.numberOfLines = -1;
    [label sizeToFit];
    
    NSInteger labH = label.frame.size.height;
    
    
    if (count > 0) {
        labH += 25;
    }
    return labH;
}

@end
