//
//  LMEvaluateSubmitCell.h
//  living
//
//  Created by WangShengquan on 2017/2/24.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SubmitSelectedBlock)();

@interface LMEvaluateSubmitCell : UITableViewCell

@property (nonatomic, copy)SubmitSelectedBlock submitSelectedBlock;

@end
