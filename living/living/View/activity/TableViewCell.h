//
//  TableViewCell.h
//  TFSearchBar
//
//  Created by TF_man on 16/5/19.
//  Copyright © 2016年 TF_man. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TFTableViewDlegate <NSObject>

- (void)TableViewSelectorIndix:(NSString *)str;


@end

@interface TableViewCell : UITableViewCell

@property (nonatomic,strong)NSArray *cellArr;

@property (nonatomic,assign)id<TFTableViewDlegate> delegate;

@end
