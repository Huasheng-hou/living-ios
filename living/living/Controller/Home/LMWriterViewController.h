//
//  LMWriterViewController.h
//  living
//
//  Created by Ding on 2016/11/1.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "FitStatefulTableViewController.h"

@interface LMWriterViewController :FitStatefulTableViewController

@property(nonatomic,strong)NSString *writerUUid;


-(id)initWithUUid:(NSString *)writerUUid;

@end
