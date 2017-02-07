//
//  LMNoticCell.h
//  living
//
//  Created by Ding on 16/10/10.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMNoticVO.h"

@interface LMNoticCell : UITableViewCell

@property (nonatomic)NSInteger INDEX;

@property (nonatomic, readonly) float xScale;
@property (nonatomic, readonly) float yScale;

- (void)setXScale:(float)xScale yScale:(float)yScale;

-(void)setData:(LMNoticVO *)list name:(NSString *)name;

+ (CGFloat)cellHigth:(NSString *)MyName friendName:(NSString *)friendName type:(NSString *)type sign:(NSString *)sign  title:(NSString *)title content:(NSString *)content;

@end
