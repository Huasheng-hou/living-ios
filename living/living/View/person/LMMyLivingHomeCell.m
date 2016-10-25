//
//  LMMyLivingHomeCell.m
//  living
//
//  Created by Ding on 2016/10/25.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMMyLivingHomeCell.h"
#import "FitConsts.h"
#import "UIImageView+WebCache.h"

@interface LMMyLivingHomeCell () {
    float _xScale;
    float _yScale;
}

@property(nonatomic,strong)UIImageView *imgView;

@end

@implementation LMMyLivingHomeCell


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
    _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 190)];
    _imgView.backgroundColor = [UIColor grayColor];
    _imgView.image = [UIImage imageNamed:@"112"];
    [self.contentView addSubview:_imgView];
    
}
- (void)setXScale:(float)xScale yScale:(float)yScale
{
    _xScale = xScale;
    _yScale = yScale;
}

-(void)layoutSubviews
{
    
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
