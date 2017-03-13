//
//  LMActivityApplyCell.h
//  living
//
//  Created by WangShengquan on 2017/2/22.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityListVO.h"
@interface LMActivityApplyCell : UITableViewCell

@property (nonatomic, strong) UIButton *joinBtn;  // 参加按钮

- (void)setVO:(ActivityListVO *)list;
@end
