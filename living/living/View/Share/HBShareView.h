//
//  HBShareView.h
//  HBLive
//
//  Created by JamHonyZ on 2016/10/20.
//  Copyright © 2016年 Hou Huasheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol shareTypeDelegate <NSObject>

-(void)shareType:(NSInteger)type;

@end

@interface HBShareView : UIView

@property(nonatomic,assign)id<shareTypeDelegate>delegate;

@end
