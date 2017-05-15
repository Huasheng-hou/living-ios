//
//  LMFriendMessageCell.m
//  living
//
//  Created by Ding on 2017/3/6.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMFriendMessageCell.h"
#import "FitConsts.h"

@implementation LMFriendMessageCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubviews];
    }
    return self;
}
- (void)addSubviews{

    
    __textLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 10, kScreenWidth-30, 45)];
    __textLabel.font = TEXT_FONT_LEVEL_1;
    __textLabel.numberOfLines = 0;
    [self.contentView addSubview:__textLabel];
    
}

-(void)setFriendVO:(LMFriendVO *)friendVO
{
    NSString *string;
    if (friendVO.content) {
        if (friendVO.remark && ![friendVO.remark isEqualToString:@""]) {
            string =[NSString stringWithFormat:@"%@：%@",friendVO.remark,friendVO.content];
        }else{
            string =[NSString stringWithFormat:@"%@：%@",friendVO.nickname,friendVO.content];
        }
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
        if (friendVO.remark && ![friendVO.remark isEqualToString:@""]) {
            [str addAttribute:NSForegroundColorAttributeName value:LIVING_COLOR range:NSMakeRange(0,[friendVO.remark length]+1)];
        }else{
            [str addAttribute:NSForegroundColorAttributeName value:LIVING_COLOR range:NSMakeRange(0,[friendVO.nickname length]+1)];
        }

        __textLabel.attributedText = str;
    }else{
        if (friendVO.remark && ![friendVO.remark isEqualToString:@""]) {
            string =[NSString stringWithFormat:@"%@回复%@：%@",friendVO.myNickname,friendVO.remark,friendVO.myContent];
        }else{
            string =[NSString stringWithFormat:@"%@回复%@：%@",friendVO.myNickname,friendVO.nickname,friendVO.myContent];
        }
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
        [str addAttribute:NSForegroundColorAttributeName value:LIVING_COLOR range:NSMakeRange(0,[friendVO.myNickname length])];
        
        if (friendVO.remark && ![friendVO.remark isEqualToString:@""]) {
            [str addAttribute:NSForegroundColorAttributeName value:LIVING_COLOR range:NSMakeRange([friendVO.myNickname length]+2,[friendVO.remark length]+1)];
        }else{
            [str addAttribute:NSForegroundColorAttributeName value:LIVING_COLOR range:NSMakeRange([friendVO.myNickname length]+2,[friendVO.nickname length]+1)];
        }
        
        
        __textLabel.attributedText = str;
    }
    
    NSDictionary *attributes    = @{NSFontAttributeName:TEXT_FONT_LEVEL_1};
    _CellHight = [string boundingRectWithSize:CGSizeMake(kScreenWidth-30, 100000)
                                   options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                attributes:attributes
                                   context:nil].size.height;


}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [__textLabel sizeToFit];
    __textLabel.frame = CGRectMake(15, 10, kScreenWidth-30, _CellHight);
}



@end
