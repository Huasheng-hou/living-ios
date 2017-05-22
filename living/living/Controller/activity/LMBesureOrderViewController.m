//
//  LMBesureOrderViewController.m
//  living
//
//  Created by Ding on 2016/10/28.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMBesureOrderViewController.h"
#import "LMOrederDeleteRequest.h"
#import "APChooseView.h"
#import "LMOrderpayRequest.h"
#import "LMOrderBodyVO.h"
#import "LMOrderInfoVO.h"

//支付宝
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "LMAliPayRequest.h"
#import "LMAlipayResultRequest.h"

//微信支付
#import "WXApiObject.h"
#import "WXApi.h"
#import "WXApiRequestHandler.h"

#import "LMBalanceChargeRequest.h"

#import "LMWXPayRequest.h"
#import "LMWXPayResultRequest.h"
#import "LMEventBodyVO.h"
#import "UIImageView+WebCache.h"

#import "FitPickerView.h"
#import "LMCouponMsgRequest.h"
#import "LMCouponUseRequest.h"
#import "LMCouponChoseCell.h"
#import "LMCouponVO.h"

@interface LMBesureOrderViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
FitPickerViewDelegate
>
{
    LMOrderInfoVO *orderInfos;
    LMOrderBodyVO *orderdata;
    NSString *rechargeOrderUUID;
    LMEventBodyVO *eventDic;
    NSMutableArray *couponList;
    NSMutableArray *couponIDList;
    UITableView *_couponView;
    UIView *addView;
    UIView *backView;
    NSInteger selectedRow;
    NSMutableArray *couponPriceArray;
    NSString *type;
    
    
    NSMutableArray * selectedArray;
    NSMutableArray * selectedUuid;
    
    NSInteger discountMoney;//可抵扣金额
    
    NSMutableArray * tempSelectedArray;
}

@end

@implementation LMBesureOrderViewController

- (id)init
{
    self = [super init];
    if (self) {
        
        // * 微信支付被用户取消
        //
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(wxPayCanceled)
                                                     name:LM_WECHAT_PAY_CANCEL_NOTIFICATION
                                                   object:nil];
        
        // * 微信支付失败
        //
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(wxPayFailed)
                                                     name:LM_WECHAT_PAY_FAILED_NOTIFICATION
                                                   object:nil];
        
        // * 微信支付结果确认
        //
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(weixinPayEnsure)
                                                     name:LM_WECHAT_PAY_CALLBACK_NOTIFICATION
                                                   object:nil];
        
        // * 支付宝支付结果确认
        //
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(aliPayEnsure:)
                                                     name:@"aliPayEnsure"
                                                   object:nil];
        
        
        selectedArray = [NSMutableArray new];
        selectedUuid = [NSMutableArray new];
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI
{
    [super createUI];
    self.title = @"确认订单";
    selectedRow= 0;
    eventDic =[[LMEventBodyVO alloc] initWithDictionary:_dict];
    
    [self getOrderData];
    
    UIBarButtonItem     *leftItem   = [[UIBarButtonItem alloc] initWithTitle:@"关闭"
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(dismissitemPressed)];
    
    self.navigationItem.leftBarButtonItem   = leftItem;
}

- (void)dismissitemPressed
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:nil];
}

- (void)getOrderData
{
    if (![CheckUtils isLink]) {
        
        [self textStateHUD:@"无网络"];
        return;
    }
    LMOrderpayRequest *request = [[LMOrderpayRequest alloc] initWithOrder_uuid:_orderUUid];
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(getOrderDataResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"网络错误"
                                                                   waitUntilDone:YES];
                                           }];
    [proxy start];
}

