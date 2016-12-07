//
//  LMSegmentView.h
//  living
//
//  Created by JamHonyZ on 2016/12/7.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol itemTypeDelegate <NSObject>

-(void)selectedItem:(NSInteger)item;

@end

@interface LMSegmentView : UIView

@property(nonatomic,strong)id<itemTypeDelegate>delegate;

-(instancetype)initWithViewHeight:(CGFloat)height;
@end
