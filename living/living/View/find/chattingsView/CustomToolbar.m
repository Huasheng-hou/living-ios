//
//  CustomToolbar.m
//  chatting
//
//  Created by JamHonyZ on 2016/12/12.
//  Copyright © 2016年 Dlx. All rights reserved.
//

#import "CustomToolbar.h"

#import "FitConsts.h"

@interface CustomToolbar()<AVAudioRecorderDelegate>
{
    NSDate *startdate;
    NSDate *enddate;
    CGPoint _tempPoint;
    
}


@end


@implementation CustomToolbar

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor lightGrayColor]];
        
         [self initializeAudioSession];
        [self contentWithView];
    }
    return self;
}

#pragma mark 视图
-(void)contentWithView
{
    //语音
    _imageV=[[UIImageView alloc]initWithFrame:CGRectMake(10, 8.5, 28, 28)];
    [_imageV setImage:[UIImage imageNamed:@"sayImageIcon"]];
    [self addSubview:_imageV];
    
    _saybutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 45, 45)];
//    [_saybutton setBackgroundImage:[UIImage imageNamed:@"sayImage"] forState:UIControlStateNormal];
    [_saybutton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_saybutton setTag:0];
    [_saybutton setSelected:NO];
    [self addSubview:_saybutton];
    
    //输入框
    _inputTextView=[[UITextView alloc]initWithFrame:CGRectMake(45, 5, kScreenWidth-45-45, 35)];
    [_inputTextView setBackgroundColor:[UIColor whiteColor]];
    [_inputTextView.layer setCornerRadius:3.0f];
    [_inputTextView.layer setMasksToBounds:YES];
    [_inputTextView setKeyboardType:UIKeyboardTypeDefault];
    [_inputTextView setReturnKeyType:UIReturnKeyDone];
    [_inputTextView setFont:[UIFont systemFontOfSize:14]];
    [self addSubview:_inputTextView];
    
    //按住说话
    _sayLabel=[[UILabel alloc]initWithFrame:CGRectMake(45, 5, kScreenWidth-45-45, 35)];
    [_sayLabel.layer setCornerRadius:3.0f];
    [_sayLabel.layer setMasksToBounds:YES];
    [_sayLabel setText:@"按住 说话"];
    [_sayLabel setHidden:YES];
    [_sayLabel setUserInteractionEnabled:YES];
    [_sayLabel setTextAlignment:NSTextAlignmentCenter];
    [_sayLabel setFont:[UIFont systemFontOfSize:14]];
    [self addSubview:_sayLabel];
    
    _longPressReger = [[UILongPressGestureRecognizer alloc]
                                                    initWithTarget:self action:@selector(handleLongPress:)];
    _longPressReger.minimumPressDuration = 1.0;
    
    [_sayLabel addGestureRecognizer:_longPressReger];
    
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-28-10, 8.5, 28, 28)];
    [imageView setImage:[UIImage imageNamed:@"addImageCircle"]];
    [self addSubview:imageView];
    //
    _addButton=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-45, 0, 45, 45)];
    [_addButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_addButton setTag:1];
    [self addSubview:_addButton];
}

#pragma mark 长安手势
-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        NSLog(@"=============开始录制=====================");
        [self recorderState:YES];
        [_sayLabel setBackgroundColor:TEXT_COLOR_LEVEL_3];
        [_sayLabel setText:@"松开 结束"];
        [self.delegate longPressBegin];
        
        startdate = [NSDate date];
    }
    
    if(gestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        NSLog(@"=============开始录制=====================");
        [self.delegate longPressChanged];

    }
    
     if(gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        NSLog(@"=============结束录制======================");
        [self recorderState:NO];
        enddate = [NSDate date];
        NSTimeInterval start = [startdate timeIntervalSince1970]*1;
        NSTimeInterval end = [enddate timeIntervalSince1970]*1;
        NSTimeInterval value = end - start;
        
        int time = (int)value;
        [self.delegate voiceFinish:_recoder.url time:time];
        [_sayLabel setBackgroundColor:[UIColor clearColor]];
        [_sayLabel setText:@"按住 说话"];
    }
    if (gestureRecognizer.state ==UIGestureRecognizerStateCancelled) {
        [_recoder stop];
    }
}