- (void)getOrderDataResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    
    [self logoutAction:resp];
    
    if (!bodyDic) {
        
        [self textStateHUD:@"获取数据失败"];
    } else {
        
        if ([[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
            
            orderInfos = [[LMOrderInfoVO alloc] initWithDictionary:[bodyDic objectForKey:@"orderInfo"]];
            orderdata = [[LMOrderBodyVO alloc] initWithDictionary:[bodyDic objectForKey:@"order_body"]];
            
            if ([orderdata.totalMoney integerValue] < 120) {
                discountMoney = 10;
            }
            else if ([orderdata.totalMoney integerValue] < 200) {
                discountMoney = 20;
            }else{
                discountMoney = 30;
            }
            
            if (orderdata.coupons && orderdata.coupons>0) {
                [self getCouponListRequest];
            }
            
            [self.tableView reloadData];
        } else {
            
            [self textStateHUD:[bodyDic objectForKey:@"description"]];
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView==self.tableView) {
        return 2;
    }
    if (tableView==_couponView) {
        return 1;
    }
    return 0;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==self.tableView) {
        if (section == 0) {
            
            return 1;
        }
        if (section == 1) {
        
            if ([_Type isEqualToString:@"voice"]) {
                return 6;
            }else{
                return 7;
            }
        }
    }
    if (tableView==_couponView) {
        return couponList.count+1;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==self.tableView) {
        if (indexPath.section==0) {
            if (orderdata.coupons &&orderdata.coupons>0) {
                return 190;
            }else{
//                return 150;
                return 190;
            }
            
        }
        if (indexPath.section==1) {
            if (indexPath.row==5) {
                return 75;
            }
        }
        return 45;
    }
    if (tableView==_couponView) {
        return 50;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView==self.tableView) {
        
        if (section==1) {
            
            UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
            UILabel *msgLabel = [UILabel new];
            msgLabel.text = @"订单信息";
            msgLabel.font = TEXT_FONT_LEVEL_2;
            msgLabel.textColor = TEXT_COLOR_LEVEL_3;
            [msgLabel sizeToFit];
            msgLabel.frame = CGRectMake(15, 0, kScreenWidth-30, 30);
            [headView addSubview:msgLabel];
            
            return headView;
        }
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView==self.tableView) {
        if (section==0) {
            return 5;
        }
        return 30;
    }
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==self.tableView){
        static NSString *cellID = @"cellID";
        
        if (indexPath.section==0) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(25, 0, 0.5, 35)];
            line1.backgroundColor = LINE_COLOR;
            [cell.contentView addSubview:line1];
            
            UILabel *payLabel = [UILabel new];
            payLabel.text = @"待支付";
            payLabel.font = TEXT_FONT_LEVEL_1;
            [payLabel sizeToFit];
            payLabel.frame = CGRectMake(40, 0, payLabel.bounds.size.width, 35);
            [cell.contentView addSubview:payLabel];
            
            
            
            UILabel *timeLabel = [UILabel new];
            timeLabel.text = orderdata.orderTime;
            timeLabel.font = TEXT_FONT_LEVEL_2;
            timeLabel.textColor = TEXT_COLOR_LEVEL_3;
            [timeLabel sizeToFit];
            timeLabel.frame = CGRectMake(kScreenWidth-15-timeLabel.bounds.size.width, 0, timeLabel.bounds.size.width, 35);
            [cell.contentView addSubview:timeLabel];
            
            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(12, 40, 20, 20)];
            image.image = [UIImage imageNamed:@"rechage-2"];
            [cell.contentView addSubview:image];
            
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 30, kScreenWidth-55, 60)];
            if ([_Type isEqualToString:@"voice"]) {
                titleLabel.text = orderdata.voiceTitle;
            }else{
               titleLabel.text = orderdata.eventName;
            }
            
            titleLabel.numberOfLines = 0;
            titleLabel.font = TEXT_FONT_LEVEL_2;
            titleLabel.textColor = TEXT_COLOR_LEVEL_2;
            [cell.contentView addSubview:titleLabel];
            
            UILabel *perCost = [UILabel new];
            perCost.textColor = TEXT_COLOR_LEVEL_3;
            perCost.font = TEXT_FONT_LEVEL_1;
            NSString *string = [NSString stringWithFormat:@"￥%@", orderInfos.validatedPrice];
            perCost.text = [NSString stringWithFormat:@"%@",string];
            [perCost sizeToFit];
            perCost.frame = CGRectMake(40, 85, perCost.bounds.size.width, 25);
            [cell.contentView addSubview:perCost];
            
            UILabel *perNum = [UILabel new];
            perNum.textColor = TEXT_COLOR_LEVEL_3;
            perNum.font  = TEXT_FONT_LEVEL_3;
            NSString *string2 = [NSString stringWithFormat:@"/人x%d",orderdata.number];
            perNum.text = [NSString stringWithFormat:@"%@",string2];
            [perNum sizeToFit];
            perNum.frame = CGRectMake(40+perCost.bounds.size.width, 85, perNum.bounds.size.width, 25);
            [cell.contentView addSubview:perNum];
            
            
            UILabel *priceLabel = [UILabel new];
            priceLabel.text = [NSString stringWithFormat:@"￥ %@",orderdata.totalMoney];
            priceLabel.font = TEXT_FONT_LEVEL_1;
            priceLabel.textColor = LIVING_REDCOLOR;
            [priceLabel sizeToFit];
            priceLabel.frame = CGRectMake(kScreenWidth-15-priceLabel.bounds.size.width, 85, priceLabel.bounds.size.width, 25);
            [cell.contentView addSubview:priceLabel];
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 115, kScreenWidth, 0.5)];
            line.backgroundColor = LINE_COLOR;
            [cell.contentView addSubview:line];
            
            UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
            cancel.frame = CGRectMake(0, 115.5, kScreenWidth/2, 34.5);
            cancel.titleLabel.font = [UIFont systemFontOfSize:14];
            [cancel setTitleColor:TEXT_COLOR_LEVEL_2 forState:UIControlStateNormal];
            [cancel setTitle:@"取消订单" forState:UIControlStateNormal];
            [cancel addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.contentView addSubview:cancel];
            
            UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth/2-0.5, 115, 0.5, 35)];
            line2.backgroundColor = LINE_COLOR;
            [cell.contentView addSubview:line2];
            
            UIButton *payButton = [UIButton buttonWithType:UIButtonTypeCustom];
            payButton.frame = CGRectMake(kScreenWidth/2+0.25, 115.5, kScreenWidth/2-0.25, 34.5);
            payButton.titleLabel.font = [UIFont systemFontOfSize:14];
            [payButton setTitleColor:LIVING_REDCOLOR forState:UIControlStateNormal];
            [payButton setTitle:@"立即支付" forState:UIControlStateNormal];
            
            
            [payButton addTarget:self action:@selector(payAction) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:payButton];
            
            if (orderdata.coupons||orderdata.coupons>=0) {
                
                UILabel *cPLabel = [UILabel new];
                NSString *couponString;
                if ([orderdata.couponPrice intValue] ==0) {
                    cPLabel.textColor = TEXT_COLOR_LEVEL_3;
                    cPLabel.text = @"未使用优惠券";
                    cPLabel.font = TEXT_FONT_LEVEL_2;
                    couponString = [NSString stringWithFormat:@"优惠券："];
                    if ([orderdata.available isEqualToString:@"1"]) {
                        cPLabel.text = @"不支持使用优惠券";
                    }else if ([orderdata.available isEqualToString:@"3"] ){
                        cPLabel.text = @"无可用优惠券";
                    }else if ([orderdata.available isEqualToString:@"4"]){
                        cPLabel.text = @"无优惠券";
                    }
                }else{
                    cPLabel.textColor = LIVING_REDCOLOR;
                    NSString *cpString =[NSString stringWithFormat:@"抵￥%@",orderdata.couponPrice];
                    
                    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:cpString];
                    
                    [str addAttribute:NSFontAttributeName value:TEXT_FONT_LEVEL_3 range:NSMakeRange(0,1)];
                    [str addAttribute:NSFontAttributeName value:TEXT_FONT_LEVEL_1 range:NSMakeRange(1,cpString.length-1)];
                    cPLabel.attributedText = str;
                }
                
                
                [cell.contentView addSubview:cPLabel];
                
                
                UILabel *couponLabel = [UILabel new];
                int couponNum ;
                
                if ([orderdata.couponPrice intValue] > 0) {
                    if (selectedArray.count > 0) {
                        couponNum = selectedArray.count;
                    }else{
                        couponNum = 1;
                    }
                    couponString = [NSString stringWithFormat:@"优惠券 x%d",couponNum];
                    
                    NSMutableAttributedString *cStr = [[NSMutableAttributedString alloc] initWithString:couponString];
                
                    [cStr addAttribute:NSFontAttributeName value:TEXT_FONT_LEVEL_1 range:NSMakeRange(0,3)];
                    [cStr addAttribute:NSForegroundColorAttributeName value:BLUE_COLOR range:NSMakeRange(0, 3)];
                    [cStr addAttribute:NSFontAttributeName value:TEXT_FONT_LEVEL_3 range:NSMakeRange(3,couponString.length-3)];
                    couponLabel.attributedText = cStr;
                    
                }else{
                    
                    couponLabel.attributedText = nil;
                    
                }
                //couponLabel.textColor = LIVING_COLOR;
                [cell.contentView addSubview:couponLabel];
                
                
                UILabel *cPMoneyLabel = [UILabel new];
                
                cPMoneyLabel.text = [NSString stringWithFormat:@"￥%@",orderdata.couponMoney];
                if (![orderdata.available isEqualToString:@"2"]) {
                    cPMoneyLabel.text = [NSString stringWithFormat:@"¥%@", orderdata.totalMoney];
                }
                cPMoneyLabel.font = [UIFont systemFontOfSize:20];
                cPMoneyLabel.textColor = LIVING_REDCOLOR;
                [cell.contentView addSubview:cPMoneyLabel];
                
                
                [couponLabel sizeToFit];
                couponLabel.frame = CGRectMake(40, 115+2, couponLabel.bounds.size.width, 30);
                [cPLabel sizeToFit];
                cPLabel.frame = CGRectMake(50+couponLabel.bounds.size.width, 117, cPLabel.bounds.size.width, 30);
                
                [cPMoneyLabel sizeToFit];
                cPMoneyLabel.frame = CGRectMake(kScreenWidth-15-cPMoneyLabel.bounds.size.width, 117, cPMoneyLabel.bounds.size.width, 30);
                
                
                
                priceLabel.textColor = TEXT_COLOR_LEVEL_2;
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 12, priceLabel.bounds.size.width, 1.0)];
                lineView.backgroundColor = TEXT_COLOR_LEVEL_2;
                [priceLabel addSubview:lineView];
                line.frame = CGRectMake(0, 112+40, kScreenWidth, 0.5);
                cancel.frame = CGRectMake(0, 112.5+40, kScreenWidth/2, 34.5);
                line2.frame = CGRectMake(kScreenWidth/2-0.5, 112+40, 0.5, 35);
                payButton.frame = CGRectMake(kScreenWidth/2+0.25, 112.5+40, kScreenWidth/2-0.25, 34.5);
                
                UIView *clickView = [[UIView alloc] initWithFrame:CGRectMake(0, 110, kScreenWidth/2, 42)];
                clickView.userInteractionEnabled = YES;
                [cell.contentView addSubview:clickView];
                
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(CouponChose)];
                [clickView addGestureRecognizer:tap];
            }
            
            return cell;
        }
        
        if (indexPath.section == 1) {
            
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
            
            cell.selectionStyle         = UITableViewCellSelectionStyleNone;
            cell.textLabel.textColor    = TEXT_COLOR_LEVEL_2;
            cell.textLabel.font         = TEXT_FONT_LEVEL_2;
            cell.detailTextLabel.font   = TEXT_FONT_LEVEL_2;
            
            switch (indexPath.row) {
                    
                case 0:
                    
                    cell.textLabel.text = @"订单号:";
                    cell.detailTextLabel.text = orderInfos.orderNumber;
                    
                    break;
                case 1:
                    if ([_Type isEqual:@"voice"]) {
                        cell.textLabel.text = @"课程名称:";
                        cell.detailTextLabel.text = orderInfos.voiceTitle;
                    }else{
                        cell.textLabel.text = @"活动名称:";
                        cell.detailTextLabel.text = orderInfos.eventName;
                    }
                    
                    break;
                case 2:
                    
                    cell.textLabel.text = @"参加人数:";
                    cell.detailTextLabel.text =[NSString stringWithFormat:@"%d人",orderInfos.joinNumber];
                    
                    break;
                case 3:
                    
                    cell.textLabel.text = @"平均价格:";
                    
                    if (orderInfos.averagePrice == nil) {
                        
                        cell.detailTextLabel.text = @"";
                    } else {
                        
                        cell.detailTextLabel.text = [NSString stringWithFormat:@"￥%@",orderInfos.averagePrice];
                    }
                    
                    break;
                case 4:
                    cell.textLabel.text = @"订单总价:";
                    if (orderInfos.totalMoney==nil) {
                        cell.detailTextLabel.text = @"";
                    }else{
                        cell.detailTextLabel.text = [NSString stringWithFormat:@"￥%@",orderInfos.totalMoney];
                    }
                    break;
                case 5:
                    if ([_Type isEqual:@"voice"]) {
                        cell.textLabel.text       = @"课程时间:";
                    }else{
                        cell.textLabel.text       = @"活动时间:";
                    }
                    
                    cell.detailTextLabel.numberOfLines  = 3;
                    
                    if (orderInfos.startTime == nil) {
                        
                        cell.detailTextLabel.text = @"";
                    } else {
                        
                        NSDateFormatter     *longFormater   = [[NSDateFormatter alloc] init];
                        NSDateFormatter     *shortFormatter = [[NSDateFormatter alloc] init];
                        
                        [longFormater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                        [shortFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
                        
                        
                        
                        if (orderInfos.endTime) {
                            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@\n至\n%@",
                                                         [shortFormatter stringFromDate:[longFormater dateFromString:orderInfos.startTime]],
                                                         [shortFormatter stringFromDate:[longFormater dateFromString:orderInfos.endTime]]];
                        }else{
                            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",
                                                         [shortFormatter stringFromDate:[longFormater dateFromString:orderInfos.startTime]]];
                            
                        }
                        
                        
                        
                    }
                    
                    break;
                case 6:
                    
                    if (orderInfos.eventAddress == nil) {
                        
                        cell.textLabel.text =@"活动地点：";
                    }
                    
                    cell.textLabel.text             = [NSString stringWithFormat:@"活动地点：%@",orderInfos.eventAddress];
                    cell.textLabel.numberOfLines    = 0;
                    
                    break;
                    
                default:
                    
                    break;
            }
            
            return cell;
        }
        
    }
    if (tableView ==_couponView) {
        static NSString *cellIDD = @"cellIDD";
        LMCouponChoseCell *cell = [[LMCouponChoseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIDD];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        if (indexPath.row<couponList.count) {
            LMCouponVO *vo = couponList[indexPath.row];
            [cell setValue:vo];
            [cell setArray:couponPriceArray index:indexPath.row];
            
        }else{
            cell.nameLabel.text = @"不使用任何优惠券";
            cell.nameLabel.textColor = [UIColor colorWithRed:255.0/255.0 green:180.0/255.0 blue:21.0/255.0 alpha:1.0];
            cell.priceLabel.hidden = YES;
            
        }
        
        if (selectedRow == couponList.count) {
            if (indexPath.row == selectedRow) {
                cell.chooseView.image= [UIImage imageNamed:@"choose"];
            }else{
                cell.chooseView.image= [UIImage imageNamed:@"choose-no"];
            }
        } else {
    
            if ([tempSelectedArray containsObject:[NSNumber numberWithInteger:indexPath.row]]) {
                cell.chooseView.image= [UIImage imageNamed:@"choose"];
            }else{
                cell.chooseView.image = [UIImage imageNamed:@"choose-no"];
            }
            
        }
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView==self.tableView){
        if (indexPath.section==1) {
            if (indexPath.row==7) {
                APChooseView *infoView = [[APChooseView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
                
                infoView.titleLabel.text = [NSString stringWithFormat:@"￥:%@", eventDic.perCost];
                
                infoView.inventory.text = [NSString stringWithFormat:@"活动人数 %d/%d人",eventDic.totalNumber,eventDic.totalNum];
                
                [infoView.productImage sd_setImageWithURL:[NSURL URLWithString:eventDic.eventImg]];
                
                infoView.orderInfo = _dict;
                
                [self.view addSubview:infoView];
                
                UIView *view = [infoView viewWithTag:1000];
                [UIView animateWithDuration:0.2 animations:^{
                    view.frame = CGRectMake(0, kScreenHeight-465,self.view.bounds.size.width, 465);
                }];
            }
        }
    }
    if (tableView ==_couponView){
        //可使用优惠券
        if (indexPath.row<couponList.count) {
            
            selectedRow=indexPath.row;
            
            NSInteger currentMoney = 0;
            
            //数组为空
            if (tempSelectedArray.count == 0) {
                
                NSInteger selectedMoney = [couponPriceArray[selectedRow] integerValue];
                if (currentMoney + selectedMoney > discountMoney) {
                    [self textStateHUD:[NSString stringWithFormat:@"最多抵扣%d元",discountMoney]];
                    return;
                }else{
                    [tempSelectedArray addObject:[NSNumber numberWithInteger:selectedRow]];
                }
            } else {
            
                for (NSNumber * num in tempSelectedArray) {
                    
                    NSInteger money = [couponPriceArray[[num integerValue]] integerValue];
                    currentMoney += money;
                }
                NSNumber * num = [NSNumber numberWithInteger:selectedRow];
                if ([tempSelectedArray containsObject:num]) {
                    [tempSelectedArray removeObject:num];
                }
                else{
                        
                    NSInteger selectedMoney = [couponPriceArray[selectedRow] integerValue];
                    if (currentMoney + selectedMoney > discountMoney) {
                        [self textStateHUD:[NSString stringWithFormat:@"最多抵扣%d元",discountMoney]];
                        return;
                    }else{
                        [tempSelectedArray addObject:[NSNumber numberWithInteger:selectedRow]];
                    }
                    
                }
            }
        } else {
            [tempSelectedArray removeAllObjects];
            //不使用优惠券
            selectedRow=indexPath.row;
        }
        
        [_couponView reloadData];
    }
}

- (void)cancelAction
{
    LMOrederDeleteRequest *request = [[LMOrederDeleteRequest alloc] initWithOrder_uuid:_orderUUid];
    
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(getdeleteDataResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"删除失败，请重试！"
                                                                   waitUntilDone:YES];
                                           }];
    [proxy start];
    
}

