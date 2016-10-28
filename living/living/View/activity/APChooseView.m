//
//  APChooseView.m
//  apparel
//
//  Created by Ding on 16/7/26.
//  Copyright © 2016年 Huasheng. All rights reserved.
//

#import "APChooseView.h"
#import "FitConsts.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "UIImageView+WebCache.h"

@implementation APChooseView
{
    NSInteger totalNumber;
    NSInteger totalNum;

    MBProgressHUD *stateHud;
    
    NSString *stock;
    
    UILabel *sizeLabel;
    UILabel *colorLabel;
    UILabel *countLabel;
    UILabel *lineLabel2;
    
    NSInteger _sizeIndex;
    NSInteger _colorIndex;
    
}
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        

    
        [self setBackgroundColor:[UIColor colorWithRed:38/255.0f green:38/255.0f blue:38/255.0f alpha:0.6f]];
        //control 点击屏幕上方 View消失
        self.control = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height-280)];
        [self.control addTarget:self action:@selector(controlClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.control];
        
        //白板位置
        self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight,self.bounds.size.width , 465)];
        self.bottomView.backgroundColor = [UIColor whiteColor];
        self.bottomView.tag = 1000;
        [self addSubview:self.bottomView];
        
        //退出按钮
        UIButton *exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        exitButton.frame = CGRectMake(self.bounds.size.width-40, 10, 30, 30);
        [exitButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [exitButton addTarget:self action:@selector(controlClick) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:exitButton];
        
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(15, -25, 120, 120)];
        headView.backgroundColor = [UIColor whiteColor];
        headView.layer.cornerRadius = 5;
        headView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        headView.layer.borderWidth = 0.5;
        [self.bottomView addSubview:headView];
        
        //图片
        self.productImage = [[UIImageView alloc]initWithFrame:CGRectMake(3,3 , 114, 114)];
        self.productImage.layer.cornerRadius = 5;
        [self.productImage setContentMode:UIViewContentModeScaleAspectFill];
        [self.productImage setClipsToBounds:YES];
        [headView addSubview:self.productImage];
        //价格
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(150, 30, 150, 30)];
        _titleLabel.text = @"￥:0";
        _titleLabel.textColor = LIVING_REDCOLOR;
        _titleLabel.font = [UIFont systemFontOfSize:17];
        [self.bottomView addSubview:_titleLabel];
        
        //活动人数
        _inventory = [[UILabel alloc]initWithFrame:CGRectMake(150, 65, 150, 20)];
        _inventory.text = @"活动人数 ";
        _inventory.font = [UIFont systemFontOfSize:14];
        [self.bottomView addSubview:_inventory];
        
        //分界线
        UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,150, kScreenWidth, 0.5)];
        lineLabel.backgroundColor = [UIColor lightGrayColor];
        [self.bottomView addSubview:lineLabel];


        //报名须知
        sizeLabel = [UILabel new];
        sizeLabel.text = @"报名须知";
        sizeLabel.textColor = TEXT_COLOR_LEVEL_1;
//        sizeLabel.textAlignment = NSTextAlignmentCenter;
        sizeLabel.font = [UIFont systemFontOfSize:15];
        [sizeLabel sizeToFit];
        sizeLabel.frame = CGRectMake(10, 170, sizeLabel.bounds.size.width, 20);
        [self.bottomView addSubview:sizeLabel];
        
        //
        colorLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 200, kScreenWidth-30,60)];
        colorLabel.numberOfLines = 0;
        colorLabel.text = @"报名须知报名须知报名须知报名须知报名须知报名须知报名须知报名须知报名须知报名须知";
        colorLabel.textColor = [UIColor lightGrayColor];
        
