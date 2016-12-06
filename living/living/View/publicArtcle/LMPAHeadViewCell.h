//
//  LMPAHeadViewCell.h
//  living
//
//  Created by Ding on 2016/12/6.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  LMPAHeadViewCellDelegate;

@interface LMPAHeadViewCell : UITableViewCell
<UITextFieldDelegate,UITextViewDelegate>


@property(nonatomic,strong)UITextView *includeTF;

@property(nonatomic,strong)UIButton *eventButton;

@property(nonatomic,strong)UILabel *textLab;

@property(nonatomic,strong)UIImageView *imgView;

@property(nonatomic,strong)UIButton *addButton;

@property(nonatomic)NSInteger cellndex;


@property (nonatomic, weak) id <LMPAHeadViewCellDelegate> delegate;

@end

@protocol LMPAHeadViewCellDelegate <NSObject>

@optional
- (void)cellWilladdImage:(LMPAHeadViewCell *)cell;


@end
