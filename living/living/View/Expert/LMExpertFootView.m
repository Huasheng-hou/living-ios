//
//  LMExpertFootView.m
//  living
//
//  Created by hxm on 2017/5/3.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMExpertFootView.h"
#import "FitConsts.h"
#import "UIImageView+WebCache.h"
#import "LMExpertArticleView.h"
#import "LMExpertHotArticleCell.h"
#import "LMMoreEventsVO.h"
#import "LMMoreVoicesVO.h"
#import "LMExpertEventView.h"
#import "LMExpertVoiceView.h"

@interface LMExpertFootView ()<UIScrollViewDelegate>

@end

@implementation LMExpertFootView
{
    
    UILabel * _slideLine;
    
    UIScrollView * _scroll;
    
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubViews];
    }
    return self;
}

- (void)addSubViews{
    
    UIView * topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 45)];
    topView.backgroundColor = [UIColor whiteColor];
    [self addSubview:topView];
    
    UILabel * topLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 5)];
    topLine.backgroundColor = BG_GRAY_COLOR;
    [topView addSubview:topLine];
    
    NSArray * typeArray = @[@"文章", @"活动", @"课堂"];
    for (int i=0; i<typeArray.count; i++) {
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(i*kScreenWidth/3, 15, kScreenWidth/3, 20)];
        [btn setTitle:typeArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:TEXT_COLOR_LEVEL_2 forState:UIControlStateNormal];
        btn.titleLabel.font = TEXT_FONT_LEVEL_3;
        btn.tag = i;
        [btn addTarget:self action:@selector(chooseType:) forControlEvents:UIControlEventTouchUpInside];
        
        [topView addSubview:btn];
    }
    
    UILabel * gapLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, 1)];
    gapLine.backgroundColor = BG_GRAY_COLOR;
    [topView addSubview:gapLine];
    
    _slideLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 43, kScreenWidth/3, 2)];
    _slideLine.backgroundColor = [UIColor redColor];
    [topView addSubview:_slideLine];
    
    _scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame), kScreenWidth, 120)];
    _scroll.pagingEnabled = YES;
    _scroll.delegate = self;
    _scroll.bounces = NO;
    _scroll.showsHorizontalScrollIndicator = NO;
    _scroll.contentSize = CGSizeMake(kScreenWidth*3, 120);
    [self addSubview:_scroll];
    
}

- (void)chooseType:(UIButton *)sender {
    
    NSInteger index = sender.tag;
    
    [_scroll setContentOffset:CGPointMake(index*kScreenWidth, 0) animated:YES];
    
    [UIView animateWithDuration:0.5 animations:^{
        _slideLine.frame = CGRectMake(index*kScreenWidth/3, 43, kScreenWidth/3, 2);
    }];
    
    
}
- (void)setDataWithArticle:(NSArray *)articles andEvents:(NSArray *)events andVoices:(NSArray *)voices{
    CGFloat cellW = (kScreenWidth - 30) / 2;
    
    for (int i=0; i<articles.count; i++) {
        LMExpertArticleView * articleCell = [[LMExpertArticleView alloc] initWithFrame:CGRectMake(10+i*(cellW + 10), 10, cellW, 100)];
        articleCell.tag = 10 + i;
        articleCell.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        [articleCell addGestureRecognizer:tap];
        articleCell.clipsToBounds = YES;
        articleCell.layer.cornerRadius = 3;
        LMMoreArticlesVO * vo = articles[i];
        [articleCell setData:vo];
        [_scroll addSubview:articleCell];
        
    }
    for (int i=0; i<events.count; i++) {
        LMExpertEventView * eventCell = [[LMExpertEventView alloc] initWithFrame:CGRectMake(kScreenWidth+10+i*(cellW+10), 10, cellW, 100)];
        eventCell.tag = 20 + i;
        eventCell.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        [eventCell addGestureRecognizer:tap];
        eventCell.clipsToBounds = YES;
        eventCell.layer.cornerRadius = 3;
        LMMoreEventsVO * vo = events[i];
        [eventCell setData:vo];
        [_scroll addSubview:eventCell];
        
    }
    for (int i=0; i<voices.count; i++) {
        LMExpertVoiceView * voiceCell = [[LMExpertVoiceView alloc] initWithFrame:CGRectMake(kScreenWidth*2+10+i*(cellW+10), 10, cellW, 100)];
        voiceCell.tag = 30 + i;
        voiceCell.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        [voiceCell addGestureRecognizer:tap];
        voiceCell.clipsToBounds = YES;
        voiceCell.layer.cornerRadius = 3;
        LMMoreVoicesVO * vo = voices[i];
        [voiceCell setData:vo];
        [_scroll addSubview:voiceCell];

    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    CGFloat offset = scrollView.contentOffset.x;
    NSInteger index = offset / kScreenWidth;
    [UIView animateWithDuration:0.5 animations:^{
        _slideLine.frame = CGRectMake(index*kScreenWidth/3, 43, kScreenWidth/3, 2);
    }];

}

- (void)tapped:(UITapGestureRecognizer *)tap{
   
    [self.delegate gotoDetailPage:tap.view.tag];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
}

@end
