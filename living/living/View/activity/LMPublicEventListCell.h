//
//  LMPublicEventListCell.h
//  living
//
//  Created by Ding on 16/10/14.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  LMPublicEventCellDelegate;

@interface LMPublicEventListCell : UITableViewCell
<UITextFieldDelegate,UITextViewDelegate>


@property(nonatomic,strong)UITextField *titleTF;

@property(nonatomic,strong)UITextView *includeTF;

@property(nonatomic,strong)UIButton *eventButton;

@property(nonatomic,strong)UILabel *textLab;

@property(nonatomic,strong)UIImageView *imgView;

@property(nonatomic)NSInteger cellndex;

@property(nonatomic,strong)UIButton *deleteBt;


@property (nonatomic, weak) id <LMPublicEventCellDelegate> delegate;

@end

@protocol LMPublicEventCellDelegate <NSObject>

@optional
- (void)cellWilladdImage:(LMPublicEventListCell *)cell;


@end
