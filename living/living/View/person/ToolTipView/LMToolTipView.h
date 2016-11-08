//
//  LMToolTipView.h
//  living
//
//  Created by JamHonyZ on 2016/11/8.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol buttonTypeDelegate <NSObject>

-(void)buttonType:(NSInteger)type;

@end

@interface LMToolTipView : UIView

@property(nonatomic,assign)id<buttonTypeDelegate>delegate;

- (id)initWithHeadImage:(NSString *)image andNickName:(NSString *)nickName;
@end
