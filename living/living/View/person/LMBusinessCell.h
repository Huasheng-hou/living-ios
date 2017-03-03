//
//  LMBusinessCell.h
//  living
//
//  Created by Ding on 2016/11/10.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LMBusinessCell : UITableViewCell
<
UITextFieldDelegate
>

@property(nonatomic,strong)UITextField *NumTF;
@property(nonatomic,strong)UITextField *NameTF;

@end
