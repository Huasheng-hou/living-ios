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
        self.navigationBar.tintColor                    = [UIColor blackColor];
        self.navigationBar.barTintColor                 = [UIColor whiteColor];
        self.navigationBar.titleTextAttributes          = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],
                                                           NSForegroundColorAttributeName, nil];
    }
    return self;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
    //return UIStatusBarStyleDefault;
}
@end
