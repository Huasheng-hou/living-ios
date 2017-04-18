//
//  LMExpertListCell.h
//  living
//
//  Created by Huasheng on 2017/2/23.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMRecommendExpertVO.h"
@protocol LMExpertListDelegate <NSObject>

- (void)gotoNextPage:(NSInteger)index;

@end
@interface LMExpertListCell : UITableViewCell

@property (nonatomic, assign)NSInteger count;
@property (nonatomic, weak)id <LMExpertListDelegate> delegate;

- (void)setArray:(NSArray *)array;

@end
