//
//  LMScanViewController.m
//  living
//
//  Created by Ding on 2016/10/21.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMScanViewController.h"
#import "QRCodeReaderView.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "LMWebViewController.h"
#import "LMScanRequest.h"
#import "LMMyFriendViewController.h"
#import "LMFriendDataRequest.h"

#import "LMToolTipView.h"


#define DeviceMaxHeight ([UIScreen mainScreen].bounds.size.height)
#define DeviceMaxWidth ([UIScreen mainScreen].bounds.size.width)
#define widthRate DeviceMaxWidth/320
#define IOS8 ([[UIDevice currentDevice].systemVersion intValue] >= 8 ? YES : NO)


@interface LMScanViewController ()
<QRCodeReaderViewDelegate,AVCaptureMetadataOutputObjectsDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,buttonTypeDelegate>
{
    QRCodeReaderView * readview;//二维码扫描对象
    
    BOOL isFirst;//第一次进入该页面
    BOOL isPush;//跳转到下一级页面
    
    NSString *scanResult;
}

@property (strong, nonatomic) CIDetector *detector;
@end

@implementation LMScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"扫描";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem * rbbItem = [[UIBarButtonItem alloc]initWithTitle:@"相册" style:UIBarButtonItemStyleDone target:self action:@selector(alumbBtnEvent)];
    self.navigationItem.rightBarButtonItem = rbbItem;
    
    UIBarButtonItem * lbbItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(backButtonEvent)];
    self.navigationItem.leftBarButtonItem = lbbItem;
    
    isFirst = YES;
    isPush = NO;
    
    [self InitScan];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 返回
- (void)backButtonEvent
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 初始化扫描
- (void)InitScan
{
    if (readview) {
        [readview removeFromSuperview];
        readview = nil;
    }
    
    readview = [[QRCodeReaderView alloc]initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, DeviceMaxHeight)];
    readview.is_AnmotionFinished = YES;
    readview.backgroundColor = [UIColor clearColor];
    readview.delegate = self;
    readview.alpha = 0;
    
    [self.view addSubview:readview];
    
    [UIView animateWithDuration:0.5 animations:^{
        readview.alpha = 1;
    }completion:^(BOOL finished) {
        
    }];
    
}

#pragma mark - 相册
- (void)alumbBtnEvent
{
    
    self.detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) { //判断设备是否支持相册
        
        if (IOS8) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"未开启访问相册权限，现在去开启！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 4;
            [alert show];
        }
        else{
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"设备不支持访问相册，请在设置->隐私->照片中进行设置！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
        return;
    }
    
    isPush = YES;
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    mediaUI.mediaTypes = [UIImagePickerController         availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    mediaUI.allowsEditing = NO;
    mediaUI.delegate = self;
    [self presentViewController:mediaUI animated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    }];
    
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (!image){
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    readview.is_Anmotion = YES;
    
    NSArray *features = [self.detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    if (features.count >=1) {    
        
        [picker dismissViewControllerAnimated:YES completion:^{
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
            
            CIQRCodeFeature *feature = [features objectAtIndex:0];
            NSString *scannedResult = feature.messageString;
            //播放扫描二维码的声音
//            SystemSoundID soundID;
//            NSString *strSoundFile = [[NSBundle mainBundle] pathForResource:@"noticeMusic" ofType:@"wav"];
//            AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:strSoundFile],&soundID);
//            AudioServicesPlaySystemSound(soundID);
            
            [self accordingQcode:scannedResult];
        }];
        
    }
    else{
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该图片没有包含一个二维码！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        
        [picker dismissViewControllerAnimated:YES completion:^{
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
            
            readview.is_Anmotion = NO;
            [readview start];
        }];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    }];
    
}

#pragma mark -QRCodeReaderViewDelegate
- (void)readerScanResult:(NSString *)result
{
    readview.is_Anmotion = YES;
    [readview stop];
    
//    //播放扫描二维码的声音
//    SystemSoundID soundID;
//    NSString *strSoundFile = [[NSBundle mainBundle] pathForResource:@"noticeMusic" ofType:@"wav"];
//    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:strSoundFile],&soundID);
//    AudioServicesPlaySystemSound(soundID);
//    
    [self accordingQcode:result];
    
    [self performSelector:@selector(reStartScan) withObject:nil afterDelay:1.5];
}

#pragma mark - 扫描结果处理
- (void)accordingQcode:(NSString *)str
{
    
    NSLog(@"%@",str);
    
    if (str.length >9) {
        scanResult = [str substringFromIndex:9];
    }else{
        scanResult=@"123456789";
    }
    
    LMFriendDataRequest *request = [[LMFriendDataRequest alloc] initWithscanningResult:scanResult];
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(getjoinNumResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"获取好友信息失败"
                                                                   waitUntilDone:YES];
                                           }];
    [proxy start];
 
    
}





-(void)getjoinNumResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    
    [self logoutAction:resp];
    
    if (!bodyDic) {
        [self textStateHUD:@"获取好友信息失败"];
    }else{
        if ([[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
            NSLog(@"=======扫码之后展示加盟商信息==bodyDic======%@",bodyDic);
            
            NSDictionary *dic=bodyDic[@"map"];
            
            NSString *avatar;
            
            if (dic[@"avatar"]) {
                avatar=dic[@"avatar"];
            }else{
                avatar=@"http://";
            }
            
             NSString *nickname;
            if (dic[@"nickname"]) {
                nickname=dic[@"nickname"];
            }else{
                nickname=@" ";
            }
            
             [readview stop];
            LMToolTipView *tipView=[[LMToolTipView alloc]initWithHeadImage:avatar andNickName:nickname];
            [tipView setDelegate:self];
            [self.view addSubview:tipView];
            
        }else{
            [self textStateHUD:[bodyDic objectForKey:@"description"]];
        }
    }
}

#pragma mark LMToolTipView代理方法

-(void)buttonType:(NSInteger)type
{
    if (type==1) {//确定
    
        [self getMakeFriend];
    }else{
        [readview start];
    }
}


#pragma mark 扫码加好友

-(void)getMakeFriend
{
    LMScanRequest *request = [[LMScanRequest alloc] initWithscanningResult:scanResult];
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(getscanningResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"添加好友失败"
                                                                   waitUntilDone:YES];
                                                [readview start];
                                           }];
    [proxy start];
}




-(void)getscanningResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    
    [self logoutAction:resp];
    
    if (!bodyDic) {
        [self textStateHUD:@"添加好友失败!"];
         [readview start];
    }else{
        
        if ([[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
            [self textStateHUD:@"添加好友成功!"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                LMMyFriendViewController *friendVC = [[LMMyFriendViewController alloc] init];
                
                [self.navigationController pushViewController:friendVC animated:YES];
                
            });
            
        }else{
             [readview start];
            [self textStateHUD:[bodyDic objectForKey:@"description"]];
        }
        
    }
    
}


- (void)reStartScan
{
    readview.is_Anmotion = NO;
    
    if (readview.is_AnmotionFinished) {
        [readview loopDrawLine];
    }
    
    [readview start];
}

#pragma mark - view
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reStartScan];
    if (isFirst || isPush) {
        if (readview) {
            [self reStartScan];
        }
    }
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (readview) {
        [readview stop];
        readview.is_Anmotion = YES;
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (isFirst) {
        isFirst = NO;
    }
    if (isPush) {
        isPush = NO;
    }
}


@end
