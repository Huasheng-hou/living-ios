//
//  LMExpertListCell.m
//  living
//
//  Created by Huasheng on 2017/2/23.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMExpertListCell.h"
#import "FitConsts.h"
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
        _icon.image = [UIImage imageNamed:@""];
        _icon.layer.masksToBounds = YES;
        _icon.layer.cornerRadius = 25;
        _icon.backgroundColor = BG_GRAY_COLOR;
        [_scrollView addSubview:_icon];
        
        _name = [[UILabel alloc] initWithFrame:CGRectMake(edgeW+3*margin*i, 10+iconW+10, iconW, 20)];
        _name.text = @"李莺莺";
        _name.textColor = TEXT_COLOR_LEVEL_3;
        _name.font = TEXT_FONT_LEVEL_3;
        _name.textAlignment = NSTextAlignmentCenter;
        [_scrollView addSubview:_name];
        
    }
    
    
    [self.contentView addSubview:_scrollView];
    
}


@end
