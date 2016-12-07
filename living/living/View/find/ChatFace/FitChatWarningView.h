//
//  FitChatWarningView.h
//  FitTrainer
//
//  Created by JamHonyZ on 16/1/7.
//  Copyright © 2016年 Huasheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FitChatWarningViewDelegate <NSObject>

- (void)pushToRecommentPlan;

- (void)pushToOpenPlan;

@end

@interface FitChatWarningView : UIView

@property (nonatomic, assign) id <FitChatWarningViewDelegate> delegate;

@end
