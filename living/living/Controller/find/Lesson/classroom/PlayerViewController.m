//
//  PlayerViewController.m
//  Video
//
//  Created by JamHonyZ on 2017/2/15.
//  Copyright © 2017年 Dlx. All rights reserved.
//

#import "PlayerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "FitConsts.h"

#define KPlayerItemStatus @"status"

#define KPlayerItemLoadTime @"loadedTimeRanges"

#define KScreenW  [UIScreen mainScreen].bounds.size.width
#define KScreenH  [UIScreen mainScreen].bounds.size.height

@interface PlayerViewController ()
{
    //播放文件
    AVPlayerItem *videoUrlItem;
    
    NSString *videoUrl;
    
    //播放界面
    AVPlayer *playerView;//时间(CMTime)就是帧数
    //播放按钮
    UIButton *playButton;
    //进度条
    UISlider *sliderView;
    UIProgressView *progressView;
    
    id playbackTimeObserver;
    
    NSDateFormatter *_dateFormatter;
    
    UILabel *totalTimeLabel;
    UIView *maskView;
    NSString *imageUrl;
}
@property(nonatomic,copy)void (^Block)(NSString *current);
@end

@implementation PlayerViewController

- (instancetype)initWithVideoUrl:(NSString *)url
{
    self=[super init];
    if (self) {
        videoUrl=url;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
     [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self createPlayer];
    
     maskView=[[UIView alloc]initWithFrame:self.view.frame];
     [maskView setBackgroundColor:[UIColor clearColor]];
    [maskView setTag:1];
    [self.view addSubview:maskView];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(isHiddenMaskView:)];
    [maskView addGestureRecognizer:tap];
    
    [self createFuctionView];
}

- (void)isHiddenMaskView:(UITapGestureRecognizer *)guesture
{
    if (guesture.view.tag==1) {
         [UIView animateWithDuration:0.1 animations:^{
             [maskView setAlpha:0.1f];
         }];
        [maskView setHidden:YES];
    }else{
        [UIView animateWithDuration:0.1 animations:^{
            [maskView setAlpha:1.0f];
        }];
        [maskView setHidden:NO];
    }
}

