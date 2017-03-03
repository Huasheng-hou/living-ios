//
//  LMExceptionalView.m
//  living
//
//  Created by Ding on 2017/2/14.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMExceptionalView.h"
#import "FitConsts.h"

@implementation LMExceptionalView

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
        [self contentWithView];
    }
    return self;
}

- (void)contentWithView
{
    UIImageView *imageV =[[UIImageView alloc] initWithFrame:CGRectMake(15, kScreenHeight/5, kScreenWidth-30, kScreenHeight*3/5)];
    imageV.image = [UIImage imageNamed:@"Redpacket-1"];
    imageV.userInteractionEnabled = YES;
    [self addSubview:imageV];
    
    _headerView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2-15-40, self.frame.size.height/4-80, 80, 80)];
    _headerView.backgroundColor = LINE_COLOR;
    _headerView.clipsToBounds = YES;
    _headerView.contentMode = UIViewContentModeScaleAspectFill;
    _headerView.layer.cornerRadius = 40;
    [imageV addSubview:_headerView];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height/4, kScreenWidth-30, 30)];
    _nameLabel.text = @"打赏~~~";
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.font = TEXT_FONT_LEVEL_1;
    [imageV addSubview:_nameLabel];
    
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelButton setImage:[UIImage imageNamed:@"cancelIcon"] forState:UIControlStateNormal];
    _cancelButton.frame = CGRectMake(0, 0, 60, 60);
    [imageV addSubview:_cancelButton];
    int buttonW = ((kScreenWidth-30)-4*15)/3;
    NSArray *moneyArr = @[@"￥2",@"￥5",@"￥10",@"￥50",@"￥100",@"￥200"];
    for (int i = 0; i<6; i++) {
        
        UIButton *_moneyButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _moneyButton.backgroundColor = [UIColor colorWithRed:249.0/255.0 green:217.0/255.0 blue:217.0/255.0 alpha:1.0];
        _moneyButton.layer.cornerRadius = 5;
        _moneyButton.frame = CGRectMake(15+(i%3)*(15+buttonW), self.frame.size.height/4+50+(i/3)*50, buttonW, 40);
        [_moneyButton setTintColor:LIVING_REDCOLOR];
        [_moneyButton setTitle:moneyArr[i] forState:UIControlStateNormal];
        _moneyButton.tag = i;
        [_moneyButton addTarget:self action:@selector(moneyAction:) forControlEvents:UIControlEventTouchUpInside];
        [imageV addSubview:_moneyButton];
    }
    
    
    
}

-(void)moneyAction:(UIButton *)sender
{
    if ([_delegate respondsToSelector:@selector(ViewForMoney: Viewtag:)]) {
        [_delegate ViewForMoney:self Viewtag:sender.tag];
    }
}



@end
