//
//  LMQuestionTableViewCell.h
//  living
//
//  Created by Ding on 2016/12/19.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMQuestionVO.h"

@interface LMQuestionTableViewCell : UITableViewCell

- (void)setValue:(LMQuestionVO *)vo;

+ (CGFloat)cellHigth:(NSString *)titleString;

@end
