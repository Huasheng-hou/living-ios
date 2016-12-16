//
//  ChattingCell.h
//  living
//
//  Created by JamHonyZ on 2016/12/13.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChattingCell : UITableViewCell

@property(nonatomic,strong)UIImageView *headImageView;

@property(nonatomic,strong)UILabel *chatNameLabel;

@property(nonatomic,strong)UILabel *timeLabel;

@property(nonatomic,strong)UIButton *soundbutton;

@property(nonatomic,strong)UILabel *duration;

@property(nonatomic,strong)UILabel *contentLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

-(void)setCellValue:(id)content;
@end
