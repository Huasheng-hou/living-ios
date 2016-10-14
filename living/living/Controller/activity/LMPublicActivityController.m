//
//  LMPublicActivityController.m
//  living
//
//  Created by Ding on 16/10/8.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMPublicActivityController.h"
#import "LMPublicEventListCell.h"
#import "LMPublicMsgCell.h"
#import "LMTimeButton.h"
#import "FitPickerView.h"
#import "FitDatePickerView.h"
#import "LMPublicEventRequest.h"
#import "FirUploadImageRequest.h"
#import "ImageHelpTool.h"
#import "BabFilterAgePickerView.h"

@interface LMPublicActivityController ()<UITableViewDelegate,
UITableViewDataSource,
UITextFieldDelegate,
UITextViewDelegate,
FitDatePickerDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
UIActionSheetDelegate,
FitPickerViewDelegate
>
{
    LMPublicMsgCell *msgCell;
    LMPublicEventListCell *AddEventCell;
    UIImagePickerController *pickImage;
    NSString *_imgURL;
    NSInteger dateIndex;
    NSInteger timeIndex;
    
    
}

@end

@implementation LMPublicActivityController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatUI];
}

-(void)creatUI
{
    [super createUI];
    //去分割线
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    pickImage=[[UIImagePickerController alloc]init];
    
    [pickImage setDelegate:self];
    [pickImage setAllowsEditing:NO];
    
    
    [self creatFootView];
    
    
}

-(void)creatFootView
{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 150)];
    footView.backgroundColor = [UIColor clearColor];
    
    UIButton *publicButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [publicButton setTitle:@"确认并发布" forState:UIControlStateNormal];
    publicButton.layer.cornerRadius = 5;
    publicButton.titleLabel.font = TEXT_FONT_LEVEL_2;
    publicButton.frame = CGRectMake(10, 65, kScreenWidth-20, 45);
    publicButton.backgroundColor = LIVING_COLOR;
    
    [publicButton addTarget:self action:@selector(publishButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [footView addSubview:publicButton];
    
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setTitle:@"添加项目" forState:UIControlStateNormal];
    [addButton setTitleColor:LIVING_COLOR forState:UIControlStateNormal];
    addButton.titleLabel.font = TEXT_FONT_LEVEL_2;
    addButton.frame = CGRectMake(kScreenWidth/2-50, 5, 100, 30);
    [footView addSubview:addButton];
    
    
    self.tableView.tableFooterView = footView;
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
        return 2;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 400 +165;
    }
    if (indexPath.section==1) {
        return 340;
    }
    return 0;
}



