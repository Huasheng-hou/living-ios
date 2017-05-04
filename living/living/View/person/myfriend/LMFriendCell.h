//
//  LMFriendCell.h
//  living
//
//  Created by Ding on 2016/11/4.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMFriendVO.h"

@interface LMFriendCell : UITableViewCell

@property (nonatomic, strong)UIImageView *headImage;

@property (nonatomic, strong)UILabel *addressLabel;

@property (nonatomic, strong)UILabel *nameLabel;

@property (nonatomic, strong)UILabel *idLabel;

@property (nonatomic, strong)UIButton * editBtn;

@property (nonatomic, assign) BOOL isEdit;


-(void)setData:(LMFriendVO *)list;



@end
