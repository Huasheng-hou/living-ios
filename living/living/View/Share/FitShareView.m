//
//  FitShareView.m
//  FitTrainer
//
//  Created by JamHonyZ on 15/10/8.
//  Copyright (c) 2015年 Huasheng. All rights reserved.
//

#import "FitShareView.h"
#import "FitConsts.h"
//#import "UMSocial.h"

@interface FitShareView () 



@end


@implementation FitShareView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self _initSubviews];
        
        self.backgroundColor    = BG_GRAY_COLOR;
    }
    
    return self;
}

- (void)_initSubviews {
    
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//    cancelBtn.frame = CGRectMake(0, 220, kScreenWidth, 50);
    cancelBtn.frame = CGRectMake(0, 120, kScreenWidth, 50);
    cancelBtn.backgroundColor = [UIColor whiteColor];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(dismissSelf) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelBtn];
    
    _shareSMSBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _shareSMSBtn.frame = CGRectMake((kScreenWidth / 4 - 60) / 2, 15, 60, 60);
    [_shareSMSBtn setBackgroundImage:[UIImage imageNamed:@"share_sms_icon"] forState:UIControlStateNormal];
    [_shareSMSBtn addTarget:self action:@selector(shareWithSMS) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_shareSMSBtn];
    
    UILabel *textLab = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth / 4 - 60) / 2, 85, 60, 20)];
    textLab.backgroundColor = [UIColor clearColor];
    textLab.text = @"短信";
    textLab.font = TEXT_FONT_LEVEL_3;
    textLab.textColor = TEXT_COLOR_LEVEL_2;
    textLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:textLab];
    
    _shareSinaBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _shareSinaBtn.frame = CGRectMake(kScreenWidth / 4 + (kScreenWidth / 4 - 60) / 2, 15, 60, 60);
    [_shareSinaBtn setBackgroundImage:[UIImage imageNamed:@"share_sina_icon"] forState:UIControlStateNormal];
    [_shareSinaBtn addTarget:self action:@selector(shareWithSina) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_shareSinaBtn];
    
    UILabel *textLab1 = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth / 4 + (kScreenWidth / 4 - 60) / 2, 85, 60, 20)];
    textLab1.backgroundColor = [UIColor clearColor];
    textLab1.text = @"微博";
    textLab1.font = TEXT_FONT_LEVEL_3;
    textLab1.textColor = TEXT_COLOR_LEVEL_2;
    textLab1.textAlignment = NSTextAlignmentCenter;
    [self addSubview:textLab1];
    
    
    
//    _shareTencentBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//    _shareTencentBtn.frame = CGRectMake(kScreenWidth / 2 + (kScreenWidth / 4 - 60) / 2, 15, 60, 60);
//    [_shareTencentBtn setBackgroundImage:[UIImage imageNamed:@"share_tencent_icon"] forState:UIControlStateNormal];
//    [_shareTencentBtn addTarget:self action:@selector(shareWithTencent) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:_shareTencentBtn];
//    
//    UILabel *textLab2 = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth / 2 + (kScreenWidth / 4 - 60) / 2, 85, 60, 20)];
//    textLab2.backgroundColor = [UIColor clearColor];
//    textLab2.text = @"腾讯微博";
//    textLab2.font = TEXT_FONT_LEVEL_3;
//    textLab2.textColor = TEXT_COLOR_LEVEL_2;
//    textLab2.textAlignment = NSTextAlignmentCenter;
//    [self addSubview:textLab2];
    
    
    _shareWeChatBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//    _shareWeChatBtn.frame = CGRectMake(kScreenWidth / 4 * 3 + (kScreenWidth / 4 - 60) / 2, 15, 60, 60);
    _shareWeChatBtn.frame = CGRectMake(kScreenWidth / 2 + (kScreenWidth / 4 - 60) / 2, 15, 60, 60);
    [_shareWeChatBtn setBackgroundImage:[UIImage imageNamed:@"share_wechat_session_icon"] forState:UIControlStateNormal];
    [_shareWeChatBtn addTarget:self action:@selector(shareWithWeChat) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_shareWeChatBtn];
    
