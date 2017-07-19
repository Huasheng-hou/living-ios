//
//  UIViewController+Authority.h
//  living
//
//  Created by hxm on 2017/7/17.
//  Copyright © 2017年 chenle. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface UIViewController (Authority)

/**
 检查相机权限

 @return 是否获取相机权限
 */
- (BOOL)hasCameraAuthority;

/**
 检查相册权限

 @return 是否获取相册权限
 */
- (BOOL)hasPhotosAuthority;

/**
 检查定位权限

 @return 是否获取定位权限
 */
- (BOOL)hasLocationAuthority;

/**
 检查麦克风权限

 @return 是否获取麦克风权限
 */
- (BOOL)hasMicrophoneAuthority;

/**
 检查打电话权限

 @return 是否获取打电话权限
 */
- (BOOL)hasPhoneAuthority;

- (void)showAuthorityView;


@end
