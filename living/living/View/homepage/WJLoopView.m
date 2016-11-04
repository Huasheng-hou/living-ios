//
//  WJLoopVIew.m
//  WJLoopView
//
//  Created by bringbird on 15/12/29.
//  Copyright © 2015年 韦明杰. All rights reserved.
//

#import "WJLoopView.h"
#import "UIImageView+WebCache.h"

#define scrollW self.frame.size.width
#define scrollH self.frame.size.height

@interface WJLoopView ()<UIScrollViewDelegate>

@property (nonatomic, weak) id<WJLoopViewDelegate> delegate;

@property (nonatomic, strong) NSArray *imageURLs;
@property (nonatomic, assign) NSTimeInterval timeInterval;
@property (nonatomic, strong) UIColor *currentPageIndicatorTintColor;
@property (nonatomic, strong) UIColor *pageIndicatorTintColor;
@property (nonatomic, copy)   NSString *placeholderImage;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, weak)   UIScrollView *scrollView;
@property (nonatomic, weak)   UIPageControl *pageControl;

@end

@implementation WJLoopView

+(instancetype)WJLoopViewWithFrame:(CGRect)frame delegate:(id<WJLoopViewDelegate>)delegate imageURLs:(NSArray *)imageURLs placeholderImage:(NSString *)placeholderImage timeInterval:(NSTimeInterval)timeInterval currentPageIndicatorITintColor:(UIColor *)currentPageIndicatorITintColor pageIndicatorTintColor:(UIColor *)pageIndicatorTintColor{
    return [[self alloc]initWithFrame:frame delegate:delegate imageURLs:imageURLs placeholderImage:placeholderImage timeInterval:timeInterval currentPageIndicatorITintColor:currentPageIndicatorITintColor pageIndicatorTintColor:pageIndicatorTintColor];
}

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<WJLoopViewDelegate>)delegate imageURLs:(NSArray *)imageURLs placeholderImage:(NSString *)placeholderImage timeInterval:(NSTimeInterval)timeInterval currentPageIndicatorITintColor:(UIColor *)currentPageIndicatorITintColor pageIndicatorTintColor:(UIColor *)pageIndicatorTintColor {
    if (self = [super initWithFrame:frame]) {
        self.delegate = delegate;
        self.imageURLs = imageURLs;
        self.placeholderImage = placeholderImage;
        self.currentPageIndicatorTintColor = currentPageIndicatorITintColor;
        self.pageIndicatorTintColor = pageIndicatorTintColor;
        [self setupWJLoopView];
    }
    return self;
}
- (void)setupWJLoopView {
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, scrollW, scrollH)];
    NSInteger tag;
    for (int i = 0; i<self.imageURLs.count + 2; i++) {
        if (i == 0) {
            tag = self.imageURLs.count;
            
        } else if (i == self.imageURLs.count + 1) {
            tag = 1;
            
        } else {
            tag = i;
        }
        
        [self addSubview:({
            
            UIImageView *imageVIew = [[UIImageView alloc]init];
            imageVIew.tag = tag;
            
            [imageVIew sd_setImageWithURL:[NSURL URLWithString:self.imageURLs[tag - 1]] placeholderImage:self.placeholderImage.length > 0 ? [UIImage imageNamed:self.placeholderImage] : nil];
            
            
            imageVIew.userInteractionEnabled = YES;
            
            [imageVIew setContentMode:UIViewContentModeScaleAspectFill];
            imageVIew.clipsToBounds  = YES;
            
            imageVIew.frame = CGRectMake(scrollW * i, 0, scrollW, scrollH);
            [scrollView addSubview:imageVIew];
            
            [imageVIew addGestureRecognizer:({
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewTaped:)];
                tap;
            })];
            
            scrollView.delegate = self;
            scrollView.scrollsToTop = NO;
            scrollView.pagingEnabled = YES;
            scrollView.scrollEnabled = self.imageURLs.count == 1 ? NO : YES;
            scrollView.showsHorizontalScrollIndicator = NO;
            scrollView.contentOffset = CGPointMake(scrollW, 0);
            scrollView.contentSize = CGSizeMake((self.imageURLs.count+2) * scrollW, 0);
            self.scrollView = scrollView;
        })];
    }
    if (self.imageURLs.count <= 1) return;
    [self addSubview:({
        UIPageControl *pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, scrollH - 20, scrollW, 10)];
        pageControl.numberOfPages = self.imageURLs.count;
        pageControl.userInteractionEnabled = NO;
        pageControl.currentPageIndicatorTintColor = self.currentPageIndicatorTintColor ?:[UIColor whiteColor];
        pageControl.pageIndicatorTintColor = self.pageIndicatorTintColor ? : [UIColor grayColor] ;
        self.pageControl = pageControl;
    })];
    
    [self addTimer];
}
- (void)imageViewTaped:(UITapGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(WJLoopView:didClickImageIndex:)]) {
        [self.delegate WJLoopView:self didClickImageIndex:tap.view.tag - 1];
    }
}
- (void)addTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)removeTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}
- (void)nextImage {
    
    NSInteger currentPage = self.pageControl.currentPage;
    __weak __typeof(&*self)weakSelf = self;
    if (currentPage == self.imageURLs.count - 1) {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
        currentPage=0;
        [UIView animateWithDuration:0.8 animations:^{
            [weakSelf.scrollView setContentOffset:CGPointMake(scrollW, 0) animated:NO];
        }];
    }else{
        currentPage++;
        [UIView animateWithDuration:0.8 animations:^{
            [weakSelf.scrollView setContentOffset:CGPointMake(scrollW * (currentPage + 1), 0) animated:NO];
        }];
    }
    self.pageControl.currentPage = currentPage;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.imageURLs.count <= 1) return;
    NSInteger currentPage = self.scrollView.contentOffset.x / scrollW;
    self.pageControl.currentPage = currentPage == 0 ? self.imageURLs.count : currentPage - 1;
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.imageURLs.count <= 1) return;
    NSInteger currentPage = self.scrollView.contentOffset.x / scrollW;
    if (currentPage == self.imageURLs.count + 1) {
        
        self.pageControl.currentPage = 0;
        
        [self.scrollView setContentOffset:CGPointMake(scrollW, 0) animated:NO];
        
    } else if (currentPage == 0) {
        
        self.pageControl.currentPage = self.imageURLs.count;
        
        [self.scrollView setContentOffset:CGPointMake(self.imageURLs.count * scrollW, 0) animated:NO];
        
    } else {
        
        self.pageControl.currentPage = currentPage - 1;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    if (self.imageURLs.count <= 1) return;
    [self removeTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.imageURLs.count <= 1) return;
    [self addTimer];
}
- (void)setLocation:(WJPageControlLocation)location {
    if (self.imageURLs.count <= 1) return;
    CGFloat w = self.imageURLs.count * 17;
    if (location == WJPageControlAlignmentCenter) {
        self.pageControl.center = CGPointMake(scrollW- w * 0.5-20, scrollH - 20.0f);
    } else if (location == WJPageControlAlignmentCenter) {
        self.pageControl.center = CGPointMake(scrollW * 0.5, scrollH - 20.0f);
    } else if (location == WJPageControlAlignmentLeft) {
        self.pageControl.center = CGPointMake(w * 0.5 + 20, scrollH - 20.0f);
    }
}

@end
