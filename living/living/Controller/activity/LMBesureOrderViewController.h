//
//  LMBesureOrderViewController.h
//  living
//
//  Created by Ding on 2016/10/28.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "FitTableViewController.h"

@interface LMBesureOrderViewController : FitTableViewController

@property (nonatomic,strong)    NSString            *orderUUid;
@property (nonatomic,strong)    NSMutableDictionary *dict;
@property (nonatomic, strong)   NSString  *Type;
@property (nonatomic, copy) NSString * tips;


@end
