//
//  MJPhotoBrowser.h
//
//  Created by mj on 13-3-4.
//  Copyright (c) 2013年 itcast. All rights reserved.

#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>

@protocol MJPhotoBrowserDelegate;

@interface MJPhotoBrowser : UIViewController
<
UIScrollViewDelegate,
UIActionSheetDelegate,
MBProgressHUDDelegate
>

@property (nonatomic, weak) id<MJPhotoBrowserDelegate> delegate;
@property (nonatomic, strong) NSArray *photos;
@property (nonatomic, assign) NSUInteger currentPhotoIndex;

- (void)show;

@end

@protocol MJPhotoBrowserDelegate <NSObject>

@optional

- (void)photoBrowser:(MJPhotoBrowser *)photoBrowser didChangedToPageAtIndex:(NSUInteger)index;

@end
