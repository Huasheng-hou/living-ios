//
//  LMExpertHeadView.h
//  living
//
//  Created by hxm on 2017/5/3.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMExpertSpaceVO.h"

@protocol LMExpertHeadViewDelegate <NSObject>

- (void)gotoListPage:(NSInteger)index;

@end

@interface LMExpertHeadView : UIView

@property (nonatomic, assign) CGFloat cellH;


@property (nonatomic, weak) id<LMExpertHeadViewDelegate> delegate;

- (void)setData:(LMExpertSpaceVO *)vo;

@end
