//
//  LMChooseView.h
//  living
//
//  Created by Ding on 2016/12/13.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomButton.h"
#import "LMVoiceDetailVO.h"

@protocol LMChooseViewDelegate;

@protocol LMChooseViewDelegate <NSObject>
-(void)LMChooseViewSelectItem;
- (void)LMChooseViewClose;
@end

@interface LMChooseView : UIView
{
    int count ;
    UILabel *_numLabel;
    
    CustomButton *_recordButton;
    CustomButton *_recordSizeButton;
}

@property (nonatomic , strong)NSString *size;
@property (nonatomic , strong)NSString *color;

@property (nonatomic , strong)UIView *bottomView;
@property (nonatomic , strong)UIScrollView *scroll;

@property (nonatomic , strong)UIImageView *productImage;
@property (nonatomic , strong)NSArray *infoArray;
@property (nonatomic ,strong)UILabel *tipLabel;

@property (nonatomic , strong)UIControl *control;

@property(nonatomic,strong)id<LMChooseViewDelegate>delegate;

@property(nonatomic,strong)UILabel *titleLabel;//价格
@property(nonatomic,strong)UILabel *title2;//价格
@property(nonatomic,strong)UILabel *inventory;//库存
@property(nonatomic,strong)UILabel *dspLabel;

@property(nonatomic,strong)NSString *string;

@property(nonatomic,strong)CustomButton *addButton;
@property(nonatomic,strong)CustomButton *reduceButotn;

@property(nonatomic,strong)NSMutableDictionary *orderInfo;
@property (nonatomic, retain) LMVoiceDetailVO     *event;

- (id)initWithFrame:(CGRect)frame;

@end
