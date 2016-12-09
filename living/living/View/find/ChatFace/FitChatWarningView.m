//
//  FitChatWarningView.m
//  FitTrainer
//
//  Created by JamHonyZ on 16/1/7.
//  Copyright © 2016年 Huasheng. All rights reserved.
//

#import "FitChatWarningView.h"
#import "FitConsts.h"

#define CONTENT_TEXT  @"这里有最志同道合的小伙伴在一起进行一次对人性和毅力的挑战；这里没有抓早恋的班主任，却有一个兢兢业业抓熄灯的大胡子院长哦~~ \n可惜您当前还未加入任何班级，可以先围观一下满足自己的好奇心"

@implementation FitChatWarningView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initSubViews];
    }
    return self;
}

- (void)_initSubViews
{
    
    UIView  *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgView];
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, kScreenHeight / 2.0 - 140, kScreenWidth, 40)];
    titleLbl.text = @"- 什么是班级? -";
    titleLbl.textColor = COLOR_HOME_YELLOW;
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.font = [UIFont systemFontOfSize:20];
    [bgView addSubview:titleLbl];
    
    CGFloat contentHei = ceil([CONTENT_TEXT boundingRectWithSize:CGSizeMake(280, 1000000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:TEXT_FONT_LEVEL_1 forKey:NSFontAttributeName] context:nil].size.height);
    
    UILabel *textLbl = [[UILabel alloc] initWithFrame:CGRectMake( kScreenWidth / 2.0 - 140, kScreenHeight / 2.0 - 80, 280, contentHei + 30)];
    textLbl.text = CONTENT_TEXT;
    textLbl.font = TEXT_FONT_LEVEL_2;
    textLbl.textColor = TEXT_COLOR_LEVEL_2;
    textLbl.numberOfLines = 0;
    [bgView addSubview:textLbl];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:textLbl.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];//调整行间距
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, textLbl.text.length)];
    textLbl.attributedText = attributedString;
    
    
    UIButton    *pushBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    pushBtn.frame = CGRectMake(kScreenWidth / 2.0 - 100, kScreenHeight / 2.0 - 80 + contentHei + 30 + 20, 200, 40);
    pushBtn.layer.cornerRadius = 25;
    pushBtn.clipsToBounds = YES;
    pushBtn.backgroundColor = COLOR_HOME_YELLOW;
    [pushBtn setTitle:@"现在去了解班级" forState:UIControlStateNormal];
    [pushBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [pushBtn addTarget:self action:@selector(pushToRecomment) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:pushBtn];
    
    
    UILabel *botLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(pushBtn.frame) + 10, kScreenWidth, 30)];
    botLbl.text = @"先旁听其他班级 >";
    botLbl.textColor = COLOR_TEXT_BLUE;
    botLbl.font = TEXT_FONT_LEVEL_1;
    botLbl.textAlignment = NSTextAlignmentCenter;
    [botLbl addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToOpen)]];
    botLbl.userInteractionEnabled = YES;
    
    [bgView addSubview:botLbl];
}

- (void)pushToRecomment
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pushToRecommentPlan)]) {
        [self.delegate pushToRecommentPlan];
    }
}

- (void)pushToOpen
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pushToOpenPlan)]) {
        [self.delegate pushToOpenPlan];
    }
}

@end
