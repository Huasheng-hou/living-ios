//
//  LMPulicVoicemsgViewCell.h
//  living
//
//  Created by Ding on 2016/12/13.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMTimeButton.h"

@interface LMPulicVoicemsgViewCell : UITableViewCell

@property(nonatomic,strong)UITextField *titleTF;

@property(nonatomic,strong)UITextField *phoneTF;

@property(nonatomic,strong)UITextField *nameTF;

@property(nonatomic,strong)UITextField *freeTF;

@property(nonatomic,strong)UITextField *VipFreeTF;

@property(nonatomic,strong)UITextField *couponTF;

@property(nonatomic,strong)UITextField *joincountTF;

@property(nonatomic,strong)LMTimeButton *teacherButton;

@property(nonatomic,strong)LMTimeButton *hostButton;

@property(nonatomic,strong)LMTimeButton *dateButton;

@property(nonatomic,strong)LMTimeButton *endDateButton;

@property(nonatomic,strong)UIButton *imageButton;


@property(nonatomic,strong)UIImageView *imgView;

@property(nonatomic,strong)UITextView *applyTextView;

@property(nonatomic,strong)UILabel *msgLabel;

@end
