//
//  LMVoiceDetailHeaderView.h
//  living
//
//  Created by Ding on 2016/12/13.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LMVoiceDetailVO;

@protocol LMVoiceDetailHeaderViewDelegate <NSObject>

- (void)shouldJoinVoice;

@end

@interface LMVoiceDetailHeaderView : UIView

@property   (retain, nonatomic) LMVoiceDetailVO   *event;
@property   (nonatomic, strong) NSString *role;

@property   (weak, nonatomic)   id <LMVoiceDetailHeaderViewDelegate>   delegate;

@end
