//
//  DraftCell.m
//  living
//
//  Created by hxm on 2017/7/13.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "DraftCell.h"

@implementation DraftCell
{
    UILabel *type;
    UIImageView *icon;
    UILabel *name;
    UILabel *time;
    UIButton *delete;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubViews];
    }
    return self;
}

- (void)addSubViews {
    self.backgroundColor = BG_GRAY_COLOR;
    UIView *back = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 90)];
    back.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:back];
    
    type = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 50, 50)];
    type.text = @"文章";
    type.textColor = [UIColor whiteColor];
    type.textAlignment = NSTextAlignmentCenter;
    type.font = TEXT_FONT_LEVEL_1;
    type.clipsToBounds = YES;
    type.layer.cornerRadius = 25;
    type.backgroundColor = LIVING_COLOR;
    [back addSubview:type];
    
    icon = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(type.frame) + 10, 10, 80, 70)];
    icon.backgroundColor = BG_GRAY_COLOR;
    icon.contentMode = UIViewContentModeScaleAspectFill;
    icon.clipsToBounds = YES;
    [back addSubview:icon];
    
    name = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(icon.frame) + 10, 10, kScreenWidth - CGRectGetMaxX(icon.frame) - 40, 40)];
    name.text = @"这是草稿标题这是草稿标题";
    name.textColor = TEXT_COLOR_LEVEL_1;
    name.font = TEXT_FONT_LEVEL_2;
    name.numberOfLines = 2;
    [back addSubview:name];
    
    time = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(icon.frame) + 10, CGRectGetMaxY(name.frame) + 10, kScreenWidth - CGRectGetMaxX(icon.frame) - 20, 20)];
    time.text = @"时间:2017-07-13 15:35";
    time.textColor = TEXT_COLOR_LEVEL_3;
    time.font = TEXT_FONT_LEVEL_3;
    [back addSubview:time];
    
    delete = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 30, 30, 20, 20)];
    delete.backgroundColor = BG_GRAY_COLOR;
    [delete setBackgroundImage:[UIImage imageNamed:@"delete_draft"] forState:UIControlStateNormal];
    delete.clipsToBounds = YES;
    delete.layer.cornerRadius = 10;
    [delete addTarget:self action:@selector(deleteItem:) forControlEvents:UIControlEventTouchUpInside];
    [back addSubview:delete];
    
    
}

- (void)deleteItem:(UIButton *)btn {
    NSLog(@"删除草稿");
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteItemWithTag:)]) {
        [self.delegate deleteItemWithTag:self.tag];
    }
}

- (void)setData:(NSDictionary *)dict {
    NSString *contentStr = dict[@"content"];
    NSData *contentData = [contentStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *contentDic = [NSJSONSerialization JSONObjectWithData:contentData options:NSJSONReadingMutableContainers error:nil];
    NSDictionary *headDic = contentDic[@"headData"];
    if ([dict[@"type"] isEqualToString:@"article"]) {
        type.text = @"文章";
        type.backgroundColor = [UIColor yellowColor];
    } else if ([dict[@"type"] isEqualToString:@"review"]) {
        type.text = @"回顾";
        type.backgroundColor = [UIColor blueColor];
    } else if ([dict[@"type"] isEqualToString:@"activity"]) {
        type.text = @"活动";
        type.backgroundColor = [UIColor greenColor];
        if (headDic[@"imgUrl"]) {
            [icon sd_setImageWithURL:[NSURL URLWithString:headDic[@"imgUrl"]]];
        }
    } else if ([dict[@"type"] isEqualToString:@"event"]) {
        type.text = @"项目";
        type.backgroundColor = [UIColor purpleColor];
        if (headDic[@"imgUrl"]) {
            [icon sd_setImageWithURL:[NSURL URLWithString:headDic[@"imgUrl"]]];
        }
    } else if ([dict[@"type"] isEqualToString:@"class"]) {
        type.text = @"课程";
        type.backgroundColor = LIVING_COLOR;
        if (headDic[@"imgUrl"]) {
            [icon sd_setImageWithURL:[NSURL URLWithString:headDic[@"imgUrl"]]];
        }
    }
    
    name.text = dict[@"title"];
    
    time.text = [NSString stringWithFormat:@"时间:%@", dict[@"time"]];
    
    
}
@end
