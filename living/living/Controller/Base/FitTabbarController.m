//
//  FitTabbarController.m
//  FitTrainer
//
//  Created by Huasheng on 15/8/20.
//  Copyright (c) 2015年 Huasheng. All rights reserved.
//

#import "FitTabbarController.h"
#import "FitUserManager.h"
#import "FitNavigationController.h"

#import "LMHomePageController.h"
#import "LMFindViewController.h"
#import "LMActivityViewController.h"
#import "LMPersonViewController.h"
#import "LMLoginViewController.h"

#import "UITabBar+Badge.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation FitTabbarController

- (id)init
{
    self = [super init];
    if (self) {
    
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self createUI];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchAction) name:FIT_LOGOUT_NOTIFICATION object:nil];
 
    if (![[FitUserManager sharedUserManager] isLogin]) {
        
        [LMLoginViewController presentInViewController:self Animated:NO];
    }
}

- (void)switchAction
{
    self.selectedIndex = 0;
    [LMLoginViewController presentInViewController:self Animated:YES];
}

- (void)createUI
{
    [self.tabBar setTintColor:LIVING_COLOR];
    [[UITabBarItem appearance]setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]}
                                            forState:UIControlStateNormal];
   
    
    //设置工具栏中文字的偏移量
    [[UITabBarItem appearance]setTitlePositionAdjustment:UIOffsetMake(0, -3)];
    
    LMHomePageController    *homeVC = [[LMHomePageController alloc] init];
    
    homeVC.title    = @"首页";
    
    FitNavigationController     *homeNav    = [[FitNavigationController alloc] initWithRootViewController:homeVC];
    
    UITabBarItem *itemHome=[[UITabBarItem alloc]initWithTitle:@"首页"
                                                        image:[UIImage imageNamed:@"homepage-gray"]
                                                selectedImage:[UIImage imageNamed:@"homepage"]];
    
    [homeNav setTabBarItem:itemHome];
    
    
    LMActivityViewController    *secondVC = [[LMActivityViewController alloc] init];
    
    secondVC.title    = @"活动";
    
    FitNavigationController     *secondNav    = [[FitNavigationController alloc] initWithRootViewController:secondVC];
    
    UITabBarItem *itemTrip=[[UITabBarItem alloc]initWithTitle:@"活动"
                                                        image:[UIImage imageNamed:@"activity-gray"]
                                                selectedImage:[UIImage imageNamed:@"activity"]];
    [secondNav setTabBarItem:itemTrip];
    
    
    LMFindViewController    *thirdVC = [[LMFindViewController alloc] init];
    
    thirdVC.title    = @"发现";
    
    UITabBarItem *itemHealth=[[UITabBarItem alloc]initWithTitle:@"发现"
                                                          image:[UIImage imageNamed:@"find-gray"]
                                                  selectedImage:[UIImage imageNamed:@"find"]];
    
    FitNavigationController     *thirdNav    = [[FitNavigationController alloc] initWithRootViewController:thirdVC];
    
    [thirdNav setTabBarItem:itemHealth];
    
    LMPersonViewController    *fourthVC = [[LMPersonViewController alloc] init];
    
    fourthVC.title    = @"我";
    
    UITabBarItem * itemMe=[[UITabBarItem alloc]initWithTitle:@"我"
                                                      image:[UIImage imageNamed:@"person-gray"]
                                              selectedImage:[UIImage imageNamed:@"person"]];
    
    FitNavigationController     *fourthNav    = [[FitNavigationController alloc] initWithRootViewController:fourthVC];
    
    [fourthNav setTabBarItem:itemMe];
    
    self.viewControllers    = [NSArray arrayWithObjects:homeNav,secondNav,thirdNav, fourthNav, nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(tongzhi:)
                                                 name:@"getui_message"
                                               object:nil];
    
    if ( [[[NSUserDefaults standardUserDefaults]objectForKey:@"person_dot"] isEqualToString:@"1"]) {
    
        [self.tabBar showBadgeOnItemIndex:3];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(tongzhi2)
                                                 name:@"getui_notic"
                                               object:nil];
       
    
}

-(void)tongzhi2
{
    [self.tabBar hideBadgeOnItemIndex:3];
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"person_dot"];
}



- (void)tongzhi:(NSNotification *)text
{
    
    [self.tabBar showBadgeOnItemIndex:3];
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"person_dot"];
    
    NSString *title=text.userInfo[@"push_title"];
    
    NSString *content=text.userInfo[@"push_dsp"];
    
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    
    if (localNotif == nil)
        return;
    
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    
    localNotif.alertTitle=title;
    
    localNotif.alertBody = content;
    
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    
    AudioServicesPlaySystemSound (1300);
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