- (void)getdeleteDataResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    
    [self logoutAction:resp];
    
    if (!bodyDic) {
        
        [self textStateHUD:@"删除失败"];
    } else {
        
        if ([[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
            
            [self textStateHUD:@"订单取消成功"];
            [self performSelector:@selector(dismissitemPressed) withObject:nil afterDelay:1];
            
        } else {
            
            [self textStateHUD:bodyDic[@"description"]];
        }
    }
}

- (void)payAction
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择支付方式"
                                                                   message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"余额支付" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self balanceChargeRequest];
        
    }]];
    
    if (![orderdata.totalMoney isEqualToString:@"0"] && ![orderdata.couponMoney isEqualToString:@"0"]) {
        
    
    
    [alert addAction:[UIAlertAction actionWithTitle:@"微信支付" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
        NSArray *searchArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"payArr"];
        if (searchArr==nil) {
            [self getagreementCharge:@"wx"];
        }else{
            for (NSString *string in searchArr) {
                if ([string isEqualToString:@"agree"]) {
                    [self wxRechargeRequest];
                }else{
                    [self getagreementCharge:@"wx"];
                }
                
            }
        }
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"支付宝支付"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                
                                                
                                                NSArray *searchArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"payArr"];
                                                if (searchArr==nil) {
                                                    [self getagreementCharge:@"ali"];
                                                }else{
                                                    for (NSString *string in searchArr) {
                                                        if ([string isEqualToString:@"agree"]) {
                                                            [self aliRechargeRequest];
                                                        }else{
                                                            [self getagreementCharge:@"ali"];
                                                        }
                                                        
                                                    }
                                                }

                                                
                                            }]];
        
    }
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                [alert dismissViewControllerAnimated:YES completion:nil];      }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 微信充值下单请求

