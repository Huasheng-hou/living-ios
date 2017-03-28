//
//  LMExpertListCell.m
//  living
//
//  Created by Huasheng on 2017/2/23.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMExpertListCell.h"
#import "FitConsts.h"
#import "UIImageView+WebCache.h"

@interface LMExpertListCell ()

@end

@implementation LMExpertListCell
{
    UIImageView * _icon;
    UILabel * _name;
    UIScrollView * _scrollView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    
    return self;
}
- (void)setCount:(NSInteger)count{
    
    if (_scrollView) {
        [_scrollView removeFromSuperview];
    }
    CGFloat edgeW = 10;
    CGFloat margin = kScreenWidth / 13.5;
    CGFloat iconW = margin * 2;
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    _scrollView.contentSize = CGSizeMake(edgeW+count*(margin+iconW), 100);
    _scrollView.scrollEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    
    for (int i=0; i<count; i++) {
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(edgeW+3*margin*i, 10, iconW, iconW)];
        _icon.image = [UIImage imageNamed:@"cellHeadImageIcon"];
        _icon.layer.masksToBounds = YES;
        _icon.layer.cornerRadius = 24;
        _icon.backgroundColor = BG_GRAY_COLOR;
        [_scrollView addSubview:_icon];
        _icon.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapIcon:)];
        [_icon addGestureRecognizer:tap];
        
        _name = [[UILabel alloc] initWithFrame:CGRectMake(edgeW+3*margin*i, 10+iconW+10, iconW, 20)];
        _name.text = @"李莺莺";
        _name.textColor = TEXT_COLOR_LEVEL_3;
        _name.font = TEXT_FONT_LEVEL_3;
        _name.textAlignment = NSTextAlignmentCenter;
        [_scrollView addSubview:_name];
        
    }
    
    
    [self.contentView addSubview:_scrollView];
    
}
- (void)setArray:(NSArray *)array{
    
    if (array.count > 0) {
        if (_scrollView) {
            [_scrollView removeFromSuperview];
        }
        CGFloat edgeW = 10;
        CGFloat margin = kScreenWidth / 13.5;
        CGFloat iconW = margin * 2;
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
        _scrollView.contentSize = CGSizeMake(edgeW+array.count*(margin+iconW), 100);
        _scrollView.scrollEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        
        for (int i=0; i<array.count; i++) {
            
            LMRecommendExpertVO * vo = array[i];
            
            _icon = [[UIImageView alloc] initWithFrame:CGRectMake(edgeW+3*margin*i, 10, iconW, iconW)];
            _icon.tag = i;
            _icon.layer.masksToBounds = YES;
            _icon.layer.cornerRadius = 25;
            _icon.userInteractionEnabled = YES;
            _icon.backgroundColor = BG_GRAY_COLOR;
            
            [_icon sd_setImageWithURL:[NSURL URLWithString:vo.avatar] placeholderImage:nil];
            [_scrollView addSubview:_icon];
            
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapIcon:)];
            [_icon addGestureRecognizer:tap];
            
            _name = [[UILabel alloc] initWithFrame:CGRectMake(edgeW+3*margin*i, 10+iconW+10, iconW, 20)];
            _name.text = vo.nickName;
            _name.textColor = TEXT_COLOR_LEVEL_3;
            _name.font = TEXT_FONT_LEVEL_3;
            _name.textAlignment = NSTextAlignmentCenter;
            [_scrollView addSubview:_name];
            
        }
        
        
        [self.contentView addSubview:_scrollView];

    }
}
- (void)tapIcon:(UITapGestureRecognizer *)tap{
    
    [self.delegate gotoNextPage:tap.view.tag];
    
}
@end
