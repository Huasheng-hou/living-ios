//
//  ChattingCell.m
//  living
//
//  Created by JamHonyZ on 2016/12/13.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "ChattingCell.h"
#import "FitConsts.h"
#import "UIImageView+WebCache.h"

#define lightRedColor [UIColor colorWithRed:255/255.0f green:240/255.0f blue:240/255.0f alpha:1.0f]
#define LMRedColor [UIColor colorWithRed:255/255.0f green:84/255.0f blue:84/255.0f alpha:1.0f]
#define LMBuleColor [UIColor colorWithRed:240/255.0f green:248/255.0f blue:255/255.0f alpha:1.0f]
#define lightBuleColor [UIColor colorWithRed:55/255.0f green:155/255.0f blue:239/255.0f alpha:1.0f]
#define LMGrayColor [UIColor colorWithRed:217/255.0f green:217/255.0f blue:217/255.0f alpha:1.0f]
#define LMlightGrayColor [UIColor colorWithRed:247/255.0f green:247/255.0f blue:247/255.0f alpha:1.0f]

@implementation ChattingCell
{
    UIView *contentbgView;
    UIImageView *publishImageV;
}
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *cellID = @"chatCell";
    
    ChattingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[ChattingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self contentWithCell];
    }
    return self;
}

-(void)contentWithCell
{
    //头像
    _headImageView=[[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 30, 30)];
    [_headImageView setBackgroundColor:[UIColor lightGrayColor]];
    [_headImageView.layer setCornerRadius:5.0f];
    [_headImageView.layer setMasksToBounds:YES];
    [_headImageView setContentMode:UIViewContentModeScaleAspectFill];
    [_headImageView setClipsToBounds:YES];
    [self addSubview:_headImageView];
    
    //名字
    _chatNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(60, 5, kScreenWidth-75, 30)];
    [_chatNameLabel setFont:TEXT_FONT_LEVEL_2];
    [_chatNameLabel setTextColor:[UIColor blackColor]];
    [self addSubview:_chatNameLabel];
    
    //时间
    _timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(60, 5, kScreenWidth-75, 30)];
    [_timeLabel setTextAlignment:NSTextAlignmentRight];
    [_timeLabel setFont:TEXT_FONT_LEVEL_3];
    [_timeLabel setTextColor:[UIColor grayColor]];
    [self addSubview:_timeLabel];
    
    //声音
    _soundbutton=[[UIButton alloc]initWithFrame:CGRectMake(50, 35, kScreenWidth-65, 35)];
    [_soundbutton.layer setBorderWidth:0.5f];
    [_soundbutton.titleLabel setFont:TEXT_FONT_LEVEL_2];
    [_soundbutton.layer setCornerRadius:3.0f];
    [_soundbutton.layer setMasksToBounds:YES];
    
    
    [_soundbutton addTarget:self action:@selector(soundPlay) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_soundbutton];
    
    UIImageView *imageV=[[UIImageView alloc]initWithFrame:CGRectMake(10, 8, 11, 17)];
    [imageV setImage:[UIImage imageNamed:@"cellSoundIcon"]];
    [_soundbutton addSubview:imageV];
    
    _duration=[[UILabel alloc]initWithFrame:CGRectMake(_soundbutton.bounds.size.width-60, 0, 50, _soundbutton.bounds.size.height)];
    [_duration setFont:TEXT_FONT_LEVEL_3];
    _duration.textAlignment = NSTextAlignmentRight;
    [_duration setTextColor:[UIColor redColor]];
    [_soundbutton addSubview:_duration];
    
    //内容底板
    contentbgView=[[UIView alloc]initWithFrame:CGRectMake(50, 35, kScreenWidth-65, 100)];
    [contentbgView.layer setBorderWidth:0.5f];
    [contentbgView.layer setCornerRadius:3.0f];
    [contentbgView.layer setMasksToBounds:YES];
    
    
    [self addSubview:contentbgView];
    //内容
    _contentLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, kScreenWidth-65-10, 100)];
    [_contentLabel setText:@" "];
    [_contentLabel setFont:TEXT_FONT_LEVEL_2];
    [_contentLabel setNumberOfLines:0];
    
    [contentbgView addSubview:_contentLabel];
    
    publishImageV=[[UIImageView alloc]initWithFrame:CGRectMake(50, 35, 100, 150)];
    [publishImageV setContentMode:UIViewContentModeScaleAspectFill];
    [publishImageV.layer setCornerRadius:3.0f];
    [publishImageV.layer setMasksToBounds:YES];
    [publishImageV setBackgroundColor:BG_GRAY_COLOR];
    [self addSubview:publishImageV];
}

