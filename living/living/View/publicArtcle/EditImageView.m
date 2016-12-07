//
//  EditImageView.m
//  manage
//
//  Created by JamHonyZ on 2016/12/5.
//  Copyright © 2016年 Dlx. All rights reserved.
//

#import "EditImageView.h"
#import "FitConsts.h"

@implementation EditImageView

-(instancetype)initWithStartY:(CGFloat)y andImageArray:(NSArray *)array
{
    self=[super init];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self contentWithView:array andY:y];
    }
    return self;
}

-(void)contentWithView:(NSArray *)imageArray andY:(CGFloat)y
{
    
    NSInteger margin=10;//图片之间的间隔
    NSInteger imageWidth=(kScreenWidth-margin*5)/4;//图片的宽度，固定一行只放置4个图片
    NSInteger deleteBtW=25;//删除小图标的宽度（宽等于高）
    NSInteger columnNum=4;//列数
    if (imageArray.count<=0) {
        
        [self setFrame:CGRectMake(0, y, kScreenWidth, imageWidth+margin)];
        
        [self createAddButton:CGRectMake(margin, margin, imageWidth, imageWidth)];
        return;
    }
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
     NSInteger rowNum=(imageArray.count/(columnNum))+1;
     [self setFrame:CGRectMake(0, y, kScreenWidth, (imageWidth+margin)*rowNum)];
    //设置图片
    for (int i=0; i<=imageArray.count; i++) {
        if (i == imageArray.count) {
            [self createAddButton:CGRectMake(margin*((i%columnNum)+1)+imageWidth*(i%columnNum), (imageWidth+margin)*(i/columnNum), imageWidth, imageWidth)];
    
            return;
        }
       
        
        UIImageView *imageV=[[UIImageView alloc]initWithFrame:CGRectMake(margin*((i%columnNum)+1)+imageWidth*(i%columnNum), (imageWidth+margin)*(i/columnNum), imageWidth, imageWidth)];
        [imageV.layer setCornerRadius:5.0f];
        [imageV.layer setMasksToBounds:YES];
        [imageV setTag:i];
        [imageV setContentMode:UIViewContentModeScaleAspectFill];
        [imageV setClipsToBounds:YES];
        [imageV setImage:imageArray[i]];
        imageV.userInteractionEnabled = YES;
        [self addSubview:imageV];
        //删除按钮
        UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(imageV.bounds.size.width-deleteBtW, 0, deleteBtW, deleteBtW)];
        [button setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        
        [button setTag:i];

        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [imageV addSubview:button];
    }
}

-(void)buttonAction:(UIButton *)sender
{
    NSLog(@"================删除按钮==========%ld",(long)sender.tag);
    [self.delegate deleteViewTag:self.tag andSubViewTag:sender.tag];

    
}

-(void)addImageAction:(UIButton *)sender
{
    NSLog(@"==========增加按钮================");
    if ([_delegate respondsToSelector:@selector(addViewTag:)]) {
        [_delegate addViewTag:self.tag];
    }
}

-(void)createAddButton:(CGRect)frame
{
    UIButton *button=[[UIButton alloc]initWithFrame:frame];
    [button setImage:[UIImage imageNamed:@"addImage"] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(addImageAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
}

#pragma mark 判断图片编辑状态
-(void)pictureEditState:(BOOL)state
{
        for (UIView *view in self.subviews) {
            if ([view isKindOfClass:[UIImageView class]]) {
                UIImageView *imageview=(UIImageView *)view;
                
                for (UIView *subView in imageview.subviews) {
                    if ([subView isKindOfClass:[UIButton class]]) {
                        UIButton *deleteBt=(UIButton*)subView;
                
                        if (state) {
                            [deleteBt setHidden:NO];
                        }else{
                            [deleteBt setHidden:YES];
                        }
                    }
                }
                            }
            if ([view isKindOfClass:[UIButton class]]) {
                UIButton *addbutton=(UIButton *)view;
                if (state) {
                    [addbutton setHidden:NO];
                }else{
                    [addbutton setHidden:YES];
                }
            }
        }
}
@end
