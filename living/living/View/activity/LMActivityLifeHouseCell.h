//
//  LMActivityLifeHouseCell.h
//  living
//
//  Created by WangShengquan on 2017/2/22.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BtnPressedBlock)(NSInteger buttonTag);

@interface LMActivityLifeHouseCell : UITableViewCell

@property (nonatomic, copy)BtnPressedBlock btnPressedBlock;


@end
