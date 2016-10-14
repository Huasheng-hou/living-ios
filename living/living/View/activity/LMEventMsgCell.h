//
//  LMEventMsgCell.h
//  living
//
//  Created by Ding on 16/10/13.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMEventDetailEventProjectsBody.h"

@interface LMEventMsgCell : UITableViewCell

@property (nonatomic)CGFloat conHigh;
@property (nonatomic)CGFloat dspHigh;

@property (nonatomic, readonly) float xScale;
@property (nonatomic, readonly) float yScale;

- (void)setXScale:(float)xScale yScale:(float)yScale;

-(void)setValue:(LMEventDetailEventProjectsBody *)data;

+ (CGFloat)cellHigth:(NSString *)titleString;

@end
