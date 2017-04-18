//
//  LMHomeBannerView.h
//  living
//
//  Created by Huasheng on 2017/2/23.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LMHomeBannerDelegate <NSObject>

- (void)gotoNextPage:(NSInteger)index;

@end
@interface LMHomeBannerView : UIView

@property (nonatomic, strong) id <LMHomeBannerDelegate> delegate;

@end
