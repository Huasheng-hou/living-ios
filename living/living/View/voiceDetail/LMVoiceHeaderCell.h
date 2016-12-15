//
//  LMVoiceHeaderCell.h
//  living
//
//  Created by Ding on 2016/12/13.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "LMVoiceDetailVO.h"

@protocol  LMVoiceHeaderCellDelegate;

@interface LMVoiceHeaderCell : UITableViewCell

@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong)UIButton *joinButton;
@property (nonatomic, strong)LMVoiceDetailVO *voiceVO;

@property (nonatomic, weak) id <LMVoiceHeaderCellDelegate> delegate;

@property (nonatomic, readonly) float xScale;
@property (nonatomic, readonly) float yScale;

- (void)setXScale:(float)xScale yScale:(float)yScale;

-(void)setValue:(LMVoiceDetailVO *)event;

+ (CGFloat)cellHigth:(NSString *)titleString imageArray:(NSArray *)array;

@end

@protocol LMVoiceHeaderCellDelegate <NSObject>

@optional
- (void)cellWillApply:(LMVoiceHeaderCell *)cell;

- (void)cellClickImage:(LMVoiceHeaderCell *)cell;



@end
