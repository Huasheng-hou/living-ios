//
//  LMContentTableViewCell.h
//  living
//
//  Created by Ding on 2016/12/8.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlendVO.h"


@protocol LMContentTableViewCellDelegate <NSObject>


-(void)clickViewTag:(NSInteger)viewTag andSubViewTag:(NSInteger)tag;

@end

@interface LMContentTableViewCell : UITableViewCell

@property(nonatomic,assign)NSInteger typeIndex;

@property (nonatomic, weak) id <LMContentTableViewCellDelegate> delegate;
- (void)setValue:(BlendVO *)vo;

@end
