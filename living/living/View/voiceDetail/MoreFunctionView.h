//
//  MoreFunctionView.h
//  living
//
//  Created by JamHonyZ on 2016/12/13.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol moreSelectItemDelegate <NSObject>

-(void)moreViewSelectItem:(NSInteger)item;

@end

@interface MoreFunctionView : UIView

@property(nonatomic,strong)id<moreSelectItemDelegate>delegate;

-(instancetype)initWithContentArray:(NSArray *)contentArray andImageArray:(NSArray *)imageArray;
@end
