//
//  CustomToolbar.h
//  chatting
//
//  Created by JamHonyZ on 2016/12/12.
//  Copyright © 2016年 Dlx. All rights reserved.
//

#import <UIKit/UIKit.h>

@class selectItemDelegate;

@protocol selectItemDelegate <NSObject>

-(void)selectItem:(NSInteger)item;

-(void)voiceFinish:(NSURL *)string;

@end

@interface CustomToolbar : UIToolbar

@property(nonatomic,strong)UIImageView *imageV;

@property(nonatomic,strong)UIButton *saybutton;

@property(nonatomic,strong)UILabel *sayLabel;//按住说话

@property(nonatomic,strong)UITextView *inputTextView;

@property(nonatomic,strong)UIButton *addButton;

@property(weak, nonatomic)id<selectItemDelegate> delegate;

@end
