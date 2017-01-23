//
//  DYPersonViewController.m
//  dirty
//
//  Created by Ding on 16/8/23.
//  Copyright © 2016年 Huasheng. All rights reserved.
//

#import "LMPersonViewController.h"
#import "LMChangeDataViewController.h"
#import "LMSettingViewController.h"
#import "LMNoticViewController.h"
#import "LMBalanceViewController.h"
#import "LMOrderViewController.h"
#import "LMMy2dcodeViewController.h"
#import "LMMyLivingViewController.h"
#import "LMMyFriendViewController.h"
#import "LMPersonInfoRequest.h"
#import "FitUserManager.h"
#import "UserInfoVO.h"
#import "LMScanViewController.h"
#import "LMMyCouponController.h"
#import "ImageHelpTool.h"
#import "UIBarButtonItem+Badge.h"
#import "SYPhotoBrowser.h"
#import "LMBlacklistViewController.h"
#import "LMMyvoicSegmentViewController.h"

static CGRect oldframe;
@interface LMPersonViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    UserInfoVO *infoModels;
    NSString *gender;
    NSMutableDictionary *infoDic;
    UIImageView *headerView;
    UIView *backgroundViews;
    UIImageView *imageViews;
}

@end

@implementation LMPersonViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor  = LIVING_COLOR;

    if (![[FitUserManager sharedUserManager] isLogin]) {
        NSString*appDomain = [[NSBundle mainBundle]bundleIdentifier];
        
        [[NSUserDefaults standardUserDefaults]removePersistentDomainForName:appDomain];
        
        [self.navigationController popViewControllerAnimated:NO];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:FIT_LOGOUT_NOTIFICATION object:nil];
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self getUserInfoData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    infoDic = [NSMutableDictionary new];
    
    [self creatUI];
    
    //请求获取余额
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getUserInfoData)
                                                 name:@"rechargeMoney"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getUserInfoData)
                                                 name:@"reloadData"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(addDot)
     
                                                 name:@"getui_message"
     
                                               object:nil];
}

- (void)creatUI
{
    _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"notic"] style:UIBarButtonItemStylePlain target:self action:@selector(noticAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"homeDot"] isEqualToString:@"1"]) {
        self.navigationItem.rightBarButtonItem.badgeValue = @"1";
        self.navigationItem.rightBarButtonItem.badgeBGColor = [UIColor redColor];
    }else{
        self.navigationItem.rightBarButtonItem.badgeValue = @"";
        self.navigationItem.rightBarButtonItem.badgeBGColor = [UIColor clearColor];
    }
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    footView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = footView;
    
}

- (void)addDot
{
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"homeDot"];
    self.navigationItem.rightBarButtonItem.badgeValue = @"1";
    self.navigationItem.rightBarButtonItem.badgeBGColor = [UIColor redColor];
}


- (void)noticAction
{
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"homeDot"];
    self.navigationItem.rightBarButtonItem.badgeValue = @"";
    self.navigationItem.rightBarButtonItem.badgeBGColor = [UIColor clearColor];
    
    LMNoticViewController *noticVC = [[LMNoticViewController alloc] init];
    [noticVC setHidesBottomBarWhenPushed:YES];
    
    [self.navigationController pushViewController:noticVC animated:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getui_notic" object:nil];
    
}

#pragma mark  请求个人数据
- (void)getUserInfoData
{
    LMPersonInfoRequest *request = [[LMPersonInfoRequest alloc] initWithUserUUid:[FitUserManager sharedUserManager].uuid];
    
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(getUserInfoResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"获取数据失败"
                                                                   waitUntilDone:YES];
                                           }];
    [proxy start];
}

