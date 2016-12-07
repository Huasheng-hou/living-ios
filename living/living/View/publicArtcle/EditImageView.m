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
        [self setBackgroundColor:[UIColor clearColor]];
        [self contentWithView:array andY:y];
    }
    return self;
}

-(void)contentWithView:(NSArray *)imageArray andY:(CGFloat)y
{
    if (imageArray.count<=0) {
        return;
    }
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    NSInteger margin=10;//图片之间的间隔
    NSInteger imageWidth=(kScreenWidth-margin*5)/4;//图片的宽度，固定一行只放置4个图片
    NSInteger deleteBtW=25;//删除小图标的宽度（宽等于高）
    NSInteger columnNum=4;//列数

    //设置图片
    for (int i=0; i<=imageArray.count; i++) {
        if (i == imageArray.count) {
             NSInteger rowNum=(imageArray.count/(columnNum+1))+1;
            [self setFrame:CGRectMake(0, y, kScreenWidth, (imageWidth+margin)*rowNum)];
            
            [self createAddButton:CGRectMake(margin*((i%columnNum)+1)+imageWidth*(i%columnNum), (imageWidth+margin)*(i/columnNum), imageWidth, imageWidth)];
    
            return;
        }

        
        UIImageView *imageV=[[UIImageView alloc]initWithFrame:CGRectMake(margin*((i%columnNum)+1)+imageWidth*(i%columnNum), (imageWidth+margin)*(i/columnNum), imageWidth, imageWidth)];
        [imageV.layer setCornerRadius:5.0f];
        [imageV.layer setMasksToBounds:YES];
        [imageV setTag:i];
        [imageV setContentMode:UIViewContentModeScaleAspectFill];
        [imageV setClipsToBounds:YES];
        [imageV setImage:[UIImage imageNamed:imageArray[i]]];
        [self addSubview:imageV];
        //删除按钮
        UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(imageV.bounds.size.width-deleteBtW, 0, deleteBtW, deleteBtW)];
        [button setBackgroundColor:[UIColor colorWithRed:38/255.0f green:38/255.0f blue:38/255.0f alpha:0.7f]];
        [button setTag:i];
        [button setHidden:YES];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [imageV addSubview:button];
    }
}

-(void)buttonAction:(UIButton *)sender
{
    NSLog(@"================删除按钮==========%ld",(long)sender.tag);
}

-(void)addImageAction:(UIButton *)sender
{
    NSLog(@"==========增加按钮================");
}

-(void)createAddButton:(CGRect)frame
{
    UIButton *button=[[UIButton alloc]initWithFrame:frame];
    [button setBackgroundColor:[UIColor redColor]];
    [button addTarget:self action:@selector(addImageAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setHidden:YES];
    [button.layer setCornerRadius:button.frame.size.width/2];
    [button.layer setMasksToBounds:YES];
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