- (void)createFuctionView
{
    UIButton *backButtton=[[UIButton alloc]initWithFrame:CGRectMake(0, 10, 60, 40)];
    [backButtton setImage:[UIImage imageNamed:@"back-1"] forState:UIControlStateNormal];
    backButtton.backgroundColor = LIVING_COLOR;
    [backButtton addTarget:self action:@selector(backSuperViewController) forControlEvents:UIControlEventTouchUpInside];
    [maskView addSubview:backButtton];
    
    playButton=[[UIButton alloc]initWithFrame:CGRectMake(KScreenW/2-37, KScreenH/2-37, 74, 74)];
    [playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    [playButton addTarget:self action:@selector(playButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [maskView addSubview:playButton];
    
    //UIProgressView
    //实例化一个进度条，有两种样式，一种是UIProgressViewStyleBar一种是UIProgressViewStyleDefault，几乎无区别
    progressView=[[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
    //设置的高度对进度条的高度没影响，整个高度=进度条的高度，进度条也是个圆角矩形
    //但slider滑动控件：设置的高度对slider也没影响，但整个高度=设置的高度，可以设置背景来检验
    progressView.frame=CGRectMake(50, self.view.frame.size.height-30, self.view.frame.size.width-100, 0);
    //设置进度条颜色
    progressView.trackTintColor=[UIColor grayColor];
    progressView.progressTintColor=[UIColor lightGrayColor];
    [maskView addSubview:progressView];
    
    // UISlider
    sliderView=[[UISlider alloc]initWithFrame:CGRectMake(50, self.view.frame.size.height-55, self.view.frame.size.width-100, 50)];
    [sliderView addTarget:self action:@selector(sliderChangeOfValue:) forControlEvents:UIControlEventValueChanged];
    [sliderView addTarget:self action:@selector(sliderValueTouch:) forControlEvents:UIControlEventTouchUpInside];
    [sliderView setMinimumValue:0.0f];
    [sliderView setContinuous:NO];
    sliderView.minimumTrackTintColor=[UIColor clearColor];
    sliderView.maximumTrackTintColor=[UIColor clearColor];
    UIImage *imagea=[self OriginImage:[UIImage imageNamed:@"sliderIcon"] scaleToSize:CGSizeMake(12, 12)];
    [sliderView  setThumbImage:imagea forState:UIControlStateNormal];
    [maskView addSubview:sliderView];
    
     //显示当前播放时长
    UILabel *currentLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-55, 50, 50)];
    [maskView addSubview:currentLabel];
    [currentLabel setBackgroundColor:[UIColor clearColor]];
    [currentLabel setTextAlignment:NSTextAlignmentCenter];
    [currentLabel setTextColor:[UIColor whiteColor]];
    [currentLabel setFont:[UIFont systemFontOfSize:12]];
    [self setBlock:^(NSString *current) {
        [currentLabel setText:current];
    }];
    
    //总时长
    totalTimeLabel=[[UILabel alloc]initWithFrame:CGRectMake(KScreenW-50, self.view.frame.size.height-55, 50, 50)];
    [totalTimeLabel setBackgroundColor:[UIColor clearColor]];
    [totalTimeLabel setTextAlignment:NSTextAlignmentCenter];
    [totalTimeLabel setFont:[UIFont systemFontOfSize:12]];
    [totalTimeLabel setTextColor:[UIColor whiteColor]];
    [maskView addSubview:totalTimeLabel];
}

- (void)createPlayer
{
    //NSString *path=[[NSBundle mainBundle] pathForResource:@"1" ofType:@"mp4"];
    //NSURL *url = [[NSURL alloc] initFileURLWithPath:path];
    //网络视频
//    NSURL *url = [NSURL URLWithString:@"http://living-2016.oss-cn-hangzhou.aliyuncs.com/81e94a51a77453e1a606fbc3cf21d262.mp4"];
    /*
     在开发中，单纯使用AVPlayer类是无法显示视频的，要将视频层添加至AVPlayerLayer中，这样才能将视频显示出来,AVPlayer只能添加至AVPlayerLayer中
     */
    //管理资源的对象
    videoUrlItem=[AVPlayerItem playerItemWithURL:[NSURL URLWithString:videoUrl]];
    
    [videoUrlItem addObserver:self forKeyPath:KPlayerItemStatus options:NSKeyValueObservingOptionNew context:nil];
    [videoUrlItem addObserver:self forKeyPath:KPlayerItemLoadTime options:NSKeyValueObservingOptionNew context:nil];
    //添加视频播放结束通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:videoUrlItem];
    
    playerView=[AVPlayer playerWithPlayerItem:videoUrlItem];
    
    AVPlayerLayer *layer=[AVPlayerLayer playerLayerWithPlayer:playerView];
    [layer setFillMode:kCAFillModeBoth];
    //    显示AVPlayerLayer边界矩形内视频的方式（播放窗口大小）(AVLayerVideoGravityResizeAspectFill  AVLayerVideoGravityResizeAspect   AVLayerVideoGravityResize)
    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    layer.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    layer.backgroundColor=[[UIColor blackColor]CGColor];
    [self.view.layer addSublayer:layer];
    //播放内容在图层上旋转90度
    //layer.transform=CATransform3DMakeRotation(M_PI/2, 0, 0, 1);
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(isHiddenMaskView:)];
    [self.view addGestureRecognizer:tap];
}

- (void)backSuperViewController
{
    [videoUrlItem removeObserver:self forKeyPath:KPlayerItemStatus];
    [videoUrlItem removeObserver:self forKeyPath:KPlayerItemLoadTime];
    
     [[NSNotificationCenter defaultCenter] removeObserver:self];
    [playerView removeTimeObserver:playbackTimeObserver];
    
    [self dismissViewControllerAnimated:NO completion:^{
       
    }];
}

- (void)playButtonClicked:(UIButton *)sender
{
    sender.selected=!sender.selected;
    
    BOOL isPlay=sender.selected;
    if (isPlay) {
        [playerView play];
        [playButton setImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
    }else{
        [playerView pause];
         [playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    }
}

- (void)sliderChangeOfValue:(UISlider *)sender
{
    UISlider *slider1 = (UISlider *)sender;
    if (slider1.value == 0.000000) {
        [playerView seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
            [playerView play];
        }];
    }
}

//滑动结束后,视频从当前位置开始播放
- (void)sliderValueTouch:(UISlider *)sender
{
    UISlider *slider1 = (UISlider *)sender;
    //调节播放进度(a当前时间（当前帧数）,b每秒钟多少帧)
    CMTime changedTime = CMTimeMakeWithSeconds(slider1.value, 1);
    [playerView seekToTime:changedTime completionHandler:^(BOOL finished) {
        [playerView play];
        [playButton setSelected:YES];
        [playButton setImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:KPlayerItemStatus]) {//执行一次
        if ([playerItem status] == AVPlayerStatusReadyToPlay) {
            //视频时间（总帧数）
            CMTime duration = videoUrlItem.duration;
            //视频播放的总秒数（总帧数/每秒的帧数）
            double totalSecond = (double)videoUrlItem.duration.value / videoUrlItem.duration.timescale;
            
            //总秒数转换成显示需要的格式
             NSString *totalTime = [self convertTime:totalSecond];
            [totalTimeLabel setText:totalTime];
            //slider的最大值
            sliderView.maximumValue = CMTimeGetSeconds(duration);
            // 监听播放状态
            [self monitoringPlayback:videoUrlItem];
            
        } else if ([playerItem status] == AVPlayerStatusFailed) {
            NSLog(@"播放失败！");
        }
        
    } else if ([keyPath isEqualToString:KPlayerItemLoadTime]) {//缓冲区
        
        NSArray *loadedTimeRanges = [[playerView currentItem] loadedTimeRanges];
        CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval timeInterval = startSeconds + durationSeconds;
        [progressView setProgress:timeInterval / CMTimeGetSeconds(videoUrlItem.duration) animated:YES];
    }
}

- (void)monitoringPlayback:(AVPlayerItem *)playerItem
{
    __weak typeof(UISlider)* weakSlider = sliderView;
    __weak typeof(self) weakSelf = self;
    /*
     // a当前第几帧, b每秒钟多少帧.当前播放秒数为a/b
     CMTimeMake(time, timeScale)
     time指的就是時間(不是秒),而時間要換算成秒就要看第二個參數timeScale了。timeScale指的是1秒需要由幾個frame構成(可以視為fps),因此真正要表達的時間就會是 time / timeScale 才會是秒.”
     */
        playbackTimeObserver = [playerView addPeriodicTimeObserverForInterval:CMTimeMake(1, 10000) queue:NULL usingBlock:^(CMTime time) {
        double currentSecond = (double)playerItem.currentTime.value/playerItem.currentTime.timescale;
        __strong typeof(UISlider)* strongSlider = weakSlider;
        if (strongSlider) {
            [strongSlider setValue:currentSecond animated:YES];
        }
        NSString *timeStr = [weakSelf convertTime:currentSecond];
        weakSelf.Block(timeStr);
    }];
}

- (void)moviePlayDidEnd:(NSNotification *)notification
{
    [playerView seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
        [sliderView setValue:0.0 animated:YES];
         [playButton setSelected:NO];
        [playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    }];
    
    [UIView animateWithDuration:0.1 animations:^{
        [maskView setAlpha:1.0f];
    }];
    [maskView setHidden:NO];
}

#pragma mark  时间转换
- (NSString *)convertTime:(CGFloat)second
{
    second=second+0.5;
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:second];
    if (second/3600 >= 1) {
        [[self dateFormatter] setDateFormat:@"HH:mm:ss"];
    } else {
        [[self dateFormatter] setDateFormat:@"mm:ss"];
    }
    NSString *showtimeNew = [[self dateFormatter] stringFromDate:d];
    return showtimeNew;
}
- (NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
    }
    return _dateFormatter;
}

-(UIImage *)OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0,0, size.width, size.height)];
    UIImage *scaleImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaleImage;
}

@end
