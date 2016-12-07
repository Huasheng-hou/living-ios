//
//  LMPublishViewController.m
//  living
//
//  Created by JamHonyZ on 2016/11/5.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMPublishViewController.h"
#import "LMProjectCell.h"
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
#import "LMSearchAddressController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "UIImageView+WebCache.h"
#import "LMAddressChooseView.h"

@interface LMPublishViewController ()
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
selectAddressDelegate,
addressTypeDelegate
>
{
    LMPublicMsgCell *msgCell;
    UIImagePickerController *pickImage;
    NSString *_imgURL;
    NSString *_imgProURL;
    NSInteger dateIndex;
    NSInteger timeIndex;
    NSString  *districtStr;//设置中间变量，获取县（区）的编码
    //    NSInteger imageIndex;
    NSString *eventUUid;
    
    NSInteger projectIndex;
    
    CGFloat _latitude;
    CGFloat _longitude;
    LMProjectCell * cell;
    NSInteger addImageIndex;
    
    NSMutableArray *projectImageArray;
    LMAddressChooseView *addView;
    LMAddressChooseView *addView2;
    
}
@property(nonatomic,strong) MAMapView *mapView;
@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic,retain)UITableView *tableView;
@end

@implementation LMPublishViewController

static NSMutableArray *cellDataArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布活动";
    cellDataArray=[NSMutableArray arrayWithCapacity:10];
    projectImageArray=[NSMutableArray arrayWithCapacity:10];
    
    for (int i=0; i<10; i++) {
        [projectImageArray addObject:@""];
    }
    
    [self projectDataStorageWithArrayIndex:0];
    
    [self creatUI];
    
    [self initSearch];

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
    
    self.mapView.allowsBackgroundLocationUpdates    = NO;
    self.mapView.showsUserLocation                  = YES;
}

