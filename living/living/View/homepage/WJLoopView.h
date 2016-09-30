//
//  WJLoopVIew.h
//  WJLoopView
//
//  Created by bringbird on 15/12/29.
//  Copyright © 2015年 韦明杰. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  PageControl的位置
 */
typedef NS_ENUM(NSUInteger, WJPageControlLocation) {
    /** 左侧 */
    WJPageControlAlignmentLeft,
    /** 中心 */
    WJPageControlAlignmentCenter,
    /** 右侧 */
    WJPageControlAlignmentRight,
};

@class WJLoopView;

@protocol WJLoopViewDelegate <NSObject>
/**
 *  点击轮播图的回调方法
 *
 *  @param LoopView 轮播图
 *  @param index    图片的index
 */
-(void)WJLoopView:(WJLoopView *)LoopView didClickImageIndex:(NSInteger)index;

@end

@interface WJLoopView : UIView
/** PageControl 的位置，默认位于中间 */
@property (nonatomic, assign) WJPageControlLocation location;

#pragma mark - Class Method
/**
 *  广告轮播图
 *
 *  @param frame                          frame
 *  @param delegate                       点击代理
 *  @param imageURLs                      网络图路径数组
 *  @param placeholderImage               占位图
 *  @param timeInterval                   轮播时间
 *  @param currentPageIndicatorITintColor 当前pagecontrol的颜色
 *  @param pageIndicatorTintColor         pagecontrol的其他颜色
 *
 */
+ (instancetype)WJLoopViewWithFrame:(CGRect)frame delegate:(id<WJLoopViewDelegate>)delegate imageURLs:(NSArray *)imageURLs placeholderImage:(NSString *)placeholderImage timeInterval:(NSTimeInterval)timeInterval currentPageIndicatorITintColor:(UIColor *)currentPageIndicatorITintColor pageIndicatorTintColor:(UIColor *)pageIndicatorTintColor;

#pragma mark - Initialization Method
/**
 *  广告轮播图
 *
 *  @param frame                          frame
 *  @param delegate                       点击代理
 *  @param imageURLs                      网络图路径数组
 *  @param placeholderImage               占位图
 *  @param timeInterval                   轮播时间
 *  @param currentPageIndicatorITintColor 当前pagecontrol的颜色
 *  @param pageIndicatorTintColor         pagecontrol的其他颜色
 *
 */
- (instancetype)initWithFrame:(CGRect)frame delegate:(id<WJLoopViewDelegate>)delegate imageURLs:(NSArray *)imageURLs placeholderImage:(NSString *)placeholderImage timeInterval:(NSTimeInterval)timeInterval currentPageIndicatorITintColor:(UIColor *)currentPageIndicatorITintColor pageIndicatorTintColor:(UIColor *)pageIndicatorTintColor;

@end
