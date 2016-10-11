//
//  LMhomePageCell.h
//  living
//
//  Created by Ding on 16/9/26.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMActicleList.h"

@interface LMhomePageCell : UITableViewCell
@property (nonatomic, strong)NSString *imageUrl;

//@property (nonatomic, strong)NSString *titleString;

@property (nonatomic, strong)NSString *name;

@property (nonatomic, strong)NSString *time;

@property (nonatomic, readonly) float xScale;
@property (nonatomic, readonly) float yScale;

- (void)setXScale:(float)xScale yScale:(float)yScale;

-(void)setValue:(LMActicleList *)list;

@end
