//
//  LMPublicEventCell.m
//  living
//
//  Created by hxm on 2017/3/23.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMPublicEventCell.h"
#import "FitConsts.h"
#define titleW titleLable.bounds.size.width
@implementation LMPublicEventCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self    = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self addSubviews];
    }
    return self;
}
-(void)addSubviews
{
    /***********  左侧信息名称部分  *********/
    
    //活动标题
    UILabel *titleLable = [UILabel new];
    titleLable.text = @"活动标题";
    titleLable.font = TEXT_FONT_LEVEL_1;
    titleLable.textColor = TEXT_COLOR_LEVEL_2;
    [titleLable sizeToFit];
    titleLable.frame = CGRectMake(10, 5, titleLable.bounds.size.width, 30);
    [self.contentView addSubview:titleLable];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(20+titleW, 40, kScreenWidth-30-titleW, 0.5)];
    lineView.backgroundColor = LINE_COLOR;
    [self.contentView addSubview:lineView];
    
    //联系电话
    UILabel *phoneLable = [UILabel new];
    phoneLable.text = @"联系电话";
    phoneLable.font = TEXT_FONT_LEVEL_1;
    phoneLable.textColor = TEXT_COLOR_LEVEL_2;
    [phoneLable sizeToFit];
    phoneLable.frame = CGRectMake(10, 50, titleW, 30);
    [self.contentView addSubview:phoneLable];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(20+titleW, 85, kScreenWidth-30-titleW, 0.5)];
    lineView1.backgroundColor = LINE_COLOR;
    [self.contentView addSubview:lineView1];
    //联系姓名
    UILabel *nameLable = [UILabel new];
    nameLable.text = @"联系姓名";
    nameLable.font = TEXT_FONT_LEVEL_1;
    nameLable.textColor = TEXT_COLOR_LEVEL_2;
    [nameLable sizeToFit];
    nameLable.frame = CGRectMake(10, 95, titleW, 30);
    [self.contentView addSubview:nameLable];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(20+titleW, 130, kScreenWidth-30-titleW, 0.5)];
    lineView2.backgroundColor = LINE_COLOR;
    [self.contentView addSubview:lineView2];
    //人均费用
    UILabel *freeLable = [UILabel new];
    freeLable.text = @"活动费用";
    freeLable.font = TEXT_FONT_LEVEL_1;
    freeLable.textColor = TEXT_COLOR_LEVEL_2;
    [freeLable sizeToFit];
    freeLable.frame = CGRectMake(10, 140, titleW, 30);
    [self.contentView addSubview:freeLable];
    
    UIView *lineView8 = [[UIView alloc] initWithFrame:CGRectMake(20+titleW, 175, kScreenWidth-30-titleW, 0.5)];
    lineView8.backgroundColor = LINE_COLOR;
    [self.contentView addSubview:lineView8];
    
    //会员费用
    UILabel *VIPLable = [UILabel new];
    VIPLable.text = @"会员费用";
    VIPLable.font = TEXT_FONT_LEVEL_1;
    VIPLable.textColor = TEXT_COLOR_LEVEL_2;
    [VIPLable sizeToFit];
    VIPLable.frame = CGRectMake(10, 185, titleW, 30);
    [self.contentView addSubview:VIPLable];
    
    UIView *lineView9 = [[UIView alloc] initWithFrame:CGRectMake(20+titleW, 220, kScreenWidth-30-titleW, 0.5)];
    lineView9.backgroundColor = LINE_COLOR;
    [self.contentView addSubview:lineView9];
    
    //加盟商费用
    UILabel *couponLable = [UILabel new];
    couponLable.text = @"加盟商价格";
    couponLable.font = TEXT_FONT_LEVEL_1;
    couponLable.textColor = TEXT_COLOR_LEVEL_2;
    [couponLable sizeToFit];
    couponLable.frame = CGRectMake(10, 230, couponLable.bounds.size.width, 30);
    [self.contentView addSubview:couponLable];
    
    UIView *lineView10 = [[UIView alloc] initWithFrame:CGRectMake(20+couponLable.bounds.size.width, 265, kScreenWidth-30-couponLable.bounds.size.width, 0.5)];
    lineView10.backgroundColor = LINE_COLOR;
    [self.contentView addSubview:lineView10];
    
    //是否抵用
    UILabel *UseLable = [UILabel new];
    UseLable.text = @"是否抵用";
    UseLable.font = TEXT_FONT_LEVEL_1;
    UseLable.textColor = TEXT_COLOR_LEVEL_2;
    [UseLable sizeToFit];
    UseLable.frame = CGRectMake(10, 275, UseLable.bounds.size.width, 30);
    [self.contentView addSubview:UseLable];
    
    UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(20+titleW, 355, kScreenWidth-30-titleW, 0.5)];
    lineView3.backgroundColor = LINE_COLOR;
    [self.contentView addSubview:lineView3];
    
    //项目类别
    UILabel *stopLable = [UILabel new];
    stopLable.text = @"项目类别";
    stopLable.font = TEXT_FONT_LEVEL_1;
    stopLable.textColor = TEXT_COLOR_LEVEL_2;
    [stopLable sizeToFit];
    stopLable.frame = CGRectMake(10, 320, stopLable.bounds.size.width, 30);
    [self.contentView addSubview:stopLable];
    
    //活动地址
    UILabel *addressLable = [UILabel new];
    addressLable.text = @"活动地址";
    addressLable.font = TEXT_FONT_LEVEL_1;
    addressLable.textColor = TEXT_COLOR_LEVEL_2;
    [addressLable sizeToFit];
    addressLable.frame = CGRectMake(10, 455-90, addressLable.bounds.size.width, 30);
    [self.contentView addSubview:addressLable];
    //地址详情
    UILabel *dspLable = [UILabel new];
    dspLable.text = @"地址详情";
    dspLable.font = TEXT_FONT_LEVEL_1;
    dspLable.textColor = TEXT_COLOR_LEVEL_2;
    [dspLable sizeToFit];
    dspLable.frame = CGRectMake(10, 500-90, dspLable.bounds.size.width, 30);
    [self.contentView addSubview:dspLable];
    
    
    
    UIView *lineView4 = [[UIView alloc] initWithFrame:CGRectMake(20+titleW, 535-90, kScreenWidth-30-titleW, 0.5)];
    lineView4.backgroundColor = LINE_COLOR;
    [self.contentView addSubview:lineView4];
    
    
    //报名须知
    UILabel *msgLabel = [UILabel new];
    msgLabel.text = @"报名须知";
    msgLabel.font = TEXT_FONT_LEVEL_1;
    msgLabel.textColor = TEXT_COLOR_LEVEL_2;
    [msgLabel sizeToFit];
    msgLabel.frame = CGRectMake(10, 545-90, msgLabel.bounds.size.width, 30);
    [self.contentView addSubview:msgLabel];
    
    
    
    //封面图片
    UILabel *imageLable = [UILabel new];
    imageLable.text = @"封面图片";
    imageLable.font = TEXT_FONT_LEVEL_1;
    imageLable.textColor = TEXT_COLOR_LEVEL_2;
    [imageLable sizeToFit];
    imageLable.frame = CGRectMake(10, 635-90, imageLable.bounds.size.width, 30);
    [self.contentView addSubview:imageLable];
    
    UILabel *imagemsgLable = [UILabel new];
    imagemsgLable.text = @"(建议尺寸：750*330)";
    imagemsgLable.font = TEXT_FONT_LEVEL_3;
    imagemsgLable.textColor = TEXT_COLOR_LEVEL_3;
    [imagemsgLable sizeToFit];
    imagemsgLable.frame = CGRectMake(15+imageLable.bounds.size.width, 635-90, imagemsgLable.bounds.size.width, 30);
    [self.contentView addSubview:imagemsgLable];
    
    
    
    //输入内容部分
    _titleTF = [[UITextField alloc] initWithFrame:CGRectMake(titleW+20, 5, kScreenWidth- titleW-30, 30)];
    _titleTF.font = TEXT_FONT_LEVEL_2;
    _titleTF.returnKeyType = UIReturnKeyDone;
    _titleTF.placeholder = @"请输入活动标题";
    [self.contentView addSubview:_titleTF];
    
    _phoneTF = [[UITextField alloc] initWithFrame:CGRectMake(titleW+20, 50, kScreenWidth- titleW-30, 30)];
    _phoneTF.font = TEXT_FONT_LEVEL_2;
    _phoneTF.returnKeyType = UIReturnKeyDone;
    _phoneTF.keyboardType = UIKeyboardTypePhonePad;
    _phoneTF.placeholder = @"请输入活动联系人号码";
    [self.contentView addSubview:_phoneTF];
    
    _nameTF = [[UITextField alloc] initWithFrame:CGRectMake(titleW+20, 95, kScreenWidth- titleW-30, 30)];
    _nameTF.font = TEXT_FONT_LEVEL_2;
    _nameTF.returnKeyType = UIReturnKeyDone;
    _nameTF.placeholder = @"请输入活动联系人姓名";
    [self.contentView addSubview:_nameTF];
    
    _freeTF = [[UITextField alloc] initWithFrame:CGRectMake(titleW+20, 140, kScreenWidth- titleW-30, 30)];
    _freeTF.font = TEXT_FONT_LEVEL_2;
    _freeTF.returnKeyType = UIReturnKeyDone;
    _freeTF.placeholder = @"请输入活动费用";
    _freeTF.keyboardType = UIKeyboardTypeNumberPad;
    [self.contentView addSubview:_freeTF];
    
    //会员费用
    _VipFreeTF = [[UITextField alloc] initWithFrame:CGRectMake(titleW+20, 185, kScreenWidth- titleW-30, 30)];
    _VipFreeTF.font = TEXT_FONT_LEVEL_2;
    _VipFreeTF.returnKeyType = UIReturnKeyDone;
    _VipFreeTF.placeholder = @"请输入会员费用";
    _VipFreeTF.keyboardType = UIKeyboardTypeNumberPad;
    [self.contentView addSubview:_VipFreeTF];
    
    //加盟商费用
    _couponTF = [[UITextField alloc] initWithFrame:CGRectMake(couponLable.bounds.size.width+20, 230, kScreenWidth- titleW-30, 30)];
    _couponTF.font = TEXT_FONT_LEVEL_2;
    _couponTF.returnKeyType = UIReturnKeyDone;
    _couponTF.placeholder = @"请输入加盟商费用";
    _couponTF.keyboardType = UIKeyboardTypeNumberPad;
    [self.contentView addSubview:_couponTF];
    
    //是否抵用
    _UseButton = [LMChoseCounponButton buttonWithType:UIButtonTypeSystem];
    _UseButton.textLabel.text =  @"是";
    _UseButton.chooseImage.backgroundColor = LIVING_COLOR;
    [_UseButton sizeToFit];
    _UseButton.frame = CGRectMake(titleW+20+20, 275, 60, 30);
    
    [self.contentView addSubview:_UseButton];
    
    _unUseButton = [LMChoseCounponButton buttonWithType:UIButtonTypeSystem];
    _unUseButton.textLabel.text =  @"否";
    _unUseButton.chooseImage.backgroundColor = [UIColor clearColor];
    _unUseButton.chooseImage.layer.borderColor = [UIColor blackColor].CGColor;
    [_unUseButton sizeToFit];
    _unUseButton.frame = CGRectMake(titleW+20+20+80, 275, 60, 30);
    [self.contentView addSubview:_unUseButton];
    
    //分类
    _category = [LMTimeButton buttonWithType:UIButtonTypeSystem];
    [_category setTitle:@"请选择项目类别" forState:UIControlStateNormal];
    [_category setTitleColor:COLOR_BLACK_LIGHT forState:UIControlStateNormal];
    _category.layer.cornerRadius = 5;
    _category.layer.borderColor = LINE_COLOR.CGColor;
    _category.layer.borderWidth = 0.5;
    _category.titleLabel.textAlignment = NSTextAlignmentCenter;
    //_category.textLabel.text =  @"请选择项目类别";
    [_category.textLabel sizeToFit];
    _category.textLabel.frame = CGRectMake(5, 0, kScreenWidth-titleW-30, 30);
    [_category sizeToFit];
    _category.frame = CGRectMake(titleW+20, 320, kScreenWidth-titleW-30, 30);
    [self.contentView addSubview:_category];

    
    //活动地址
    _addressButton = [LMTimeButton buttonWithType:UIButtonTypeSystem];
    _addressButton.layer.cornerRadius = 5;
    _addressButton.layer.borderColor = LINE_COLOR.CGColor;
    _addressButton.layer.borderWidth = 0.5;
    _addressButton.textLabel.text =  @"请选择活动所在省市，县区";
    [_addressButton.textLabel sizeToFit];
    _addressButton.textLabel.frame = CGRectMake(5, 0, kScreenWidth-titleW-30, 30);
    [_addressButton sizeToFit];
    _addressButton.frame = CGRectMake(titleW+20, 455-90, kScreenWidth-titleW-30, 30);
    [self.contentView addSubview:_addressButton];
    
    
    
    
    _dspTF = [[UITextField alloc] initWithFrame:CGRectMake(titleW+20, 500-90, kScreenWidth- titleW-30, 30)];
    _dspTF.font = TEXT_FONT_LEVEL_2;
    [_dspTF setUserInteractionEnabled:NO];
    _dspTF.returnKeyType = UIReturnKeyDone;
    _dspTF.placeholder = @"请选择详细地址";
    [self.contentView addSubview:_dspTF];
    
    //地图选点按钮
    _mapButton=[[UIButton alloc]initWithFrame:CGRectMake(titleW+20, 500-90, kScreenWidth-(titleW+20), 30)];
    [_mapButton setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:_mapButton];
    
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(titleW+20, 545-90, kScreenWidth-(titleW+30), 80)];
    backView.layer.borderColor = LINE_COLOR.CGColor;
    backView.layer.borderWidth = 0.5;
    backView.layer.cornerRadius = 5;
    [self.contentView addSubview:backView];
    
    _applyTextView = [[UITextView alloc] initWithFrame:CGRectMake(3, 0, kScreenWidth-(titleW+30+6), 80)];
    
    _msgLabel = [UILabel new];
    _msgLabel.text = @"请输入报名须知内容";
    _msgLabel.font = TEXT_FONT_LEVEL_2;
    _msgLabel.textColor = TEXT_COLOR_LEVEL_2;
    [_msgLabel sizeToFit];
    _msgLabel.frame = CGRectMake(5, 0, _msgLabel.bounds.size.width, 25);
    [_applyTextView addSubview:_msgLabel];
    
    [backView addSubview:_applyTextView];
    
    
    
    
    
    
    UIView *imgBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 670-90, kScreenWidth, kScreenWidth*3/5)];
    imgBackView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    [self.contentView addSubview:imgBackView];
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2-28, (kScreenWidth*3/5-65)/2, 56, 65)];
    image.image = [UIImage imageNamed:@"publicEvent"];
    [imgBackView addSubview:image];
    
    
    _imageButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _imageButton.backgroundColor = [UIColor clearColor];
    _imageButton.frame = CGRectMake(0, 670-90, kScreenWidth, kScreenWidth*3/5);
    [self.contentView addSubview:_imageButton];
    
    _imgView = [[UIImageView alloc] init];
    _imgView.frame = CGRectMake(0, 670-90, kScreenWidth, kScreenWidth*3/5);
    [self.contentView addSubview:_imgView];
    
    
    for (int i = 0; i<12; i++) {
        
        
        if (i ==5) {
            UIImageView *keyImage = [[UIImageView alloc] initWithFrame:CGRectMake(couponLable.bounds.size.width+10, 10+45*i-90, 6, 5)];
            keyImage.image = [UIImage imageNamed:@"key"];
            [self.contentView addSubview:keyImage];
        }else{
            UIImageView *keyImage = [[UIImageView alloc] initWithFrame:CGRectMake(imageLable.bounds.size.width+10, 10+45*i-90, 6, 5)];
            keyImage.image = [UIImage imageNamed:@"key"];
            [self.contentView addSubview:keyImage];
        }
        
    }
    
    UIImageView *keyImage2 = [[UIImageView alloc] initWithFrame:CGRectMake(imageLable.bounds.size.width+10, 5+590+45-90, 6, 5)];
    keyImage2.image = [UIImage imageNamed:@"key"];
    [self.contentView addSubview:keyImage2];
    
}

@end
