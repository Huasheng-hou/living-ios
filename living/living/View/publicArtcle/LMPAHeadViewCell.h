//
//  LMPAHeadViewCell.h
//  living
//
//  Created by Ding on 2016/12/6.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditImageView.h"

@protocol  LMPAHeadViewCellDelegate;

@interface LMPAHeadViewCell : UITableViewCell


@property(nonatomic,strong)UITextView *includeTF;

@property(nonatomic,strong)UIButton *eventButton;

@property(nonatomic,strong)UILabel *textLab;

@property(nonatomic,strong)UIImageView *imgView;

@property(nonatomic)NSInteger cellndex;

@property(nonatomic,strong)UIButton *deleteBt;

@property(nonatomic,strong)UIView *backView;

@property(nonatomic,strong)EditImageView *imageV;

@property(nonatomic,strong)NSMutableArray *array;


@property (nonatomic, weak) id <LMPAHeadViewCellDelegate> delegate;

@end

@protocol LMPAHeadViewCellDelegate <NSObject>

@optional
- (void)cellWilladdImage:(LMPAHeadViewCell *)cell;


@end
