//
//  MainViewController.h
//  chatting
//
//  Created by JamHonyZ on 2016/12/12.
//  Copyright © 2016年 Dlx. All rights reserved.
//

#import "FitStatefulTableViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import <MediaPlayer/MediaPlayer.h>
#import "LMWobsocket.h"
#import "UIImageView+WebCache.h"
#import "ZYQAssetPickerController.h"
#import "WebsocketStompKit.h"
#import "LGAudioKit.h"
#import "Masonry.h"


typedef enum {
    kFitMessageTableStateOnLoading    =   1,
    kFitMessageTableStateIdle         =   2,
} FitMessageTableState;

@interface LMChatViewController : FitTableViewController <STOMPClientDelegate>

@property (nonatomic,strong)    NSString        *voiceUuid;
@property (nonatomic,strong)    NSString        *sign;
@property (nonatomic,strong)    NSString        *roles;
@property (nonatomic,retain)    NSMutableArray  *listData;

@property (assign, nonatomic)   NSInteger               total;
@property (nonatomic)           int                     max;
@property (nonatomic)           int                     timeNum;
@property (nonatomic)           int                     durationTime;

@property (assign, nonatomic)   FitMessageTableState    state;

@property (nonatomic, weak) NSTimer *timerOf60Second;




@end
