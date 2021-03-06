//
//  LMProjectCell.h
//  living
//
//  Created by JamHonyZ on 2016/11/5.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  LMProjectCellDelegate;

@interface LMProjectCell : UITableViewCell

//@property(nonatomic,strong)UITextField *titleTF;

@property(nonatomic,strong)UITextField *title;


@property(nonatomic,strong)UITextView *includeTF;

@property(nonatomic,strong)UILabel *textLab;

@property(nonatomic,strong)UIButton *eventButton;

@property(nonatomic,strong)UIImageView *imgView;

@property(nonatomic)NSInteger cellndex;

@property(nonatomic,strong)UIButton *deleteBt;

@property(nonatomic,strong)UIButton *videoButton;

@property(nonatomic,strong)UIImageView *VideoImgView;

@property(nonatomic,strong)UIButton *button;

@property (nonatomic, weak) id <LMProjectCellDelegate> delegate;

@end

@protocol LMProjectCellDelegate <NSObject>

@optional
- (void)cellWilldelete:(LMProjectCell *)projectcell;


@end