- (void)wxRechargeRequest
{
    if (![CheckUtils isLink]) {
        
        [self textStateHUD:@"无网络连接"];
        return;
    }
    
    [self initStateHud];
    NSLog(@"%@", orderInfos.orderUuid);
    LMWXPayRequest *request=[[LMWXPayRequest alloc]initWithWXRecharge:orderInfos.orderUuid];
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(wxRechargeResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               [self textStateHUD:@"微信充值下单失败"];
                                           }];
    [proxy start];
}

- (void)wxRechargeResponse:(NSString *)resp
{
    NSDictionary    *bodyDict   = [VOUtil parseBody:resp];
    
    [self logoutAction:resp];
    
    if (!bodyDict) {
        return;
    }
    
    if (bodyDict && [bodyDict objectForKey:@"result"]
        && [[bodyDict objectForKey:@"result"] isKindOfClass:[NSString class]]){
        
        if ([[bodyDict objectForKey:@"result"] isEqualToString:@"0"]){
            [self textStateHUD:@"微信充值下单成功"];
            
            if (bodyDict[@"map"][@"myOrderUuid"]) {
                
                rechargeOrderUUID=bodyDict[@"map"][@"myOrderUuid"];
            }
            if (bodyDict[@"map"][@"wxOrder"]) {
                [self senderWeiXinPay:bodyDict[@"map"][@"wxOrder"]];
            }
        } else {

            [self textStateHUD:[bodyDict objectForKey:@"description"]];
            
            
            
        }
    }
}

