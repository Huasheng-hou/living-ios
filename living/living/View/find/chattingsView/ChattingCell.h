//
//  ChattingCell.h
//  living
//
//  Created by JamHonyZ on 2016/12/13.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MssageVO.h"

typedef NS_ENUM(NSUInteger, LGVoicePlayState){
    LGVoicePlayStateNormal,/**< 未播放状态 */
    LGVoicePlayStateDownloading,/**< 正在下载中 */
    LGVoicePlayStatePlaying,/**< 正在播放 */
    LGVoicePlayStateCancel,/**< 播放被取消 */
};


@protocol  ChattingCellDelegate;

@interface ChattingCell : UITableViewCell

@property(nonatomic,strong)UIImageView *headImageView;

@property(nonatomic,strong)UILabel *chatNameLabel;

@property(nonatomic,strong)UILabel *timeLabel;

@property(nonatomic,strong)UIButton *soundbutton;

@property(nonatomic,strong)UILabel *duration;

@property(nonatomic,strong)UILabel *contentLabel;

@property(nonatomic,strong)UIImageView *bootomView;

@property (nonatomic, assign) LGVoicePlayState voicePlayState;

@property (nonatomic, weak) id <ChattingCellDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

-(void)setCellValue:(MssageVO *)content;
@end

@protocol ChattingCellDelegate <NSObject>

@optional
- (void)cellClickImage:(ChattingCell *)cell;
- (void)cellClickVoice:(ChattingCell *)cell;


@end
