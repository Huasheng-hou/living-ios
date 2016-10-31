//
//  LMMy2dcodeViewController.m
//  living
//
//  Created by Ding on 2016/10/25.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMMy2dcodeViewController.h"
#import "LM2DcodeRequest.h"
#import "UIImageView+WebCache.h"

@interface LMMy2dcodeViewController ()

@end

@implementation LMMy2dcodeViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor  = [UIColor blackColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor blackColor];
    
    self.title = @"二维码";
    [self get2DcodeRequest];
    
    
}

-(void)get2DcodeRequest
{
    if (![CheckUtils isLink]) {
        
        [self textStateHUD:@"无网络连接"];
        return;
    }
    LM2DcodeRequest *request = [[LM2DcodeRequest alloc] initWithUserUUid:[FitUserManager sharedUserManager].uuid];
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(get2DcodeResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"获取数据失败"
                                                                   waitUntilDone:YES];
                                           }];
    [proxy start];

}

-(void)get2DcodeResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    if (!bodyDic) {
        [self textStateHUD:@"获取数据失败"];
        return;
    }
    
    NSString *result    = [bodyDic objectForKey:@"result"];
    
    if (result && [result intValue] == 0)
    {
    
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(15, 60+64, kScreenWidth-20, 115+kScreenWidth)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    UIImageView *headImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 75, 75)];
    headImage.backgroundColor = [UIColor lightGrayColor];
    [headImage sd_setImageWithURL:[NSURL URLWithString:_headURL]];
    headImage.layer.cornerRadius = 5;
    headImage.clipsToBounds = YES;
    [backView addSubview:headImage];
    
    
    //nick
    UILabel *nicklabel = [[UILabel alloc] initWithFrame:CGRectMake(100,10,30,30)];
    nicklabel.font = TEXT_FONT_LEVEL_1;
    nicklabel.textColor = TEXT_COLOR_LEVEL_2;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16],};
    
    NSString *str = _name;
    CGSize textSize = [str boundingRectWithSize:CGSizeMake(600, 30) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    [nicklabel setFrame:CGRectMake(100, 20, textSize.width, 30)];
    nicklabel.text = str;
    [backView addSubview:nicklabel];
    
    
    UIImageView *genderImage = [[UIImageView alloc] initWithFrame:CGRectMake(textSize.width+5+100, 22, 16, 16)];
    if (_gender) {
        if ([_gender intValue] ==1) {
            [genderImage setImage:[UIImage imageNamed:@"gender-man"]];
        }else{
            [genderImage setImage:[UIImage imageNamed:@"gender-woman"]];
        }
    }
    [backView addSubview:genderImage];
    
    
    UILabel *addressLabel = [UILabel new];
    addressLabel.text = _address;
    addressLabel.textColor = TEXT_COLOR_LEVEL_3;
    addressLabel.font = TEXT_FONT_LEVEL_2;
    
    [addressLabel sizeToFit];
    addressLabel.frame = CGRectMake(100, 75, addressLabel.bounds.size.width, 20);
    [backView addSubview: addressLabel];
    
    
    
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 125, kScreenWidth-70, kScreenWidth-70)];
//        imageView.backgroundColor = [UIColor redColor];
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:bodyDic[@"code"]]];
        [backView addSubview:imageView];
    
    
    UIImageView *headImage2 = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-70)/2-37.5, (kScreenWidth-70)/2-37.5, 75, 75)];
    headImage2.backgroundColor = [UIColor lightGrayColor];
    [headImage2 sd_setImageWithURL:[NSURL URLWithString:_headURL]];
    headImage2.layer.cornerRadius = 5;
    headImage2.clipsToBounds = YES;
    [imageView addSubview:headImage2];

    
    } else {
        [self textStateHUD:bodyDic[@"description"]];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"你不是轻创客，没有二维码"
                                                                       message:nil
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定"
                                                               style:UIAlertActionStyleCancel
                                                             handler:nil];
        
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
        
        
    }
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
