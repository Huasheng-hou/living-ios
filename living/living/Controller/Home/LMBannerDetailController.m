//
//  LMBannerDetailController.m
//  living
//
//  Created by Huasheng on 2017/2/23.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMBannerDetailController.h"
#import "LMBannerDetailCommonController.h"
#import "LMBannerDetailExpertController.h"
#import "LMBannerDetailMakerController.h"
#import "LMSegmentController.h"

#import "LMPublicArticleController.h"
#import "LMSubmitSuccessController.h"

static CGFloat const ButtonHeight = 38;

@interface LMBannerDetailController ()<LMSegmentDelegate>

@end

@implementation LMBannerDetailController
{
    BOOL isShow;
    CGFloat keyBoardHeight;
    
    UIView * bgView;
    UIView * topView;
    UIView * botView;
    UILabel * tips;
    UITextField * nameTF;
    UITextField * phoneTF;
    UIButton * bookBtn;
    
    
}

- (instancetype)initWithIndex:(NSInteger)index{
    
    if (self = [super init]) {
        self.index = index;
        [self createUIWithIndex:self.index];
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([[FitUserManager sharedUserManager] isLogin]) {
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(publicAction)];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:nil];
}


- (void)createUIWithIndex:(NSInteger)index
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Yao·美丽";
    NSArray *titleArrays = @[@[@"美·发现", @"美·活动", @"美·达人"], @[@"康·发现", @"康·活动", @"康·达人"], @[@"食·发现", @"食·活动", @"食·达人"], @[@"福·发现", @"福·活动", @"福·达人"]];
    LMSegmentController *vc = [[LMSegmentController alloc]init];
    NSLog(@"%d",index);
    NSArray *titleArray = titleArrays[index-10];
    
    vc.titleArray = titleArray;
    NSMutableArray *controlArray = [[NSMutableArray alloc]init];
    
    LMBannerDetailCommonController *vc1 = [[LMBannerDetailCommonController alloc]init];
    [controlArray addObject:vc1];
    
    LMBannerDetailCommonController *vc2 = [[LMBannerDetailCommonController alloc]init];
    [controlArray addObject:vc2];
    
    LMBannerDetailExpertController *vc3 = [[LMBannerDetailExpertController alloc]init];
    [controlArray addObject:vc3];
    
    vc.delegate = self;
    vc.titleColor = TEXT_COLOR_LEVEL_2;
    vc.titleSelectedColor = LIVING_COLOR;
    vc.subViewControllers = controlArray;
    vc.buttonWidth = kScreenWidth/3.0;
    vc.buttonHeight = ButtonHeight;
    [vc initSegment];
    [vc addParentController:self];
    
    
}
#pragma mark LMSegmentDelegate
- (void)changeNavigationItem:(NSInteger)index{
    if ([[FitUserManager sharedUserManager] isLogin]) {
        if (index == 10004) {
            UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"联系我们" style:UIBarButtonItemStylePlain target:self action:@selector(contactUs)];
            self.navigationItem.rightBarButtonItem = rightItem;
        }else{
            UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(publicAction)];
            self.navigationItem.rightBarButtonItem = rightItem;
        }
    }
}
#pragma mark 发布文章
- (void)publicAction
{
    LMPublicArticleController *publicVC = [[LMPublicArticleController alloc] init];
    [self.navigationController pushViewController:publicVC animated:YES];
}


