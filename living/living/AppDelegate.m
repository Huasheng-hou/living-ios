//
//  AppDelegate.m
//  living
//
//  Created by Ding on 16/9/26.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "AppDelegate.h"
#import "FitTabbarController.h"
#import "FitTabbarController.h"
#import "FitNavigationController.h"
#import "FitUserManager.h"
#import "FitPayloadManager.h"
#import "FitClientIDManager.h"

//支付宝
#import <AlipaySDK/AlipaySDK.h>
//微信支付
#import "WXApi.h"

//qqSDK
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

#import <AMapFoundationKit/AMapFoundationKit.h>

#import <UserNotifications/UserNotifications.h>

#define TENCENT_CONNECT_APP_KEY @"1105720353"


@interface AppDelegate ()
<
TencentLoginDelegate,
TencentSessionDelegate,
QQApiInterfaceDelegate,
TencentLoginDelegate,
TencentSessionDelegate,
WXApiDelegate,
UNUserNotificationCenterDelegate
>

@end

@implementation AppDelegate
{
    NSURL               *_dataPath;
    NSString            *_fileName;
    
    TencentOAuth *_tencentOAuth;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // * 启动个推
    //
//    [self GexinProcess:launchOptions];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    FitTabbarController  *rootVC     = [[FitTabbarController alloc] init];
    
    [self.window setRootViewController:rootVC];
    [self.window makeKeyAndVisible];
    
    //向微信注册
    [WXApi registerApp:wxAppID];
    
//    1104875913
   _tencentOAuth=  [[TencentOAuth alloc]initWithAppId:@"1105720353" andDelegate:self];; //注册

    //高德地图
     [AMapServices sharedServices].apiKey = @"51d5d65d0c32d550adda51ed2d90e338";

    // 使用 UNUserNotificationCenter 来管理通知
//    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
//    //监听回调事件
//    center.delegate = self;
//    
//    //iOS 10 使用以下方法注册，才能得到授权
//    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound)
//                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
//                              // Enable or disable features based on authorization.
//                          }];
//    
//    //获取当前的通知设置，UNNotificationSettings 是只读对象，不能直接修改，只能通过以下方法获取
//    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
//        
//    }];

    
    return YES;
}

#pragma mark - APNS Process

//注册苹果通知
- (void)registerRemoteNotification
{
#ifdef __IPHONE_8_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        
        UIUserNotificationSettings *uns = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound) categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:uns];
    } else {
        UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeBadge);
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
    }
#else
    UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeBadge);
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
#endif
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    _deviceToken = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSLog(@"--------_deviceToken:%@",_deviceToken);
    
    NSUserDefaults  *standDefaults  = [NSUserDefaults standardUserDefaults];
    
    [standDefaults setObject:_deviceToken forKey:@"deviceToken"];
    
    [standDefaults synchronize];
    
//    [GeTuiSdk registerDeviceToken:_deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
//    [GeTuiSdk registerDeviceToken:@""];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userinfo
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    NSString *payloadMsg = [userInfo objectForKey:@"payload"];
    
    if (payloadMsg && [payloadMsg isKindOfClass:[NSString class]]) {
        
        [FitPayloadManager processPayload:payloadMsg];
    }
    
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark - Getui Process

