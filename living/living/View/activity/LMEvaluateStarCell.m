//
//  LMEvaluateStarCell.m
//  living
//
//  Created by WangShengquan on 2017/2/24.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMEvaluateStarCell.h"
#import "LMEvaluateStarView.h"
#import "FitConsts.h"

@interface LMEvaluateStarCell ()<UITextViewDelegate>
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) LMEvaluateStarView *starView;
@property (nonatomic, strong) UITextView *commentText;
@property (nonatomic, strong) UILabel *placeholderLbl;
@property (nonatomic, strong) UIView *whiteView;

@end

@implementation LMEvaluateStarCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayout];
    }
    return self;
}

- (void)initLayout
{
    _titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 16, 70, 20)];
    _titleLbl.text = @"总体评价";
    _titleLbl.font = TEXT_FONT_LEVEL_1;
    [self.contentView addSubview:_titleLbl];
    
    _starView = [[LMEvaluateStarView alloc]initWithFrame:CGRectMake(85, 14, kScreenWidth - 110, 22) withTotalStar:5 withTotalPoint:5 starSpace:8];
    _starView.starAliment = StarAlimentDefault;
    [self.contentView addSubview:_starView];
    
    UIImageView *lineView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 51, kScreenWidth - 20, 0.5)];
    lineView.backgroundColor = LINE_COLOR;
    [self.contentView addSubview:lineView];
    
    _commentText = [[UITextView alloc]initWithFrame:CGRectMake(10, 55, kScreenWidth - 20, 120)];
//    _commentText.backgroundColor = BG_GRAY_COLOR;
    _commentText.font = TEXT_FONT_LEVEL_2;
    _commentText.delegate = self;
    [self.contentView addSubview:_commentText];
    
    _placeholderLbl = [[UILabel alloc]initWithFrame:CGRectMake(15, 62, 220, 20)];
    _placeholderLbl.text = @"说点什么吧，您的评价很重要哦！";
    _placeholderLbl.font = TEXT_FONT_LEVEL_2;
    _placeholderLbl.textColor = TEXT_COLOR_LEVEL_3;
    [self.contentView addSubview:_placeholderLbl];
    
    _imageV = [[EditImageView alloc] initWithStartY:155 andImageArray:nil];
    [self.contentView addSubview:_imageV];
    
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        _placeholderLbl.text = @"说点什么吧，您的评价很重要哦！";
    }else{
        _placeholderLbl.text = @"";
    }
}


-(void)setArray:(NSMutableArray *)array
{
    _array = array;
    
    if ([_array isEqual:@""]) {
        _array = nil;
    }
    [_imageV contentWithView:_array andY:155];
    
    self.contentView.frame = CGRectMake(0, 10, kScreenWidth, _imageV.frame.size.height+155);
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    _starView.commentPoint = (point.x - 85) / (self.starView.starHeight + self.starView.spaceWidth);
    [self setNeedsDisplay];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
