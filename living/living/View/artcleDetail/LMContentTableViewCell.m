//
//  LMContentTableViewCell.m
//  living
//
//  Created by Ding on 2016/12/8.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMContentTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "FitConsts.h"

@interface LMContentTableViewCell ()
{
    UIImageView *imageView;
    UILabel *contentLabel;
    NSDictionary *attributes2;
    CGFloat conHighs;
    NSMutableArray *hightArray;
    NSArray *imageArray;
}

@end

@implementation LMContentTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self    = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self addSubviews];
        
    }
    return self;
}

- (void)addSubviews
{
    contentLabel = [UILabel new];
    contentLabel.textColor = TEXT_COLOR_LEVEL_2;
    contentLabel.numberOfLines=0;
    [self.contentView addSubview:contentLabel];
}

- (void)setValue:(BlendVO *)vo
{
    NSLog(@"%@",vo.content);
    contentLabel.text = vo.content;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    if (contentLabel.text!=nil) {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:contentLabel.text];
        
        [paragraphStyle setLineSpacing:7];
        [paragraphStyle setParagraphSpacing:10];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, contentLabel.text.length)];
        contentLabel.attributedText = attributedString;
    }
    if (_typeIndex==1) {
        contentLabel.font = [UIFont systemFontOfSize:18.0];
        attributes2 = @{NSFontAttributeName:[UIFont systemFontOfSize:18.0],NSParagraphStyleAttributeName:paragraphStyle};
    }
    if (_typeIndex==2) {
        contentLabel.font = TEXT_FONT_LEVEL_1;
        attributes2 = @{NSFontAttributeName:[UIFont systemFontOfSize:16.0],NSParagraphStyleAttributeName:paragraphStyle};
    }
    if (_typeIndex==3) {
        contentLabel.font = [UIFont systemFontOfSize:14.0];
        attributes2 = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0],NSParagraphStyleAttributeName:paragraphStyle};
    }
    
    conHighs = [contentLabel.text boundingRectWithSize:CGSizeMake(kScreenWidth-30, 100000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes2 context:nil].size.height;
    
    
    if (vo.images) {
        
        imageArray =vo.images;
        hightArray = [NSMutableArray new];
        for (int i = 0; i<imageArray.count; i++) {
            
            NSDictionary *dic = imageArray[i];
            
            CGFloat imageVH = [dic[@"height"] floatValue];
            CGFloat imageVW = [dic[@"width"] floatValue];
            CGFloat imageViewH = kScreenWidth*imageVH/imageVW;
            
            UIImageView *headImage = [UIImageView new];
            [headImage sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"url"]] placeholderImage:[UIImage imageNamed:@"BackImage"]];
            headImage.backgroundColor = BG_GRAY_COLOR;
            
            headImage.contentMode = UIViewContentModeScaleAspectFill;
            [headImage setClipsToBounds:YES];
            
            headImage.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapimageAction:)];
            headImage.tag = i;
            [headImage addGestureRecognizer:tap];
            headImage.userInteractionEnabled = YES;
            [headImage sizeToFit];
            if (i>0) {
                headImage.frame = CGRectMake(15, [hightArray[i-1] floatValue], kScreenWidth-30, imageViewH);
            }else{
                headImage.frame = CGRectMake(15, 20 + conHighs, kScreenWidth-30, imageViewH);
            }
            
            NSString *string = [NSString stringWithFormat:@"%f",imageViewH+headImage.frame.origin.y+5];
            
            [hightArray addObject:string];
            
            [self.contentView addSubview:headImage];
            
        }
        
    }
}


- (void)layoutSubviews
{
    [contentLabel sizeToFit];
    contentLabel.frame = CGRectMake(15, 10, kScreenWidth-30, conHighs);
}


- (void)tapimageAction:(UITapGestureRecognizer *)sender
{
    [self.delegate  clickViewTag:self.tag andSubViewTag:sender.view.tag];
}


@end