#pragma mark 发起第三方微信支付

- (void)senderWeiXinPay:(NSDictionary *)dic
{
    [WXApiRequestHandler jumpToBizPay:dic];
}

#pragma mark 微信支付结果确认

// * 微信支付被取消

- (void)wxPayCanceled
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self textStateHUD:@"支付失败，用户取消"];
        
    });
}

// * 微信支付失败（其它原因）

- (void)wxPayFailed
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self textStateHUD:@"微信支付失败"];
    });
}

- (void)weixinPayEnsure
{
    if (![CheckUtils isLink]) {
        
        [self textStateHUD:@"无网络"];
        return;
    }
    LMWXPayResultRequest *request=[[LMWXPayResultRequest alloc]initWithMyOrderUuid:rechargeOrderUUID];
    
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(weixinPaySuccessEnsureResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               [self textStateHUD:@"数据请求失败"];
                                           }];
    [proxy start];
    
}

- (void)weixinPaySuccessEnsureResponse:(NSString *)resp
{
    NSDictionary    *bodyDict   = [VOUtil parseBody:resp];
    
    if (!bodyDict) {
        [self textStateHUD:@"数据请求失败"];
        return;
    }
    
    if (bodyDict && [bodyDict objectForKey:@"result"]
        && [[bodyDict objectForKey:@"result"] isKindOfClass:[NSString class]]){
        
        if ([[bodyDict objectForKey:@"result"] isEqualToString:@"0"]){
            
            if ([bodyDict[@"trade_state"] isEqualToString:@"SUCCESS"]) {
                
                [self textStateHUD:@"支付成功！"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self dismissViewControllerAnimated:YES completion:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:nil];
                });
                
            } else {
                
                [self textStateHUD:@"支付失败！"];
            }
        } else {
            
            [self textStateHUD:bodyDict[@"description"]];
        }
    }
}

