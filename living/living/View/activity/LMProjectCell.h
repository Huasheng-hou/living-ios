//
//  LMProjectCell.h
//  living
//
//  Created by JamHonyZ on 2016/11/5.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LMProjectCell : UITableViewCell

//@property(nonatomic,strong)UITextField *titleTF;

@property(nonatomic,strong)UITextField *title;


@property(nonatomic,strong)UITextView *includeTF;

@property(nonatomic,strong)UILabel *textLab;

@property(nonatomic,strong)UIButton *eventButton;

@property(nonatomic,strong)UIImageView *imgView;

@property(nonatomic)NSInteger cellndex;

@property(nonatomic,strong)UIButton *deleteBt;

@end
