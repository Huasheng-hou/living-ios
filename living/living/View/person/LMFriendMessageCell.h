//
//  LMFriendMessageCell.h
//  living
//
//  Created by Ding on 2017/3/6.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMFriendVO.h"

@interface LMFriendMessageCell : UITableViewCell

@property(nonatomic,strong)UILabel *_textLabel;

@property(nonatomic,strong)LMFriendVO *friendVO;

@property(nonatomic,assign)CGFloat CellHight;

@end
