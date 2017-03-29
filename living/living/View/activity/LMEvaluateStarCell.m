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
@property (nonatomic, strong) UIView *starView;
@property (nonatomic, strong) UITextView *commentText;
@property (nonatomic, strong) UILabel *placeholderLbl;
@property (nonatomic, strong) UIView *whiteView;

@end

@implementation LMEvaluateStarCell
{
    NSMutableArray * _imgArray;
}

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
    
    _starView = [[UIView alloc]initWithFrame:CGRectMake(85, 14, kScreenWidth - 110, 22)];
    _starView.userInteractionEnabled = YES;
    [self.contentView addSubview:_starView];
    [self addStarsInView:_starView];
    
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
//添加星星图案
- (void)addStarsInView:(UIView *)superView
{
    if (!_imgArray) {
        _imgArray = [[NSMutableArray alloc] init];
    }
    for (int i=0; i<5; i++) {
        UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(i*(20+10), 0, 20, 20)];
        image.image = [UIImage imageNamed:@"Star"];
        image.tag = i;
        image.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapStar:)];
        [image addGestureRecognizer:tap];
        
        [_imgArray addObject:image];
        [superView addSubview:image];
    }
    
}
//点击星星事件
- (void)tapStar:(UITapGestureRecognizer *)tap{
    
    for (UIImageView * img in _imgArray) {
        if (img.tag > tap.view.tag) {
            img.image = [UIImage imageNamed:@"Star"];
        }else{
            img.image = [UIImage imageNamed:@"in"];
        }
    }
    
    [self.delegate getStarValue:tap.view.tag+1];
    
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

#pragma mark - textview代理
- (void)textViewDidChange:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        _placeholderLbl.text = @"说点什么吧，您的评价很重要哦！";
    }else{
        _placeholderLbl.text = @"";
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
    [self.delegate getCommentText:textView.text];
}





@end