//    UILabel *textLab3 = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth / 4 * 3 + (kScreenWidth / 4 - 60) / 2, 85, 60, 20)];
    UILabel *textLab3 = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth / 2 + (kScreenWidth / 4 - 60) / 2, 85, 60, 20)];
    textLab3.backgroundColor = [UIColor clearColor];
    textLab3.text = @"微信";
    textLab3.font = TEXT_FONT_LEVEL_3;
    textLab3.textColor = TEXT_COLOR_LEVEL_2;
    textLab3.textAlignment = NSTextAlignmentCenter;
    [self addSubview:textLab3];
    
    
    _shareWeChatTimelineBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _shareWeChatTimelineBtn.frame = CGRectMake(kScreenWidth / 4 * 3 + (kScreenWidth / 4 - 60) / 2, 15, 60, 60);
//    _shareWeChatTimelineBtn.frame = CGRectMake((kScreenWidth / 4 - 60) / 2, 120, 60, 60);
    [_shareWeChatTimelineBtn setBackgroundImage:[UIImage imageNamed:@"share_wechat_timeline_icon"] forState:UIControlStateNormal];
    [_shareWeChatTimelineBtn addTarget:self action:@selector(shareWithWeChatTimeLine) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_shareWeChatTimelineBtn];
    
    UILabel *textLab4 = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth / 4 * 3 + (kScreenWidth / 4 - 60) / 2, 85, 60, 20)];
//     UILabel *textLab4 = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth / 4 - 60) / 2, 190, 60, 20)];
    textLab4.backgroundColor = [UIColor clearColor];
    textLab4.text = @"朋友圈";
    textLab4.font = TEXT_FONT_LEVEL_3;
    textLab4.textColor = TEXT_COLOR_LEVEL_2;
    textLab4.textAlignment = NSTextAlignmentCenter;
    [self addSubview:textLab4];
    
    
}

- (void)shareWithSMS {
    [self dismissSelf];
    if ([self.delegate respondsToSelector:@selector(doShareWithSMS)]) {
        [self.delegate doShareWithSMS];
    }
}

- (void)shareWithSina {
    [self dismissSelf];
    if ([self.delegate respondsToSelector:@selector(doShareWithSina)]) {
        [self.delegate doShareWithSina];
    }
}

- (void)shareWithTencent {
    [self dismissSelf];
    if ([self.delegate respondsToSelector:@selector(doShareWithTencent)]) {
        [self.delegate doShareWithTencent];
    }
}

- (void)shareWithWeChat {
    [self dismissSelf];
    if ([self.delegate respondsToSelector:@selector(doShareWithWeChat)]) {
        [self.delegate doShareWithWeChat];
    }
}

- (void)shareWithWeChatTimeLine {
    [self dismissSelf];
    if ([self.delegate respondsToSelector:@selector(doShareWithWeChatTimeLine)]) {
        [self.delegate doShareWithWeChatTimeLine];
    }
}


+ (FitShareView *)showShareView {
    FitShareView *shareView = [[FitShareView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 170)];
    
    
    UIView          *viewMask   = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    
    viewMask.backgroundColor    = [UIColor blackColor];
    viewMask.alpha              = 0;
    
    UITapGestureRecognizer  *tapGR  = [[UITapGestureRecognizer alloc] initWithTarget:shareView action:@selector(dismissSelf)];
    [viewMask addGestureRecognizer:tapGR];
    
    
    shareView.viewMask = viewMask;
    
    [[[[UIApplication sharedApplication] delegate] window] addSubview:viewMask];
    [[[[UIApplication sharedApplication] delegate] window] addSubview:shareView];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        viewMask.alpha      = 0.2;
        shareView.frame    = CGRectMake(0, kScreenHeight - 170, kScreenWidth, 170);
    }];
    return shareView;
}

- (void)dismissSelf {
    [UIView animateWithDuration:0.2 animations:^{
        
        self.frame  = CGRectMake(0, kScreenHeight, kScreenWidth, self.frame.size.height);
        self.viewMask.alpha = 0;
    } completion:^(BOOL finished) {
        
        [self.viewMask removeFromSuperview];
        [self removeFromSuperview];
    }];
}


@end
