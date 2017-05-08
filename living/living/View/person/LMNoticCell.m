//
//  LMNoticCell.m
//  living
//
//  Created by Ding on 16/10/10.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMNoticCell.h"
#import "FitConsts.h"
#import "UIView+frame.h"
#import "FitUserManager.h"

@interface LMNoticCell (){
    float _xScale;
    float _yScale;
    CGFloat CellConHigh;
    CGFloat contentHigh;
    
}

@property(nonatomic,retain)UIImageView *headImage;

@property(nonatomic,retain)UILabel *timeLabel;

@property(nonatomic,retain)UILabel *typeLabel;

@property(nonatomic,retain)UILabel *contentLabel;

@property(nonatomic,retain)UILabel *titleLabel;

@property(nonatomic,retain)UIView *whiteView;




@end


@implementation LMNoticCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self    = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
        [self addSubviews];
    }
    return self;
}

-(void)addSubviews
{
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 30)];
    _timeLabel.text = @"2017-03-21 15:30:26";
    _timeLabel.font = TEXT_FONT_LEVEL_3;
    _timeLabel.textColor = TEXT_COLOR_LEVEL_3;
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_timeLabel];
    
    _headImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 50, 40, 40)];
    _headImage.layer.cornerRadius = 20;
    _headImage.image = [UIImage imageNamed:@"themeIcon"];
    _headImage.contentMode = UIViewContentModeScaleAspectFill;
    _headImage.clipsToBounds = YES;
    [self.contentView addSubview:_headImage];
    
    _whiteView = [UIView new];
    _whiteView.backgroundColor = [UIColor whiteColor];
    _whiteView.layer.cornerRadius = 3;
    _whiteView.contentMode = UIViewContentModeScaleAspectFill;
    _whiteView.clipsToBounds = YES;
    [self.contentView addSubview:_whiteView];
    
    _typeLabel = [UILabel new];
    _typeLabel.font = TEXT_FONT_LEVEL_2;
    _typeLabel.textColor = TEXT_COLOR_LEVEL_1;
    _typeLabel.numberOfLines = 0;
    [_whiteView addSubview:_typeLabel];
    
    _contentLabel = [UILabel new];
    _contentLabel.font = TEXT_FONT_LEVEL_2;
    _contentLabel.textColor = TEXT_COLOR_LEVEL_2;
    _contentLabel.numberOfLines = 0;
    [_whiteView addSubview:_contentLabel];
    
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, kScreenWidth-140, 20)];
    _titleLabel.textAlignment = NSTextAlignmentRight;
    _titleLabel.textColor = [UIColor blueColor];
    _titleLabel.font = TEXT_FONT_LEVEL_2;
    [_whiteView addSubview:_titleLabel];
    
    

}


-(void)setData:(LMNoticVO *)list name:(NSString *)name
{
    
    NSString *type = list.type;
    NSString *string;
    NSString *typeString;
    NSString *signString;
    NSString *title = @"";
    
    if (name&&![name isEqualToString:@""]) {
        
    }else{
        name = @"匿名用户";
    }
    
    if (list.sign &&[list.sign isEqual:@"article"]) {
        
        signString = @"文章";
        
        if (list.articleTitle) {
           title = list.articleTitle;
        }else{
            title = @"";
        }
        

    }
    if (list.sign &&[list.sign isEqual:@"event"]) {
        signString = @"活动";
        if (list.eventName) {
            title = list.eventName;
        }else{
            title = @"";
        }

    }
    
    if (list.sign &&[list.sign isEqual:@"voice"]) {
        signString = @"课程";
        if (list.voiceTitle) {
            title = list.voiceTitle;
        }else{
            title = @"";
        }

    }
    
    if (list.sign &&[list.sign isEqual:@"item"]) {
        signString = @"项目";
        if (list.eventName) {
            title = list.eventName;
        }else{
            title = @"";
        }
        
    }
    
    if (list.sign &&[list.sign isEqual:@"eventReview"]) {
        signString = @"活动回顾";
        if (list.reviewTitle) {
            title = list.reviewTitle;
        }else{
            title = @"";
        }
        
    }
    

    if ([type isEqualToString:@"comment"]) {
        typeString = @"评论";
    }
    if ([type isEqualToString:@"adopted"]) {
        typeString = @"回复";
    }
    if ([type isEqualToString:@"praise"]) {
        typeString = @"赞";
    }
    if ([type isEqualToString:@"system"]) {
        typeString = @"系统消息";
    }

    if ([typeString isEqualToString:@"赞"]) {
        
        if (list.content==nil) {
                string = [NSString stringWithFormat:@"亲爱的%@，@%@%@了你的%@",name,list.userNick,typeString,signString];
        }else{
                string = [NSString stringWithFormat:@"亲爱的%@，@%@%@了你的评论：",name,list.userNick,typeString];
        }
        
    }else if ([typeString isEqualToString:@"评论"]){
        string = [NSString stringWithFormat:@"亲爱的%@，@%@%@了你的%@",name,list.userNick,typeString,signString];

    }else if ([typeString isEqualToString:@"回复"]){

        string = [NSString stringWithFormat:@"亲爱的%@，@%@%@了你的评论：",name,list.userNick,typeString];
    }else {
        string = @"系统消息:";
    }
    
    
    
    _contentLabel.text = list.content;
    
    if (title && title != nil && ![title isEqualToString:@""]) {
       
        _titleLabel.text = [NSString stringWithFormat:@"《%@》  ", title];
    }
    
    
    
    if (![string isEqualToString:@"系统消息:"]) {
        NSInteger num = [name length];

        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
        [str addAttribute:NSForegroundColorAttributeName value:LIVING_COLOR range:NSMakeRange(3,num)];
        [str addAttribute:NSForegroundColorAttributeName value:LIVING_COLOR range:NSMakeRange(4+num,[list.userNick length]+1)];

        _typeLabel.attributedText = str;
    }else{
        _typeLabel.text = string;
    }
    
    
    
    
    NSDateFormatter *formatter  = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yy-MM-dd HH:mm"];
    
    if (list.noticeTime && [list.noticeTime isKindOfClass:[NSDate class]]) {
        
        _timeLabel.text = [formatter stringFromDate:list.noticeTime];
    }

    //头部高度
    NSDictionary *attributes    = @{NSFontAttributeName:TEXT_FONT_LEVEL_2};
    
    CellConHigh = [string boundingRectWithSize:CGSizeMake(kScreenWidth-150, 100000)
                                          options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                        attributes:attributes
                                          context:nil].size.height;


    contentHigh = [list.content boundingRectWithSize:CGSizeMake(kScreenWidth-150, 100000)
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                    attributes:attributes
                                       context:nil].size.height;
    
    
    
    

}