- (void)getUserInfoResponse:(NSString *)resp
{
    NSDictionary    *bodyDict   = [VOUtil parseBody:resp];
    
    [self logoutAction:resp];
    
    if (!bodyDict) {
        [self textStateHUD:@"获取数据失败"];
        return;
    }
    
    NSString *result    = [bodyDict objectForKey:@"result"];
    
    if (result && [result intValue] == 0)
    {
        infoModels = [[UserInfoVO alloc] initWithDictionary:[bodyDict objectForKey:@"userInfo"]];
        infoDic =[bodyDict objectForKey:@"userInfo"];
        
        if ([infoModels.franchisee isEqualToString:@"yes"]) {
            NSDate * date = [NSDate date];
            
            NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            //设置时间间隔（秒）
            NSTimeInterval time = 30 * 24 * 60 * 60;//一年的秒数
            //得到一年之前的当前时间（-：表示向前的时间间隔（即去年），如果没有，则表示向后的时间间隔（即明年））
            NSDate * lastYear = [date dateByAddingTimeInterval:time];
            //转化为字符串
            NSString * startDate = [dateFormatter stringFromDate:lastYear];
            NSLog(@"%@",startDate);
            NSDate *endDate = [dateFormatter dateFromString:infoModels.endTime];
            
            [self compareOneDay:lastYear withAnotherDay:endDate];
        }

        
        [_tableView reloadData];
        
    } else {
        [self textStateHUD:bodyDict[@"description"]];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 20;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }
    if (section==1) {
        if (infoModels.prove&&[infoModels.prove isEqualToString:@"teacher"]) {
            return 6;
        }
        return 5;
    }
    if (section==2) {
        return 2;
    }
    if (section==3) {
        return 1;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        
        if (indexPath.row==0) {
            
            return 100;
        }
        return 45;
    }
    return 45;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.textLabel setFont:TEXT_FONT_LEVEL_1];
    cell.textLabel.textColor = TEXT_COLOR_LEVEL_2;
    [cell.detailTextLabel setFont:TEXT_FONT_LEVEL_2];
    if (indexPath.section==0) {
        
        UserInfoVO *infoModel = [[UserInfoVO alloc] initWithDictionary:infoDic];
        
        if (indexPath.row==0) {
            
            //头像
            headerView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 70, 70)];
            headerView.layer.cornerRadius = 35;
            headerView.backgroundColor = BG_GRAY_COLOR;
            headerView.contentMode = UIViewContentModeScaleAspectFill;
            headerView.clipsToBounds = YES;
            
            if (infoModel.avatar ==nil) {
                if ([infoModel.gender isEqual:@"1"]) {
                    headerView.image = [UIImage imageNamed:@"placeholder-man"];
                }else{
                    headerView.image = [UIImage imageNamed:@"placeholder-woman"];
                }
                
            }else{
                [headerView setImageWithURL:[NSURL URLWithString:infoModel.avatar]];
                
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bigImageAction:)];
                [headerView addGestureRecognizer:tap];
                headerView.userInteractionEnabled = YES;
                
                
            }
            [cell.contentView addSubview:headerView];
            
            //nick
            UILabel *nicklabel = [[UILabel alloc] initWithFrame:CGRectMake(100,15,30,30)];
            nicklabel.font = TEXT_FONT_LEVEL_1;
            nicklabel.textColor = TEXT_COLOR_LEVEL_2;
            NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16],};
            
            NSString *str = infoModel.nickName;
            CGSize textSize = [str boundingRectWithSize:CGSizeMake(600, 30) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
            [nicklabel setFrame:CGRectMake(100, 15, textSize.width, 30)];
            nicklabel.text = str;
            [cell.contentView addSubview:nicklabel];
            
            //gender icon
            UIImageView *genderImage = [[UIImageView alloc] initWithFrame:CGRectMake(textSize.width+5+100, 22, 16, 16)];
            if (infoModel.gender) {
                if ([infoModel.gender isEqual:@"1"]) {
                    [genderImage setImage:[UIImage imageNamed:@"gender-man"]];
                }else{
                    [genderImage setImage:[UIImage imageNamed:@"gender-woman"]];
                }
            }
            [cell.contentView addSubview:genderImage];
            
            if (infoModel.sign&&[infoModel.sign isEqualToString:@"menber"]) {
                UIImageView *Vimage = [[UIImageView alloc] initWithFrame:CGRectMake(textSize.width+5+100+5+16, 17, 56, 22)];
                Vimage.contentMode = UIViewContentModeScaleAspectFill;
                Vimage.image = [UIImage imageNamed:@"BigVBlue"];
                Vimage.clipsToBounds = YES;
                [cell.contentView addSubview:Vimage];
            }
            
            //id
            
            UILabel     *idLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 75, kScreenWidth-(textSize.width+5+100+23)-15, 16)];
            NSString    *userID  = [NSString stringWithFormat:@"%d", infoModel.userId];
            
            if (userID) {
                
                [idLabel setText:[NSString stringWithFormat:@"ID:%@",userID]];
            }
            
            [idLabel setFont:TEXT_FONT_LEVEL_3];
            idLabel.textColor = TEXT_COLOR_LEVEL_3;
            [cell.contentView addSubview:idLabel];
            
            //下划线
            UILabel *lineLabel =[[UILabel alloc] initWithFrame:CGRectMake(100, 50, kScreenWidth-100, 0.5)];
            lineLabel.backgroundColor = LINE_COLOR;
            [cell.contentView addSubview:lineLabel];
            
            //余额
            UILabel *question = [[UILabel alloc] initWithFrame:CGRectMake(100, 55, 80, 20)];
            question.text = [NSString stringWithFormat:@"余额 ￥%.2f", infoModel.balance];
            question.font = TEXT_FONT_LEVEL_3;
            question.textColor = TEXT_COLOR_LEVEL_3;
            [question sizeToFit];
            question.frame = CGRectMake(100, 55, question.bounds.size.width, 20);
            [cell.contentView addSubview:question];
            
            //订单
            UILabel *reward = [[UILabel alloc] initWithFrame:CGRectMake(180, 55, 80, 20)];
            reward.text = [NSString stringWithFormat:@"订单 %d", infoModel.orderNumber];
            reward.font = TEXT_FONT_LEVEL_3;
            reward.textColor = TEXT_COLOR_LEVEL_3;
            [reward sizeToFit];
            reward.frame = CGRectMake(115+question.bounds.size.width, 55, reward.bounds.size.width, 20);
            [cell.contentView addSubview:reward];
            
            //生活馆
            UILabel *living = [[UILabel alloc] initWithFrame:CGRectMake(180, 55, 80, 20)];
            living.text = [NSString stringWithFormat:@"生活馆 %d", infoModel.livingNumber];
            living.font = TEXT_FONT_LEVEL_3;
            living.textColor = TEXT_COLOR_LEVEL_3;
            [living sizeToFit];
            living.frame = CGRectMake(130+question.bounds.size.width+reward.bounds.size.width, 55, living.bounds.size.width, 20);
            [cell.contentView addSubview:living];
            
            UIImageView *right = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-20, 63, 7, 14)];
            right.image = [UIImage imageNamed:@"turnright"];
            [cell.contentView addSubview:right];
        }
    }
    if (indexPath.section==1) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        switch (indexPath.row) {
                
            case 0:
                cell.textLabel.text = @"余额";
                cell.imageView.image = [UIImage imageNamed:@"balance"];
                
                break;
                
            case 1:
                cell.textLabel.text = @"订单";
                cell.imageView.image = [UIImage imageNamed:@"order"];
                
                break;
                
            case 2:
                cell.textLabel.text = @"生活馆";
                cell.imageView.image = [UIImage imageNamed:@"living"];
                
                break;
            case 3:
                cell.textLabel.text = @"我的好友";
                cell.imageView.image = [UIImage imageNamed:@"friend"];
                
                break;
            case 4:
                cell.textLabel.text = @"我的优惠券";
                cell.imageView.image = [UIImage imageNamed:@"personCoupon"];
                
                break;
            case 5:
                cell.textLabel.text = @"我是讲师";
                cell.imageView.image = [UIImage imageNamed:@"teacherIcon"];
                
                break;
                
            default:
                break;
        }
        
    }
    
    if (indexPath.section==2) {
        UILabel *dotLabel;
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"扫一扫";
                cell.imageView.image = [UIImage imageNamed:@"scanIcon"];
                break;
            case 1:
                cell.textLabel.text = @"我的二维码";
                cell.imageView.image = [UIImage imageNamed:@"2Dcode"];
                
                if ( [[[NSUserDefaults standardUserDefaults]objectForKey:@"xufei_dot"] isEqualToString:@"3"]) {
                    dotLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-43, (45-15)/2, 15, 15)];
                    dotLabel.text =@"1";
                    
                    dotLabel.layer.cornerRadius = 7.5;
                    dotLabel.clipsToBounds = YES;
                    dotLabel.textAlignment = NSTextAlignmentCenter;
                    dotLabel.font = [UIFont systemFontOfSize:12];
                    dotLabel.textColor = [UIColor whiteColor];
                    dotLabel.backgroundColor = [UIColor redColor];
                    [cell.contentView addSubview:dotLabel];
                }

                break;

            default:
                break;
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    if (indexPath.section==3) {
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cell.textLabel.text = @"设置";
        cell.imageView.image = [UIImage imageNamed:@"setting"];
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //修改资料
    UserInfoVO *infoModel = [[UserInfoVO alloc] initWithDictionary:infoDic];
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            
            LMChangeDataViewController *changeVC = [[LMChangeDataViewController alloc] init];
            changeVC.hidesBottomBarWhenPushed = YES;
            changeVC.avartStr = infoModel.avatar;
            changeVC.nickStr = infoModel.nickName;
            changeVC.ageStr = infoModel.birthday;
            changeVC.cityStr = infoModel.city;
            changeVC.provinceStr = infoModel.province;
            changeVC.genderStr = infoModel.gender;
            
            [self.navigationController pushViewController:changeVC animated:YES];
        }
    }
    
    if (indexPath.section==1) {
        //余额
        if (indexPath.row==0) {
            LMBalanceViewController *baVC = [[LMBalanceViewController alloc] init];
            [baVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:baVC animated:YES];
        }
        //订单
        if (indexPath.row==1) {
            UserInfoVO *infoModel = [[UserInfoVO alloc] initWithDictionary:infoDic];
            LMOrderViewController *orderVC = [[LMOrderViewController alloc] init];
            [orderVC setHidesBottomBarWhenPushed:YES];
            orderVC.useBalance = [NSString stringWithFormat:@"%.2f", infoModel.balance];
            [self.navigationController pushViewController:orderVC animated:YES];
        }
        
        // * 生活馆
        if (indexPath.row == 2) {
            
            if (infoModel.livingUuid && infoModel.livingUuid != nil && infoModel.livingNumber > 0) {
                
                LMMyLivingViewController    *myVC   = [[LMMyLivingViewController alloc] init];
                
                myVC.hidesBottomBarWhenPushed       = YES;
                myVC.livImgUUid                     = infoModel.livingUuid;
                
                [self.navigationController pushViewController:myVC animated:YES];
            } else {
                
                [self textStateHUD:@"你还没有生活馆，赶快充值吧~"];
            }
        }
        //我的好友
        if (indexPath.row ==3) {
            LMMyFriendViewController *myfVC = [[LMMyFriendViewController alloc] init];
            [myfVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:myfVC animated:YES];
        }
        
        //我的优惠券
        if (indexPath.row == 4) {
            
            LMMyCouponController *myfVC = [[LMMyCouponController alloc] init];
            [myfVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:myfVC animated:YES];
        }
        
        if (indexPath.row == 5) {
            LMMyvoicSegmentViewController *myVoiceVC = [[LMMyvoicSegmentViewController alloc] init];
            myVoiceVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:myVoiceVC animated:YES];
        }
        
    }
    
    if (indexPath.section==2) {
        if (indexPath.row==0) {
            LMScanViewController *setVC = [[LMScanViewController alloc] init];
            [setVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:setVC animated:YES];
        }
        if (indexPath.row==1) {
            LMMy2dcodeViewController *setVC = [[LMMy2dcodeViewController alloc] init];
            [setVC setHidesBottomBarWhenPushed:YES];
            
            if (infoModel.province!=nil) {
                setVC.address = [NSString stringWithFormat:@"%@-%@",infoModel.province,infoModel.city];
            }
            setVC.name = infoModel.nickName;
            setVC.gender = infoModel.gender;
            setVC.headURL = infoModel.avatar;
            setVC.endTime = infoModel.endTime;
            
            [self.navigationController pushViewController:setVC animated:YES];
        }

    }
    
    if (indexPath.section==3) {
        if (indexPath.row==0) {
            LMSettingViewController *setVC = [[LMSettingViewController alloc] init];
            [setVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:setVC animated:YES];
        }
    }
}

