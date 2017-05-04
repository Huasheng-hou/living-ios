//
//  LMExpertFootView.h
//  living
//
//  Created by hxm on 2017/5/3.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LMExpertFootViewDelegate <NSObject>

- (void)gotoDetailPage:(NSInteger)index;

@end

@interface LMExpertFootView : UIView

@property (nonatomic, weak) id<LMExpertFootViewDelegate> delegate;

- (void)setDataWithArticle:(NSArray *)articles andEvents:(NSArray *)events andVoices:(NSArray *)voices;

@end
