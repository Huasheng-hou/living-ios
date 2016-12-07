//
//  FitChatFunctionView.m
//  FitTrainer
//
//  Created by JamHonyZ on 15/12/14.
//  Copyright (c) 2015年 Huasheng. All rights reserved.
//

#import "FitChatFunctionView.h"
#import "FitConsts.h"

#define KJIANJU         floor((kScreenWidth - 60.0 * 4) / 5)
#define KBGVIEW_WID     60
#define KBUTTON_WID     KBGVIEW_WID / 2.0 / 4 * 6

@implementation FitChatFunctionView
{
    UIView      *_photoBgView;
    UIView      *_cameraBgView;
    UIView      *_moneyBgView;
    UIView      *_rewardsBgView;
    UIButton    *_photoBtn;
    UIButton    *_cameraBtn;
    UIButton    *_moneyBtn;
    UIButton    *_rewardsBtn;
    UILabel     *_photoLbl;
    UILabel     *_cameraLbl;
    UILabel     *_moneyLbl;
    UILabel     *_rewardsLbl;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initSubViews];
    }
    return self;
}

- (void)_initSubViews
{
    _photoBgView = [[UIView alloc] initWithFrame:CGRectMake( KJIANJU, 10, KBGVIEW_WID, KBGVIEW_WID)];
    _photoBgView.layer.cornerRadius = 5;
    _photoBgView.layer.masksToBounds = YES;
    _photoBgView.layer.borderColor = LINE_COLOR.CGColor;
    _photoBgView.layer.borderWidth = 0.5;
    
    _photoBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _photoBtn.frame = CGRectMake(KBGVIEW_WID / 2.0 / 4, _photoBgView.frame.size.height / 2 / 4.0 , KBUTTON_WID, KBUTTON_WID);
    [_photoBtn setImage:[UIImage imageNamed:@"icon-xiangce"] forState:UIControlStateNormal];
    [_photoBtn addTarget:self action:@selector(openPhotoLibrary) forControlEvents:UIControlEventTouchUpInside];
    _photoBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    _photoBtn.tintColor             = TEXT_COLOR_LEVEL_3;
    _photoBtn.imageView.clipsToBounds = YES;
    [_photoBgView addSubview:_photoBtn];
    
    _photoLbl = [[UILabel alloc] initWithFrame:CGRectMake(KJIANJU, 10 + KBGVIEW_WID + 2, KBGVIEW_WID, 20)];
    _photoLbl.text = @"照片";
    _photoLbl.textColor = TEXT_COLOR_LEVEL_3;
    _photoLbl.textAlignment = NSTextAlignmentCenter;
    _photoLbl.font = TEXT_FONT_LEVEL_3;
    
    _cameraBgView = [[UIView alloc] initWithFrame:CGRectMake(KBGVIEW_WID + KJIANJU * 2, 10, KBGVIEW_WID, KBGVIEW_WID)];
    _cameraBgView.layer.cornerRadius = 5;
    _cameraBgView.layer.masksToBounds = YES;
    _cameraBgView.layer.borderColor = LINE_COLOR.CGColor;
    _cameraBgView.layer.borderWidth = 0.5;
    
    _cameraBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _cameraBtn.frame = CGRectMake(KBGVIEW_WID / 2 / 4.0, _cameraBgView.frame.size.height / 2 / 4.0, KBUTTON_WID, KBUTTON_WID);
    [_cameraBtn setImage:[UIImage imageNamed:@"icon-zhaoxiang"] forState:UIControlStateNormal];
    [_cameraBtn addTarget:self action:@selector(takePhotos) forControlEvents:UIControlEventTouchUpInside];
    _cameraBtn.imageView.contentMode    = UIViewContentModeScaleAspectFill;
    _cameraBtn.tintColor                = TEXT_COLOR_LEVEL_3;
    _cameraBtn.imageView.clipsToBounds  = YES;
    [_cameraBgView addSubview:_cameraBtn];
    
    
    _cameraLbl = [[UILabel alloc] initWithFrame:CGRectMake(KBGVIEW_WID + KJIANJU * 2, 10 + KBGVIEW_WID + 2, KBGVIEW_WID, 20)];
    _cameraLbl.text = @"照相";
    _cameraLbl.textColor = TEXT_COLOR_LEVEL_3;
    _cameraLbl.textAlignment = NSTextAlignmentCenter;
    _cameraLbl.font = TEXT_FONT_LEVEL_3;
    
    
    _moneyBgView = [[UIView alloc] initWithFrame:CGRectMake(KBGVIEW_WID * 2 + KJIANJU * 3, 10, KBGVIEW_WID, KBGVIEW_WID)];
    _moneyBgView.layer.cornerRadius = 5;
    _moneyBgView.layer.masksToBounds = YES;
    _moneyBgView.layer.borderColor = LINE_COLOR.CGColor;
    _moneyBgView.layer.borderWidth = 0.5;
    
    _moneyBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _moneyBtn.frame = CGRectMake(KBGVIEW_WID / 2 / 4.0, _moneyBgView.frame.size.height / 2 / 4.0, KBUTTON_WID, KBUTTON_WID);
    [_moneyBtn setImage:[UIImage imageNamed:@"icon-hongbao"] forState:UIControlStateNormal];
    [_moneyBtn addTarget:self action:@selector(sendMoney) forControlEvents:UIControlEventTouchUpInside];
    _moneyBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    _moneyBtn.tintColor             = TEXT_COLOR_LEVEL_3;
    _moneyBtn.imageView.clipsToBounds = YES;
    [_moneyBgView addSubview:_moneyBtn];
    
    _moneyLbl = [[UILabel alloc] initWithFrame:CGRectMake(KBGVIEW_WID * 2 + KJIANJU * 3, 10 + KBGVIEW_WID + 2, KBGVIEW_WID, 20)];
    _moneyLbl.text = @"红包";
    _moneyLbl.textColor = TEXT_COLOR_LEVEL_3;
    _moneyLbl.textAlignment = NSTextAlignmentCenter;
    _moneyLbl.font = TEXT_FONT_LEVEL_3;
    
    
    _rewardsBgView = [[UIView alloc] initWithFrame:CGRectMake(KBGVIEW_WID * 3 + KJIANJU * 4, 10, KBGVIEW_WID, KBGVIEW_WID)];
    _rewardsBgView.layer.cornerRadius = 5;
    _rewardsBgView.layer.masksToBounds = YES;
    _rewardsBgView.layer.borderColor = LINE_COLOR.CGColor;
    _rewardsBgView.layer.borderWidth = 0.5;
    
    _rewardsBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _rewardsBtn.frame = CGRectMake(KBGVIEW_WID / 2 / 4.0, _rewardsBgView.frame.size.height / 2 / 4.0, KBUTTON_WID, KBUTTON_WID);
    [_rewardsBtn setImage:[UIImage imageNamed:@"icon-dashang"] forState:UIControlStateNormal];
    [_rewardsBtn addTarget:self action:@selector(sendPersonMoney) forControlEvents:UIControlEventTouchUpInside];
    _rewardsBtn.imageView.contentMode   = UIViewContentModeScaleAspectFill;
    _rewardsBtn.tintColor               = TEXT_COLOR_LEVEL_3;
    _rewardsBtn.imageView.clipsToBounds = YES;
    [_rewardsBgView addSubview:_rewardsBtn];
    
    _rewardsLbl = [[UILabel alloc] initWithFrame:CGRectMake(KBGVIEW_WID * 3 + KJIANJU * 4, 10 + KBGVIEW_WID + 2, KBGVIEW_WID, 20)];
    _rewardsLbl.text = @"打赏";
    _rewardsLbl.textColor = TEXT_COLOR_LEVEL_3;
    _rewardsLbl.textAlignment = NSTextAlignmentCenter;
    _rewardsLbl.font = TEXT_FONT_LEVEL_3;
    
    
    [self addSubview:_photoBgView];
    [self addSubview:_photoLbl];
    [self addSubview:_cameraBgView];
    [self addSubview:_cameraLbl];
    [self addSubview:_moneyBgView];
    [self addSubview:_moneyLbl];
    [self addSubview:_rewardsBgView];
    [self addSubview:_rewardsLbl];
}

//进入相册
- (void)openPhotoLibrary
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(openPhotoLibrary)]) {
        [self.delegate openPhotoLibrary];
    }
}

//照相
- (void)takePhotos
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(takePhoto)]) {
        [self.delegate takePhoto];
    }
}

//发红包
- (void)sendMoney
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendMoney)]) {
        [self.delegate sendMoney];
    }
}

//打赏
- (void)sendPersonMoney
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendPersonMoney)]) {
        [self.delegate sendPersonMoney];
    }
}

- (void)setRedPacketHidden
{
    _moneyBgView.hidden     = YES;
    _rewardsBgView.hidden   = YES;

    _moneyBtn.hidden        = YES;
    _rewardsBtn.hidden      = YES;

    _moneyLbl.hidden        = YES;
    _rewardsLbl.hidden      = YES;
}

@end
