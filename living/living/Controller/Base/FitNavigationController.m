//
//  FitNavigationController.m
//  FitTrainer
//
//  Created by Huasheng on 15/8/21.
//  Copyright (c) 2015年 Huasheng. All rights reserved.
//

#import "FitNavigationController.h"
#import "FitConsts.h"

@implementation FitNavigationController

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        self.navigationBar.tintColor                    = [UIColor whiteColor];
        self.navigationBar.barTintColor                 = [UIColor colorWithRed:0/255.0 green:130/255.0 blue:230.0/255.0 alpha:1.0];
        self.navigationBar.titleTextAttributes          = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],
                                                           NSForegroundColorAttributeName, nil];
    }
    return self;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
