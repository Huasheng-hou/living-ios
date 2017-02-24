//
//  LMHomeBannerView.m
//  living
//
//  Created by Huasheng on 2017/2/23.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMHomeBannerView.h"
#import "FitConsts.h"

@interface LMHomeBannerView ()<UIScrollViewDelegate>

@end


@implementation LMHomeBannerView
{
    
    UIScrollView * _scrollView;
    UILabel *   _botLine;
    UILabel *   _scrollLine;
    
    CGFloat  originX;
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
    
}

- (void)createUI{
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    CGFloat cellW = kScreenWidth/4;
    CGFloat cellH = 200;
    CGFloat imageX = cellW/3;
    CGFloat imageY = cellH/4-10;
    CGFloat imageWd = imageX;
    CGFloat imageHt = cellH/4+10;
    CGFloat imageCount = 7;
    NSArray * listName = @[@"Yao·美丽", @"Yao·健康", @"Yao·美食", @"Yao·幸福", @"Yao·运动", @"Yao·学习", @"Yao·干哈"];
    for (int i=0; i<imageCount; i++) {
        
        UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(i*cellW, 0, cellW, cellH)];
        backView.backgroundColor = [UIColor whiteColor];
        backView.tag = 10 + i;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(detailPage:)];
        [backView addGestureRecognizer:tap];
        
        
        UIImageView * headImage = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, imageY, imageWd, imageHt)];
        headImage.backgroundColor = BG_GRAY_COLOR;
        [backView addSubview:headImage];
        
        UILabel * typeName = [[UILabel alloc] initWithFrame:CGRectMake(0, cellH/2+20, cellW, 40)];
        typeName.textAlignment = NSTextAlignmentCenter;
        typeName.text = listName[i];
        typeName.textColor = TEXT_COLOR_LEVEL_2;
        typeName.font = TEXT_FONT_LEVEL_1;
        [backView addSubview:typeName];
        
        [_scrollView addSubview:backView];
    }
    _scrollView.contentSize = CGSizeMake(imageCount*cellW, cellH);
    _scrollView.delegate = self;
    _scrollView.bounces = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_scrollView];
    
    
    _botLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 2)];
    _botLine.center = CGPointMake(self.center.x, cellH/2+70);
    _botLine.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:0/255.0 blue:0/255.0 alpha:0.2];
    _botLine.layer.masksToBounds = YES;
    _botLine.layer.cornerRadius = 2;
    [self addSubview:_botLine];
    
    
    _scrollLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 2)];
    _scrollLine.center = CGPointMake(_botLine.center.x-15, cellH/2+70);
    _scrollLine.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5];
    _scrollLine.layer.masksToBounds = YES;
    _scrollLine.layer.cornerRadius = 2;
    [self addSubview:_scrollLine];
    
    originX = _scrollLine.frame.origin.x;
    
}

//scrollView代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat contentW = scrollView.contentSize.width;
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat percent = offsetX / (contentW - kScreenWidth);
    [self animationWhenScroll:percent];
}

- (void)animationWhenScroll:(CGFloat)percent{
    CGFloat x = 30 * percent + originX;
    [UIView animateWithDuration:0.4 animations:^{
       
        CGRect rect = CGRectMake(x, _scrollLine.frame.origin.y, _scrollLine.frame.size.width, _scrollLine.frame.size.height);
        _scrollLine.frame = rect;
        
    }];
    
}


- (void)detailPage:(UITapGestureRecognizer *)tap{
    
    [self.delegate gotoNextPage:tap.view.tag];
}

@end
