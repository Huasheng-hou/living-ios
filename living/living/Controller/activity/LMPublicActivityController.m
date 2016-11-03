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
#import "LMPublicProjectRequest.h"
#import "FirUploadImageRequest.h"
#import "ImageHelpTool.h"
#import "BabFilterAgePickerView.h"
#import "FitPickerThreeLevelView.h"
#import "LMMapViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface LMPublicActivityController ()
<
UITableViewDelegate,
UITableViewDataSource,
UITextFieldDelegate,
UITextViewDelegate,
FitDatePickerDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
UIViewControllerTransitioningDelegate,
UIActionSheetDelegate,
FitPickerViewDelegate,
LMPublicEventCellDelegate,
selectAddressDelegate
>
{
    LMPublicMsgCell *msgCell;
    LMPublicEventListCell *AddEventCell;
    UIImagePickerController *pickImage;
    NSString *_imgURL;
    NSString *_imgProURL;
    NSInteger dateIndex;
    NSInteger timeIndex;
    NSInteger cellIndex;
    NSString                    *districtStr;//设置中间变量，获取县（区）的编码
    NSInteger imageIndex;
    NSString *eventUUid;
    
    NSInteger projectIndex;
    
    NSMutableArray *projectTitle;
    NSMutableArray *projectDsp;
    NSMutableArray *imageURL;
    
    CGFloat _latitude;
    CGFloat _longitude;
}
@property(nonatomic,strong) MAMapView *mapView;
@property (nonatomic, strong) AMapSearchAPI *search;

@end

@implementation LMPublicActivityController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"发布活动";
    // Do any additional setup after loading the view.
    [self creatUI];
    
    [self initSearch];
    
    [self initMapView];
    
    projectTitle = [NSMutableArray new];
    projectDsp = [NSMutableArray new];
    imageURL = [NSMutableArray new];
    
}

- (void)initSearch
{
    if (self.search==nil) {
        self.search     = [[AMapSearchAPI alloc] init];
    }
}

-(void)initMapView
{
    if (self.mapView==nil) {
        self.mapView    = [[MAMapView alloc] initWithFrame:self.view.bounds];
    }
    self.mapView.visibleMapRect = MAMapRectMake(220880104, 101476980, 272496, 466656);

    
}


