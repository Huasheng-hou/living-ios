
//
//  FitProtocols.h
//  FitTrainer
//
//  Created by Huasheng on 15/8/20.
//  Copyright (c) 2015年 Huasheng. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol FitStateHudDelegate <NSObject>

- (void)textStateHUD:(NSString *)text;
- (void)initStateHud;
- (void)hideStateHud;

@end

// * 手动封装的拨轮选择组件代理
//
@protocol FitPickerViewDelegate <NSObject>
@optional

- (void)didSelectedItems:(NSArray *)items Row:(NSInteger)row;
- (void)didSelectedItems:(NSArray *)items andDistrict:(NSString *)district;

@end

// * 手动封装的时间选择器代理
//
@protocol FitDatePickerDelegate <NSObject>
@optional

- (void)didSelectedDate:(NSDate *)date;

- (void)pickerViewDidDisAppear;

@end

// * 加号动效五个按钮的代理
// FitPlusAnimationDelegate  <NSObject>
@protocol FitPlusAnimationDelegate <NSObject>
@optional

// * 调休
- (void)didSelectedTakeBreakBtn;

// * 饮水打卡
- (void)didSelectedWaterReportBtn;

// * 饮食打卡
- (void)didSelectedDietReportBtn;

// * 运动打卡
- (void)didSelectedSportReportBtn;

// * 体重打卡
- (void)didSelectedWeightReportBtn;

@end

// * 点击用户头像
//

@protocol FitTouchUserAvatarDelegate <NSObject>
@optional

- (void)useravatarTouchedWithUUID:(NSString *)uuid;
- (void)thumAvatarTouches:(NSString *)uuid
                 Username:(NSString *)username;

@end

// * 点击查看大图
//

@protocol FitThumbImageTappedDelegate <NSObject>
@optional

- (void)thumImageTouched:(UIImageView *)imageView
             WithURLList:(NSArray *)urlList
              ImageViews:(NSArray *)imageViews
            CurrentIndex:(NSInteger)currentIndex;

@end

// * 私聊教练
//

@protocol FitChatToCoachDelegate <NSObject>
@optional

- (void)chatToCoachWithCoachUUID:(NSString *)coachUUID;

@end

// * 私信气泡单元的代理
//
@class MessageVO;

@protocol FitMessageCellDelegate <NSObject, FitThumbImageTappedDelegate, FitTouchUserAvatarDelegate>
@optional

- (void)resentMessage:(MessageVO *)message Cell:(UITableViewCell *)cell;
- (void)forwardMessage:(MessageVO *)message;
- (void)messageTouched:(MessageVO *)message;
- (void)thumImageTouched:(UIImageView *)imageView
                    cell:(UITableViewCell *)cell;
- (void)thumAvatarLongPressed:(UITableViewCell *)cell;
- (void)thumImageTouched:(UIImageView *)imageView imgUrl:(NSString *)imgurl;

@end
