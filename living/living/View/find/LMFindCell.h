//
//  LMFindCell.h
//  living
//
//  Created by Ding on 16/9/26.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMFindList.h"

@interface LMFindCell : UITableViewCell



@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *contentLabel;
@property(nonatomic, strong) UILabel *numLabel;

@property(nonatomic,strong) UIImageView *imageview;

@property(nonatomic,strong)UIButton *praiseBt;

@property(nonatomic,strong)UIImageView *thumbIV;


//- (void)setXScale:(float)xScale yScale:(float)yScale;
-(void)setValue:(LMFindList *)list;

-(void)setimagearray:(NSString *)str;
-(void)settitlearray:(NSString *)str;
-(void)setcontentarray:(NSString *)str;



@end