#pragma mark 按钮执行动作
-(void)buttonAction:(UIButton *)sender
{
    if (sender.tag==0) {
        sender.selected=!sender.selected;
        if (sender.selected) {
            [_imageV setImage:[UIImage imageNamed:@"sayImage"]];
            [_sayLabel setHidden:NO];
            [_inputTextView setUserInteractionEnabled:NO];
            
        }else{
            [_imageV setImage:[UIImage imageNamed:@"sayImageIcon"]];
            [_sayLabel setHidden:YES];
            [_inputTextView setUserInteractionEnabled:YES];
            
        }
        
    }else{
         [_imageV setImage:[UIImage imageNamed:@"sayImageIcon"]];
        [_saybutton setSelected:NO];
        [_sayLabel setHidden:YES];
        [_inputTextView setUserInteractionEnabled:YES];
    }
      [self.delegate selectItem:sender.tag];
}

#pragma mark 录音部分
#pragma mark *** Initialize methods ***
- (void)initializeAudioSession {
    // 配置音频处理模式
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
    NSError *error = nil;
    
    BOOL success = NO;
    
    success = [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    NSAssert(success, @"set audio session category failed with error message '%@'.", [error localizedDescription]);
    
    // 激活音频处理
    success = [audioSession setActive:YES error:&error];
    NSAssert(success, @"set audio session active failed with error message '%@'.", [error localizedDescription]);
}

#pragma mark *** Events ***
- (void)recorderState:(BOOL)state {
            // 录音
    if (state) {
        
            // 设置音频存储路径
            NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
            NSString *outputPath = [documentPath stringByAppendingString:@"/recodOutput.wav"];
            NSURL *outputUrl = [NSURL fileURLWithPath:outputPath];
            
            // 初始化录音器
            NSError *error = nil;
            // settings:
        NSDictionary *settings=[NSDictionary dictionaryWithObjectsAndKeys:
                                [NSNumber numberWithFloat:8000],AVSampleRateKey,
                                [NSNumber numberWithInt:kAudioFormatLinearPCM],AVFormatIDKey,
                                [NSNumber numberWithInt:1],AVNumberOfChannelsKey,
                                [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
                                [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,
                                [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                                nil];
        self.recoder = [[AVAudioRecorder alloc] initWithURL:outputUrl settings:settings error:&error];
        self.recoder.delegate = self;
            if (error) {
                NSLog(@"initialize recoder error. reason:“%@”", error.localizedDescription);
            }else {
                // 准备录音
                [_recoder prepareToRecord];
                _recoder.meteringEnabled = YES;
                // 录音
                [_recoder record];
            }
    }
//    else// 播放
//    {
//        
//            // 播放录制的音频文件
//            NSError *error = nil;
//            self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.recoder.url error:&error];
//            if (error) {
//                NSLog(@"%@", error.localizedDescription);
//            }else {
//                // 设置循环次数
//                // -1：无限循环
//                //  0：不循环
//                //  1：循环1次...
//                _player.numberOfLoops = 1;
//                _player.volume=1.0;
//                [_player prepareToPlay];
//                [_player play];
//            }
//        }
}

#pragma mark *** Setters ***
- (void)setRecoder:(AVAudioRecorder *)recoder {
    if (_recoder != recoder) {
        // 删除录制的音频文件
        [_recoder deleteRecording];
        
        _recoder = nil;
        
        NSLog(@"==================setRecoder======================");
        
        _recoder = recoder;
    }
}

- (void)setPlayer:(AVAudioPlayer *)player {
    if (_player != player) {
        [_player stop];
         NSLog(@"==================setPlayer======================");
        _player = nil;
        
        _player = player;
    }
}

@end