//- (void)GexinProcess:(NSDictionary *)launchOptions
//{
//    // [1]:使用APPID/APPKEY/APPSECRENT创建个推实例
//    [GeTuiSdk startSdkWithAppId:gtAppID appKey:gtAppKey appSecret:gtAppSecret delegate:self error:nil];
//    
//    // [2]:注册APNS
//    [self registerRemoteNotification];
//    
//    // [2-EXT]: 获取启动时收到的APN
//    NSDictionary* message = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
//    if (message) {
//        //        NSString *payloadMsg = [message objectForKey:@"payload"];
//        //        NSString *record = [NSString stringWithFormat:@"[APN]%@, %@", [NSDate date], payloadMsg];
//        //        if (payloadMsg && [payloadMsg isKindOfClass:[NSString class]]) {
//        //            [[hcb_PayloadManager sharedPayloadManager] processPayload:payloadMsg];
//        //        }
//    }
//    
//    [[UIApplication sharedApplication] cancelAllLocalNotifications];
//    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
//}
//
//#pragma mark - GexinSdkDelegate
//
////SDK启动成功返回cid
//- (void) GeTuiSdkDidRegisterClient:(NSString *)clientId
//{
//    [[FitClientIDManager sharedClientIDManager] saveClientID:clientId];
//    NSLog(@"--------clientId:%@",clientId);
//}
//
////SDK收到透传消息回调
//- (void) GeTuiSdkDidReceivePayload:(NSString *)payloadId
//                         andTaskId:(NSString*) taskId
//                      andMessageId:(NSString*)aMsgId
//                   fromApplication:(NSString *)appId
//{
//    // [4]: 收到个推消息
//    NSData *payload = [GeTuiSdk retrivePayloadById:payloadId];
//    NSString *payloadMsg = nil;
//    if (payload) {
//        
//        
//        
//        payloadMsg = [[NSString alloc] initWithBytes:payload.bytes
//                                              length:payload.length
//                                            encoding:NSUTF8StringEncoding];
//    }
//    
//    if (payloadMsg && [payloadMsg isKindOfClass:[NSString class]]) {
//        
//        NSLog(@"---------payloadMsg------------%@",payloadMsg);
//        
//        [FitPayloadManager processTransPayload:payloadMsg];
//    }
//}


#pragma mark - UNUserNotificationCenterDelegate
//在展示通知前进行处理，即有机会在展示通知前再修改通知内容。
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    //1. 处理通知
    
    //2. 处理完成后条用 completionHandler ，用于指示在前台显示通知的形式
    completionHandler(UNNotificationPresentationOptionAlert);
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
//    [GeTuiSdk enterBackground];
}

//登录完成后，会调用TencentSessionDelegate中关于登录的协议方法。
- (void)tencentDidLogin
{
    NSLog(@"登录完成");
    if (_tencentOAuth.accessToken && 0 != [_tencentOAuth.accessToken length]){
        // 记录登录用户的OpenID、Token以及过期时间
        NSLog(@"tencent-accessToken:%@",_tencentOAuth.accessToken);
    } else {
        
        NSLog(@"登录不成功 没有获取tencent-accesstoken");
    }
}

//非网络错误导致登录失败
- (void)tencentDidNotLogin:(BOOL)cancelled
{
    if (cancelled) {

    } else {
        
    }
}

//腾讯代理函数
- (void)tencentDidNotNetWork
{

}

//禁止横屏
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    if ([url.absoluteString hasPrefix:[NSString stringWithFormat:@"tencent%@",TENCENT_CONNECT_APP_KEY]]) {
        [QQApiInterface handleOpenURL:url delegate:self];
        
        return [TencentOAuth HandleOpenURL:url];
    } else {
        
        return  [WXApi handleOpenURL:url delegate:self];
    }
    
    return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    
    if ([url.absoluteString hasPrefix:[NSString stringWithFormat:@"tencent%@",TENCENT_CONNECT_APP_KEY]]) {
        
        [QQApiInterface handleOpenURL:url delegate:self];
        return [TencentOAuth HandleOpenURL:url];
        
    }
    
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        NSLog(@"===AppDelegate 支付宝支付9.0以后处理支付结果====result = %@",resultDic);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"aliPayEnsure" object:resultDic];
    }];
    
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([url.absoluteString hasPrefix:[NSString stringWithFormat:@"tencent%@",TENCENT_CONNECT_APP_KEY]]) {
 
        [QQApiInterface handleOpenURL:url delegate:self];
        return [TencentOAuth HandleOpenURL:url];
    }
    
    // 支付跳转支付宝钱包进行支付，处理支付结果
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        NSLog(@"AppDelegate 支付宝支付，处理支付结果result = %@",resultDic);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"aliPayEnsure" object:resultDic];
    }];
    
    return [WXApi handleOpenURL:url delegate:self];
}

/**
 微信SDK回调
 */
- (void)onReq:(BaseReq *)req
{
    
}

