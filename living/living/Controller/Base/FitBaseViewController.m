//
//  FitBaseViewController.m
//  FitTrainer
//
//  Created by Huasheng on 15/8/20.
//  Copyright (c) 2015年 Huasheng. All rights reserved.
//

#import "FitBaseViewController.h"

@implementation FitBaseViewController

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

- (void)textStateHUD:(NSString *)text
{
    if (!text || ![text isKindOfClass:[NSString class]]) {
        return;
    }
    
    if (!stateHud) {
        stateHud = [[MBProgressHUD alloc] initWithView:self.view];
        stateHud.delegate = self;
        [self.view addSubview:stateHud];
    }
    stateHud.mode = MBProgressHUDModeText;
    stateHud.labelColor=[UIColor whiteColor] ;
    stateHud.color=[UIColor blackColor];
    stateHud.labelText = text;
    stateHud.labelFont = [UIFont systemFontOfSize:12.0f];
    [stateHud show:YES];
    [stateHud hide:YES afterDelay:1.2];
}

- (void)initStateHud
{
    if (!stateHud) {
        stateHud = [[MBProgressHUD alloc] initWithView:self.view];
        stateHud.delegate = self;
        [self.view addSubview:stateHud];
    }
    stateHud.mode = MBProgressHUDModeIndeterminate;
    stateHud.labelColor    = [UIColor whiteColor];
    stateHud.color=[UIColor blackColor];
    [stateHud setActivityIndicatorColor:[UIColor whiteColor]];
    [stateHud show:YES];
}

- (void)hideStateHud
{
    [stateHud hide:YES];
}

- (void)resignCurrentFirstResponder
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow endEditing:YES];
}

- (void)popSelf
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - MBProgressHUD Delegate

- (void)hudWasHidden:(MBProgressHUD *)ahud
{
    [stateHud removeFromSuperview];
    stateHud = nil;
}

- (void)logoutAction:(NSString *)resp
{
    NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSDictionary *respDict = [NSJSONSerialization
                              JSONObjectWithData:respData
                              options:NSJSONReadingMutableLeaves
                              error:nil];
    NSDictionary *body = [respDict objectForKey:@"head"];
    if ([body[@"returnCode"] isEqualToString:@"002"]){
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                       message:reLoginTip
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                                  style:UIAlertActionStyleDestructive
                                                handler:^(UIAlertAction*action) {
                                                    
                                                    [[FitUserManager sharedUserManager] logout];
                                                    NSString*appDomain = [[NSBundle mainBundle]bundleIdentifier];
                                                    
                                                    [[NSUserDefaults standardUserDefaults]removePersistentDomainForName:appDomain];
                                                    
                                                    [self.navigationController popViewControllerAnimated:NO];
                                                    
                                                    [[NSNotificationCenter defaultCenter] postNotificationName:FIT_LOGOUT_NOTIFICATION object:nil];
                                                    
                                                    
                                                }]];
        
        [self presentViewController:alert animated:YES completion:nil];
    }

}

-(void)IsLoginIn
{

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                       message:@"请登录"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                                  style:UIAlertActionStyleDestructive
                                                handler:^(UIAlertAction*action) {

                                                    NSString*appDomain = [[NSBundle mainBundle]bundleIdentifier];
                                                    
                                                    [[NSUserDefaults standardUserDefaults]removePersistentDomainForName:appDomain];
                                                    
                                                    [self.navigationController popViewControllerAnimated:NO];
                                                    
                                                    [[NSNotificationCenter defaultCenter] postNotificationName:FIT_LOGOUT_NOTIFICATION object:nil];

                                                    
                                                    
                                                }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                                  style:UIAlertActionStyleCancel
                                                handler:^(UIAlertAction*action) {
                                                    
                                                }]];
        
        [self presentViewController:alert animated:YES completion:nil];

    
    
}
#pragma mark 获取请求
- (void)loadWithRequest:(FitBaseRequest *)request
{
    if (![CheckUtils isLink]) {
        [self textStateHUD:@"无网络连接"];
        return;
    }
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request completed:^(NSString *resp, NSStringEncoding encoding) {
        
        [self performSelectorOnMainThread:@selector(requestResponse:) withObject:resp waitUntilDone:YES];
    } failed:^(NSError *error) {
        [self textStateHUD:@"网络出错"];
    }];
    [proxy start];
}

- (void)requestResponse:(NSString *)resp
{
    NSLog(@"============基类响应===============");
}

@end