#pragma mark - 支付宝充值下单请求

- (void)aliRechargeRequest
{
    if (![CheckUtils isLink]) {
        
        [self textStateHUD:@"无网络"];
        return;
    }
    
    [self initStateHud];
    
    LMAliPayRequest *request=[[LMAliPayRequest alloc]initWithAliRecharge:orderInfos.orderUuid];
    
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(aliRechargeResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               [self textStateHUD:@"数据请求失败"];
                                           }];
    [proxy start];
}

- (void)aliRechargeResponse:(NSString *)resp
{
    NSDictionary    *bodyDict   = [VOUtil parseBody:resp];
    
    if (!bodyDict) {
        [self textStateHUD:@"数据请求失败"];
        return;
    }
    
    if (bodyDict && [bodyDict objectForKey:@"result"]
        && [[bodyDict objectForKey:@"result"] isKindOfClass:[NSString class]]){
        
        if ([[bodyDict objectForKey:@"result"] isEqualToString:@"0"]){
            [self textStateHUD:@"下单成功"];
            //支付宝支付下单后货物的uuid
            if (bodyDict[@"myOrderUuid"]) {
                rechargeOrderUUID=bodyDict[@"myOrderUuid"];
            }
            
            if (bodyDict[@"aliSignedOrder"]) {
                
                [self senderAliPay:bodyDict[@"aliSignedOrder"]];
            }
            
        } else {
            
                [self textStateHUD:[bodyDict objectForKey:@"description"]];

            
        }
    }
}