-(void)creatUI
{
//    [super createUI];
    
    _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    //去分割线
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    pickImage=[[UIImagePickerController alloc]init];
    
    [pickImage setDelegate:self];
    pickImage.transitioningDelegate  = self;
    pickImage.modalPresentationStyle = UIModalPresentationCustom;
    [pickImage setAllowsEditing:YES];
    cellIndex = 1;
    
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
    
    [addButton addTarget:self action:@selector(addButtonAction:) forControlEvents:UIControlEventTouchUpInside];
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
        return cellIndex;
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

        [msgCell.endDateButton addTarget:self action:@selector(endDateAction:) forControlEvents:UIControlEventTouchUpInside];

        [msgCell.addressButton addTarget:self action:@selector(addressAction:) forControlEvents:UIControlEventTouchUpInside];
        [msgCell.imageButton addTarget:self action:@selector(imageButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [msgCell.mapButton addTarget:self action:@selector(selectLocation) forControlEvents:UIControlEventTouchUpInside];
        
         return msgCell;
    }
    if (indexPath.section==1) {
        
        static NSString *cellId = @"cellId";
        AddEventCell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!AddEventCell) {
            AddEventCell = [[LMPublicEventListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            AddEventCell.selectionStyle = UITableViewCellSelectionStyleNone;
            AddEventCell.delegate = self;
            AddEventCell.titleTF.delegate = self;
            AddEventCell.includeTF.delegate = self;
            AddEventCell.cellndex = indexPath.row;
            AddEventCell.tag = indexPath.row;

        }
         
        
        return AddEventCell;
    }
    return nil;
}

#pragma mark 地图选择地址详情

-(void)selectLocation
{
    LMMapViewController *map=[[LMMapViewController alloc]init];
    map.delegate=self;
    map.mapView=self.mapView;
    map.search=self.search;
    [self.navigationController pushViewController:map animated:YES];
}

- (void)selectAddress:(NSString *)addressName andLatitude:(CGFloat)latitude
         andLongitude:(CGFloat)longitude
          anddistance:(CGFloat)distance
{
    NSLog(@"=============addressName=%@,latitude=%f  longitude=%f",addressName,latitude,longitude);
    msgCell.dspTF.text=addressName;
    _latitude=latitude;
    _longitude=longitude;
}

-(void)beginDateAction:(id)sender
{
    [self.view endEditing:YES];
    dateIndex = 0;
    NSLog(@"************beginDateAction");
    NSDateFormatter *formatter  = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *currentDate;
    
    currentDate = [NSDate date];
    
    [FitDatePickerView showWithMinimumDate:[formatter dateFromString:@"1950-01-01"]
                               MaximumDate:[formatter dateFromString:@"2950-01-01"]
                               CurrentDate:currentDate
                                      Mode:UIDatePickerModeDateAndTime
                                  Delegate:self];

}

-(void)endDateAction:(id)sender
{
    [self.view endEditing:YES];
    dateIndex = 1;
    NSLog(@"************endDateAction");
    
    NSDateFormatter *formatter  = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *currentDate;
    
    currentDate = [NSDate date];
    
    [FitDatePickerView showWithMinimumDate:[formatter dateFromString:@"2010-01-01 00:00:00"]
                               MaximumDate:[formatter dateFromString:@"2950-01-01 00:00:00"]
                               CurrentDate:currentDate
                                      Mode:UIDatePickerModeDateAndTime
                                  Delegate:self];
    
}


#pragma mark 选择省市区视图

-(void)createPickerView
{
    
    FitPickerThreeLevelView *pickView=[[FitPickerThreeLevelView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 260)];
    pickView.delegate=self;
    [[[[UIApplication sharedApplication] delegate] window] addSubview:pickView];
}

-(void)addressAction:(id)sender
{
    [self.view endEditing:YES];
    NSLog(@"************addressAction");
    
   [self createPickerView];
    
}
- (void)didSelectedItems:(NSArray *)items andDistrict:(NSString *)district
{
   
        msgCell.addressButton.textLabel.text = [NSString stringWithFormat:@"%@", items[0]];
        districtStr=district;
    
}




-(void)imageButtonAction:(id)sender
{
    NSLog(@"************imageButtonAction");
    imageIndex = 0;
    
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

-(void)cellWilladdImage:(LMPublicEventListCell *)cell
{
    NSLog(@"*******项目图片");
    
    imageIndex = 1;
    projectIndex =cell.cellndex;
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
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    if (dateIndex==0) {
        msgCell.dateButton.textLabel.text   = [formatter stringFromDate:date];
    }
    if (dateIndex==1) {
         msgCell.endDateButton.textLabel.text   = [formatter stringFromDate:date];
    }
   
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [self.view endEditing:YES];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
        
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}


- (void)textViewDidChange:(UITextView *)textView1
{
    AddEventCell = (LMPublicEventListCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:AddEventCell.tag inSection:1]];
    
    if (textView1.text.length==0)
    {
        [AddEventCell.textLab setHidden:NO];
    }else{
        [AddEventCell.textLab setHidden:YES];
    }
}


-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    AddEventCell = (LMPublicEventListCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:AddEventCell.tag inSection:1]];
    
    if (AddEventCell.includeTF.text.length>0) {
        projectDsp[AddEventCell.tag]  = AddEventCell.includeTF.text;
    }
    
    [self resignCurrentFirstResponder];
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [self scrollEditingRectToVisible:textView.frame EditingView:textView];
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if ([textField isEqual:AddEventCell.titleTF]&&textField.text.length>0) {
        AddEventCell = (LMPublicEventListCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:AddEventCell.tag inSection:1]];
        
        projectTitle[AddEventCell.tag] = AddEventCell.titleTF.text;
    }
    
    
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
    if (imageIndex==0) {
        //设置头像图片

        msgCell.imgView.contentMode = UIViewContentModeScaleAspectFill;
        msgCell.imgView.clipsToBounds = YES;
        [msgCell.imgView setImage:image];
        //获取图片的url
        [self getImageURL:image];
    }
    if (imageIndex==1) {
        //设置头像图片
        
        
        AddEventCell = (LMPublicEventListCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:projectIndex inSection:1]];
                
        AddEventCell.imgView.contentMode = UIViewContentModeScaleAspectFill;
        AddEventCell.imgView.clipsToBounds = YES;
        [AddEventCell.imgView setImage:image];
        //获取图片的url
        [self getImageURL:image];
      

}
        

    
    [pickImage dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark 获取头像的url

- (void)getImageURL:(UIImage*)image
{
    if (![CheckUtils isLink]) {
        
        [self textStateHUD:@"无网络连接"];
        return;
    }
    
    if (imageIndex==0) {
        FirUploadImageRequest   *request    = [[FirUploadImageRequest alloc] initWithFileName:@"file"];
        UIImage *headImage = [ImageHelpTool scaleImage:image];
        request.imageData   = UIImageJPEGRepresentation(headImage, 1);
        
        [self initStateHud];
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
    if (imageIndex==1) {
        
                
                FirUploadImageRequest   *request    = [[FirUploadImageRequest alloc] initWithFileName:@"file"];
                UIImage *headImage = [ImageHelpTool scaleImage:image];
                request.imageData   = UIImageJPEGRepresentation(headImage, 1);
                
                [self initStateHud];
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
                                                                   
                                                                   _imgProURL=imgUrl;
                                                                   
                                                                   imageURL[projectIndex] = _imgProURL;
                                                                   
                                                                   
                                                               }
                                                           }
                                                       } failed:^(NSError *error) {
                                                           [self hideStateHud];
                                                       }];
                [proxy start];
                

        


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
    NSString *startstring = [NSString stringWithFormat:@"%@",msgCell.dateButton.textLabel.text];
    NSString *endString =[NSString stringWithFormat:@"%@",msgCell.endDateButton.textLabel.text];

    if (!(msgCell.titleTF.text.length>0)) {
        [ self textStateHUD:@"请输入活动标题"];
        return;
    }
    if (!(msgCell.phoneTF.text.length>0)) {
        [ self textStateHUD:@"请输入联系电话"];
        return;
    }
    if (!(msgCell.nameTF.text.length>0)) {
        [ self textStateHUD:@"请输入联系人名字"];
        return;
    }
    if (!(msgCell.freeTF.text.length>0)) {
        [ self textStateHUD:@"请输入人均费用"];
        return;
    }
    if ([msgCell.addressButton.textLabel.text isEqual:@"请选择活动所在省市，县区"]) {
        [ self textStateHUD:@"请选择活动地址"];
        return;
    }
    if (!(msgCell.dspTF.text.length>0)) {
        [ self textStateHUD:@"请选择活动详细地址"];
        return;
    }
    
    if ([startstring isEqual:@"请选择活动开始时间"]) {
        [ self textStateHUD:@"请选择开始时间"];
        return;
    }
    if ([endString isEqual:@"请选择活动开始时间"]) {
        [ self textStateHUD:@"请选择开始时间"];
        return;
    }
  
    LMPublicEventRequest *request = [[LMPublicEventRequest alloc] initWithevent_name:msgCell.titleTF.text Contact_phone:msgCell.phoneTF.text Contact_name:msgCell.nameTF.text Per_cost:msgCell.freeTF.text Start_time:startstring End_time:endString Address:msgCell.addressButton.textLabel.text Address_detail:msgCell.dspTF.text Event_img:_imgURL Event_type:@"ordinary" andLatitude:[NSString stringWithFormat:@"%f",_latitude] andLongitude:[NSString stringWithFormat:@"%f",_longitude]];
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(getEventDataResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"获取列表失败"
                                                                   waitUntilDone:YES];
                                           }];
    [proxy start];

    
    [self publicProject];
    
}

