//
//  UIViewController+Authority.m
//  living
//
//  Created by hxm on 2017/7/17.
//  Copyright © 2017年 chenle. All rights reserved.
//



#import "UIViewController+Authority.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreLocation/CoreLocation.h>
#import <AddressBook/AddressBook.h>

@implementation UIViewController (Authority)

- (BOOL)hasCameraAuthority {
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        return NO;
    }
    return YES;
}

- (BOOL)hasPhotosAuthority {
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied) {
        return NO;
    }
    return YES;
}

- (BOOL)hasLocationAuthority {
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    NSLog(@"%d", status);
    if ([CLLocationManager locationServicesEnabled] &&
        (status == kCLAuthorizationStatusAuthorizedAlways ||
         status == kCLAuthorizationStatusNotDetermined ||
         status == kCLAuthorizationStatusAuthorizedWhenInUse)) {
        return YES;
    }
    return NO;
}

- (BOOL)hasMicrophoneAuthority {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        return NO;
    }
    return YES;
}

- (BOOL)hasPhoneAuthority {
    
    return YES;
}

- (void)showAuthorityView {
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 80, kScreenWidth,80)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
}






@end
