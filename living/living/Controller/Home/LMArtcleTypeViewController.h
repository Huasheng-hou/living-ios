//
//  LMArtcleTypeViewController.h
//  living
//
//  Created by Ding on 2016/12/7.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "FitStatefulTableViewController.h"

@interface LMArtcleTypeViewController : FitStatefulTableViewController

@property(nonatomic,strong)NSString *type;


-(id)initWithType:(NSString *)type;

@end