#pragma mark 联系我们
- (void)contactUs{
    
    NSLog(@"联系我们");
    
    
    
    
    bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    bgView.backgroundColor = [UIColor clearColor];
    [self.view.window addSubview:bgView];
    
    
    topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-170)];
    topView.backgroundColor = MASK_COLOR;
    [bgView addSubview:topView];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(remove:)];
    [topView addGestureRecognizer:tap];
    
    
    botView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-170, kScreenWidth, 170)];
    botView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:botView];
    
    tips = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth-20, 15)];
    tips.text = @"留下姓名电话，预约就进生活馆了解“创客”详情";
    tips.textColor = TEXT_COLOR_LEVEL_4;
    tips.font = TEXT_FONT_LEVEL_4;
    [botView addSubview:tips];
    
    nameTF = [[UITextField alloc] initWithFrame:CGRectMake(10, 35, kScreenWidth-20, 25)];
    nameTF.keyboardType = UIKeyboardTypeNamePhonePad;
    nameTF.placeholder = @" 姓名";
    nameTF.textColor = TEXT_COLOR_LEVEL_4;
    nameTF.font = TEXT_FONT_LEVEL_2;
    nameTF.borderStyle = UITextBorderStyleLine;
    nameTF.layer.borderColor = TEXT_COLOR_LEVEL_4.CGColor;
    nameTF.layer.borderWidth = 1;
    nameTF.layer.masksToBounds = YES;
    nameTF.layer.cornerRadius = 3;
    [botView addSubview:nameTF];
    
    phoneTF = [[UITextField alloc] initWithFrame:CGRectMake(10, 75, kScreenWidth-20, 25)];
    phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    phoneTF.placeholder = @" 电话";
    phoneTF.textColor = TEXT_COLOR_LEVEL_4;
    phoneTF.font = TEXT_FONT_LEVEL_2;
    phoneTF.borderStyle = UITextBorderStyleLine;
    phoneTF.layer.borderColor = TEXT_COLOR_LEVEL_4.CGColor;
    phoneTF.layer.borderWidth = 1;
    phoneTF.layer.masksToBounds = YES;
    phoneTF.layer.cornerRadius = 3;
    [botView addSubview:phoneTF];
    
    
    bookBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 115, kScreenWidth-40, 35)];
    [bookBtn setTitle:@"预约生活馆" forState:UIControlStateNormal];
    [bookBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    bookBtn.titleLabel.font = TEXT_FONT_BOLD_14;
    bookBtn.backgroundColor = ORANGE_COLOR;
    bookBtn.layer.masksToBounds = YES;
    bookBtn.layer.cornerRadius = 3;
    [bookBtn addTarget:self action:@selector(booking:) forControlEvents:UIControlEventTouchUpInside];
    [botView addSubview:bookBtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)booking:(UIButton *)btn{
    
    NSLog(@"预约生活馆");
    //验证输入内容
    if ([self checkConfirm]) {
        //移除当前视图
        [bgView removeFromSuperview];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        //跳转下一页面
        LMSubmitSuccessController * ssVC = [[LMSubmitSuccessController alloc] init];
        ssVC.title = @"预约成功";
        [self.navigationController pushViewController:ssVC animated:YES];
    }
    
    
}
#pragma 验证输入内容
- (BOOL)checkConfirm{
    if ([nameTF.text isEqualToString:@""] ) {
        [nameTF resignFirstResponder];
        [phoneTF resignFirstResponder];
        [self textStateHUD:@"请输入姓名"];
        return NO;
    }
    else if ([phoneTF.text isEqualToString:@""]) {
        [nameTF resignFirstResponder];
        [phoneTF resignFirstResponder];
        [self textStateHUD:@"请输入电话"];
        return NO;
    }
    else{
        // 手机号正则
        NSString *mobileRegex = @"[1][34578][0-9]{9}";
        NSPredicate *mobilePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobileRegex];
    
        if (![mobilePredicate evaluateWithObject:phoneTF.text]) {
        
            [nameTF resignFirstResponder];
            [phoneTF resignFirstResponder];
            [self textStateHUD:@"手机格式不正确"];
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请输入正确的手机号码"
//                                                                       message:nil
//                                                                preferredStyle:UIAlertControllerStyleAlert];
//            [alert addAction:[UIAlertAction actionWithTitle:@"确定"
//                                                  style:UIAlertActionStyleCancel
//                                                handler:nil]];
//        
//            [self presentViewController:alert animated:YES completion:nil];
        
        
            return NO;
        }
    }
    return YES;
}

- (void)keyboardShow:(NSNotification *)noti{
    if (isShow) {
        return;
    }
    isShow = YES;
    NSLog(@"%@", [noti userInfo]);
    
    CGRect frame = bgView.frame;
    NSDictionary * info = [noti userInfo];
    CGSize kSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    keyBoardHeight = kSize.height;
    CGRect rect = CGRectMake(frame.origin.x, frame.origin.y-kSize.height, frame.size.width, frame.size.height);
    [UIView animateWithDuration:0.5 animations:^{
        bgView.frame = rect;
    }];
    
    
}

- (void)keyboardHide:(NSNotification *)noti{
    
    [self hideAnimation];
    
}


- (void)remove:(UITapGestureRecognizer *)tap{
    if (isShow) {
        
        [nameTF resignFirstResponder];
        [phoneTF resignFirstResponder];

    }else{
        [bgView removeFromSuperview];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (void)hideAnimation{
    isShow = NO;
    
    CGRect frame = bgView.frame;
    CGRect rect = CGRectMake(frame.origin.x, frame.origin.y+keyBoardHeight, frame.size.width, frame.size.height);
    [UIView animateWithDuration:0.5 animations:^{
        bgView.frame = rect;
    }];
    

}
@end
