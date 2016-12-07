//
//  FitChatFaceView.h
//  FitTrainer
//
//  Created by JamHonyZ on 15/10/13.
//  Copyright (c) 2015年 Huasheng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^FaceBlock) (UIImage *image, NSString *imageID);

@interface FitChatFaceView : UIView

//图片对应的文字
@property (nonatomic, strong) NSString *imageID;
//表情图片
@property (nonatomic, strong) UIImage *headerImage;

//设置block回调
- (void)setFaceBlock:(FaceBlock)block;

//设置图片，文字
- (void)setImage:(UIImage *) image ImageID:(NSString *)ID;


@end
