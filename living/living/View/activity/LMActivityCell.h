//
//  LMActivityCell.h
//  living
//
//  Created by Ding on 16/9/26.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "LMActivityList.h"

@interface LMActivityCell : UITableViewCell
@property (nonatomic, strong)NSString *imageUrl;

@property (nonatomic, strong)NSString *titleString;

@property (nonatomic, strong)NSString *joinCount;

@property (nonatomic, strong)NSString *price;

@property (nonatomic, strong)NSString *time;

@property (nonatomic, strong)NSString *headUrl;

@property (nonatomic, strong)NSString *name;

@property (nonatomic, strong)NSString *address;


@property (nonatomic, readonly) float xScale;
@property (nonatomic, readonly) float yScale;

- (void)setXScale:(float)xScale yScale:(float)yScale;

//-(void)setValue:(LMActivityList *)list;

@end
