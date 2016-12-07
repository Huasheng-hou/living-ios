//
//  EditImageView.h
//  manage
//
//  Created by JamHonyZ on 2016/12/5.
//  Copyright © 2016年 Dlx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditImageView : UIView

-(instancetype)initWithStartY:(CGFloat)y andImageArray:(NSArray *)array;

//判断图片编辑状态
-(void)pictureEditState:(BOOL)state;

-(void)contentWithView:(NSArray *)imageArray andY:(CGFloat)y;
@end
