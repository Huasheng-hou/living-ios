
//
//  FitChatFunctionView.h
//  FitTrainer
//
//  Created by JamHonyZ on 15/12/14.
//  Copyright (c) 2015年 Huasheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FitChatFunctionViewDelegate <NSObject>

- (void)openPhotoLibrary;

- (void)takePhoto;

- (void)sendMoney;

- (void)sendPersonMoney;

@end

@interface FitChatFunctionView : UIView

@property (nonatomic, assign) id<FitChatFunctionViewDelegate> delegate;

- (void)setRedPacketHidden;

@end
