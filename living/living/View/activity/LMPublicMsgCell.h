//
//  LMPublicMsgCell.h
//  living
//
//  Created by Ding on 16/10/9.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMTimeButton.h"
#import "LMChoseCounponButton.h"

@interface LMPublicMsgCell : UITableViewCell
@property(nonatomic,strong)UITextField *titleTF;

@property(nonatomic,strong)UITextField *phoneTF;

@property(nonatomic,strong)UITextField *nameTF;

@property(nonatomic,strong)UITextField *freeTF;

@property(nonatomic,strong)UITextField *VipFreeTF;

@property(nonatomic,strong)UITextField *couponTF;

@property(nonatomic,strong)UITextField *joincountTF;

@property(nonatomic,strong)LMTimeButton *dateButton;

@property(nonatomic,strong)LMTimeButton *timeButton;

@property(nonatomic,strong)LMTimeButton *endDateButton;

@property(nonatomic,strong)LMTimeButton *endTimeButton;

@property(nonatomic,strong)LMTimeButton *addressButton;

@property (nonatomic, strong) LMTimeButton * category;

@property(nonatomic,strong)UITextField *dspTF;

@property(nonatomic,strong)UIButton *mapButton;

@property(nonatomic,strong)UIButton *imageButton;

@property(nonatomic,strong)UIImageView *imgView;

@property(nonatomic,strong)UITextView *applyTextView;

@property(nonatomic,strong)UILabel *msgLabel;

@property(nonatomic,strong)LMChoseCounponButton *UseButton;

@property(nonatomic,strong)LMChoseCounponButton *unUseButton;

//@property(nonatomic,strong);



@end
