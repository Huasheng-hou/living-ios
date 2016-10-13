//
//  DYRegisterViewController.m
//  dirty
//
//  Created by Ding on 16/8/24.
//  Copyright © 2016年 Huasheng. All rights reserved.
//

#import "LMRegisterViewController.h"
#import "LMChooseButton.h"
#import "LMAgeChooseButton.h"
#import "FitPickerView.h"
#import "FitDatePickerView.h"
#import "NSString+StringHelper.h"
#import "LMRegisterRequest.h"
#import "FirUploadImageRequest.h"
#import "FitTabbarController.h"
#import "ImageHelpTool.h"


#define TOKEN @"dirty2016"
@interface LMRegisterViewController ()<UITextFieldDelegate,FitDatePickerDelegate,FitPickerViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UITextField *nickTF;
    LMAgeChooseButton *ageTF;
    LMAgeChooseButton *cityTF;
    LMChooseButton *manButton;
    LMChooseButton *womanButton;
    
    UIImagePickerController *pickImage;
    
    NSString *_imgURL;
    UIImageView *headerView;
    NSString *provinceStr;
    NSString *cityStr;
    NSString *genderStr;
    NSString *passWordStr;
    
    NSString        *_uuid;
    
    NSDictionary *infoDic;
}

@end

@implementation LMRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

-(void)createUI
{
    [super createUI];
    self.title = @"填写资料";
    genderStr = @"1";
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 150)];
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 130)];
    backView.backgroundColor = [UIColor whiteColor];
    
    
    headerView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2-30, 20, 60, 60)];
    headerView.image = [UIImage imageNamed:@"headerIcon"];
    [backView addSubview:headerView];
    
    headerView.userInteractionEnabled=YES;
    //headerView tap事件
    
    UITapGestureRecognizer   *tap     = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectHeadImage)];
    
    
    [headerView addGestureRecognizer:tap];
    
    
    
    UILabel *introduce =[[UILabel alloc] initWithFrame:CGRectMake(0, 90, kScreenWidth, 20)];
    introduce.text = @"上传真实照片，让小伙伴更好的认识你哦";
    introduce.font = TEXT_FONT_LEVEL_3;
    introduce.textColor = TEXT_COLOR_LEVEL_2;
    introduce.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:introduce];
    [headView addSubview:backView];
    self.tableView.tableHeaderView = headView;
    
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 120)];
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame = CGRectMake(15, 20, kScreenWidth-30, 45);
    loginButton.titleLabel.font = TEXT_FONT_LEVEL_1;
    [loginButton setTitle:@"登 陆" forState:UIControlStateNormal];
    loginButton.backgroundColor = [UIColor colorWithRed:0/255.0 green:130/255.0 blue:230.0/255.0 alpha:1.0];
    [loginButton addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    
    loginButton.layer.cornerRadius = 5;
    [footView addSubview:loginButton];
    
    self.tableView.tableFooterView = footView;
    
    
    pickImage=[[UIImagePickerController alloc]init];
    
    [pickImage setDelegate:self];
    [pickImage setAllowsEditing:YES];
    
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return 10;

}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 130;
    }
    if (indexPath.section==1) {
        return 160;
    }

    return 0;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    
    if (indexPath.section==0) {
        manButton = [[LMChooseButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth/2, 130)];
        manButton.headImage.image = [UIImage imageNamed:@"manIcon-choose"];
        manButton.roolImage.image = [UIImage imageNamed:@"roolIcon-choose"];
        [manButton addTarget:self action:@selector(manAction) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:manButton];
        
        
        womanButton = [[LMChooseButton alloc] initWithFrame:CGRectMake(kScreenWidth/2, 0, kScreenWidth/2, 130)];
        womanButton.headImage.frame = CGRectMake(26, 20, 44, 50);
        womanButton.headImage.image = [UIImage imageNamed:@"womanIcon-gray"];
        womanButton.roolImage.frame = CGRectMake(41.5, 90, 15, 15);
        womanButton.roolImage.image = [UIImage imageNamed:@"roolIcon-gray"];
        [womanButton addTarget:self action:@selector(womanAction) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:womanButton];
        

        
        
    }
    if (indexPath.section==1) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 75, 30)];
        nameLabel.text = @"输入昵称";
        nameLabel.font = TEXT_FONT_LEVEL_2;
        nameLabel.textColor = TEXT_COLOR_LEVEL_2;
        [cell.contentView addSubview:nameLabel];
        
        nickTF = [[UITextField alloc] initWithFrame:CGRectMake(90, 10, kScreenWidth-100, 30)];
        nickTF.placeholder = @"请输入昵称";
        [nickTF setValue:TEXT_COLOR_LEVEL_3 forKeyPath:@"_placeholderLabel.textColor"];
        nickTF.font=TEXT_FONT_LEVEL_2;
        nickTF.textColor = TEXT_COLOR_LEVEL_3;
        nickTF.delegate = self;
        [cell.contentView addSubview:nickTF];
        
        UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 45, kScreenWidth-90, 0.5)];
        lineLabel.backgroundColor = LINE_COLOR;
        [cell.contentView addSubview:lineLabel];
        
        
        UILabel *ageLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 60, 75, 30)];
        ageLabel.text = @"真实年龄";
        ageLabel.font = TEXT_FONT_LEVEL_2;
        ageLabel.textColor = TEXT_COLOR_LEVEL_2;
        [cell.contentView addSubview:ageLabel];
        
        ageTF = [[LMAgeChooseButton alloc] initWithFrame:CGRectMake(90, 60, kScreenWidth-90-50, 30)];
        ageTF.layer.borderWidth=0.5;
        ageTF.layer.borderColor = LINE_COLOR.CGColor;
        [ageTF addTarget:self action:@selector(timeChooseAction) forControlEvents:UIControlEventTouchUpInside];
        ageTF.textLabel.text = @"请选择出生日期";
        [cell.contentView addSubview:ageTF];
        
        
        UILabel *cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 110, 75, 30)];
        cityLabel.text = @"所在城市";
        cityLabel.font = TEXT_FONT_LEVEL_2;
        cityLabel.textColor = TEXT_COLOR_LEVEL_2;
        [cell.contentView addSubview:cityLabel];
        
        cityTF = [[LMAgeChooseButton alloc] initWithFrame:CGRectMake(90, 110, kScreenWidth-90-50, 30)];
        cityTF.layer.borderWidth=0.5;
        cityTF.layer.borderColor = LINE_COLOR.CGColor;
        [cityTF addTarget:self action:@selector(addressChooseAction) forControlEvents:UIControlEventTouchUpInside];
        cityTF.textLabel.text = @"请选择所在城市";
        [cell.contentView addSubview:cityTF];
        
    }
    
    
    
    
    
    return cell;
}

