//
//  LMActivityLifeHouseCell.m
//  living
//
//  Created by WangShengquan on 2017/2/22.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMActivityLifeHouseCell.h"
#import "FitConsts.h"
#import "LMActivityLifeHouseBtn.h"

@interface LMActivityLifeHouseCell ()
@property (nonatomic, strong) UIScrollView *scrollView;
//@property (nonatomic, strong) NSArray * btnArray;

@end

@implementation LMActivityLifeHouseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self    = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self initLayout];
    }
    return self;
}

- (void)initLayout
{
    int count = 3;
    self.backgroundColor = [UIColor whiteColor];
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 144)];
    _scrollView.contentSize = CGSizeMake(5 + (144 * 1.1 + 5) * 3, 144);
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.contentView addSubview:_scrollView];
    
    for (int i = 0; i < count; i++) {
        LMActivityLifeHouseBtn *btn = [[LMActivityLifeHouseBtn alloc]initWithFrame:CGRectMake(5 + (144 * 1.1 + 5) * i, 0,144 * 1.1, 144)];
        btn.tag = i;
        btn.layer.cornerRadius = 10;
        btn.backgroundColor = [UIColor clearColor];
        [btn addTarget:self action:@selector(btnSelectPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn];
    }
}

- (void)btnSelectPressed:(LMActivityLifeHouseBtn *)button
{
    self.btnPressedBlock(button.tag);
}


@end
