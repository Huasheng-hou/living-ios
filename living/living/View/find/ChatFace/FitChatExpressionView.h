//
//  FitChatExpressionView.h
//  FitTrainer
//
//  Created by JamHonyZ on 15/10/15.
//  Copyright (c) 2015年 Huasheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FitChatFaceView.h"

@protocol FitChatExpressionViewDelegate <NSObject>

- (void)passValueImage:(UIImage *)image imageID:(NSString *)imageID;

@end

@interface FitChatExpressionView : UIScrollView

@property (nonatomic, assign) id<FitChatExpressionViewDelegate> ExpresionViewDelegate;

@property (nonatomic, retain) UIPageControl     *pageControl;
@property (nonatomic, retain) UIScrollView      *expressionView;
@property (nonatomic, retain) FitChatFaceView   *faceView;

@end
