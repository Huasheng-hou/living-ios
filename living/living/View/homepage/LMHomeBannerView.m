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
        self.backgroundColor = BG_GRAY_COLOR;
        [self createUI];
    }
    return self;
    
}

- (void)createUI{
    
    
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.frame.size.height-10)];
    CGFloat cellW = kScreenWidth/4;
    CGFloat cellH = 122;
    CGFloat imageX = 25;
    CGFloat imageY = 25;
    CGFloat imageWd = 30;
    CGFloat imageHt = 32;
    CGFloat imageCount = 6;
    NSArray * listName = @[@"Yao·美丽", @"Yao·健康", @"Yao·美食", @"Yao·幸福", @"Yao·创客", @"Yao·果币"];
    NSArray * imageNames = @[@"beautiful", @"healthy", @"delicious", @"happiness", @"maker", @"yaoguobi-1"];
    for (int i=0; i<imageCount; i++) {
        
        UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(i*cellW, 0, cellW, cellH)];
        backView.backgroundColor = [UIColor whiteColor];
        backView.tag = 10 + i;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(detailPage:)];
        [backView addGestureRecognizer:tap];
        
        
        UIImageView * headImage = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, imageY, imageWd, imageHt)];
        headImage.center = CGPointMake(cellW/2.0, imageY+imageHt/2.0);
        headImage.image = [UIImage imageNamed:imageNames[i]];
        [backView addSubview:headImage];
        
        UILabel * typeName = [[UILabel alloc] initWithFrame:CGRectMake(0, imageHt+imageY+10, cellW, 15)];
        typeName.textAlignment = NSTextAlignmentCenter;
        typeName.text = listName[i];
        typeName.textColor = TEXT_COLOR_LEVEL_4;
        typeName.font = TEXT_FONT_LEVEL_2;
        [backView addSubview:typeName];
        
        [_scrollView addSubview:backView];
    }
    _scrollView.contentSize = CGSizeMake(imageCount*cellW, cellH);
    _scrollView.delegate = self;
    _scrollView.bounces = NO;
    _scrollView.pagingEnabled = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_scrollView];
    
    
    _botLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 2)];
    _botLine.center = CGPointMake(self.center.x, imageY+imageHt+10+15+20);
    _botLine.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:0/255.0 blue:0/255.0 alpha:0.2];
    _botLine.layer.masksToBounds = YES;
    _botLine.layer.cornerRadius = 2;
    [self addSubview:_botLine];
    
    
    _scrollLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 15, 2)];
    _scrollLine.center = CGPointMake(_botLine.center.x-7.5, imageY+imageHt+10+15+20);
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
    CGFloat x = 15 * percent + originX;
    [UIView animateWithDuration:0.4 animations:^{
       
        CGRect rect = CGRectMake(x, _scrollLine.frame.origin.y, _scrollLine.frame.size.width, _scrollLine.frame.size.height);
        _scrollLine.frame = rect;
        
    }];
    
}


- (void)detailPage:(UITapGestureRecognizer *)tap{
    
    NSLog(@"%d", tap.view.tag);
    [self.delegate gotoNextPage:tap.view.tag];
}

@end
