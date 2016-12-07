//
//  FitChatExpressionView.m
//  FitTrainer
//
//  Created by JamHonyZ on 15/10/15.
//  Copyright (c) 2015年 Huasheng. All rights reserved.
//

#import "FitChatExpressionView.h"
#import "FitConsts.h"

@interface FitChatExpressionView () <UIScrollViewDelegate>

@end

@implementation FitChatExpressionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviewsWithFrame:frame];
    }
    return self;
}


- (void)initSubviewsWithFrame:(CGRect)frame
{
    if (!_expressionView) {
        _expressionView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height - 20)];
    }

    _expressionView.pagingEnabled = YES;
    _expressionView.delegate = self;
    _expressionView.showsVerticalScrollIndicator = NO;
    _expressionView.showsHorizontalScrollIndicator = NO;
    _expressionView.backgroundColor = [UIColor whiteColor];
    
    //添加表情
    NSInteger numberOfImgsOneRow    = 4;
    NSInteger numberOfRow           = 2;
    
    NSInteger numberOfPage = 0;
    
    NSString *plistPath     = [[NSBundle mainBundle] pathForResource:@"ExpressionImg" ofType:@"plist"];
    NSArray  *ImgArr        = [NSArray arrayWithContentsOfFile:plistPath];
    
    for (NSInteger i = 0; i < 8; i++) {
       
        NSInteger lie = i % numberOfImgsOneRow;
        NSInteger row;
        
        if (i == 0) {
            row = 0;
        } else {
            row = i / numberOfImgsOneRow;
        }
        
        if (row % numberOfRow == 0 && row != 0 && lie == 0) {
            numberOfPage += 1;
        }
        
        row -= (numberOfRow * numberOfPage);
       
        _faceView   = [[FitChatFaceView alloc] initWithFrame:CGRectMake(ceil(kScreenWidth * lie / 4.0), row * 110, ceil(kScreenWidth / 4.0), 110)];
        
        if (row == 1) {
            
            _faceView.frame = CGRectMake(_faceView.frame.origin.x, _faceView.frame.origin.y - 20, _faceView.frame.size.width, _faceView.frame.size.height);
        }
        
        [_faceView setImage:[UIImage imageNamed:ImgArr[i][@"imgName"]] ImageID:ImgArr[i][@"id"]];
       
        __weak __block FitChatExpressionView *copy_self = self;
        
        [_faceView setFaceBlock:^(UIImage *image, NSString *imageID) {
        
            if ([copy_self.ExpresionViewDelegate respondsToSelector:@selector(passValueImage:imageID:)]) {
                [copy_self.ExpresionViewDelegate passValueImage:image imageID:imageID];
            }
        }];
        
        [_expressionView addSubview:_faceView];
    }
    
    for (NSInteger i = 8; i < ImgArr.count; i++) {
        
        NSInteger lie = i % numberOfImgsOneRow;
        NSInteger row;
        
        if (i == 0) {
            row = 0;
        } else {
            row = i / numberOfImgsOneRow - 2;
        }
        
        
        _faceView   = [[FitChatFaceView alloc] initWithFrame:CGRectMake(ceil(kScreenWidth * lie / 4.0) + kScreenWidth,
                                                                        row * 110, ceil(kScreenWidth / 4.0), 110)];
        if (row == 1) {
            
            _faceView.frame = CGRectMake(_faceView.frame.origin.x, _faceView.frame.origin.y - 20, _faceView.frame.size.width, _faceView.frame.size.height);
        }
        
        [_faceView setImage:[UIImage imageNamed:ImgArr[i][@"imgName"]] ImageID:ImgArr[i][@"id"]];
        
        __weak __block FitChatExpressionView *copy_self = self;
        
        [_faceView setFaceBlock:^(UIImage *image, NSString *imageID) {
            
            if ([copy_self.ExpresionViewDelegate respondsToSelector:@selector(passValueImage:imageID:)]) {
                [copy_self.ExpresionViewDelegate passValueImage:image imageID:imageID];
            }
        }];
        
        [_expressionView addSubview:_faceView];
    }
    
//    _expressionView.contentSize = CGSizeMake(kScreenWidth * (numberOfPage + 1), 200);
    _expressionView.contentSize = CGSizeMake(kScreenWidth * 2, 200);
    [self addSubview:_expressionView];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, frame.size.height - 20, frame.size.width, 20)];
//    _pageControl.backgroundColor    = MASK_COLOR;
//    _pageControl.numberOfPages      = numberOfPage + 1;
    _pageControl.numberOfPages      = 2;
    _pageControl.currentPage        = 0;
    _pageControl.pageIndicatorTintColor         = MASK_COLOR;
    _pageControl.currentPageIndicatorTintColor  = MASK_DARK_COLOR;
//    [_pageControl addTarget:self action:@selector(doPage:) forControlEvents:UIControlEventValueChanged];
    
    [self addSubview:_pageControl];
}

#pragma mark - scrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //更新UIPageControl的当前页
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.frame;
    [_pageControl setCurrentPage:offset.x / bounds.size.width];
//    NSLog(@"%f",offset.x / bounds.size.width);
}

- (void)doPage:(UIPageControl *)sender
{
    //令UIScrollView做出相应的滑动显示
    CGSize viewSize = _expressionView.frame.size;
    CGRect rect = CGRectMake(sender.currentPage * viewSize.width, 0, viewSize.width, viewSize.height);
    [_expressionView scrollRectToVisible:rect animated:YES];
}

@end
