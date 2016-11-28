//
//  LMAddressChooseView.h
//  living
//
//  Created by Ding on 2016/11/28.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol addressTypeDelegate <NSObject>

-(void)buttonType:(NSInteger)type;

@end

@interface LMAddressChooseView : UIView

@property(nonatomic ,strong)UIButton *addressButton;

@property(nonatomic ,strong)UITextView *addressTF;

@property(nonatomic ,strong)UILabel *msgLabel;

@property(nonatomic,assign)id<addressTypeDelegate>delegate;

- (id)init;

@end
