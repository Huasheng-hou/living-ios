//
//  SearchViewController.h
//  TFSearchBar
//
//  Created by TF_man on 16/5/18.
//  Copyright © 2016年 TF_man. All rights reserved.
//

#import "FitBaseViewController.h"

@interface SearchViewController : FitBaseViewController


@property (nonatomic,copy)void (^succeed)(NSString *str);

@end
