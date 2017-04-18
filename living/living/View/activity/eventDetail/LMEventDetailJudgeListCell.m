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
    UIView * _starView;
    UILabel * _time;
    
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
    
    _icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
    _icon.backgroundColor = BG_GRAY_COLOR;
    _icon.clipsToBounds = YES;
    _icon.layer.cornerRadius = 15;
    [self.contentView addSubview:_icon];
    
    
    _name = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_icon.frame)+15, 10, 100, 20)];
    _name.textColor = TEXT_COLOR_LEVEL_3;
    _name.font = TEXT_FONT_LEVEL_3;
    [self.contentView addSubview:_name];
    
    _starView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_icon.frame), CGRectGetMaxY(_icon.frame)+10, kScreenWidth-CGRectGetMaxX(_name.frame)-20, 20)];
    [self.contentView addSubview:_starView];
    
    
    _time = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-120, CGRectGetMaxY(_name.frame)+10, 100, 20)];
    _time.textColor = TEXT_COLOR_LEVEL_4;
    _time.font = TEXT_FONT_LEVEL_4;
    [self.contentView addSubview:_time];
    
    
    _content = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_starView.frame)+10, kScreenWidth-20, 0)];
    [self.contentView addSubview:_content];
    
    _imageBack = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_content.frame)+10, kScreenWidth-20, 0)];
    _imageBack.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_imageBack];
    
    
    _botLine = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_imageBack.frame)+5, kScreenWidth-20, 1)];
    _botLine.backgroundColor = BG_GRAY_COLOR;
    [self.contentView addSubview:_botLine];
}

- (void)setData:(LMEventCommentVO *)vo{
    
    //cell高度
    frameH = [self getHeightWithContent:vo.commentContent andImageCount:vo.images.count] + 100;
        
    [_icon sd_setImageWithURL:[NSURL URLWithString:vo.avatar]];
    
    _name.text = vo.nickName;
//    [_name sizeToFit];
//    _name.frame = CGRectMake(CGRectGetMaxX(_icon.frame)+15, 10, _name.bounds.size.width+20, 20);
    
    
    _time.text = [vo.commentTime substringFromIndex:5];
    [_time sizeToFit];
    
    
    _content.text = vo.commentContent;
    _content.textColor = TEXT_COLOR_LEVEL_2;
    _content.font = TEXT_FONT_LEVEL_2;
    _content.numberOfLines = -1;
    [_content sizeToFit];
    _content.frame = CGRectMake(10, CGRectGetMaxY(_starView.frame)+10, kScreenWidth-20, _content.bounds.size.height);
    
    
    if (vo.images.count > 0) {
        _imageBack.frame = CGRectMake(0, CGRectGetMaxY(_content.frame)+10, kScreenWidth, 30);
        for (UIView * sub in _imageBack.subviews) {
            [sub removeFromSuperview];
        }
        for (int i=0; i<vo.images.count; i++) {
            NSString * url = [vo.images[i] objectForKey:@"url"];
            
            UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(10+i*30, 5, 25, 25)];
            [image sd_setImageWithURL:[NSURL URLWithString:url]];
            image.clipsToBounds = YES;
            image.contentMode = UIViewContentModeScaleAspectFill;
            [_imageBack addSubview:image];
            
        }
    }
    
    
    NSInteger star = [vo.star integerValue];
    for (int i=0; i<star; i++) {
        UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(i*(10+15), 0, 15, 15)];
        image.image = [UIImage imageNamed:@"in"];
        
        [_starView addSubview:image];

    }
    
    _botLine.frame = CGRectMake(10, frameH-2, kScreenWidth-20, 1);
    
    
}

#pragma mark - 根据内容cell自适应
- (NSInteger)getHeightWithContent:(NSString *)content andImageCount:(NSInteger)count{
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-20, 0)];
    label.text = content;
    label.font = TEXT_FONT_LEVEL_2;
    label.numberOfLines = -1;
    [label sizeToFit];
    
    NSInteger contentH = label.frame.size.height;
    
    
    if (count > 0) {
        contentH += 30;
    }
    return contentH;
}

@end
