//
//  FitTableViewController.m
//  FitTrainer
//
//  Created by Huasheng on 15/8/20.
//  Copyright (c) 2015年 Huasheng. All rights reserved.
//

#import "FitTableViewController.h"

@implementation FitTableViewController

- (id)init
{
    self = [super init];
    if (self) {
        
        _style  = UITableViewStylePlain;
        self.hidesBottomBarWhenPushed   = YES;
    }
    
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super init];
    if (self) {
        
        _style  = style;
        self.hidesBottomBarWhenPushed   = YES;
    }
    
    return self;
}

- (void)refreshData
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.tableView reloadData];
    });
}

- (void)createUI
{
    self.view.backgroundColor       = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets   = NO;
    
    self.tableView  = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:_style];
    self.tableView.backgroundColor  = BG_GRAY_COLOR;
    self.tableView.tableFooterView  = [[UIView alloc] init];
    self.tableView.contentInset     = UIEdgeInsetsMake(64, 0, 0, 0);
    self.tableView.separatorInset   = UIEdgeInsetsMake(64, 0, 0, 0);
    
    self.tableView.delegate     = self;
    self.tableView.dataSource   = self;
    
    self.tableView.keyboardDismissMode          = UIScrollViewKeyboardDismissModeOnDrag;
    
    [self.view addSubview:self.tableView];
}

- (void)textStateHUD:(NSString *)text
{
    if (!stateHud) {
        stateHud = [[MBProgressHUD alloc] initWithView:self.view];
        stateHud.delegate = self;
        [self.view addSubview:stateHud];
    }
    stateHud.mode = MBProgressHUDModeText;
    stateHud.label.textColor=[UIColor whiteColor] ;
    stateHud.color=[UIColor blackColor];
    stateHud.label.text = text;
    stateHud.label.font = [UIFont systemFontOfSize:12.0f];
    [stateHud showAnimated:YES];
    [stateHud hideAnimated:YES afterDelay:0.8];
}

- (void)initStateHud
{
    if (!stateHud) {
        stateHud = [[MBProgressHUD alloc] initWithView:self.view];
        stateHud.delegate = self;
        [self.view addSubview:stateHud];
    }
    stateHud.mode = MBProgressHUDModeIndeterminate;
    stateHud.label.textColor=[UIColor whiteColor] ;
    stateHud.color=[UIColor blackColor];
    [stateHud showAnimated:YES];
}

- (void)hideStateHud
{
    [stateHud hideAnimated:YES];
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

- (void)scrollEditingRectToVisible:(CGRect)rect EditingView:(UIView *)view
{
    CGFloat     keyboardHeight  = 280;
    
    if (view && view.superview) {
        rect    = [self.tableView convertRect:rect fromView:view.superview];
    }
    
    if (rect.origin.y < kScreenHeight - keyboardHeight - rect.size.height - 64) {
        return;
    }
    
    [self.tableView setContentOffset:CGPointMake(0, rect.origin.y - (kScreenHeight - keyboardHeight - rect.size.height)) animated:YES];
}

#pragma mark - UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL_IDENTIFI"];
}

-(void)logoutAction:(NSString *)resp
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




@end
