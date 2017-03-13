//
//  LMChangeTextView.m
//  living
//
//  Created by Ding on 2017/3/1.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMChangeTextView.h"
#import "FitConsts.h"

@implementation LMChangeTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}

-(void)initSubviews
{
    UILabel *textLabel = [UILabel new];
    textLabel.text = @"转文字";
    textLabel.font = TEXT_FONT_LEVEL_2;
    textLabel.textColor = [UIColor whiteColor];
    textLabel.backgroundColor = [UIColor blackColor];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.layer.cornerRadius = 4;
    textLabel.clipsToBounds = YES;
    [textLabel sizeToFit];
    textLabel.frame = CGRectMake(10, 0, textLabel.bounds.size.width+20, 30);
    textLabel.userInteractionEnabled = YES;
    
    UIView *downView = [[UIView alloc] initWithFrame:CGRectMake(40, 25, 10, 10)];
    downView.backgroundColor = [UIColor blackColor];
    downView.layer.cornerRadius = 10;
    downView.clipsToBounds = YES;
    [self addSubview:downView];
    
    [self addSubview:textLabel];

}

@end