- (void)creatUI
{
    _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.keyboardDismissMode          = UIScrollViewKeyboardDismissModeOnDrag;
    
    //去分割线
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;

    
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
        return cellDataArray.count;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 490 +kScreenWidth*3/5+90;
    }
    if (indexPath.section==1) {
        return 340;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 35)];
        
        UIView *commentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 35)];
        commentView.backgroundColor = [UIColor whiteColor];
        [headView addSubview:commentView];
        
        UILabel *commentLabel = [UILabel new];
        commentLabel.font = [UIFont systemFontOfSize:13.f];
        commentLabel.textColor = LIVING_COLOR;
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
        commentLabel.textColor = LIVING_COLOR;
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
        msgCell.VipFreeTF.delegate = self;
        msgCell.joincountTF.delegate = self;
        
        msgCell.titleTF.tag = 100;
        msgCell.phoneTF.tag = 100;
        msgCell.nameTF.tag = 100;
        msgCell.freeTF.tag =100;
        msgCell.dspTF.tag = 100;
        msgCell.VipFreeTF.tag = 100;
        msgCell.joincountTF.tag = 100;
        msgCell.applyTextView.delegate = self;
        
        
        [msgCell.dateButton addTarget:self action:@selector(beginDateAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [msgCell.endDateButton addTarget:self action:@selector(endDateAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [msgCell.addressButton addTarget:self action:@selector(addressAction:) forControlEvents:UIControlEventTouchUpInside];
        [msgCell.imageButton addTarget:self action:@selector(imageButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [msgCell.imageButton setTag:0];
        
        [msgCell.mapButton addTarget:self action:@selector(selectLocation) forControlEvents:UIControlEventTouchUpInside];
        
        return msgCell;
    }
    if (indexPath.section==1) {
        
        static NSString *cellId = @"cellId";
        cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell==nil) {
            cell = [[LMProjectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.title.delegate = self;
            cell.includeTF.delegate = self;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.title setTag:indexPath.row];
        [cell.includeTF setTag:indexPath.row];
        cell.cellndex = indexPath.row;
        cell.tag = indexPath.row;
        
        cell.title.text=cellDataArray[indexPath.row][@"title"];
        
        cell.includeTF.text=cellDataArray[indexPath.row][@"content"];
        
        if ([projectImageArray[indexPath.row] isKindOfClass:[UIImage class]]) {
            UIImage *image=(UIImage *)projectImageArray[indexPath.row];
            [cell.imgView setImage:image];
        }else
            if ([projectImageArray[indexPath.row] isKindOfClass:[NSString class]]) {
                [cell.imgView setImage:[UIImage imageNamed:@""]];
            }
        
        
        [cell.deleteBt addTarget:self action:@selector(closeCell:) forControlEvents:UIControlEventTouchUpInside];
        [cell.deleteBt setTag:indexPath.row];
        
        [cell.eventButton addTarget:self action:@selector(imageButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.eventButton setTag:indexPath.row+10];
        
        [cell.deleteBt setHidden:NO];
        
        if (cellDataArray.count==1) {
            if (indexPath.row==0) {
                [cell.deleteBt setHidden:YES];
            }else{
                [cell.deleteBt setHidden:NO];
            }
        }
        
        if ([cellDataArray[indexPath.row][@"content"] isEqualToString:@""]&&cellDataArray[indexPath.row][@"content"]) {
            [cell.textLab setHidden:NO];
        }else{
            [cell.textLab setHidden:YES];
        }
        
        return cell;
    }
    return nil;
}

- (void)closeCell:(UIButton *)button
{
    NSInteger row=button.tag;
    
    [cellDataArray removeObjectAtIndex:row];
    
    [projectImageArray removeObjectAtIndex:row];
    
    [self refreshData];
}

#pragma mark 地图选择地址详情

- (void)selectLocation
{
    addView = [[LMAddressChooseView alloc] initWithIndex:2];
    [addView setDelegate:self];
    addView.addressTF.delegate = self;
    
    [addView.addressButton addTarget:self action:@selector(addViewAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:addView];

}

-(void)addViewAction
{
    [addView removeFromSuperview];
    LMSearchAddressController *map=[[LMSearchAddressController alloc]init];
    map.delegate=self;
    map.mapView=self.mapView;
    map.search=self.search;
    [self.navigationController pushViewController:map animated:YES];
}


#pragma mark LMAddressChooseView代理方法

-(void)buttonType:(NSInteger)type
{
    if (addView) {
        if (type==1) {//确定
            
            [addView removeFromSuperview];
            _latitude   = 0;
            _longitude  = 0;
            
            if (addView.addressTF.text.length>0) {
                msgCell.dspTF.text = addView.addressTF.text;
            }
        }else{
            [addView removeFromSuperview];
        }
    }
    
    if (addView2) {
        if (type==1) {//确定
            
            [addView2 removeFromSuperview];
            if (addView2.addressTF.text.length>0) {
                msgCell.addressButton.textLabel.text = addView2.addressTF.text;
            }
            
        }else{
            [addView2 removeFromSuperview];
        }
    }

}

//代理方法
- (void)selectAddress:(NSString *)addressName
          andLatitude:(CGFloat)latitude
         andLongitude:(CGFloat)longitude
          anddistance:(CGFloat)distance
{
    msgCell.dspTF.text  = addressName;
    
    _latitude   = latitude;
    _longitude  = longitude;
}

- (void)beginDateAction:(id)sender
{
    [self.view endEditing:YES];
    dateIndex = 0;
    
    NSDateFormatter *formatter  = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *currentDate;
    
    currentDate = [NSDate date];
    
    [FitDatePickerView showWithMinimumDate:currentDate
                               MaximumDate:[formatter dateFromString:@"2950-01-01"]
                               CurrentDate:currentDate
                                      Mode:UIDatePickerModeDateAndTime
                                  Delegate:self];
}

- (void)endDateAction:(id)sender
{
    [self.view endEditing:YES];
    dateIndex = 1;
    
    NSDateFormatter *formatter  = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *currentDate;
    if ([msgCell.dateButton.textLabel.text isEqual:@"请选择活动开始时间"]) {
        currentDate = [NSDate date];
    }else{
        
        NSString *dateString=msgCell.dateButton.textLabel.text;
        
        currentDate=[formatter dateFromString:dateString];
        
    }
    
    [FitDatePickerView showWithMinimumDate:currentDate
                               MaximumDate:[formatter dateFromString:@"2950-01-01 00:00:00"]
                               CurrentDate:currentDate
                                      Mode:UIDatePickerModeDateAndTime
                                  Delegate:self];
}

#pragma mark 选择省市区视图

- (void)createPickerView
{
    addView2 = [[LMAddressChooseView alloc] initWithIndex:1];
    [addView2 setDelegate:self];
    addView2.addressTF.delegate = self;
    [addView2.addressButton addTarget:self action:@selector(addPickerView) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:addView2];

}

-(void)addPickerView
{
    [addView2 removeFromSuperview];
    FitPickerThreeLevelView *pickView=[[FitPickerThreeLevelView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 260)];
    
    pickView.delegate=self;
    [[[[UIApplication sharedApplication] delegate] window] addSubview:pickView];
}

- (void)addressAction:(id)sender
{
    [self.view endEditing:YES];
    [self createPickerView];
}

- (void)didSelectedItems:(NSArray *)items andDistrict:(NSString *)district
{
    msgCell.addressButton.textLabel.text = [NSString stringWithFormat:@"%@", items[0]];
    districtStr=district;
}

#pragma mark ======================活动==项目活动增加图片

- (void)imageButtonAction:(UIButton *)button
{
    addImageIndex=button.tag;
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"相册", @"拍照",nil];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
    actionSheet = nil;
}

#pragma mark - 日期选择

- (void)didSelectedDate:(NSDate *)date
{
    NSDateFormatter *formatter  = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    if (dateIndex == 0) {
        
        msgCell.dateButton.textLabel.text   = [formatter stringFromDate:date];
    }
    if (dateIndex == 1) {
        
        msgCell.endDateButton.textLabel.text   = [formatter stringFromDate:date];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([textView isEqual:addView.addressTF]) {
        if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
            //在这里做你响应return键的代码
            [self.view endEditing:YES];
            return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
            
        }
    }
    if ([textView isEqual:addView2.addressTF]) {
        if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
            //在这里做你响应return键的代码
            [self.view endEditing:YES];
            return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
            
        }
    }

    
    return YES;
}


#pragma mark  textView代理方法

- (void)textViewDidChange:(UITextView *)textView1
{
    if ([textView1 isEqual:msgCell.applyTextView]) {
        
        if (msgCell.applyTextView.text.length>0) {
            msgCell.msgLabel.hidden = YES;
        } else {
            msgCell.msgLabel.hidden  = NO;
        }
        
    }
    if ([textView1 isEqual:addView.addressTF]) {
        if (addView.addressTF.text.length>0) {
            addView.msgLabel.hidden = YES;
        } else {
            addView.msgLabel.hidden  = NO;
        }
    }
    if ([textView1 isEqual:addView2.addressTF]) {
        if (addView2.addressTF.text.length>0) {
            addView2.msgLabel.hidden = YES;
        } else {
            addView2.msgLabel.hidden  = NO;
        }
    }
    
    else{
        
        NSArray *array = self.tableView.visibleCells;
        
        for (UIView * view in array) {
            if ([view isKindOfClass:[LMProjectCell class]]) {
                LMProjectCell * cells = (LMProjectCell *)view;
                if (textView1.text.length==0)
                {
                    [cells.textLab setHidden:NO];
                }else{
                    [cells.textLab setHidden:YES];
                }
            }
            
        }
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{

    if (kScreenWidth<375) {
        if ([textView isEqual:addView.addressTF]) {
            [UIView animateWithDuration:0.25f animations:^{
               addView.frame = CGRectMake(0, -40, kScreenWidth, kScreenHeight+40);
            } completion:^(BOOL finished) {

            }];
            
        
        }
        if ([textView isEqual:addView2.addressTF]) {
        
            [UIView animateWithDuration:0.25f animations:^{
                addView2.frame = CGRectMake(0, -40, kScreenWidth, kScreenHeight+40);
            } completion:^(BOOL finished) {
                
            }];
        }
        
    }

    
    [self scrollEditingRectToVisible:textView.frame EditingView:textView];
}

#pragma mark 项目介绍编辑结束

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    
    if ([textView isEqual:addView.addressTF]) {
        addView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    }else
    
    if ([textView isEqual:addView2.addressTF]) {
        addView2.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    }else
    if ([textView isEqual:msgCell.applyTextView]) {
        
    } else {
        
        NSInteger row=textView.tag;
        
        [self modifyCellDataContent:row andText:textView.text];
    }
    
    return YES;
}

#pragma mark 编辑单元格项目介绍

- (void)modifyCellDataContent:(NSInteger)row andText:(NSString *)text{
    
    NSMutableDictionary *dic=cellDataArray[row];
    
    if ([text isEqualToString:@""]) {
        
        [dic setObject:@"" forKey:@"content"];
    }else{
        [dic setObject:text forKey:@"content"];
    }
    
    [self refreshData];
}

#pragma mark  UITextField代理方法

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

#pragma mark 标题编辑结束

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    
    if (textField.tag==100) {
        return YES;
    }
    NSInteger row=textField.tag;
    
    [self modifyCellDataTitle:row andText:textField.text];
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self scrollEditingRectToVisible:textField.frame EditingView:textField];
}

#pragma mark 编辑单元格标题

- (void)modifyCellDataTitle:(NSInteger)row andText:(NSString *)text{
    
    NSMutableDictionary *dic=cellDataArray[row];
    
    if ([text isEqualToString:@""]) {
        
        [dic setObject:@"" forKey:@"title"];
    }else{
        [dic setObject:text forKey:@"title"];
    }
    
    
    [self refreshData];
    
}

#pragma mark 单元格刚创建后的数据

- (void)projectDataStorageWithArrayIndex:(NSInteger)index
{
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:0];
    [dic setObject:@"" forKey:@"title"];
    [dic setObject:@"" forKey:@"content"];
    [dic setObject:@"" forKey:@"image"];
    
    [cellDataArray insertObject:dic atIndex:index];
}

#pragma mark UIImagePickerController代理函数

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [pickImage dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary<NSString *,id> *)editingInfo
{
    if (addImageIndex==0) {
        //设置头像图片
        msgCell.imgView.contentMode = UIViewContentModeScaleAspectFill;
        msgCell.imgView.clipsToBounds = YES;
        [msgCell.imgView setImage:image];
    }else{
        
        [projectImageArray replaceObjectAtIndex:addImageIndex-10 withObject:image];
    }
    
    [self refreshData];
    
    [self getImageURL:image];
    
    [pickImage dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 编辑单元格项目活动图片

-(void)modifyCellDataImage:(NSInteger)row andImageUrl:(NSString *)imageUrl{
    
    NSMutableDictionary *dic=cellDataArray[row];
    
    if (imageUrl) {
        [dic setObject:imageUrl forKey:@"image"];
    }else{
        [dic setObject:@"" forKey:@"image"];
    }
}

#pragma mark 获取头像的url

- (void)getImageURL:(UIImage*)image
{
    if (![CheckUtils isLink]) {
        
        [self textStateHUD:@"无网络连接"];
        return;
    }
    
    if (addImageIndex == 0) {
        
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
    }else{
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
                                                   
                                                   if (result && [result isKindOfClass:[NSString class]]
                                                       && [result isEqualToString:@"0"]) {
                                                       NSString    *imgUrl = [bodyDict objectForKey:@"attachment_url"];
                                                       if (imgUrl && [imgUrl isKindOfClass:[NSString class]]) {
                                                           
                                                           [self modifyCellDataImage:addImageIndex-10 andImageUrl:imgUrl];
                                                       }
                                                   }
                                               } failed:^(NSError *error) {
                                                   [self hideStateHud];
                                               }];
        [proxy start];
        
    }
}

#pragma mark UIActionSheet ======================代理函数

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    pickImage=[[UIImagePickerController alloc]init];
    
    [pickImage setDelegate:self];
    pickImage.transitioningDelegate  = self;
    pickImage.modalPresentationStyle = UIModalPresentationCustom;
    
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

#pragma mark --判断项目标题是否为空

- (BOOL)judgeProjectTitle
{
    for (NSDictionary *dic in cellDataArray) {
        if ([dic[@"title"] isEqualToString:@""]) {
            return NO;
        }
    }
    return YES;
}

#pragma mark  --确认并发布按钮

-(void)publishButtonAction:(id)sender
{
    [self.view endEditing:YES];
    
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
        [ self textStateHUD:@"请输入活动费用"];
        return;
    }
    if (!(msgCell.VipFreeTF.text.length>0)) {
        [ self textStateHUD:@"请输入会员费用"];
        return;
    }
    
    if (!(msgCell.joincountTF.text.length>0)) {
        [ self textStateHUD:@"请输入活动人数"];
        return;
    }
    
    if ([startstring isEqual:@"请选择活动开始时间"]) {
        [ self textStateHUD:@"请选择开始时间"];
        return;
    }
    if ([endString isEqual:@"请选择活动结束时间"]) {
        [ self textStateHUD:@"请选择结束时间"];
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
    
    if (!msgCell.imgView.image) {
        [ self textStateHUD:@"请选择封面图片"];
        return;
    }
    
    if (![self judgeProjectTitle]) {
        [self textStateHUD:@"活动项目标题不能为空"];
        return;
    }
    
    [self initStateHud];
    
    NSString *latitudeString;
    NSString *longitudeString;
    if (_latitude ==0 &&_longitude==0) {
        latitudeString = @"";
        longitudeString = @"";
    }else{
        latitudeString = [NSString stringWithFormat:@"%f",_latitude];
        longitudeString =[NSString stringWithFormat:@"%f",_longitude] ;
    }
    
    
    LMPublicEventRequest *request = [[LMPublicEventRequest alloc] initWithevent_name:msgCell.titleTF.text Contact_phone:msgCell.phoneTF.text Contact_name:msgCell.nameTF.text Per_cost:msgCell.freeTF.text Discount:msgCell.VipFreeTF.text Start_time:startstring End_time:endString Address:msgCell.addressButton.textLabel.text Address_detail:msgCell.dspTF.text Event_img:_imgURL Event_type:@"ordinary" andLatitude:latitudeString andLongitude:longitudeString limit_number:[msgCell.joincountTF.text intValue] notices:msgCell.applyTextView.text];
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(getEventDataResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"网络错误"
                                                                   waitUntilDone:YES];
                                           }];
    [proxy start];
    
}

- (void)getEventDataResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    
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

#pragma mark --发布活动项目执行请求

- (void)publicProject
{
    for (int i =0; i<cellDataArray.count; i++) {
        
        NSDictionary *dic=cellDataArray[i];
        
        LMPublicProjectRequest *request = [[LMPublicProjectRequest alloc]initWithEvent_uuid:eventUUid Project_title:dic[@"title"] Project_dsp:dic[@"content"] Project_imgs:dic[@"image"]];
        
        HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                               completed:^(NSString *resp, NSStringEncoding encoding) {
                                                   
                                                   [self performSelectorOnMainThread:@selector(getEventPublicProjectDataResponse:)
                                                                          withObject:resp
                                                                       waitUntilDone:YES];
                                               } failed:^(NSError *error) {
                                                   
                                                   [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                          withObject:@"发布失败"
                                                                       waitUntilDone:YES];
                                               }];
        [proxy start];
    }
}

- (void)getEventPublicProjectDataResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    
    if (!bodyDic) {
        [self textStateHUD:@"发布失败"];
    }else{
        if ([[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
            [self textStateHUD:@"发布成功"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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

- (void)addButtonAction:(id)sender
{
    NSInteger length=cellDataArray.count;
    
    if (length==5) {
        [self textStateHUD:@"最多可添加五个项目"];
        return;
    }
    
    [self projectDataStorageWithArrayIndex:length];
    [self refreshData];
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
    
    [self.tableView setContentOffset:CGPointMake(0, rect.origin.y+15 - (kScreenHeight - keyboardHeight - rect.size.height)) animated:YES];
}

- (void)refreshData
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.tableView reloadData];
    });
}

@end