-(void)setCellValue:(MssageVO *)vo
{
   
    if (vo.role&&[vo.role isEqualToString:@"teacher"]) {
        [contentbgView.layer setBorderColor:LMRedColor.CGColor];
        [contentbgView setBackgroundColor:lightRedColor];
        [_soundbutton setBackgroundColor:lightRedColor];
        [_soundbutton.layer setBorderColor:LMRedColor.CGColor];
    }
    if (vo.role&&[vo.role isEqualToString:@"host"]) {
        [contentbgView.layer setBorderColor:lightBuleColor.CGColor];
        [contentbgView setBackgroundColor:LMBuleColor];
        [_soundbutton setBackgroundColor:LMBuleColor];
        [_soundbutton.layer setBorderColor:lightBuleColor.CGColor];
    }
    if (vo.role&&[vo.role isEqualToString:@"student"]) {
        [contentbgView.layer setBorderColor:LMGrayColor.CGColor];
        [contentbgView setBackgroundColor:LMlightGrayColor];
        [_soundbutton setBackgroundColor:LMlightGrayColor];
        [_soundbutton.layer setBorderColor:LMGrayColor.CGColor];
    }
    
    //设置时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init]; //初始化格式器。
    [formatter setDateFormat:@"MM-dd hh:mm"];//定义时间为这种格式： YYYY-MM-dd hh:mm:ss 。
    NSString *currentTime = [formatter stringFromDate:vo.time];
    [_timeLabel setText:currentTime];
    
    _chatNameLabel.text = vo.name;
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:vo.headimgurl]];
    
     //设置内容
    
    //如果为文字
    if (vo.type&&([vo.type isEqual:@"chat"]||[vo.type isEqual:@"question"])) {
        
        NSString *contentStr=vo.content;
        
         [_contentLabel setText:contentStr];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:contentStr];
       
        [paragraphStyle setLineSpacing:2];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, contentStr.length)];
        
        _contentLabel.attributedText = attributedString;

        CGSize contenSize = [contentStr boundingRectWithSize:CGSizeMake(kScreenWidth-75, MAXFLOAT)                                           options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:TEXT_FONT_LEVEL_2,NSParagraphStyleAttributeName:paragraphStyle} context:nil].size;
    
        [contentbgView setFrame:CGRectMake(50, 35, kScreenWidth-65, contenSize.height+10)];
         [_contentLabel setFont:TEXT_FONT_LEVEL_2];
        [_contentLabel setFrame:CGRectMake(10, 5, kScreenWidth-65-10, contenSize.height)];
        
        //显示文字显示控件
        [contentbgView setHidden:NO];
        //隐藏图片显示控件
        [publishImageV setHidden:YES];
        
        [_soundbutton setHidden:YES];
    }
    
    //如果为图片
     if (vo.type&&[vo.type isEqual:@"picture"]) {
         
         [publishImageV sd_setImageWithURL:[NSURL URLWithString:vo.imageurl]];
        
         //隐藏文字显示控件
         [contentbgView setHidden:YES];
         //显示图片显示控件
         [publishImageV setHidden:NO];
         
         [_soundbutton setHidden:YES];
         publishImageV.userInteractionEnabled = YES;
         
         UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick)];
         [publishImageV addGestureRecognizer:tap];
         
     }
    
    //如果为语音
    if (vo.type&&[vo.type isEqual:@"voice"]) {
        int value;
        if (vo.recordingTime&&![vo.recordingTime isEqual:@""]) {
            value =[vo.recordingTime intValue];
            if (value<15) {
                value = 15;
            }
            if (value>60) {
                value = 60;
            }
            
        }
        [_soundbutton sizeToFit];
        
        [_soundbutton setFrame:CGRectMake(50, 35, (kScreenWidth-65)*value/60, 30)];
        if (vo.recordingTime&&![vo.recordingTime isEqual:@""]) {
           _duration.text  = [NSString stringWithFormat:@"%@''",vo.recordingTime];
         _duration.frame=CGRectMake(_soundbutton.bounds.size.width-60, 0, 50, _soundbutton.bounds.size.height);
        }
        //显示文字显示控件
        [contentbgView setHidden:YES];
        //隐藏图片显示控件
        [publishImageV setHidden:YES];
        
        [_soundbutton setHidden:NO];
    }
   
}


- (void)soundPlay
{
    if ([_delegate respondsToSelector:@selector(cellClickVoice:)]) {
        [_delegate cellClickVoice:self];
    }
}

- (void)imageClick
{
    if ([_delegate respondsToSelector:@selector(cellClickImage:)]) {
        [_delegate cellClickImage:self];
    }
}





@end
