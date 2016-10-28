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

@interface LMBesureOrderViewController ()

@end

@implementation LMBesureOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}

-(void)createUI
{
    [super createUI];
    self.title = @"确认订单";
}






-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }
    if (section==1) {
        return 8;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 150;
    }
    if (indexPath.section==1) {
        if (indexPath.row==5) {
            return 75;
        }
    }
    return 45;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
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
    
    return nil;
}



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 5;
    }
    return 30;
}




-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
        timeLabel.text = @"2016-10-12 12:10:56";
        timeLabel.font = TEXT_FONT_LEVEL_2;
        timeLabel.textColor = TEXT_COLOR_LEVEL_3;
        [timeLabel sizeToFit];
        timeLabel.frame = CGRectMake(kScreenWidth-15-timeLabel.bounds.size.width, 0, timeLabel.bounds.size.width, 35);
        [cell.contentView addSubview:timeLabel];
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(12, 40, 20, 20)];
        image.image = [UIImage imageNamed:@"rechage-2"];
        [cell.contentView addSubview:image];
        
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 30, kScreenWidth-55, 60)];
        titleLabel.text = @"这是活动名称这是活动名称这是活动名称这是活动名称这是活动名称这是活动名称";
        titleLabel.numberOfLines = 0;
        titleLabel.font = TEXT_FONT_LEVEL_2;
        titleLabel.textColor = TEXT_COLOR_LEVEL_2;
        [cell.contentView addSubview:titleLabel];
        
        UILabel *perCost = [UILabel new];
        perCost.textColor = TEXT_COLOR_LEVEL_3;
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"￥155x10/人"];

        [str addAttribute:NSFontAttributeName value:TEXT_FONT_LEVEL_2 range:NSMakeRange(0,4)];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(4,str.length-4)];
        perCost.attributedText = str;
        
        [perCost sizeToFit];
        perCost.frame = CGRectMake(40, 85, perCost.bounds.size.width, 25);
        [cell.contentView addSubview:perCost];
        
        UILabel *priceLabel = [UILabel new];
        priceLabel.text = @"￥ 1552";
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
        
        return cell;
        
    }
    
    if (indexPath.section==1) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = TEXT_COLOR_LEVEL_2;
        cell.textLabel.font = TEXT_FONT_LEVEL_2;
        cell.detailTextLabel.font = TEXT_FONT_LEVEL_2;
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"订单号:";
                cell.detailTextLabel.text = @"651465416416514655514";
                break;
            case 1:
                cell.textLabel.text = @"活动名称:";
                cell.detailTextLabel.text = @"这是名称这是名称这是名称这是名称这是名称这是名称这是名称";
                break;
            case 2:
                cell.textLabel.text = @"参加人数:";
                cell.detailTextLabel.text = @"3人";
                break;
            case 3:
                cell.textLabel.text = @"平均价格:";
                cell.detailTextLabel.text = @"￥155";
                break;
            case 4:
                cell.textLabel.text = @"订单总价:";
                cell.detailTextLabel.text = @"￥1550";
                break;
            case 5:
                cell.textLabel.text = @"活动时间:";
                cell.detailTextLabel.numberOfLines=3;
                cell.detailTextLabel.text = @"2014-12-14 12:12:12\n 至 \n 2016-12-12 12:12:12";
                break;
            case 6:
                cell.textLabel.text = @"活动地点:这是名称这是名称这是名称这是名称这是名称这是名称这是名称这是名称这是名称";
                cell.textLabel.numberOfLines=0;
                break;
            case 7:
            {
                UILabel *label = [UILabel new];
                label.text = @"再来一单";
                [label sizeToFit];
                label.frame = CGRectMake(0, 0, kScreenWidth, 45);
                label.font = TEXT_FONT_LEVEL_2;
                label.textAlignment = NSTextAlignmentCenter;
                                  
                label.textColor = LIVING_REDCOLOR;
                [cell.contentView addSubview:label];
            }
                
                break;
                
            default:
                break;
        }
        return cell;
    }
    
    
    
    return nil;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1) {
        if (indexPath.row==7) {
            APChooseView *infoView = [[APChooseView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
            
//            infoView.titleLabel.text = [NSString stringWithFormat:@"￥:%@", eventDic.perCost];
//            
//            infoView.inventory.text = [NSString stringWithFormat:@"活动人数 %.0f/%.0f人",eventDic.totalNumber,eventDic.totalNum];
//            
//            [infoView.productImage sd_setImageWithURL:[NSURL URLWithString:eventDic.eventImg]];
            
//            infoView.orderInfo = orderDic;
            
            [self.view addSubview:infoView];
            
            UIView *view = [infoView viewWithTag:1000];
            [UIView animateWithDuration:0.2 animations:^{
                view.frame = CGRectMake(0, kScreenHeight-465,self.view.bounds.size.width, 465);
            }];
        }
    }
}

-(void)cancelAction
{
    NSLog(@"取消订单");
    
    LMOrederDeleteRequest *request = [[LMOrederDeleteRequest alloc] initWithOrder_uuid:@""];
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

-(void)getdeleteDataResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    if (!bodyDic) {
        [self textStateHUD:@"删除失败"];
    }else{
        if ([[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
            [self textStateHUD:@"订单取消成功"];

        }else{
            [self textStateHUD:bodyDic[@"description"]];
        }
    }
}





-(void)payAction
{
    NSLog(@"支付订单");
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
