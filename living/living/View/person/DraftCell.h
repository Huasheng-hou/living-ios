//
//  DraftCell.h
//  living
//
//  Created by hxm on 2017/7/13.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DraftCellDelegate <NSObject>

- (void)deleteItemWithTag:(NSInteger)index;

@end

@interface DraftCell : UITableViewCell

@property (nonatomic, weak) id<DraftCellDelegate> delegate;

- (void)setData:(NSDictionary *)dict;

@end