-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 35)];
        
        UIView *commentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 35)];
        commentView.backgroundColor = [UIColor whiteColor];
        [headView addSubview:commentView];
        
        UILabel *commentLabel = [UILabel new];
        commentLabel.font = [UIFont systemFontOfSize:13.f];
        commentLabel.textColor = [UIColor colorWithRed:0/255.0 green:130/255.0 blue:230.0/255.0 alpha:1.0];
        commentLabel.text = @"活动信息";
        [commentLabel sizeToFit];
        commentLabel.frame = CGRectMake(15, 10, commentLabel.bounds.size.width, commentLabel.bounds.size.height);
        [commentView addSubview:commentLabel];
        
        
        UIView *line = [UIView new];
        line.backgroundColor =[UIColor colorWithRed:0/255.0 green:130/255.0 blue:230.0/255.0 alpha:1.0];
        [line sizeToFit];
        line.frame =CGRectMake(0, 10+1, 3.f, commentLabel.bounds.size.height-2);
        [commentView addSubview:line];
        
        
        headView.backgroundColor = [UIColor clearColor];
        return headView;

    }
    
    
    if (section==1) {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        
        UIView *commentView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, kScreenWidth, 35)];
        commentView.backgroundColor = [UIColor whiteColor];
        [headView addSubview:commentView];
        
        UILabel *commentLabel = [UILabel new];
        commentLabel.font = [UIFont systemFontOfSize:13.f];
        commentLabel.textColor = [UIColor colorWithRed:0/255.0 green:130/255.0 blue:230.0/255.0 alpha:1.0];
        commentLabel.text = @"活动介绍";
        [commentLabel sizeToFit];
        commentLabel.frame = CGRectMake(15, 10, commentLabel.bounds.size.width, commentLabel.bounds.size.height);
        [commentView addSubview:commentLabel];
        
        
        UIView *line = [UIView new];
        line.backgroundColor =[UIColor colorWithRed:0/255.0 green:130/255.0 blue:230.0/255.0 alpha:1.0];
        [line sizeToFit];
        line.frame =CGRectMake(0, 10+1, 3.f, commentLabel.bounds.size.height-2);
        [commentView addSubview:line];
        
        
        headView.backgroundColor = [UIColor clearColor];
        return headView;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 35;
    }
    if (section==1) {
        return 40;
    }
    return 0;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==0) {
        
        static NSString *cellID = @"cellID";
        msgCell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!msgCell) {
            msgCell = [[LMPublicMsgCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        msgCell.selectionStyle = UITableViewCellSelectionStyleNone;
        msgCell.titleTF.delegate = self;
        msgCell.phoneTF.delegate = self;
        msgCell.nameTF.delegate = self;
        msgCell.freeTF.delegate =self;
        msgCell.dspTF.delegate = self;
        
        [msgCell.dateButton addTarget:self action:@selector(beginDateAction:) forControlEvents:UIControlEventTouchUpInside];
        [msgCell.timeButton addTarget:self action:@selector(beginTimeAction:) forControlEvents:UIControlEventTouchUpInside];
        [msgCell.endDateButton addTarget:self action:@selector(endDateAction:) forControlEvents:UIControlEventTouchUpInside];
        [msgCell.endTimeButton addTarget:self action:@selector(endTimeAction:) forControlEvents:UIControlEventTouchUpInside];
        [msgCell.addressButton addTarget:self action:@selector(addressAction:) forControlEvents:UIControlEventTouchUpInside];
        [msgCell.imageButton addTarget:self action:@selector(imageButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
         return msgCell;
    }
    if (indexPath.section==1) {
        
        static NSString *cellId = @"cellId";
        AddEventCell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!AddEventCell) {
            AddEventCell = [[LMPublicEventListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            AddEventCell.titleTF.delegate = self;
            AddEventCell.includeTF.delegate = self;
            [AddEventCell.eventButton addTarget:self action:@selector(addImageAction:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        return AddEventCell;
    }
    return nil;
}


-(void)beginDateAction:(id)sender
{
    dateIndex = 0;
    NSLog(@"************beginDateAction");
    NSDateFormatter *formatter  = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *currentDate;
    
    currentDate = [NSDate date];
    
    [FitDatePickerView showWithMinimumDate:[formatter dateFromString:@"1950-01-01"]
                               MaximumDate:[formatter dateFromString:@"2950-01-01"]
                               CurrentDate:currentDate
                                      Mode:UIDatePickerModeDate
                                  Delegate:self];

}
-(void)beginTimeAction:(id)sender
{
    NSLog(@"************beginTimeAction");
    timeIndex = 0;
    NSMutableArray *hourArray = [NSMutableArray new];
    for(int i=0; i<24; i++){
        [hourArray addObject:[NSString stringWithFormat:@"%02d",i]];
    }
    
    NSMutableArray *minArray = [NSMutableArray new];
    
    for(int i=0; i<60; i++){
        [minArray addObject:[NSString stringWithFormat:@"%02d",i]];
    }
    [self.view endEditing:YES];
    NSArray *arr = @[@":"];
    [BabFilterAgePickerView showWithData:@[hourArray, arr, minArray] Delegate:self OffSets:@[@"0",@"0",@"0"]];
}
-(void)endDateAction:(id)sender
{
    dateIndex = 1;
    NSLog(@"************endDateAction");
    
    NSDateFormatter *formatter  = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *currentDate;
    
    currentDate = [NSDate date];
    
    [FitDatePickerView showWithMinimumDate:[formatter dateFromString:@"1950-01-01"]
                               MaximumDate:[formatter dateFromString:@"2950-01-01"]
                               CurrentDate:currentDate
                                      Mode:UIDatePickerModeDate
                                  Delegate:self];
    
}
-(void)endTimeAction:(id)sender
{
    NSLog(@"************endTimeAction");
    timeIndex = 1;
    NSMutableArray *hourArray = [NSMutableArray new];
    for(int i=0; i<24; i++){
        [hourArray addObject:[NSString stringWithFormat:@"%02d",i]];
    }
    
    NSMutableArray *minArray = [NSMutableArray new];
    
    for(int i=0; i<60; i++){
        [minArray addObject:[NSString stringWithFormat:@"%02d",i]];
    }
    [self.view endEditing:YES];
    NSArray *arr = @[@":"];
    [BabFilterAgePickerView showWithData:@[hourArray, arr, minArray] Delegate:self OffSets:@[@"0",@"0",@"0"]];
}
-(void)addressAction:(id)sender
{
    NSLog(@"************addressAction");
}

-(void)imageButtonAction:(id)sender
{
    NSLog(@"************imageButtonAction");
    
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

-(void)addImageAction:(id)sender
{
    NSLog(@"*******项目图片");
    
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


#pragma mark  -日期选择
- (void)didSelectedDate:(NSDate *)date
{
    NSDateFormatter *formatter  = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    
    if (dateIndex==0) {
        msgCell.dateButton.textLabel.text   = [formatter stringFromDate:date];
    }
    if (dateIndex==1) {
         msgCell.endDateButton.textLabel.text   = [formatter stringFromDate:date];
    }
   
}

- (void)didSelectedItems:(NSArray *)items Row:(NSInteger)row
{
    if (timeIndex==0) {
        
        msgCell.timeButton.textLabel.text =[NSString stringWithFormat:@"%@:%@", items[0],items[2]];
    }
    if (timeIndex==1){
        msgCell.endTimeButton.textLabel.text = [NSString stringWithFormat:@"%@:%@", items[0],items[2]];

    }
    
    
    
}





-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [self resignCurrentFirstResponder];
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [self scrollEditingRectToVisible:textView.frame EditingView:textView];
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [self resignCurrentFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self scrollEditingRectToVisible:textField.frame EditingView:textField];
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
    [msgCell.imageButton.imageView setImage:image];
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
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self dismissViewControllerAnimated:YES completion:nil];
            });
            
        }else{
            [self textStateHUD:[bodyDict objectForKey:@"description"]];
        }
    }
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
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""
                                                                           message:@"相机不可用"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定"
                                                                   style:UIAlertActionStyleCancel
                                                                 handler:nil];
        
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
            
            
            
        }
    }
}



#pragma mark  --确认并发布按钮

-(void)publishButtonAction:(id)sender
{
    NSLog(@"**************发布");
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
