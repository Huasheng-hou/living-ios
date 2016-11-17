//
//  LMActivityheadCell.h
//  living
//
//  Created by Ding on 16/9/30.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "LMEventBodyVO.h"

@protocol  LMActivityheadCellDelegate;

@interface LMActivityheadCell : UITableViewCell

@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong)UIButton *joinButton;

@property (nonatomic, weak) id <LMActivityheadCellDelegate> delegate;

@property (nonatomic, readonly) float xScale;
@property (nonatomic, readonly) float yScale;

- (void)setXScale:(float)xScale yScale:(float)yScale;

-(void)setValue:(LMEventBodyVO *)event;

@end

@protocol LMActivityheadCellDelegate <NSObject>

@optional
- (void)cellWillApply:(LMActivityheadCell *)cell;

- (void)cellClickImage:(LMActivityheadCell *)cell;

@end