//        colorLabel.textAlignment = NSTextAlignmentCenter;
        colorLabel.font = [UIFont systemFontOfSize:15];
        [self.bottomView addSubview:colorLabel];
        
        
        //数量
        countLabel = [UILabel new];
        countLabel.text = @ "报名数量";
        countLabel.textColor = TEXT_COLOR_LEVEL_1;
        countLabel.textAlignment = NSTextAlignmentCenter;
        countLabel.font = [UIFont systemFontOfSize:15];
        [countLabel sizeToFit];
        countLabel.frame = CGRectMake(10, 300, countLabel.bounds.size.width, 20);
        
        [self.bottomView addSubview:countLabel];
        //增加按钮
        _addButton = [CustomButton buttonWithType:UIButtonTypeCustom];
        _addButton.frame = CGRectMake(kScreenWidth-50, 300, 35, 30);
        _addButton.titleLabel.font = [UIFont systemFontOfSize:20];
        _addButton.backgroundColor = LIVING_COLOR;
        [_addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_addButton setTitle:@"+" forState:0];;
        [_addButton addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:_addButton];
        //减少
        _reduceButotn = [CustomButton buttonWithType:UIButtonTypeCustom];
        _reduceButotn.frame = CGRectMake(kScreenWidth-155, 300, 35, 30);
        [_reduceButotn setTitle:@"-" forState:0];
        _reduceButotn.backgroundColor = LIVING_COLOR;
        [_reduceButotn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _reduceButotn.titleLabel.font = [UIFont systemFontOfSize:20];
        [_reduceButotn addTarget:self action:@selector(reduceButotnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:_reduceButotn];
        
        _numLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-110, 300, 50, 30)];
        _numLabel.text = @"1";
        _numLabel.backgroundColor = LIVING_COLOR;
        _numLabel.textColor = [UIColor whiteColor];
        


        _numLabel.textAlignment = NSTextAlignmentCenter;
        _numLabel.adjustsFontSizeToFitWidth = YES;
        
        [self.bottomView addSubview:_numLabel];
        //初始数量为1
        count = 1;
        UIButton *joinButton= [UIButton buttonWithType:UIButtonTypeCustom];
        joinButton.frame = CGRectMake(0, self.bottomView.frame.size.height-50,kScreenWidth, 50);
        [joinButton setBackgroundColor:LIVING_COLOR];
        [joinButton setTitleColor:[UIColor whiteColor] forState:0];
        joinButton.titleLabel.font = [UIFont systemFontOfSize:20];
        [joinButton setTitle:@"确定" forState:0];
        [self.bottomView addSubview:joinButton];
        
        [joinButton addTarget:self action:@selector(exitButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

#pragma mark 加入购物车按钮执行方法

- (void)exitButtonClick {

    totalNumber = [[_orderInfo objectForKey:@"total_number"] intValue];
    totalNum = [[_orderInfo objectForKey:@"total_num"] intValue];
    //订购数量
    NSInteger num=[_numLabel.text integerValue];
    //库存
    NSInteger stockNum=totalNum-totalNumber;
    
    
    if (num>stockNum) {
        [self textStateHUD:@"剩余活动人数不足"];
        return;
    }
    
    
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithObjectsAndKeys:_numLabel.text,@"num", nil] ;
    //
    [[NSNotificationCenter defaultCenter] postNotificationName:@"purchase" object:dic];
    
    
    UIView *view = [self viewWithTag:1000];
    __weak APChooseView *weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        
        view.frame = CGRectMake(0, self.bounds.size.height,self.bounds.size.width, 280);
        [weakSelf setAlpha:0.0f];
    } completion:^(BOOL finished) {
        
        [weakSelf removeFromSuperview];
    }];
    
}

#pragma mark 关闭按钮

- (void)controlClick {
    
    __weak APChooseView *weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        self.bottomView.frame = CGRectMake(0, self.bounds.size.height+280, self.bounds.size.width, 280);
        [weakSelf setAlpha:0.0f];
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}




- (void)addButtonClick:(CustomButton *)sender {
    
    count+=1;
    _numLabel.text = [NSString stringWithFormat:@"%@",@(count)];
    if (_reduceButotn.isRed == NO) {
        
        [_reduceButotn setBackgroundImage:[UIImage imageNamed:@"button_product_numbersub"] forState:UIControlStateNormal];
        _reduceButotn.isRed = YES;
        
    }
}

- (void)reduceButotnClick {
    count-=1;
    if (count <=1) {
        [_reduceButotn setBackgroundImage:[UIImage imageNamed:@"button_product_numbersub_enable"] forState:UIControlStateNormal];
        count = 1;
        _numLabel.text = [NSString stringWithFormat:@"%@",@(count)];
        _recordButton.isRed = NO;
        return;
    }
    _numLabel.text = [NSString stringWithFormat:@"%@",@(count)];
    
}


#pragma mark 计算价格方法

//-(NSString *)calcutePrice
//{
//    if ([style isEqualToString:@"buyout"]) {//买断
//         NSNumber *priceNumber=(NSNumber *)self.priceArray[0];
//        return [NSString stringWithFormat:@"￥%.2f",[priceNumber floatValue]];
//    }else if ([style isEqualToString:@"consignment"])//代销
//    {
//       NSNumber *priceNumber=(NSNumber *)self.priceArray[1];
//       return [NSString stringWithFormat:@"￥%.2f",[priceNumber floatValue]];
//    }
//    return @"￥0";
//}


#pragma mark 显示价格及库存

//-(void)visiablePriceAndStock
//{
////    NSString *priceString=[self calcutePrice];
//    _titleLabel.text=priceString;
//    //库存
//    _inventory.text=[NSString stringWithFormat:@"库存 %@件",stock];
//    
////     NSLog(@"==========picture===========%@  %ld   %ld",stock,(long)sizeValue,(long)colorValue);
//    if ([stock integerValue]!=0&&sizeValue>=0&&colorValue>=0) {
//       
////        NSLog(@"满足条件%@",self.allGoodsInfo);
//        for (NSDictionary *dic in self.allGoodsInfo) {
//            if ([dic[@"goodsColor"] isEqualToString: _styleArray[colorValue]]&&[dic[@"goodsSize"] isEqualToString:_sizeArray[sizeValue]]) {
////                NSLog(@"==========picture===========%@",dic[@"picture"]);
//                
//                if (dic[@"picture"]) {//图片
//                    [self.productImage sd_setImageWithURL:[NSURL URLWithString:dic[@"picture"]]];
//                }
//
//            }
//        }
//    }
//}

- (void)textStateHUD:(NSString *)text
{
    if (!text || ![text isKindOfClass:[NSString class]]) {
        return;
    }
    
    if (!stateHud) {
        stateHud = [[MBProgressHUD alloc] initWithView:self];
        [self addSubview:stateHud];
    }
    stateHud.mode = MBProgressHUDModeText;
    stateHud.opacity = 0.4;
    stateHud.labelText = text;
    stateHud.labelFont = [UIFont systemFontOfSize:12.0f];
    [stateHud show:YES];
    [stateHud hide:YES afterDelay:0.8];
}



@end
