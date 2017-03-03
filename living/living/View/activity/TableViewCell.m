//
//  TableViewCell.m
//  TFSearchBar
//
//  Created by TF_man on 16/5/19.
//  Copyright © 2016年 TF_man. All rights reserved.
//

#import "TableViewCell.h"
#import "FitConsts.h"

@implementation TableViewCell

- (void)setCellArr:(NSArray *)cellArr{
    
    _cellArr = cellArr;
    CGFloat w = (kScreenWidth-30)/3;
    for (int i = 0; i < cellArr.count; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(15+i%3*w, 15+i/3*45, w-15, 30);
        btn.titleLabel.font = TEXT_FONT_LEVEL_2;
        [btn setTitle:cellArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.layer.borderColor = LINE_COLOR.CGColor;
        btn.layer.borderWidth = 0.5;
        btn.layer.cornerRadius = 2;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor whiteColor];
        [self addSubview:btn];
    }
    
}

- (void)btnClick:(UIButton *)btn{
    
//    NSLog(@"btnClick---%@",btn.titleLabel.text);
    [self.delegate TableViewSelectorIndix:btn.titleLabel.text];
}


@end
