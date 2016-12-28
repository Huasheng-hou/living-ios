//
//  CustomToolbar.h
//  chatting
//
//  Created by JamHonyZ on 2016/12/12.
//  Copyright © 2016年 Dlx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@class selectItemDelegate;

@protocol selectItemDelegate <NSObject>

-(void)selectItem:(NSInteger)item;

-(void)voiceFinish:(NSURL *)string time:(int)timeLong;

- (void)longPressBegin;

- (void)longPressChanged;

- (void)longPressEnd;

- (void)longPressCancelled;


@end

@interface CustomToolbar : UIToolbar

@property(nonatomic,strong)UIImageView *imageV;

@property(nonatomic,strong)UIButton *saybutton;

@property(nonatomic,strong)UILabel *sayLabel;//按住说话

@property(nonatomic,strong)UITextView *inputTextView;

@property(nonatomic,strong)UIButton *addButton;

@property(nonatomic,strong)UILongPressGestureRecognizer *longPressReger;

@property (nonatomic, strong) AVAudioRecorder *recoder; /**< 录音器 */
@property (nonatomic, strong) AVAudioPlayer *player; /**< 播放器 */

@property(weak, nonatomic)id<selectItemDelegate> delegate;

@end