-(void)publicProject
{
    if (!(AddEventCell.titleTF.text.length>0)) {
        [ self textStateHUD:@"请输入活动标题"];
        return;
    }
    

    
    if (![AddEventCell.includeTF isEqual:@""]) {
            [projectDsp addObject:AddEventCell.includeTF.text];
    }else{
            [projectDsp addObject:@""];
    }
    
    if (imageURL.count<projectTitle.count) {
        for (int i = 0; projectTitle.count-imageURL.count; i++) {
           [imageURL addObject:@""];
        }
        
    }


    
    
    for (int i =0; i<projectTitle.count; i++) {
        
        
        LMPublicProjectRequest *request = [[LMPublicProjectRequest alloc]initWithEvent_uuid:eventUUid Project_title:projectTitle[i] Project_dsp:projectDsp[i] Project_imgs:imageURL[i]];

        HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                               completed:^(NSString *resp, NSStringEncoding encoding) {
                                                   
                                                   [self performSelectorOnMainThread:@selector(getEventPublicProjectDataResponse:)
                                                                          withObject:resp
                                                                       waitUntilDone:YES];
                                               } failed:^(NSError *error) {
                                                   
                                                   [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                          withObject:@"获取列表失败"
                                                                       waitUntilDone:YES];
                                               }];
        [proxy start];
    }

}



-(void)getEventDataResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    
    NSLog(@"***************%@",bodyDic);
    if (!bodyDic) {
        [self textStateHUD:@"发布失败"];
    }else{
        if ([[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
            NSString *string = [bodyDic objectForKey:@"event_uuid"];
            eventUUid = string;
            [self publicProject];
        }else{
            NSString *string = [bodyDic objectForKey:@"description"];
            [self textStateHUD:string];
        }
    }

}


-(void)getEventPublicProjectDataResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    NSLog(@"**********%@",bodyDic);
    if (!bodyDic) {
        [self textStateHUD:@"发布项目失败"];
    }else{
        if ([[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
            [self textStateHUD:@"发布项目成功"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadEvent"
                 
                                                                    object:nil];
            });
            

            
        }else{
            NSString *string = [bodyDic objectForKey:@"description"];
            [self textStateHUD:string];
        }
    }
        
    
}

#pragma mark  --添加项目
-(void)addButtonAction:(id)sender
{
    cellIndex = cellIndex+1;
    
    if (cellIndex==5) {
        [self textStateHUD:@"最多可添加五个项目"];
        return;
    }
    
    
    [self.tableView reloadData];
    
    [projectTitle addObject:@""];
    [projectDsp addObject:@""];
    [imageURL addObject:@""];
    
    
    
}

- (void)resignCurrentFirstResponder
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow endEditing:YES];
}
- (void)scrollEditingRectToVisible:(CGRect)rect EditingView:(UIView *)view
{
    CGFloat     keyboardHeight  = 280;
    
    if (view && view.superview) {
        rect    = [self.tableView convertRect:rect fromView:view.superview];
    }
    
    if (rect.origin.y < kScreenHeight - keyboardHeight - rect.size.height - 64) {
        return;
    }
    
    [self.tableView setContentOffset:CGPointMake(0, rect.origin.y - (kScreenHeight - keyboardHeight - rect.size.height)) animated:YES];
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
