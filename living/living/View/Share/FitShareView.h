//
//  FitShareView.h
//  FitTrainer
//
//  Created by JamHonyZ on 15/10/8.
//  Copyright (c) 2015年 Huasheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

#import<MessageUI/MFMailComposeViewController.h>

@protocol FitShareViewDelegate <NSObject>

- (void)doShareWithSMS;

- (void)doShareWithSina;

- (void)doShareWithTencent;

- (void)doShareWithWeChat;

- (void)doShareWithWeChatTimeLine;

@end



@interface FitShareView : UIView

@property (assign, nonatomic) id<FitShareViewDelegate> delegate;

@property (retain, nonatomic) UIButton *shareSMSBtn; //短信
@property (retain, nonatomic) UIButton *shareSinaBtn; //微博
@property (retain, nonatomic) UIButton *shareTencentBtn; //腾讯微博
@property (retain, nonatomic) UIButton *shareWeChatBtn; //微信
@property (retain, nonatomic) UIButton *shareWeChatTimelineBtn; //朋友圈

@property   (retain, nonatomic)     UIView          *viewMask;

+ (FitShareView *)showShareView;

- (void)dismissSelf;

@end