#pragma mark - 发起第三方支付宝支付

-(void)senderAliPay:(NSString *)payOrderStr
{
    NSString *appScheme = @"livingApp";
    [[AlipaySDK defaultService] payOrder:payOrderStr fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        
    }];
}

#pragma mark - 支付宝支付结果确认

-(void)aliPayEnsure:(NSNotification *)dic
{
    if (![CheckUtils isLink]) {
        
        [self textStateHUD:@"无网络连接"];
        return;
    }
    LMAlipayResultRequest *request=[[LMAlipayResultRequest alloc]initWithMyOrderUuid:rechargeOrderUUID andAlipayResult:dic.object];
    
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(aliPaySuccessEnsureResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                           }];
    [proxy start];
}

- (void)aliPaySuccessEnsureResponse:(NSString *)resp
{
    NSDictionary    *bodyDict   = [VOUtil parseBody:resp];
    
    if (!bodyDict) {
        return;
    }
    
    if (bodyDict && [bodyDict objectForKey:@"result"]
        && [[bodyDict objectForKey:@"result"] isKindOfClass:[NSString class]]){
        
        if ([[bodyDict objectForKey:@"result"] isEqualToString:@"0"]) {
            
            [self textStateHUD:@"支付成功！"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:nil];
            });
        } else {
            
            [self textStateHUD:bodyDict[@"description"]];
        }
    }
}

#pragma mark  -- 余额支付

- (void)balanceChargeRequest
{
    if (![CheckUtils isLink]) {
        
        [self textStateHUD:@"无网络"];
        return;
    }
    
    LMBalanceChargeRequest *request = [[LMBalanceChargeRequest alloc] initWithOrder_uuid:orderInfos.orderUuid useBalance:orderdata.balance];
    
    HTTPProxy   *proxy      = [HTTPProxy loadWithRequest:request
                                               completed:^(NSString *resp, NSStringEncoding encoding) {
                                                   
                                                   [self performSelectorOnMainThread:@selector(balanceChargeResponse:)
                                                                          withObject:resp
                                                                       waitUntilDone:YES];
                                               } failed:^(NSError *error) {
                                                   
                                                   [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                          withObject:@"网络错误"
                                                                       waitUntilDone:YES];
                                               }];
    [proxy start];
}

- (void)balanceChargeResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    [self logoutAction:resp];
    
    if (!bodyDic) {
        
        [self textStateHUD:@"余额支付失败"];
    } else {
        
        NSString        *result     = [bodyDic objectForKey:@"result"];
        
        if (result && ![result isEqual:[NSNull null]] && [result isKindOfClass:[NSString class]] && [result isEqualToString:@"0"]) {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"您已成功付款\n%@", _tips]
                                                                           message:nil
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * _Nonnull action) {
                                                        
                                                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                            [self dismissViewControllerAnimated:YES completion:nil];
                                                            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:nil];
                                                        });
                                                     
                                                    }]];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        } else {
            
            [self textStateHUD:@"支付失败，请重试"];
        }
    }
}

#pragma mark -- 选择优惠券

- (void)CouponChose
{
    if ([orderdata.available isEqualToString:@"1"]) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self textStateHUD:@"不支持使用优惠券"];
            return ;
        });
    }else if ([orderdata.available isEqualToString:@"3"] ){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self textStateHUD:@"无可用优惠券"];
            return ;
        });
    }else if ([orderdata.available isEqualToString:@"4"]){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self textStateHUD:@"无优惠券"];
            return ;
        });
    }
    
    [self createTableView];
}

- (void)didSelectedItems:(NSArray *)items Row:(NSInteger)row
{
    NSString *uuidString = items[0];
    
    if ([uuidString isEqual:@"不抵扣"]) {
        
        [self useCouponreload:@"0" couponUUid:@[]];
    } else {
        
        NSString *couponUUid = couponIDList[row];
        NSString *coupon = [uuidString substringFromIndex:8];
        [self useCouponreload:coupon couponUUid:@[couponUUid]];
    }
}

- (void)getCouponListRequest
{
    LMCouponMsgRequest *request = [[LMCouponMsgRequest alloc] initWithOrder_uuid:_orderUUid];
    
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(getCouponListResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               
                                               [self textStateHUD:@"网络错误"];
                                           }];
    [proxy start];
}

- (void)getCouponListResponse:(NSString *)resp
{
    NSLog(@"%@", _orderUUid);
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    
    couponList          = [NSMutableArray new];
    couponPriceArray 	= [NSMutableArray new];
    
    if (!bodyDic) {
        
        [self textStateHUD:@"获取优惠券失败"];
    } else {
        
        NSString        *result     = [bodyDic objectForKey:@"result"];
        
        if (result && ![result isEqual:[NSNull null]] && [result isKindOfClass:[NSString class]] && [result isEqualToString:@"0"]){
            
            NSArray *array = bodyDic[@"list"];
            for (int i = 0; i<array.count; i++) {
                
                LMCouponVO *vo = [LMCouponVO LMCouponVOWithDictionary:array[i]];
                
                [couponList addObject:vo];
                [couponPriceArray addObject:vo.amount];
            }
            //selectedRow = couponList.count;
        } else {
            
            [self textStateHUD:[bodyDic objectForKey:@"description"]];
        }
    }
}

