//
//  LMCommentCell.h
//  living
//
//  Created by Ding on 16/9/28.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LMCommentCell : UITableViewCell

@property (nonatomic, strong)NSString *imageUrl;

@property (nonatomic, strong)NSString *titleString;

@property (nonatomic, strong)NSString *name;

@property (nonatomic, strong)NSString *time;

@property (nonatomic, strong)NSString *address;

@property (nonatomic) NSInteger count;

@property (nonatomic)CGFloat conHigh;


@property (nonatomic, readonly) float xScale;
@property (nonatomic, readonly) float yScale;

- (void)setXScale:(float)xScale yScale:(float)yScale;

+ (CGFloat)cellHigth:(NSString *)titleString;

@end