#pragma mark 登陆
-(void)loginAction
{
    
    NSLog(@"*************denglu******");
    NSLog(@"****provinceStr********%@",provinceStr);
    NSLog(@"******nickTF.text******%@",nickTF.text);
    NSLog(@"*****cityStr*******%@",cityStr);
    NSLog(@"*******_numberString******%@",_numberString);
    NSLog(@"*****ageTF.textLabel.text********%@",ageTF.textLabel.text);
    NSLog(@"*****passWordStr********%@",passWordStr);
    NSLog(@"*******genderStr******%@",genderStr);
    NSLog(@"*************%@",_imgURL);
    
    _imgURL = @"http://a.hiphotos.baidu.com/zhidao/pic/item/2cf5e0fe9925bc314cc6bd685fdf8db1ca1370a2.jpg";
    
    if ([nickTF.text isEqualToString:@""]) {
        [self textStateHUD:@"请填写昵称"];
        return;
    }
    
    if ([_imgURL isEqualToString:@""]) {
        [self textStateHUD:@"请选择头像"];
        return;
    }
    
    if ([provinceStr isEqualToString:@""]||[cityStr isEqualToString:@""]) {
        [self textStateHUD:@"请选择所在城市"];
        return;
    }
    
    if ([ageTF.textLabel.text isEqualToString:@""]) {
        [self textStateHUD:@"请选择出生日期"];
        return;
    }
    

    
    
    LMRegisterRequest *request = [[LMRegisterRequest alloc] initWithNickname:nickTF.text andGender:genderStr andAvatar:_imgURL andBirtyday:ageTF.textLabel.text andProvince:provinceStr andCity:cityStr];
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(parseCodeResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"上传失败"
                                                                   waitUntilDone:YES];
                                           }];
    [proxy start];

    
}