- (void)useCouponreload:(NSString *)couponPrice couponUUid:(NSArray *)uuidArray;
{
    LMCouponUseRequest *request = [[LMCouponUseRequest alloc] initWithOrder_uuid:_orderUUid couponMoney:couponPrice couponUuid:uuidArray sign:@"1"];
    
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(useCouponResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               
                                               [self textStateHUD:@"网络错误"];
                                           }];
    [proxy start];
}

- (void)useCouponResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    
    if (!bodyDic) {
        
        [self textStateHUD:@"暂不能使用该优惠券"];
    } else {
        
        NSString    *result     = [bodyDic objectForKey:@"result"];
        
        if (result && ![result isEqual:[NSNull null]] && [result isKindOfClass:[NSString class]] && [result isEqualToString:@"0"]){
            _orderUUid = bodyDic[@"order_uuid"];
            [self getOrderData];
        } else {
            
            [self textStateHUD:[bodyDic objectForKey:@"description"]];
        }
    }
}

- (void)createTableView
{
    tempSelectedArray = [NSMutableArray arrayWithArray:selectedArray];
    
    backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.5;
    [self.view addSubview:backView];
    
    addView =[[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight/2-45, kScreenWidth, kScreenHeight/2)];
    addView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:addView];
    
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 45)];
    
    UIButton    *cancelBtn  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 44)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:TEXT_COLOR_LEVEL_2 forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(dismissSelf) forControlEvents:UIControlEventTouchUpInside];
    
    [buttonView addSubview:cancelBtn];
    
    UILabel * tip = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, kScreenWidth-140, 44)];
    tip.text = [NSString stringWithFormat:@"您当前最多可抵扣金额为%d元",discountMoney];
    tip.textColor = LIVING_COLOR;
    tip.textAlignment = NSTextAlignmentCenter;
    tip.font = TEXT_FONT_LEVEL_3;
    [buttonView addSubview:tip];
    
    UIButton    *confirmBtn     = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 70, 0, 70, 44)];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:BLUE_COLOR forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmItemPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [buttonView addSubview:confirmBtn];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 44.5, kScreenWidth, 0.5)];
    lineView.backgroundColor = LINE_COLOR;
    [buttonView addSubview:lineView];
    [addView addSubview:buttonView];
    
    
    _couponView = [[UITableView alloc] initWithFrame:CGRectMake(0, 45 ,kScreenWidth, kScreenHeight/2) style:UITableViewStyleGrouped];
    _couponView.backgroundColor = [UIColor whiteColor];
    _couponView.delegate = self;
    _couponView.dataSource = self;
    [addView addSubview:_couponView];
    
    [_couponView reloadData];
}

- (void)dismissSelf
{
    [backView removeFromSuperview];
    [addView removeFromSuperview];
}

- (void)confirmItemPressed
{
    if (selectedRow==couponList.count) {
        
        [self useCouponreload:@"0" couponUUid:@[]];
    } else {
        NSInteger money = 0;
        [selectedArray removeAllObjects];
        [selectedArray addObjectsFromArray:tempSelectedArray];
        [selectedUuid removeAllObjects];
        for (NSNumber * num in selectedArray) {
            //总金额
            NSString *string =  couponPriceArray[[num integerValue]];
            NSInteger mon = [string integerValue];
            money += mon;
            //UUID数组
            LMCouponVO *vo = couponList[[num integerValue]];
            [selectedUuid addObject:vo.couponUuid];
        }
        
        NSString * totalMoney = [NSString stringWithFormat:@"%d", money];
        
        
        [self useCouponreload:totalMoney couponUUid:selectedUuid];
    }
    
    [backView removeFromSuperview];
    [addView removeFromSuperview];
}

//支付协议
-(void)getagreementCharge:(NSString *)string
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:@"是否同意支付协议"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"不同意"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction*action) {
                                                return ;
                                            }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"同意"
                                              style:UIAlertActionStyleDestructive
                                            handler:^(UIAlertAction*action) {
                                                
                                                if ([string isEqual:@"wx"]) {
                                                    [self wxRechargeRequest];
                                                }else{
                                                    [self aliRechargeRequest];
                                                }
                                                NSMutableArray *mutArr = [[NSMutableArray alloc]initWithObjects:@"agree", nil];
                                                
                                                //存入数组并同步
                                                
                                                [[NSUserDefaults standardUserDefaults] setObject:mutArr forKey:@"payArr"];
                                                
                                                [[NSUserDefaults standardUserDefaults] synchronize];
                                                
                                                
                                            }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}



@end
