//
//  HBShareButton.m
//  HBLive
//
//  Created by JamHonyZ on 2016/10/20.
//  Copyright © 2016年 Hou Huasheng. All rights reserved.
//

#import "HBShareButton.h"
#import "FitConsts.h"

@implementation HBShareButton
{
    NSInteger _index;
}
-(id)initWithFrame:(CGRect)frame andIndex:(NSInteger)index
{
    self=[super initWithFrame:frame];
    if (self) {
        _index=index;
        [self setBackgroundColor:[UIColor colorWithRed:241/255.0f green:251/255.0f blue:1.0f alpha:1.0f]];
        [self createUI];
    }
    return self;
}

-(void)createUI
{
    UIImageView *image=[[UIImageView alloc]init];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height/2, self.frame.size.width, self.frame.size.height/2)];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:TEXT_FONT_LEVEL_2];
    [label setTextColor:TEXT_COLOR_LEVEL_1];
    
    NSArray *title=@[@"微信好友",@"朋友圈",@"QQ好友",@"QQ空间"];
    
     [label setText:title[_index-1]];
    
    if (_index==1) {
        [image setFrame:CGRectMake(self.frame.size.width/2-30, self.frame.size.height/2-48, 60, 48)];
        [image setImage:[UIImage imageNamed:@"weixinFriend"]];
    }
    if (_index==2) {
        [image setFrame:CGRectMake(self.frame.size.width/2-26, self.frame.size.height/2-52, 52, 52)];
         [image setImage:[UIImage imageNamed:@"weixincicle"]];
    }
    
    [self addSubview:image];
    [self addSubview:label];
}

@end