- (void)onResp:(BaseResp *)resp
{
    //    WXSuccess           = 0,    /**< 成功    */
    //    WXErrCodeCommon     = -1,   /**< 普通错误类型    */
    //    WXErrCodeUserCancel = -2,   /**< 用户点击取消并返回    */
    //    WXErrCodeSentFail   = -3,   /**< 发送失败    */
    //    WXErrCodeAuthDeny   = -4,   /**< 授权失败    */
    //    WXErrCodeUnsupport  = -5,   /**< 微信不支持    */
    
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        
        SendAuthResp    *authResp   = (SendAuthResp *)resp;
        
        if (authResp.state && [authResp.state isKindOfClass:[NSString class]] && [authResp.state isEqualToString:@"wx"]) {
            
            switch (authResp.errCode) {
                
                case WXSuccess:                 /**< 成功    */
                {
                    if (authResp.code && [authResp.code isKindOfClass:[NSString class]]) {
                        
                        NSDictionary    *userInfo   = [NSDictionary dictionaryWithObject:authResp.code forKey:@"code"];
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:LM_WECHAT_LOGIN_CALLBACK_NOTIFICATION
                                                                            object:nil
                                                                          userInfo:userInfo];
                    }
                }
                    break;
                 
                case WXErrCodeCommon:           /**< 普通错误类型    */
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:LM_WECHAT_LOGIN_FAILED_NOTIFICATION
                                                                        object:nil
                                                                      userInfo:nil];
                }
                    break;
                    
                case WXErrCodeUserCancel:       /**< 用户点击取消并返回    */
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:LM_WECHAT_LOGIN_CANCEL_NOTIFICATION
                                                                        object:nil
                                                                      userInfo:nil];
                }
                    break;
                    
                case WXErrCodeSentFail:         /**< 发送失败    */
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:LM_WECHAT_LOGIN_FAILED_NOTIFICATION
                                                                        object:nil
                                                                      userInfo:nil];
                }
                    break;
                    
                case WXErrCodeAuthDeny:         /**< 授权失败    */
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:LM_WECHAT_LOGIN_FAILED_NOTIFICATION
                                                                        object:nil
                                                                      userInfo:nil];
                }
                    break;
                    
                case WXErrCodeUnsupport:        /**< 微信不支持    */
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:LM_WECHAT_LOGIN_FAILED_NOTIFICATION
                                                                        object:nil
                                                                      userInfo:nil];
                }
                    break;
                    
                default:
                    break;
            }
        }
        
    } else if ([resp isKindOfClass:[PayResp class]]) {
        
        switch (resp.errCode) {
                
            case WXSuccess:                 /**< 成功    */
            {
                NSDictionary    *userInfo   = [NSDictionary dictionaryWithObject:resp forKey:@"payResp"];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:LM_WECHAT_PAY_CALLBACK_NOTIFICATION
                                                                    object:nil
                                                                  userInfo:userInfo];
            }
                break;
                
            case WXErrCodeCommon:           /**< 普通错误类型    */
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:LM_WECHAT_PAY_FAILED_NOTIFICATION
                                                                    object:nil
                                                                  userInfo:nil];
            }
                break;
                
            case WXErrCodeUserCancel:       /**< 用户点击取消并返回    */
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:LM_WECHAT_PAY_CANCEL_NOTIFICATION
                                                                    object:nil
                                                                  userInfo:nil];
            }
                break;
                
            case WXErrCodeSentFail:         /**< 发送失败    */
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:LM_WECHAT_PAY_FAILED_NOTIFICATION
                                                                    object:nil
                                                                  userInfo:nil];
            }
                break;
                
            case WXErrCodeAuthDeny:         /**< 授权失败    */
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:LM_WECHAT_PAY_FAILED_NOTIFICATION
                                                                    object:nil
                                                                  userInfo:nil];
            }
                break;
                
            case WXErrCodeUnsupport:        /**< 微信不支持    */
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:LM_WECHAT_PAY_FAILED_NOTIFICATION
                                                                    object:nil
                                                                  userInfo:nil];
            }
                break;
                
            default:
                break;
        }
    }
}

/**
 处理QQ在线状态的回调
 */
- (void)isOnlineResponse:(NSDictionary *)response
{
    
}

//当程序正在运行时 收到提醒事件时触发
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[notification.userInfo objectForKey:@"id"] message:notification.alertBody delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:notification.alertAction, nil];
    [alert show];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{

}

- (void)applicationWillTerminate:(UIApplication *)application
{

}

@end
