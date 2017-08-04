//
//  LMChargeButton.h
//  living
//
//  Created by Ding on 2016/11/3.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LMChargeButton : UIButton

@property(nonatomic,strong)UILabel *upLabel;

@property(nonatomic,strong)UILabel *downLabel;

@property(nonatomic,strong)UILabel *midLabel;

@property (nonatomic, assign) NSInteger type;

@end
