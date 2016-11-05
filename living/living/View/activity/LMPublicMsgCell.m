//
//  LMPublicMsgCell.m
//  living
//
//  Created by Ding on 16/10/9.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMPublicMsgCell.h"
#import "FitConsts.h"
#define titleW titleLable.bounds.size.width

@implementation LMPublicMsgCell

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
    
    //活动标题
    UILabel *titleLable = [UILabel new];
    titleLable.text = @"活动标题";
    titleLable.font = TEXT_FONT_LEVEL_1;
    titleLable.textColor = TEXT_COLOR_LEVEL_2;
    [titleLable sizeToFit];
    titleLable.frame = CGRectMake(10, 5, titleLable.bounds.size.width, 30);
    [self.contentView addSubview:titleLable];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(20+titleW, 40, kScreenWidth-25-titleW, 0.5)];
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
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(20+titleW, 85, kScreenWidth-25-titleW, 0.5)];
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
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(20+titleW, 130, kScreenWidth-25-titleW, 0.5)];
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
    
    UIView *lineView8 = [[UIView alloc] initWithFrame:CGRectMake(20+titleW, 175, kScreenWidth-25-titleW, 0.5)];
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
    
    UIView *lineView9 = [[UIView alloc] initWithFrame:CGRectMake(20+titleW, 220, kScreenWidth-25-titleW, 0.5)];
    lineView9.backgroundColor = LINE_COLOR;
    [self.contentView addSubview:lineView9];
    
    //参加人数
    UILabel *joinLable = [UILabel new];
    joinLable.text = @"活动人数";
    joinLable.font = TEXT_FONT_LEVEL_1;
    joinLable.textColor = TEXT_COLOR_LEVEL_2;
    [joinLable sizeToFit];
    joinLable.frame = CGRectMake(10, 230, titleW, 30);
    [self.contentView addSubview:joinLable];
    
    
    UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(20+titleW, 265, kScreenWidth-25-titleW, 0.5)];
    lineView3.backgroundColor = LINE_COLOR;
    [self.contentView addSubview:lineView3];
    //开始时间
    UILabel *startLable = [UILabel new];
    startLable.text = @"开始时间";
    startLable.font = TEXT_FONT_LEVEL_1;
    startLable.textColor = TEXT_COLOR_LEVEL_2;
    [startLable sizeToFit];
    startLable.frame = CGRectMake(10, 275, startLable.bounds.size.width, 30);
    [self.contentView addSubview:startLable];
    
    
    
    //结束时间
    UILabel *stopLable = [UILabel new];
    stopLable.text = @"结束时间";
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
    addressLable.frame = CGRectMake(10, 365, addressLable.bounds.size.width, 30);
    [self.contentView addSubview:addressLable];
    //地址详情
    UILabel *dspLable = [UILabel new];
    dspLable.text = @"地址详情";
    dspLable.font = TEXT_FONT_LEVEL_1;
    dspLable.textColor = TEXT_COLOR_LEVEL_2;
    [dspLable sizeToFit];
    dspLable.frame = CGRectMake(10, 410, dspLable.bounds.size.width, 30);
    [self.contentView addSubview:dspLable];
    
    UIView *lineView4 = [[UIView alloc] initWithFrame:CGRectMake(20+titleW, 445, kScreenWidth-25-titleW, 0.5)];
    lineView4.backgroundColor = LINE_COLOR;
    [self.contentView addSubview:lineView4];
    
    //封面图片
    UILabel *imageLable = [UILabel new];
    imageLable.text = @"封面图片";
    imageLable.font = TEXT_FONT_LEVEL_1;
    imageLable.textColor = TEXT_COLOR_LEVEL_2;
    [imageLable sizeToFit];
    imageLable.frame = CGRectMake(10, 455, imageLable.bounds.size.width, 30);
    [self.contentView addSubview:imageLable];
    
    UILabel *imagemsgLable = [UILabel new];
    imagemsgLable.text = @"(建议尺寸：750*330)";
    imagemsgLable.font = TEXT_FONT_LEVEL_3;
    imagemsgLable.textColor = TEXT_COLOR_LEVEL_3;
    [imagemsgLable sizeToFit];
    imagemsgLable.frame = CGRectMake(15+imageLable.bounds.size.width, 455, imagemsgLable.bounds.size.width, 30);
    [self.contentView addSubview:imagemsgLable];
    
    
    _titleTF = [[UITextField alloc] initWithFrame:CGRectMake(titleW+20, 5, kScreenWidth- titleW-25, 30)];
    _titleTF.font = TEXT_FONT_LEVEL_2;
    _titleTF.returnKeyType = UIReturnKeyDone;
    _titleTF.placeholder = @"请输入活动标题";
    [self.contentView addSubview:_titleTF];
    
    _phoneTF = [[UITextField alloc] initWithFrame:CGRectMake(titleW+20, 50, kScreenWidth- titleW-25, 30)];
    _phoneTF.font = TEXT_FONT_LEVEL_2;
    _phoneTF.returnKeyType = UIReturnKeyDone;
    _phoneTF.keyboardType = UIKeyboardTypePhonePad;
    _phoneTF.placeholder = @"请输入活动联系人号码";
    [self.contentView addSubview:_phoneTF];
    
    _nameTF = [[UITextField alloc] initWithFrame:CGRectMake(titleW+20, 95, kScreenWidth- titleW-25, 30)];
    _nameTF.font = TEXT_FONT_LEVEL_2;
    _nameTF.returnKeyType = UIReturnKeyDone;
    _nameTF.placeholder = @"请输入活动联系人姓名";
    [self.contentView addSubview:_nameTF];
    
    _freeTF = [[UITextField alloc] initWithFrame:CGRectMake(titleW+20, 140, kScreenWidth- titleW-25, 30)];
    _freeTF.font = TEXT_FONT_LEVEL_2;
    _freeTF.returnKeyType = UIReturnKeyDone;
    _freeTF.placeholder = @"请输入活动费用";
    _freeTF.keyboardType = UIKeyboardTypeNumberPad;
    [self.contentView addSubview:_freeTF];
 
    //会员费用
    _VipFreeTF = [[UITextField alloc] initWithFrame:CGRectMake(titleW+20, 185, kScreenWidth- titleW-25, 30)];
    _VipFreeTF.font = TEXT_FONT_LEVEL_2;
    _VipFreeTF.returnKeyType = UIReturnKeyDone;
    _VipFreeTF.placeholder = @"请输入会员费用";
    _VipFreeTF.keyboardType = UIKeyboardTypeNumberPad;
    [self.contentView addSubview:_VipFreeTF];
    
    //参加人数
    _joincountTF = [[UITextField alloc] initWithFrame:CGRectMake(titleW+20, 230, kScreenWidth- titleW-25, 30)];
    _joincountTF.font = TEXT_FONT_LEVEL_2;
    _joincountTF.returnKeyType = UIReturnKeyDone;
    _joincountTF.placeholder = @"请输入参加人数";
    _joincountTF.keyboardType = UIKeyboardTypeNumberPad;
    [self.contentView addSubview:_joincountTF];
    
    
    
    //开始时间
    _dateButton = [LMTimeButton buttonWithType:UIButtonTypeSystem];
    _dateButton.layer.cornerRadius = 5;
    _dateButton.layer.borderColor = LINE_COLOR.CGColor;
    _dateButton.layer.borderWidth = 0.5;
    _dateButton.textLabel.text =  @"请选择活动开始时间";
    [_dateButton.textLabel sizeToFit];
    _dateButton.textLabel.frame = CGRectMake(5, 0, _dateButton.textLabel.bounds.size.width+30, 30);
    [_dateButton sizeToFit];
    _dateButton.frame = CGRectMake(titleW+20, 275, kScreenWidth-titleW-30, 30);
    [self.contentView addSubview:_dateButton];
    
    
    //结束时间
    _endDateButton = [LMTimeButton buttonWithType:UIButtonTypeSystem];
    _endDateButton.layer.cornerRadius = 5;
    _endDateButton.layer.borderColor = LINE_COLOR.CGColor;
    _endDateButton.layer.borderWidth = 0.5;
    _endDateButton.textLabel.text =  @"请选择活动结束日期";
    [_endDateButton.textLabel sizeToFit];
    _endDateButton.textLabel.frame = CGRectMake(5, 0, _endDateButton.textLabel.bounds.size.width+30, 30);
    [_endDateButton sizeToFit];
    _endDateButton.frame = CGRectMake(titleW+20, 320, kScreenWidth-titleW-30, 30);
    [self.contentView addSubview:_endDateButton];
    
    
    //活动地址
    
    _addressButton = [LMTimeButton buttonWithType:UIButtonTypeSystem];
    _addressButton.layer.cornerRadius = 5;
    _addressButton.layer.borderColor = LINE_COLOR.CGColor;
    _addressButton.layer.borderWidth = 0.5;
    _addressButton.textLabel.text =  @"请选择活动所在省市，县区";
    [_addressButton.textLabel sizeToFit];
    _addressButton.textLabel.frame = CGRectMake(5, 0, kScreenWidth-titleW-30, 30);
    [_addressButton sizeToFit];
    _addressButton.frame = CGRectMake(titleW+20, 365, kScreenWidth-titleW-30, 30);
    [self.contentView addSubview:_addressButton];
    
    
    
    
    _dspTF = [[UITextField alloc] initWithFrame:CGRectMake(titleW+20, 410, kScreenWidth- titleW-25, 30)];
    _dspTF.font = TEXT_FONT_LEVEL_2;
    [_dspTF setUserInteractionEnabled:NO];
    _dspTF.returnKeyType = UIReturnKeyDone;
    _dspTF.placeholder = @"请选择详细地址";
    [self.contentView addSubview:_dspTF];
    
    //地图选点按钮
    _mapButton=[[UIButton alloc]initWithFrame:CGRectMake(titleW+20, 410, kScreenWidth-(titleW+20), 30)];
    [_mapButton setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:_mapButton];
    
    UIView *imgBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 490, kScreenWidth, 165)];
    imgBackView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    [self.contentView addSubview:imgBackView];
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2-28, 50, 56, 65)];
    image.image = [UIImage imageNamed:@"publicEvent"];
    [imgBackView addSubview:image];
    
    
    _imageButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _imageButton.backgroundColor = [UIColor clearColor];
    _imageButton.frame = CGRectMake(0, 490, kScreenWidth, 165);
    [self.contentView addSubview:_imageButton];
    
    _imgView = [[UIImageView alloc] init];
    _imgView.frame = CGRectMake(0, 490, kScreenWidth, 165);
    [self.contentView addSubview:_imgView];
    
    
    for (int i = 0; i<11; i++) {
        UIImageView *keyImage = [[UIImageView alloc] initWithFrame:CGRectMake(imageLable.bounds.size.width+10, 10+45*i, 6, 5)];
        keyImage.image = [UIImage imageNamed:@"key"];
        [self.contentView addSubview:keyImage];
    }

}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
