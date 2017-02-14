//
//  LMExceptionalView.h
//  living
//
//  Created by Ding on 2017/2/14.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LMExceptionalViewDelegate;


@interface LMExceptionalView : UIView

@property(nonatomic,strong)UIImageView *headerView;

@property(nonatomic,strong)UILabel *nameLabel;

@property(nonatomic,strong)UIButton *cancelButton;

@property (nonatomic, weak) id <LMExceptionalViewDelegate> delegate;

@end

@protocol LMExceptionalViewDelegate <NSObject>

@optional

- (void)ViewForMoney:(LMExceptionalView *)LMview Viewtag:(NSInteger)Viewtag;


@end


