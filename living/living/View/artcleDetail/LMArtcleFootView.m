//
//  LMArtcleFootView.m
//  living
//
//  Created by Ding on 2016/12/1.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMArtcleFootView.h"
#import "FitConsts.h"

@implementation LMArtcleFootView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        _backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, (kScreenWidth-20)/5, 50)];
        [_backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        
        [self addSubview:_backButton];
        
        _commentButton = [[UIButton alloc] initWithFrame:CGRectMake(10+(kScreenWidth-20)/5, 0, (kScreenWidth-20)/5, 50)];
        [_commentButton setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];        
        [self addSubview:_commentButton];

        
        _zanartcle = [[UIButton alloc] initWithFrame:CGRectMake(10+(kScreenWidth-20)*2/5, 0, (kScreenWidth-20)/5, 50)];
        [_zanartcle setImage:[UIImage imageNamed:@"zan-black"] forState:UIControlStateNormal];

        [self addSubview:_zanartcle];
        
        _shareartcle = [[UIButton alloc] initWithFrame:CGRectMake(10+(kScreenWidth-20)*3/5, 0, (kScreenWidth-20)/5, 50)];
        [_shareartcle setImage:[UIImage imageNamed:@"shareIcon-1"] forState:UIControlStateNormal];

        [self addSubview:_shareartcle];
        
        _moreartcle = [[UIButton alloc] initWithFrame:CGRectMake(10+(kScreenWidth-20)*4/5, 0, (kScreenWidth-20)/5, 50)];
        [_moreartcle setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
        [self addSubview:_moreartcle];
        
        
        _comentcount = [[UILabel alloc] initWithFrame:CGRectMake(_commentButton.imageView.frame.origin.x+_commentButton.imageView.frame.size.width/2, _commentButton.imageView.frame.origin.y-5, _commentButton.imageView.frame.size.width/2, 10)];
        _comentcount.textColor = LIVING_COLOR;
        _comentcount.textAlignment = NSTextAlignmentCenter;
        _comentcount.font = [UIFont systemFontOfSize:9];
        
        [_commentButton addSubview:_comentcount];
        
        _zanCount = [[UILabel alloc] initWithFrame:CGRectMake(_zanartcle.imageView.frame.origin.x+_zanartcle.imageView.frame.size.width/2+5, _zanartcle.imageView.frame.origin.y-5, _zanartcle.imageView.frame.size.width/2, 10)];
        _zanCount.textColor = LIVING_COLOR;
        _zanCount.textAlignment = NSTextAlignmentCenter;
        _zanCount.font = [UIFont systemFontOfSize:9];
        
        [_zanartcle addSubview:_zanCount];
        
    }
    return self;
}

@end
