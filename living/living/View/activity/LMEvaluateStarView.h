//
//  LMEvaluateStarView.h
//  living
//
//  Created by WangShengquan on 2017/2/24.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,StarAliment) {
    StarAlimentDefault,
    StarAlimentCenter,
    StarAlimentRight
};



@interface LMEvaluateStarView : UIView

//星星的高度
@property (nonatomic, assign) CGFloat starHeight;
//宽度间距
@property (nonatomic, assign) CGFloat spaceWidth;


/**
 评分
 */
@property (nonatomic, assign)float commentPoint;
/**
 对齐方式
 */
@property (nonatomic, assign)StarAliment starAliment;

- (void)changeSelectedStarNumWithPoint:(float)point;


/**
 初始化

 @param frame      frame
 @param totalStar  星星总个数
 @param totalPoint 总分数
 @param space      星星间距

 @return LMEvaluateStarView
 */
-(instancetype)initWithFrame:(CGRect)frame
               withTotalStar:(NSInteger)totalStar
              withTotalPoint:(CGFloat)totalPoint
                   starSpace:(NSInteger)space;


@end
