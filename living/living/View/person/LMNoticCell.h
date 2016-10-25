//
//  LMNoticCell.h
//  living
//
//  Created by Ding on 16/10/10.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMNoticeList.h"

@interface LMNoticCell : UITableViewCell

@property (nonatomic, strong)NSString *titleString;


@property (nonatomic, strong)NSString *time;

@property (nonatomic, strong)NSString *name;



@property (nonatomic, readonly) float xScale;
@property (nonatomic, readonly) float yScale;

- (void)setXScale:(float)xScale yScale:(float)yScale;

-(void)setData:(LMNoticeList *)list;

@end
