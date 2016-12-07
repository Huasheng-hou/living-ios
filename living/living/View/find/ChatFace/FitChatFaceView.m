//
//  FitChatFaceView.m
//  FitTrainer
//
//  Created by JamHonyZ on 15/10/13.
//  Copyright (c) 2015年 Huasheng. All rights reserved.
//

#import "FitChatFaceView.h"

@interface FitChatFaceView ()

@property(strong, nonatomic) FaceBlock block;
@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation FitChatFaceView

//初始化图片
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, frame.size.width - 10, frame.size.height - 10)];
        self.imageView.contentMode  = UIViewContentModeScaleAspectFit;
        
        [self addSubview:self.imageView];
    }
    return self;
}

- (void)setFaceBlock:(FaceBlock)block
{
    self.block = block;
}

- (void)setImage:(UIImage *)image ImageID:(NSString *)ID
{
    //显示图片
    [self.imageView setImage:image];
    
    //把图片存储起来
    self.headerImage = image;
    
    self.imageID = ID;
}

//点击时回调
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    //判断触摸的结束点是否在图片中
    if (CGRectContainsPoint(self.bounds, point))
    {
        //回调,把该头像的信息传到相应的controller中
        self.block(self.headerImage, self.imageID);
    }
}

@end
