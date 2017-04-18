//
//  LMPublicEventCell.h
//  living
//
//  Created by hxm on 2017/3/23.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMTimeButton.h"
#import "LMChoseCounponButton.h"
@interface LMPublicEventCell : UITableViewCell
@property(nonatomic,strong)UITextField *titleTF;

@property(nonatomic,strong)UITextField *phoneTF;

@property(nonatomic,strong)UITextField *nameTF;

@property(nonatomic,strong)UITextField *freeTF;

@property(nonatomic,strong)UITextField *VipFreeTF;

@property(nonatomic,strong)UITextField *couponTF;

@property (nonatomic, strong) LMTimeButton * category;

@property(nonatomic,strong)LMTimeButton *addressButton;

@property(nonatomic,strong)UITextField *dspTF;

@property(nonatomic,strong)UIButton *mapButton;

@property(nonatomic,strong)UIButton *imageButton;

@property(nonatomic,strong)UIImageView *imgView;

@property(nonatomic,strong)UITextView *applyTextView;

@property(nonatomic,strong)UILabel *msgLabel;

@property(nonatomic,strong)LMChoseCounponButton *UseButton;

@property(nonatomic,strong)LMChoseCounponButton *unUseButton;
@end
