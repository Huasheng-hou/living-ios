//
//  LMMapViewCell.m
//  living
//
//  Created by JamHonyZ on 2016/11/1.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMMapViewCell.h"
#import "FitConsts.h"

@implementation LMMapViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self    = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self createUI];
    }
    return self;
}
-(void)createUI
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 180)];
    [view setBackgroundColor:[UIColor greenColor]];
    [self addSubview:view];
    
}
@end
