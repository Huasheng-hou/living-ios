//
//  LMActivityCell.h
//  living
//
//  Created by Ding on 16/9/26.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityListVO.h"

@interface LMActivityCell : UITableViewCell

@property (nonatomic, readonly) float xScale;
@property (nonatomic, readonly) float yScale;
@property (nonatomic, retain)   ActivityListVO  *ActivityList;

- (void)setXScale:(float)xScale yScale:(float)yScale;

@end
