//
//  HotArticleCell.h
//  living
//
//  Created by Huasheng on 2017/2/22.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMActicleVO.h"
@interface HotArticleCell : UITableViewCell

@property (nonatomic, assign)NSInteger cellType;

@property (nonatomic, strong) NSString * type;

-(void)setValue:(LMActicleVO *)list;

@end