- (void)bigImageAction:(UIImageView *)imageV
{
    
    if (headerView.image) {
        
        [self showImage:headerView];
    }else{
        return;
    }
}

- (void)showImage:(UIImageView *)avatarImageView{
    self.navigationController.navigationBar.hidden=YES;
    self.tabBarController.tabBar.hidden = YES;
    UIImage *image=avatarImageView.image;
    backgroundViews=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    oldframe=[avatarImageView convertRect:avatarImageView.bounds toView:self.view];
    backgroundViews.backgroundColor=[UIColor blackColor];
    backgroundViews.alpha=0;
    imageViews=[[UIImageView alloc]initWithFrame:oldframe];
    imageViews.image=image;
    imageViews.tag=1;
    [backgroundViews addSubview:imageViews];
    [self.view addSubview:backgroundViews];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [backgroundViews addGestureRecognizer: tap];
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenImageView:)];
    swipe.numberOfTouchesRequired =1;
    swipe.direction =UISwipeGestureRecognizerDirectionUp|UISwipeGestureRecognizerDirectionDown;
    [backgroundViews addGestureRecognizer:swipe];
    
    UILongPressGestureRecognizer *LongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(LongPressAction:)];
    LongPress.minimumPressDuration = 1.0;
    [backgroundViews addGestureRecognizer:LongPress];
    
    [UIView animateWithDuration:0.3 animations:^{
        imageViews.frame=CGRectMake(0,([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
        
        backgroundViews.alpha=1;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hideImage:(UITapGestureRecognizer*)tap{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.navigationController.navigationBar.hidden=NO;
    self.tabBarController.tabBar.hidden = NO;
   UIView *backgroundView=tap.view;
    UIImageView *imageView=(UIImageView*)[tap.view viewWithTag:1];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=oldframe;
        backgroundView.alpha=0;
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
        
    }];
}

- (void)hiddenImageView:(UISwipeGestureRecognizer*)tap{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.navigationController.navigationBar.hidden=NO;
    self.tabBarController.tabBar.hidden = NO;
    UIView *backgroundView=tap.view;
    UIImageView *imageView=(UIImageView*)[tap.view viewWithTag:1];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=oldframe;
        backgroundView.alpha=0;
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
        
    }];
}

- (void)LongPressAction:(UILongPressGestureRecognizer *)longPress
{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"保存图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImageWriteToSavedPhotosAlbum(headerView.image,self,  @selector(image:didFinishSavingWithError:contextInfo:imageview:), NULL);
    }]];
    
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                [alert dismissViewControllerAnimated:YES completion:nil];
                                            }]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo imageview:(UIImageView *)imageView

{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.navigationController.navigationBar.hidden=NO;
    self.tabBarController.tabBar.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        imageViews.frame=oldframe;
        backgroundViews.alpha=0;
    } completion:^(BOOL finished) {
        [backgroundViews removeFromSuperview];
        
    }];
    NSString *msg = nil ;
    
    if(error != NULL){
        
        msg = @"保存图片失败" ;
        
    }else{
        
        msg = @"保存图片成功" ;
        
    }
    self.navigationController.navigationBar.hidden=NO;
    self.tabBarController.tabBar.hidden = NO;
    [self textStateHUD:msg];
}

- (void)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    if (result == NSOrderedDescending) {
        //NSLog(@"oneDay  is in the future");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LM_ADD_NOTIFICATION" object:nil];
        [[NSUserDefaults standardUserDefaults] setObject:@"3" forKey:@"xufei_dot"];

    }
    else if (result == NSOrderedAscending){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LM_ADD_NOTIFICATION" object:nil];
        [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"xufei_dot"];
        
    } else {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LM_ADD_NOTIFICATION" object:nil];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"xufei_dot"];
    }
}




@end
