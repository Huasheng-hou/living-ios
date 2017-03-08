//
//  LMYGBConvertCell.m
//  living
//
//  Created by hxm on 2017/3/8.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMYGBConvertCell.h"
#import "FitConsts.h"
@implementation LMYGBConvertCell
{
    
    UIImageView * leftImage;
    UILabel * leftTitle;
    UILabel * leftNumber;
    
    UIImageView * rightImage;
    UILabel * rightTitle;
    UILabel * rightNumber;
    
    
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubViews];
    }
    return self;
}

- (void)addSubViews{
    UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth-20, 110)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:backView];
    
    
    CGFloat gap = 10;
    
    //左侧
    leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (backView.frame.size.width-gap)/2, 110)];
    leftImage.backgroundColor = BG_GRAY_COLOR;
    leftImage.image = [UIImage imageNamed:@"demo"];
    [backView addSubview:leftImage];
    
    leftTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(leftImage.frame), 0)];
    leftTitle.center = leftImage.center;
    leftTitle.text = @"站在高处看世界";
    leftTitle.textColor = [UIColor whiteColor];
    leftTitle.font = TEXT_FONT_BOLD_14;
    
    leftTitle.numberOfLines = -1;
    [leftTitle sizeToFit];
    leftTitle.center = leftImage.center;
    [backView addSubview:leftTitle];
    
    
    leftNumber = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 40)];
    leftNumber.text = @"754腰果币+50元";
    leftNumber.textColor = [UIColor whiteColor];
    leftNumber.font = TEXT_FONT_BOLD_12;
    leftNumber.backgroundColor = [UIColor clearColor];
    [leftNumber sizeToFit];
    leftNumber.textAlignment = NSTextAlignmentCenter;
    CGFloat w = leftNumber.frame.size.width;
    CGFloat h = leftNumber.frame.size.height;
    leftNumber.center = CGPointMake(CGRectGetWidth(leftImage.frame)-5-w/2.0, CGRectGetHeight(leftImage.frame)-5-h/2.0);
    leftNumber.layer.masksToBounds = YES;
    leftNumber.layer.cornerRadius = 3;
    leftNumber.layer.borderColor = [UIColor whiteColor].CGColor;
    leftNumber.layer.borderWidth = 0.5;
    //leftNumber.frame = CGRectMake(CGRectGetWidth(leftImage.frame)-w-5-4, CGRectGetHeight(leftImage.frame)-5-h-4, w+4, h+4);
    [backView addSubview:leftNumber];
    
    //右侧
    rightImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(leftImage.frame)+gap, 0, (backView.frame.size.width-gap)/2, 110)];
    rightImage.backgroundColor = BG_GRAY_COLOR;
    rightImage.image = [UIImage imageNamed:@"demo"];
    [backView addSubview:rightImage];
    
    rightTitle = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(leftImage.frame)+gap, 0, CGRectGetWidth(rightImage.frame), 0)];
    rightTitle.center = rightImage.center;
    rightTitle.text = @"鞋与路";
    rightTitle.textColor = [UIColor whiteColor];
    rightTitle.font = TEXT_FONT_BOLD_14;
    
    rightTitle.numberOfLines = -1;
    [rightTitle sizeToFit];
    rightTitle.center = rightImage.center;
    [backView addSubview:rightTitle];
    
    
    rightNumber = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 40)];
    rightNumber.text = @"754腰果币+10元";
    rightNumber.textColor = [UIColor whiteColor];
    rightNumber.font = TEXT_FONT_BOLD_12;
    rightNumber.backgroundColor = [UIColor clearColor];
    [rightNumber sizeToFit];
    rightNumber.textAlignment = NSTextAlignmentCenter;
    CGFloat rw = rightNumber.frame.size.width;
    CGFloat rh = rightNumber.frame.size.height;
    rightNumber.center = CGPointMake(CGRectGetWidth(leftImage.frame)+gap+CGRectGetWidth(rightImage.frame)-5-rw/2.0, CGRectGetHeight(rightImage.frame)-5-rh/2.0);
    rightNumber.layer.masksToBounds = YES;
    rightNumber.layer.cornerRadius = 3;
    rightNumber.layer.borderColor = [UIColor whiteColor].CGColor;
    rightNumber.layer.borderWidth = 0.5;
    //leftNumber.frame = CGRectMake(CGRectGetMaxX(rightImage.frame)-rw-5-4, CGRectGetHeight(leftImage.frame)-5-rh-4, rw+4, rh+4);
    [backView addSubview:rightNumber];

}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