- (void)parseCodeResponse:(NSString *)resp
{
    NSDictionary    *bodyDict   = [VOUtil parseBody:resp];
    
    if (!bodyDict) {
        [self textStateHUD:@"资料填写失败"];
        return;
    }
    
    NSString *result    = [bodyDict objectForKey:@"result"];
    
    if (result && [result intValue] == 0)
    {
        
        infoDic = [bodyDict objectForKey:@"user_info"];
        
        _uuid = [infoDic objectForKey:@"user_uuid"];
        
        [self setUserInfo];

        [self gotoHomepage];
        [self textStateHUD:@"资料填写成功"];
        
    } else {
        [self textStateHUD:@"资料填写失败"];
    }
}

#pragma mark 填写资料完成跳转到首页

-(void)gotoHomepage
{
    FitTabbarController *tabbar = [[FitTabbarController alloc] init];
    
    [self presentViewController:tabbar animated:YES completion:nil];

}


#pragma mark 登记用户信息

- (void)setUserInfo{
    
    
    NSMutableDictionary *userInfo   = [NSMutableDictionary new];
    
    if (_uuid) {
        [userInfo setObject:_uuid forKey:@"uuid"];
    }
    
    if (_numberString) {
        [userInfo setObject:_numberString forKey:@"phone"];
    }
    
    if (_passWord) {
        [userInfo setObject:_passWord forKey:@"password"];
    }
    
//    if (nickTF.text) {
//        [userInfo setObject:nickTF.text forKey:@"username"];
//    }
    
    if (genderStr) {
        [userInfo setObject:genderStr forKey:@"gender"];
    }
//    if (_imgURL) {
//        [userInfo setObject:_imgURL forKey:@"avatar"];
//    }
//    if (ageTF.textLabel.text) {
//        [userInfo setObject:ageTF.textLabel.text forKey:@"birthday"];
//    }
//    
//    if (provinceStr) {
//        [userInfo setObject:provinceStr forKey:@"province"];
//    }
//    
//    if (cityStr) {
//        [userInfo setObject:cityStr forKey:@"city"];
//    }
    
    
    [[FitUserManager sharedUserManager] updateUserInfo:userInfo];
}




#pragma mark pickerView选择日期

-(void)timeChooseAction
{
    NSDateFormatter *formatter  = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *currentDate;
    
    currentDate = [NSDate date];
    
    
    
    [FitDatePickerView showWithMinimumDate:[formatter dateFromString:@"1950-01-01"]
                               MaximumDate:[NSDate date]
                               CurrentDate:currentDate
                                      Mode:UIDatePickerModeDate
                                  Delegate:self];
}

- (void)didSelectedDate:(NSDate *)date
{
    NSDateFormatter *formatter  = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    
        ageTF.textLabel.text   = [formatter stringFromDate:date];
}

#pragma mark pickerView选择城市

-(void)addressChooseAction
{
    [self.view endEditing:YES];
    
    NSString *plistPath     = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"plist"];
    NSArray  *dataArr        = [NSArray arrayWithContentsOfFile:plistPath];
    
    NSMutableArray *provinceArr = [NSMutableArray arrayWithCapacity:0];
    
    for (NSDictionary *dic in dataArr) {
        [provinceArr addObject:[dic objectForKey:@"AddressName"]];
    }
    [FitPickerView showWithData:@[provinceArr, @[@"北京"]] Delegate:self OffSets:@[@"0", @"0"]];
}


- (void)didSelectedItems:(NSArray *)items Row:(NSInteger)row
{

    cityTF.textLabel.text = [NSString stringWithFormat:@"%@ %@", items[0], items[1]];
    provinceStr = [NSString stringWithFormat:@"%@",items[0]];
    cityStr = [NSString stringWithFormat:@"%@",items[1]];
    
}


#pragma mark  性别选择

