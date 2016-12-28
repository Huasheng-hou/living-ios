//
//  LMQuestionTableViewCell.h
//  living
//
//  Created by Ding on 2016/12/19.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMQuestionVO.h"

@protocol  LMQuestionCellDelegate;
@interface LMQuestionTableViewCell : UITableViewCell

- (void)setValue:(LMQuestionVO *)vo;

@property(nonatomic,strong)NSString *roleIndex;

@property (nonatomic, weak) id <LMQuestionCellDelegate> delegate;

+ (CGFloat)cellHigth:(NSString *)titleString;

@end

@protocol LMQuestionCellDelegate <NSObject>

@optional

- (void)cellClickImage:(LMQuestionTableViewCell *)cell;


@end


