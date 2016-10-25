//
//  LMMyLivingHomeCell.h
//  living
//
//  Created by Ding on 2016/10/25.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol LMMyLivingHomeCellDelegate;

@interface LMMyLivingHomeCell : UITableViewCell

@property(nonatomic,strong)NSString *Orderuuid;

@property(nonatomic,strong)NSString *priceStr;


@property (nonatomic, weak) id <LMMyLivingHomeCellDelegate> delegate;

@property (nonatomic, readonly) float xScale;
@property (nonatomic, readonly) float yScale;

- (void)setXScale:(float)xScale yScale:(float)yScale;


@end

@protocol LMMyLivingHomeCellDelegate <NSObject>

@optional
- (void)cellWillpay:(LMMyLivingHomeCell *)cell;


@end