-(void)manAction
{
    NSLog(@"************man****");
    manButton.headImage.image = [UIImage imageNamed:@"manIcon-choose"];
    manButton.roolImage.image = [UIImage imageNamed:@"roolIcon-choose"];
    womanButton.headImage.image = [UIImage imageNamed:@"womanIcon-gray"];
    womanButton.roolImage.image = [UIImage imageNamed:@"roolIcon-gray"];
    genderStr = @"1";
}

-(void)womanAction{
    NSLog(@"***********woman*****");
    manButton.headImage.image = [UIImage imageNamed:@"manIcon-gray"];
    manButton.roolImage.image = [UIImage imageNamed:@"roolIcon-gray"];
    womanButton.headImage.image = [UIImage imageNamed:@"womanIcon-choose"];
    womanButton.roolImage.image = [UIImage imageNamed:@"roolIcon-choose"];
    genderStr = @"2";
}

#pragma mark UIImagePickerController代理函数

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [pickImage dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    //设置头像图片
    [headerView setImage:image];
    //获取图片的url
    [self getImageURL:image];
    
    [pickImage dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 获取头像的url

- (void)getImageURL:(UIImage*)image
{
    if (![CheckUtils isLink]) {
        
        [self textStateHUD:@"无网络连接"];
        return;
    }
    
    [self initStateHud];

    FirUploadImageRequest   *request    = [[FirUploadImageRequest alloc] initWithFileName:@"file"];
    UIImage *headImage = [ImageHelpTool scaleImage:image];
    request.imageData   = UIImageJPEGRepresentation(headImage, 1);
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding){
                                               
                                               [self performSelectorOnMainThread:@selector(hideStateHud)
                                                                      withObject:nil
                                                                   waitUntilDone:YES];
                                               NSDictionary    *bodyDict   = [VOUtil parseBody:resp];
                                               
                                               NSString    *result = [bodyDict objectForKey:@"result"];
                                               
                                               NSLog(@"--------bodyDict--------%@",bodyDict);
                                               
                                               if (result && [result isKindOfClass:[NSString class]]
                                                   && [result isEqualToString:@"0"]) {
                                                   NSString    *imgUrl = [bodyDict objectForKey:@"attachment_url"];
                                                   if (imgUrl && [imgUrl isKindOfClass:[NSString class]]) {
                                                       _imgURL=imgUrl;
                                                   }
                                               }
                                           } failed:^(NSError *error) {
                                               [self hideStateHud];
                                           }];
    [proxy start];
}


#pragma mark 确定执行方法

-(void)saveUserInfoResponse:(NSString *)resp
{
    NSDictionary    *bodyDict   = [VOUtil parseBody:resp];
    if (!bodyDict)
    {
        [self textStateHUD:@"保存失败"];
        return;
    }
    if (bodyDict && [bodyDict objectForKey:@"result"]
        && [[bodyDict objectForKey:@"result"] isKindOfClass:[NSString class]])
    {
        if ([[bodyDict objectForKey:@"result"] isEqualToString:@"0"]){
            [self textStateHUD:@"保存成功"];
            NSLog(@"保存成功");
            [self setUserInfo];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self dismissViewControllerAnimated:YES completion:nil];
            });
            
        }else{
            [self textStateHUD:[bodyDict objectForKey:@"description"]];
        }
    }
}

- (void)selectHeadImage
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"相册", @"拍照",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
    actionSheet = nil;
}


#pragma mark UIActionSheet 代理函数

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
    {//图库
        [pickImage setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [self presentViewController:pickImage animated:YES completion:nil];
    }
    if (buttonIndex==1)
    {//摄像头
        //判断后边的摄像头是否可用
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear])
        {
            [pickImage setSourceType:UIImagePickerControllerSourceTypeCamera];
            [self presentViewController:pickImage animated:YES completion:nil];
        }
        //判断前边的摄像头是否可用
        else if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront])
        {
            [pickImage setSourceType:UIImagePickerControllerSourceTypeCamera];
            [self presentViewController:pickImage animated:YES completion:nil];
        }else{
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@""
                                                         message:@"相机不可用" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

#pragma mark UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [nickTF resignFirstResponder];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self scrollEditingRectToVisible:textField.frame EditingView:textField];
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