- (void)setXScale:(float)xScale yScale:(float)yScale
{
    _xScale = xScale;
    _yScale = yScale;
}


+ (CGFloat)cellHigth:(NSString *)MyName friendName:(NSString *)friendName type:(NSString *)type sign:(NSString *)sign  title:(NSString *)title content:(NSString *)content
{
    NSString *string;
    NSString *typeString;
    NSString *signString;
    if ([type isEqualToString:@"comment"]) {
        typeString = @"评论";
    }
    if ([type isEqualToString:@"adopted"]) {
        typeString = @"回复";
    }
    if ([type isEqualToString:@"praise"]) {
        typeString = @"赞";
    }
    if ([type isEqualToString:@"system"]) {
        typeString = @"系统消息";
    }
    
    if ([sign isEqualToString:@"article"]) {
        signString = @"文章";
    }
    if ([sign isEqualToString:@"event"]) {
        signString = @"活动";
    }
    if ([sign isEqualToString:@"voice"]) {
        signString = @"课程";
    }
    if ([sign isEqualToString:@"item"]) {
        signString = @"项目";
    }
    if ([sign isEqualToString:@"eventReview"]) {
        signString = @"活动回顾";
    }
    
    if ([typeString isEqualToString:@"赞"]) {
        
        if (content==nil) {
            string = [NSString stringWithFormat:@"亲爱的%@，@%@%@了你的%@",MyName,friendName,typeString,signString];
        }else{
            string = [NSString stringWithFormat:@"亲爱的%@，@%@%@了你的评论：",MyName,friendName,typeString];
        }
        
    }else if ([typeString isEqualToString:@"评论"]){
        string = [NSString stringWithFormat:@"亲爱的%@，@%@%@了你的%@",MyName,friendName,typeString,signString];
        
    }else if ([typeString isEqualToString:@"回复"]){
        
        string = [NSString stringWithFormat:@"亲爱的%@，@%@%@了你的评论：",MyName,friendName,typeString];
    }else {
        string = @"系统消息:";
    }
    

    
    NSDictionary *attributes    = @{NSFontAttributeName:TEXT_FONT_LEVEL_2};
    
    CGFloat conHigh = [string boundingRectWithSize:CGSizeMake(kScreenWidth-150, 100000)
                                                options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                             attributes:attributes
                                                context:nil].size.height;
    
    CGFloat contentHight = [content boundingRectWithSize:CGSizeMake(kScreenWidth-150, 100000)
                                             options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                          attributes:attributes
                                             context:nil].size.height;
    

    
    return (conHigh + contentHight + 100);
}



-(void)layoutSubviews
{
    [super layoutSubviews];
    [_typeLabel sizeToFit];
    //[_timeLabel sizeToFit];
    [_contentLabel sizeToFit];
    [_titleLabel sizeToFit];
    [_whiteView sizeToFit];
    _whiteView.frame = CGRectMake(70, 50, kScreenWidth-140, CellConHigh+contentHigh+50);
    //_timeLabel.frame = CGRectMake(0, 20, kScreenWidth, _timeLabel.bounds.size.height);
//
//    
//    if (_INDEX==1) {
//        
//        _titleLabel.frame = CGRectMake(5, 5, 35+_timeLabel.bounds.size.width, _titleLabel.bounds.size.height);
//    }else{
//       
//        _titleLabel.frame = CGRectMake(5, 5, 85+_timeLabel.bounds.size.width, _titleLabel.bounds.size.height);
//    }
//    
//
//    _typeLabel.frame = CGRectMake(5, 10, kScreenWidth-150,  CellConHigh);
//

    _typeLabel.frame = CGRectMake(5, 10, kScreenWidth-150, CellConHigh);
    
    _contentLabel.frame = CGRectMake(5, CellConHigh+20, kScreenWidth-150, contentHigh);
    _whiteView.backgroundColor = [UIColor whiteColor];
    
    _titleLabel.frame = CGRectMake(5, CellConHigh+contentHigh+20+10, kScreenWidth-150, 20);
    
    _whiteView.backgroundColor = [UIColor whiteColor];
}


@end
