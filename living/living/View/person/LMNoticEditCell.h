//
//  LMNoticEditCell.h
//  living
//
//  Created by Ding on 2016/11/18.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMNoticVO.h"
@interface LMNoticEditCell : UITableViewCell

@property(nonatomic,strong)UIImageView *chooseView;
@property (nonatomic)NSInteger INDEX;



@property (nonatomic, readonly) float xScale;
@property (nonatomic, readonly) float yScale;

- (void)setXScale:(float)xScale yScale:(float)yScale;

-(void)setData:(LMNoticVO *)list;

@end

