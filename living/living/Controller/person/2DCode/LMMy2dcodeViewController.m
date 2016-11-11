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
#import "LMFranchiseeViewController.h"


@interface LMMy2dcodeViewController ()
{
    UIImageView *imageView;
    NSString *codeSting;
}

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
    
    //如果有缓存信息 则用缓存信息
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path = [paths objectAtIndex:0];
    
    NSString        *filename   = [path stringByAppendingPathComponent:@"img.plist"];
    NSDictionary    *headerData = [NSDictionary dictionaryWithContentsOfFile:filename];
    
    if (headerData && [headerData isKindOfClass:[NSDictionary class]]) {
        
        codeSting = [headerData objectForKey:@"code"];
        [self creatImageView];
    }
    
    
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
    
    [self logoutAction:resp];
    if (!bodyDic) {
        [self textStateHUD:@"获取数据失败"];
        return;
    }
    
    NSString *result    = [bodyDic objectForKey:@"result"];
    
    if (result && [result intValue] == 0)
    {
        codeSting =  bodyDic[@"code"];
        
        [self creatImageView];
        //将数据缓存到本地
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *path = [paths objectAtIndex:0];
        NSString *filename = [path stringByAppendingPathComponent:@"contact.plist"];
        NSMutableDictionary *userInfo;
        userInfo=[[NSMutableDictionary alloc]initWithDictionary:bodyDic];
        [userInfo writeToFile:filename atomically:YES];
        
        
    } else {
        
        UILabel *msgLabel = [UILabel new];
        
        msgLabel.textColor = [UIColor whiteColor];
        msgLabel.text = @"你不是轻创客，没有二维码";
        msgLabel.textAlignment = NSTextAlignmentCenter;
        [msgLabel sizeToFit];
        msgLabel.frame = CGRectMake(kScreenWidth/2-msgLabel.bounds.size.width/2-10, kScreenHeight/2-40, msgLabel.bounds.size.width+20, 45);
        [self.view addSubview:msgLabel];
        
        
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"business"] style:UIBarButtonItemStylePlain target:self action:@selector(joinAction)];
        self.navigationItem.rightBarButtonItem = rightItem;
        
    }
}

-(void)creatImageView
{
    UIView *KeepImage = [[UIView alloc] initWithFrame:CGRectMake(15, 60+64, kScreenWidth-30, 115+kScreenWidth)];
    KeepImage.clipsToBounds = YES;
    KeepImage.layer.cornerRadius = 5;
    KeepImage.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:KeepImage];
    
    UIImageView *headImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 60, 60)];
    headImage.backgroundColor = [UIColor lightGrayColor];
    [headImage sd_setImageWithURL:[NSURL URLWithString:_headURL]];
    headImage.layer.cornerRadius = 5;
    headImage.clipsToBounds = YES;
    [KeepImage addSubview:headImage];
    
    
    //nick
    UILabel *nicklabel = [[UILabel alloc] initWithFrame:CGRectMake(90,10,30,30)];
    nicklabel.font = TEXT_FONT_LEVEL_1;
    nicklabel.textColor = TEXT_COLOR_LEVEL_1;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16],};
    NSString *str = _name;
    CGSize textSize = [str boundingRectWithSize:CGSizeMake(600, 30) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    [nicklabel setFrame:CGRectMake(90, 22.5, textSize.width, 30)];
    nicklabel.text = str;
    [KeepImage addSubview:nicklabel];
    
    
    
    UIButton *downButton = [UIButton buttonWithType:UIButtonTypeCustom];
    downButton.frame = CGRectMake(kScreenWidth-85, 10, 40, 40);
    [downButton setImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
    [downButton addTarget:self action:@selector(saveImageToAlbum) forControlEvents:UIControlEventTouchUpInside];
    [KeepImage addSubview:downButton];
    
    
    
    UIImageView *genderImage = [[UIImageView alloc] initWithFrame:CGRectMake(textSize.width+6+90, 30, 16, 16)];
    if (_gender) {
        if ([_gender intValue] ==1) {
            [genderImage setImage:[UIImage imageNamed:@"gender-man"]];
        }else{
            [genderImage setImage:[UIImage imageNamed:@"gender-woman"]];
        }
    }
    [KeepImage addSubview:genderImage];
    
    
    UILabel *addressLabel = [UILabel new];
    addressLabel.text = _address;
    addressLabel.textColor = TEXT_COLOR_LEVEL_3;
    addressLabel.font = TEXT_FONT_LEVEL_2;
    [addressLabel sizeToFit];
    addressLabel.frame = CGRectMake(91, 52, addressLabel.bounds.size.width, 20);
    [KeepImage addSubview: addressLabel];
    
    
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 125, kScreenWidth-70, kScreenWidth-70)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:codeSting]];
    [KeepImage addSubview:imageView];
    
    
    UIImageView *headImage2 = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-70)/2-25, (kScreenWidth-70)/2-25, 50, 50)];
    headImage2.backgroundColor = [UIColor lightGrayColor];
    [headImage2 sd_setImageWithURL:[NSURL URLWithString:_headURL]];
    headImage2.layer.cornerRadius = 5;
    headImage2.clipsToBounds = YES;
    [imageView addSubview:headImage2];
}




#pragma mark  --成为加盟商

-(void)joinAction
{
    //    NSLog(@"**********");
    LMFranchiseeViewController *joinVC = [[LMFranchiseeViewController alloc] init];
    joinVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:joinVC animated:YES];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)saveImageToAlbum {
    UIImageWriteToSavedPhotosAlbum(imageView.image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
}


- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *message;
    if (!error) {
        
        [self textStateHUD:@"成功保存到相册"];
        
    }else
    {
        [self textStateHUD :[error description]];
        
    }
    NSLog(@"message is %@",message);
}


@end
