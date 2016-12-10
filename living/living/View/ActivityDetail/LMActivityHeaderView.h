//
//  LMActivityHeaderView.h
//  living
//
//  Created by 戚秋民 on 16/12/10.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LMEventBodyVO;

@protocol LMActivityHeaderViewDelegate <NSObject>

- (void)shouldJoinActivity;

@end

@interface LMActivityHeaderView : UIView

@property   (retain, nonatomic) LMEventBodyVO   *event;
@property   (weak, nonatomic)   id <LMActivityHeaderViewDelegate>   delegate;

@end
