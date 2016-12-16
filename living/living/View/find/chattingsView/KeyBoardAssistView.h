//
//  KeyBoardAssistView.h
//  chatting
//
//  Created by JamHonyZ on 2016/12/13.
//  Copyright © 2016年 Dlx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol assistViewSelectItemDelegate <NSObject>

-(void)assistViewSelectItem:(NSInteger)item;

@end

@interface KeyBoardAssistView : UIView

@property(nonatomic,assign)id<assistViewSelectItemDelegate>delegate;
@end
