//
//  LMWriterViewController.h
//  living
//
//  Created by Ding on 2016/11/1.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "FitBaseViewController.h"

@interface LMWriterViewController : FitBaseViewController

@property(nonatomic,strong)NSString *writerUUid;

@property (nonatomic)           int     current;


-(id)initWithUUid:(NSString *)writerUUid;

@end
