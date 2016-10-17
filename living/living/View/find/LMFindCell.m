//
//  LMFindCell.m
//  living
//
//  Created by Ding on 16/9/26.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMFindCell.h"
#import "FitConsts.h"
#import "UIView+frame.h"

@interface LMFindCell (){
    float _xScale;
    float _yScale;
}

@property(nonatomic,retain)UIImageView *headImage;

@property(nonatomic,retain)UILabel *questonLabel;

@property(nonatomic,retain)UILabel *numLabel;

@end

@implementation LMFindCell

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
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(15, 20, 100, 100)];
    headView.layer.cornerRadius = 5;
    headView.backgroundColor = [UIColor whiteColor];
    [self addSubview:headView];
    
    
    
    _headImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    _headImage.contentMode = UIViewContentModeScaleAspectFill;
    _headImage.clipsToBounds = YES;
    [headView addSubview:_headImage];
    
    
    
    UIView *contView = [[UIView alloc] initWithFrame:CGRectMake(116, 20, kScreenWidth-131, 100)];
    contView.backgroundColor = [UIColor whiteColor];
    contView.layer.cornerRadius = 5;
    [self addSubview:contView];
    
    
    _questonLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, kScreenWidth-116-20-15, 60)];
    _questonLabel.font = TEXT_FONT_LEVEL_2;
    _questonLabel.textColor = TEXT_COLOR_LEVEL_2;
    _questonLabel.numberOfLines = 3;
    _questonLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [contView addSubview:_questonLabel];
    
    
    _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 75, kScreenWidth-131-10, 20)];
    _numLabel.textAlignment = NSTextAlignmentRight;
    _numLabel.font = TEXT_FONT_LEVEL_3;
    _numLabel.textColor = TEXT_COLOR_LEVEL_3;
    [contView addSubview:_numLabel];
    _questonLabel.text = @"这是一段什么样的话呢这是一段什么样的话呢这是一段什么样的话呢这是一段什么样的话呢这是一段什么样的话呢这是一段什么样的话呢这是一段什么样的话呢这是一段什么样的话呢";
    
    _numLabel.text =@"得赞数 126";
    _headImage.image = [UIImage imageNamed:@"function"];
    
    
}

-(void)setValue:(LMFindList *)list
{
    _questonLabel.text = list.description;
    
}

- (void)setXScale:(float)xScale yScale:(float)yScale
{
    _xScale = xScale;
    _yScale = yScale;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [_headImage sizeToFit];
    [_questonLabel sizeToFit];
    [_numLabel sizeToFit];

    _headImage.frame =CGRectMake(22.5, 22.5, 50, 50);
    _questonLabel.frame =CGRectMake(10, 5, kScreenWidth-116-20-15, 60);
    _numLabel.frame =CGRectMake(0, 75, kScreenWidth-131-10, 20);
    
}



@end
