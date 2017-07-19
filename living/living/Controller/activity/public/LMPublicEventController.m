//
//  LMPublicEventController.m
//  living
//
//  Created by hxm on 2017/3/23.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMPublicEventController.h"
#import "LMProjectCell.h"
#import "LMPublicMsgCell.h"
#import "LMTimeButton.h"
#import "FitPickerView.h"
#import "FitDatePickerView.h"
#import "LMPublicEventRequest.h"
#import "FirUploadImageRequest.h"
#import "ImageHelpTool.h"
#import "BabFilterAgePickerView.h"
#import "FitPickerThreeLevelView.h"
#import "LMSearchAddressController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "UIImageView+WebCache.h"
#import "LMAddressChooseView.h"
#import "KZVideoViewController.h"
#import "ZYQAssetPickerController.h"
#import "FirUploadVideoRequest.h"

#import "LMPublicEventCell.h"
#import "LMNewPublicEventRequest.h"
#import "LMTypeListViewController.h"

#import "DataBase.h"

@interface LMPublicEventController ()
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
addressTypeDelegate,
ZYQAssetPickerControllerDelegate,
KZVideoViewControllerDelegate,
LMProjectCellDelegate,
LMTypeListProtocol
>
{
    LMPublicEventCell *msgCell;
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
    UIButton *publicButton;
    NSMutableArray *updateArray;
    NSInteger index;
    NSString *useCounpon;
    NSString *videoUrl;
    NSString *coverUrl;
    NSInteger videoIndex;
    UIImage *videoImage;
    NSInteger typeIndex;
    NSInteger cellTag;
    NSData *videoData;
    NSInteger publicTag;
    
    NSString * typeName;
    NSString * typeStr;
    
    DataBase *db;
    
    //权限
    UIView *authorityView;
    UILabel *authorityTip;
    NSString *authorityString;
}
@property(nonatomic,strong) MAMapView *mapView;
@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic,retain)UITableView *tableView;
@end

@implementation LMPublicEventController


static NSMutableArray *cellDataArray;


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (![self hasPhotosAuthority] && [self hasCameraAuthority] && [self hasMicrophoneAuthority]) {
        authorityString = @"相册权限未开启";
    } else if ([self hasPhotosAuthority] && ![self hasCameraAuthority] && [self hasMicrophoneAuthority]) {
        authorityString = @"相机权限未开启";
    } else if ([self hasPhotosAuthority] && [self hasCameraAuthority] && ![self hasMicrophoneAuthority]) {
        authorityString = @"麦克风权限未开启";
    } else if (![self hasPhotosAuthority] && ![self hasCameraAuthority] && [self hasMicrophoneAuthority]) {
        authorityString = @"相册、相机权限未开启";
    } else if (![self hasPhotosAuthority] && [self hasCameraAuthority] && ![self hasMicrophoneAuthority]) {
        authorityString = @"相册、麦克风权限未开启";
    } else if ([self hasPhotosAuthority] && ![self hasCameraAuthority] && ![self hasMicrophoneAuthority]) {
        authorityString = @"相机、麦克风权限未开启";
    } else if (![self hasPhotosAuthority] && ![self hasCameraAuthority] && ![self hasMicrophoneAuthority]) {
        authorityString = @"相册、相机、麦克风权限未开启";
    } else if ([self hasPhotosAuthority] && [self hasCameraAuthority] && [self hasMicrophoneAuthority]) {
        if (authorityView && !authorityView.hidden) {
            authorityView.hidden = YES;
            
        }
        return;
    }
    [self addAuthorityView];
}
- (void)addAuthorityView {
    if (!authorityView) {
        authorityView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 50, kScreenWidth, 50)];
        authorityView.backgroundColor = [UIColor whiteColor];
        authorityView.layer.borderWidth = 1;
        authorityView.layer.borderColor = BG_GRAY_COLOR.CGColor;
        [self.view addSubview:authorityView];
        
        authorityTip = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth - 100, 30)];
        authorityTip.text = authorityString;
        authorityTip.textColor = TEXT_COLOR_LEVEL_1;
        authorityTip.font = TEXT_FONT_LEVEL_1;
        [authorityView addSubview:authorityTip];
        
        UIButton *openAuthority = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(authorityTip.frame) + 10, 10, 70, 30)];
        [openAuthority setTitle:@"去开启" forState:UIControlStateNormal];
        [openAuthority setTitleColor:LIVING_COLOR forState:UIControlStateNormal];
        openAuthority.titleLabel.font = TEXT_FONT_LEVEL_1;
        openAuthority.clipsToBounds = YES;
        openAuthority.layer.cornerRadius = 2;
        openAuthority.layer.borderColor = LIVING_COLOR.CGColor;
        openAuthority.layer.borderWidth = 1;
        [openAuthority addTarget:self action:@selector(openAuthority:) forControlEvents:UIControlEventTouchUpInside];
        [authorityView addSubview:openAuthority];
    } else {
        if (authorityView.hidden) {
            authorityView.hidden = NO;
            authorityTip.text = authorityString;
        }
    }
}
- (void)openAuthority:(UIButton *)btn {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    cellDataArray=[NSMutableArray arrayWithCapacity:10];
    projectImageArray=[NSMutableArray arrayWithCapacity:10];
    
    for (int i=0; i<10; i++) {
        [projectImageArray addObject:@""];
    }
    index = 0;
    [self projectDataStorageWithArrayIndex:0];
    updateArray = [NSMutableArray new];
    
    [self creatUI];
    
    [self initSearch];
    useCounpon = @"1";
    videoUrl = nil;
}

- (void)initSearch
{
    if (self.search==nil) {
        self.search     = [[AMapSearchAPI alloc] init];
    }
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
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"存草稿"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(saveDraft)];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self creatFootView];
    
    //草稿箱
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setDataFromDraft];
    });

}

-(void)creatFootView
{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 150)];
    footView.backgroundColor = [UIColor clearColor];
    
    publicButton = [UIButton buttonWithType:UIButtonTypeCustom];
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

#pragma mark - tableView代理方法
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
        return 490 +kScreenWidth*3/5+90+90-90;
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
            msgCell = [[LMPublicEventCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        msgCell.selectionStyle = UITableViewCellSelectionStyleNone;
        msgCell.titleTF.delegate = self;
        msgCell.phoneTF.delegate = self;
        msgCell.nameTF.delegate = self;
        msgCell.freeTF.delegate =self;
        msgCell.dspTF.delegate = self;
        msgCell.VipFreeTF.delegate = self;
        msgCell.couponTF.delegate = self;
        
        msgCell.titleTF.tag = 100;
        msgCell.phoneTF.tag = 100;
        msgCell.nameTF.tag = 100;
        msgCell.freeTF.tag =100;
        msgCell.dspTF.tag = 100;
        msgCell.VipFreeTF.tag = 100;
        msgCell.applyTextView.delegate = self;
        msgCell.couponTF.tag = 100;
        
        msgCell.category.titleLabel.text = typeName;
        [msgCell.category addTarget:self action:@selector(chooseType:) forControlEvents:UIControlEventTouchUpInside];
        [msgCell.addressButton addTarget:self action:@selector(addressAction:) forControlEvents:UIControlEventTouchUpInside];
        [msgCell.imageButton addTarget:self action:@selector(imageButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [msgCell.imageButton setTag:0];
        
        [msgCell.mapButton addTarget:self action:@selector(selectLocation) forControlEvents:UIControlEventTouchUpInside];
        
        [msgCell.UseButton addTarget:self action:@selector(useCounpon) forControlEvents:UIControlEventTouchUpInside];
        [msgCell.unUseButton addTarget:self action:@selector(UNuseCounpon) forControlEvents:UIControlEventTouchUpInside];
        
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
        cell.delegate = self;
        [cell.includeTF setTag:indexPath.row];
        cell.cellndex = indexPath.row;
        cell.tag = indexPath.row;
        
        cell.title.text=cellDataArray[indexPath.row][@"title"];
        
        cell.includeTF.text=cellDataArray[indexPath.row][@"content"];
        
        if ([projectImageArray[indexPath.row] isKindOfClass:[UIImage class]]) {
            UIImage *image=(UIImage *)projectImageArray[indexPath.row];
            [cell.imgView setImage:image];
            
        }else if ([projectImageArray[indexPath.row] isKindOfClass:[NSString class]]) {
            
            if (![projectImageArray[indexPath.row] isEqualToString:@""]) {
                [cell.imgView sd_setImageWithURL:[NSURL URLWithString:projectImageArray[indexPath.row]]];
            } else {
                [cell.imgView setImage:[UIImage imageNamed:@""]];
            }
            
        }
        
        [cell.deleteBt addTarget:self action:@selector(closeCell:) forControlEvents:UIControlEventTouchUpInside];
        [cell.deleteBt setTag:indexPath.row];
        
        [cell.eventButton addTarget:self action:@selector(imageButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.eventButton setTag:indexPath.row+10];
        
        [cell.videoButton addTarget:self action:@selector(VideoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.videoButton setTag:indexPath.row+100];
        
        [cell.deleteBt setHidden:NO];
        
        if (cellDataArray.count==1) {
            if (indexPath.row==0) {
                [cell.deleteBt setHidden:YES];
            }else{
                [cell.deleteBt setHidden:NO];
            }
        }
        if (indexPath.row==cellTag-100) {
            [cell.VideoImgView setImage:videoImage];
            cell.button.hidden = NO;
        }else{
            [cell.VideoImgView setImage:[UIImage imageNamed:@""]];
            cell.button.hidden = YES;
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
#pragma mark - 选择分类代理
- (void)backLiveName:(NSString *)liveRoom
{
    typeName = liveRoom;
    if ([liveRoom isEqualToString:@"美丽"]) {
        typeStr = @"beautiful";
    }
    if ([liveRoom isEqualToString:@"幸福"]) {
        typeStr = @"happiness";
    }
    if ([liveRoom isEqualToString:@"健康"]) {
        typeStr = @"healthy";
    }
    if ([liveRoom isEqualToString:@"美食"]) {
        typeStr = @"delicious";
    }

    [self.tableView reloadData];
}

- (void)chooseType:(id)sender{
    LMTypeListViewController * typeVC = [[LMTypeListViewController alloc] init];
    typeVC.name = @"项目分类";
    typeVC.delegate     = self;
    
    [self.navigationController pushViewController:typeVC animated:YES];
}
#pragma mark - 地图选择地址详情

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


#pragma mark - LMAddressChooseView代理方法

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

//- (void)beginDateAction:(id)sender
//{
//    [self.view endEditing:YES];
//    dateIndex = 0;
//    
//    NSDateFormatter *formatter  = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy-MM-dd"];
//    NSDate *currentDate;
//    
//    currentDate = [NSDate date];
//    
//    [FitDatePickerView showWithMinimumDate:currentDate
//                               MaximumDate:[formatter dateFromString:@"2950-01-01"]
//                               CurrentDate:currentDate
//                                      Mode:UIDatePickerModeDateAndTime
//                                  Delegate:self];
//}

//- (void)endDateAction:(id)sender
//{
//    [self.view endEditing:YES];
//    dateIndex = 1;
//    
//    NSDateFormatter *formatter  = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSDate *currentDate;
//    if ([msgCell.dateButton.textLabel.text isEqual:@"请选择活动开始时间"]) {
//        currentDate = [NSDate date];
//    }else{
//        
//        NSString *dateString=msgCell.dateButton.textLabel.text;
//        
//        currentDate=[formatter dateFromString:dateString];
//        
//    }
//    
//    [FitDatePickerView showWithMinimumDate:currentDate
//                               MaximumDate:[formatter dateFromString:@"2950-01-01 00:00:00"]
//                               CurrentDate:currentDate
//                                      Mode:UIDatePickerModeDateAndTime
//                                  Delegate:self];
//}

#pragma mark - 选择省市区视图

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

#pragma mark - =====活动==项目活动增加图片

- (void)imageButtonAction:(UIButton *)button
{
    addImageIndex=button.tag;
    videoIndex  = 1;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"相册", @"拍照",nil];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
    actionSheet = nil;
}

- (void)VideoButtonAction:(UIButton *)button
{
    if (videoUrl&&![videoUrl isEqual:@""]) {
        [self textStateHUD:@"只能添加一个视频"];
        return;
    }else{
        cellTag = button.tag;
    }
    
    videoIndex = 2;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍摄小视频", @"本地选取小视频",nil];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
    actionSheet = nil;
}

#pragma mark - 日期选择

//- (void)didSelectedDate:(NSDate *)date
//{
//    NSDateFormatter *formatter  = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
//    
//    if (dateIndex == 0) {
//        
//        msgCell.dateButton.textLabel.text   = [formatter stringFromDate:date];
//    }
//    if (dateIndex == 1) {
//        
//        msgCell.endDateButton.textLabel.text   = [formatter stringFromDate:date];
//    }
//}

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

#pragma mark - textView代理方法

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

#pragma mark - 项目介绍编辑结束

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

#pragma mark - 编辑单元格项目介绍

- (void)modifyCellDataContent:(NSInteger)row andText:(NSString *)text{
    
    NSMutableDictionary *dic=cellDataArray[row];
    
    if ([text isEqualToString:@""]) {
        
        [dic setObject:@"" forKey:@"content"];
    }else{
        [dic setObject:text forKey:@"content"];
    }
    
    [self refreshData];
}

#pragma mark - UITextField代理方法

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

#pragma mark - 标题编辑结束

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

#pragma mark - 编辑单元格标题

- (void)modifyCellDataTitle:(NSInteger)row andText:(NSString *)text{
    
    NSMutableDictionary *dic=cellDataArray[row];
    
    if ([text isEqualToString:@""]) {
        
        [dic setObject:@"" forKey:@"title"];
    }else{
        [dic setObject:text forKey:@"title"];
    }
    
    [self refreshData];
    
}

#pragma mark - 单元格刚创建后的数据

- (void)projectDataStorageWithArrayIndex:(NSInteger)indexs
{
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:0];
    [dic setObject:@"" forKey:@"title"];
    [dic setObject:@"" forKey:@"content"];
    [dic setObject:@"" forKey:@"image"];
    
    [cellDataArray insertObject:dic atIndex:indexs];
}

#pragma mark - UIImagePickerController代理函数

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [pickImage dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - -选取拍摄图片
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
    typeIndex = 1;
    [self getImageURL:image];
    
    [pickImage dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 编辑单元格项目活动图片

-(void)modifyCellDataImage:(NSInteger)row andImageUrl:(NSString *)imageUrl{
    
    NSMutableDictionary *dic=cellDataArray[row];
    
    if (imageUrl) {
        [dic setObject:imageUrl forKey:@"image"];
    }else{
        [dic setObject:@"" forKey:@"image"];
    }
}


#pragma mark - 获取头像的url

- (void)getImageURL:(UIImage*)image
{
    if (![CheckUtils isLink]) {
        
        [self textStateHUD:@"无网络连接"];
        return;
    }
    
    if (addImageIndex == 0) {
        
        FirUploadImageRequest   *request    = [[FirUploadImageRequest alloc] initWithFileName:@"file"];
        if (typeIndex ==2){
            request.imageData   = UIImageJPEGRepresentation(image, 1);
        }else{
            UIImage *headImage = [ImageHelpTool scaleImage:image];
            request.imageData   = UIImageJPEGRepresentation(headImage, 1);
        }
        
        [self initStateHud];
        
        HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                               completed:^(NSString *resp, NSStringEncoding encoding){
                                                   
                                                   NSDictionary    *bodyDict   = [VOUtil parseBody:resp];
                                                   
                                                   NSString    *result = [bodyDict objectForKey:@"result"];
                                                   
                                                   if (result && [result isKindOfClass:[NSString class]]
                                                       && [result isEqualToString:@"0"]) {
                                                       NSString    *imgUrl = [bodyDict objectForKey:@"attachment_url"];
                                                       if (imgUrl && [imgUrl isKindOfClass:[NSString class]]) {
                                                           
                                                           if (typeIndex==1) {
                                                               [self performSelectorOnMainThread:@selector(hideStateHud)
                                                                                      withObject:nil
                                                                                   waitUntilDone:YES];
                                                               _imgURL=imgUrl;
                                                               
                                                           }
                                                           if (typeIndex ==2) {
                                                               coverUrl = imgUrl;
                                                               [self sendVideo:videoData];
                                                           }
                                                           
                                                           
                                                       }
                                                   }
                                               } failed:^(NSError *error) {
                                                   [self hideStateHud];
                                               }];
        [proxy start];
    }else{
        [self initStateHud];
        FirUploadImageRequest   *request    = [[FirUploadImageRequest alloc] initWithFileName:@"file"];
        if (typeIndex ==2){
            request.imageData   = UIImageJPEGRepresentation(image, 1);
        }else{
            UIImage *headImage = [ImageHelpTool scaleImage:image];
            request.imageData   = UIImageJPEGRepresentation(headImage, 1);
        }
        
        HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                               completed:^(NSString *resp, NSStringEncoding encoding){
                                                   
                                                   
                                                   
                                                   NSDictionary    *bodyDict   = [VOUtil parseBody:resp];
                                                   
                                                   NSString    *result = [bodyDict objectForKey:@"result"];
                                                   
                                                   if (result && [result isKindOfClass:[NSString class]]
                                                       && [result isEqualToString:@"0"]) {
                                                       NSString    *imgUrl = [bodyDict objectForKey:@"attachment_url"];
                                                       if (imgUrl && [imgUrl isKindOfClass:[NSString class]]) {
                                                           
                                                           if (typeIndex==1) {
                                                               [self performSelectorOnMainThread:@selector(hideStateHud)
                                                                                      withObject:nil
                                                                                   waitUntilDone:YES];
                                                               [self modifyCellDataImage:addImageIndex-10 andImageUrl:imgUrl];
                                                           }
                                                           if (typeIndex ==2) {
                                                               coverUrl = imgUrl;
                                                               [self sendVideo:videoData];
                                                           }
                                                           
                                                           
                                                       }
                                                   }
                                               } failed:^(NSError *error) {
                                                   [self hideStateHud];
                                               }];
        [proxy start];
        
    }
}






#pragma mark - UIActionSheet ======================代理函数

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (videoIndex == 1) {
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
    
    if (videoIndex == 2){
        if (buttonIndex==0)
        {//
            NSLog(@"小视频~~~~~");
            
            
            KZVideoViewController *videoVC = [[KZVideoViewController alloc] init];
            videoVC.delegate = self;
            [videoVC startAnimationWithType:KZVideoViewShowTypeSingle];
        }
        if (buttonIndex==1){
            
            ZYQAssetPickerController *pickerV = [[ZYQAssetPickerController alloc] init];
            pickerV.maximumNumberOfSelection = 1;
            pickerV.assetsFilter = [ALAssetsFilter allVideos];
            pickerV.showEmptyGroups=NO;
            pickerV.delegate=self;
            
            pickerV.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
                    NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
                    return duration < 10.5;
                } else {
                    return YES;
                }
            }];
            
            [self presentViewController:pickerV animated:YES completion:NULL];
        }
    }
}

#pragma mark - -判断项目标题是否为空

- (BOOL)judgeProjectTitle
{
    for (NSDictionary *dic in cellDataArray) {
        if ([dic[@"title"] isEqualToString:@""]) {
            return NO;
        }
    }
    return YES;
}

#pragma mark  - -确认并发布按钮

-(void)publishButtonAction:(id)sender
{
    [self.view endEditing:YES];
    
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
    
    if (!(msgCell.couponTF.text.length>0)) {
        [ self textStateHUD:@"请输入加盟商费用"];
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
    publicButton.userInteractionEnabled = NO;
    
    NSString *latitudeString;
    NSString *longitudeString;
    if (_latitude ==0 &&_longitude==0) {
        latitudeString = @"";
        longitudeString = @"";
    }else{
        latitudeString = [NSString stringWithFormat:@"%f",_latitude];
        longitudeString =[NSString stringWithFormat:@"%f",_longitude] ;
    }
    
    NSMutableArray * dataArr = [NSMutableArray new];
    for (; index<cellDataArray.count; index++) {
        NSDictionary *dic=cellDataArray[index];
        NSString *url = @"";
        NSString *cover = @"";
        if (publicTag-100 == index) {
            url = videoUrl;
            cover = coverUrl;
        }else{
            url = @"";
            cover = @"";
        }
        
        NSDictionary * dict = @{@"project_title":dic[@"title"], @"project_dsp":dic[@"content"], @"project_imgs":dic[@"image"], @"videoUrl":url, @"coverUrl":cover};
        [dataArr addObject:dict];
        
    }
    
    
    LMNewPublicEventRequest * request = [[LMNewPublicEventRequest alloc]
                                         initWithEvent_name:msgCell.titleTF.text
                                         Contact_phone:msgCell.phoneTF.text
                                         Contact_name:msgCell.nameTF.text
                                         Per_cost:msgCell.freeTF.text
                                         Discount:msgCell.VipFreeTF.text
                                         FranchiseePrice:msgCell.couponTF.text
                                         Address:msgCell.addressButton.textLabel.text
                                         Address_detail:msgCell.dspTF.text
                                         Event_img:_imgURL
                                         Latitude:latitudeString
                                         Longitude:longitudeString
                                         notices:msgCell.applyTextView.text
                                         available:useCounpon
                                         Category:typeStr
                                         Type:@"item"
                                         blend:dataArr];
    
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(getEventDataResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"网络错误"
                                                                   waitUntilDone:YES];
                                               publicButton.userInteractionEnabled = YES;
                                           }];
    [proxy start];
    
}

- (void)getEventDataResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    
    if (!bodyDic) {
        [self textStateHUD:@"发布失败"];
        publicButton.userInteractionEnabled = YES;
    }else{
        if ([[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
            
            NSString *string = [bodyDic objectForKey:@"event_uuid"];
            eventUUid = string;
            
            [self textStateHUD:@"发布成功"];
            //删除草稿
            if (_draftDic) {
                db = [DataBase sharedDataBase];
                [db deleteFromDraftWithID:_draftDic[@"id"]];
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadEvent"
                 
                                                                    object:nil];
            });
            
            
        }else{
            NSString *string = [bodyDic objectForKey:@"description"];
            [self textStateHUD:string];
            publicButton.userInteractionEnabled = YES;
        }
    }
}

#pragma mark  - -添加项目

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

//是否允许使用优惠券
- (void)useCounpon
{
    NSLog(@"使用优惠券");
    useCounpon = @"1";
    msgCell.UseButton.chooseImage.backgroundColor = LIVING_COLOR;
    msgCell.UseButton.chooseImage.layer.borderColor = [UIColor whiteColor].CGColor;
    msgCell.unUseButton.chooseImage.backgroundColor = [UIColor clearColor];
    msgCell.unUseButton.chooseImage.layer.borderColor = [UIColor blackColor].CGColor;
    
}

- (void)UNuseCounpon
{
    NSLog(@"不使用优惠券");
    useCounpon = @"2";
    msgCell.unUseButton.chooseImage.backgroundColor = LIVING_COLOR;
    msgCell.unUseButton.chooseImage.layer.borderColor = [UIColor whiteColor].CGColor;
    msgCell.UseButton.chooseImage.backgroundColor = [UIColor clearColor];
    msgCell.UseButton.chooseImage.layer.borderColor = [UIColor blackColor].CGColor;
}

#pragma mark  - 视频录制或选择后回调
- (void)videoViewController:(KZVideoViewController *)videoController didRecordVideo:(KZVideoModel *)videoModel{
    
    
    NSURL* videoUrls = [NSURL URLWithString:videoModel.videoAbsolutePath];
    
    [self movFileTransformToMP4WithSourceUrl:videoUrls completion:^(NSString *Mp4FilePath) {
        
        videoModel.videoAbsolutePath = Mp4FilePath;
    }];
    
    videoData = [NSData dataWithContentsOfFile:videoModel.videoAbsolutePath];
    
    
    UIImage  *image = [UIImage imageWithContentsOfFile:videoModel.thumAbsolutePath];
    
    videoImage = [ImageHelpTool imageWithImage:image scaledToSize:CGSizeMake(kScreenWidth, kScreenWidth*3/4)];
    typeIndex = 2;
    
    [self refreshData];
    [self getImageURL:videoImage];
    
    
}
- (UIImage*) getVideoPreViewImage:(NSURL *)path
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:path options:nil];
    AVAssetImageGenerator *assetGen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    assetGen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [assetGen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *videoImages = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return videoImages;
}

#pragma mark - mov格式转MP4
- (void)movFileTransformToMP4WithSourceUrl:(NSURL *)sourceUrl completion:(void(^)(NSString *Mp4FilePath))comepleteBlock
{
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:sourceUrl options:nil];
    
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
    if ([compatiblePresets containsObject:AVAssetExportPresetLowQuality])
        
    {
        
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset presetName:AVAssetExportPresetLowQuality];
        
        exportSession.outputURL = sourceUrl;
        
        exportSession.outputFileType = AVFileTypeMPEG4;
        
        CMTime start = CMTimeMakeWithSeconds(1.0, 600);
        
        CMTime duration = CMTimeMakeWithSeconds(3.0, 600);
        
        CMTimeRange range = CMTimeRangeMake(start, duration);
        
        exportSession.timeRange = range;
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            
            switch ([exportSession status]) {
                    
                case AVAssetExportSessionStatusFailed:
                    NSLog(@"Export failed: %@", [[exportSession error] localizedDescription]);
                    
                    break;
                    
                case AVAssetExportSessionStatusCancelled:
                    
                    NSLog(@"Export canceled");
                    
                    break;
                    
                default:
                    
                    break;
            }
            
        }];
        
    }
}

#pragma mark  - -上传视频

- (void)sendVideo:(NSData *)data
{
    if (![CheckUtils isLink]) {
        
        [self textStateHUD:@"无网络连接"];
        return;
    }
    typeIndex = 1;
    
    publicTag = cellTag;
    FirUploadVideoRequest *request = [[FirUploadVideoRequest alloc] initWithFileName:@"file"];
    
    request.videoData = data;
    
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding){
                                               
                                               [self performSelector:@selector(hideStateHud) withObject:nil afterDelay:0];
                                               NSDictionary    *bodyDict   = [VOUtil parseBody:resp];
                                               //
                                               NSString    *result = [bodyDict objectForKey:@"result"];
                                               
                                               if (result && [result isKindOfClass:[NSString class]]
                                                   && [result isEqualToString:@"0"]) {
                                                   NSString    *voiceUrl = [bodyDict objectForKey:@"attachment_url"];
                                                   if (voiceUrl && [voiceUrl isKindOfClass:[NSString class]]) {
                                                       
                                                       videoUrl = voiceUrl;
                                                       dispatch_async(dispatch_get_main_queue(), ^{
                                                           [self hideStateHud];
                                                       });
                                                   }
                                               }
                                               
                                           } failed:^(NSError *error) {
                                               
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"网络错误"
                                                                   waitUntilDone:YES];
                                           }];
    [proxy start];
}


#pragma mark - ZYQAssetPickerController Delegate

- (void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    
    if (assets.count > 0) {
        
        for (int i = 0; i < assets.count; i++) {
            
            
            ALAsset *asset=assets[i];
            NSLog(@"%@",[asset valueForProperty:ALAssetPropertyType]);
            if ([[asset valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
                
                ALAssetRepresentation * representation = asset.defaultRepresentation;
                NSLog(@"%@",representation.url);
                ALAssetRepresentation *rep = [asset defaultRepresentation];
                
                Byte *buffer = (Byte*)malloc(rep.size);
                
                NSUInteger buffered = [rep getBytes:buffer fromOffset:0.0 length:rep.size error:nil];
                // 这个data便是 转换成功的视频data 有了data边可以进行上传了
                videoData = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentD = [paths objectAtIndex:0];
                NSString *configFile = [documentD stringByAppendingString:@"123.mp4"];
                [videoData writeToFile:configFile atomically:YES];
                
                UIImage *newImage = [UIImage imageWithCGImage:[asset aspectRatioThumbnail]];
                videoImage = [ImageHelpTool clipImageWithImage:newImage inRect:CGRectMake(0, 0, kScreenWidth, kScreenWidth*3/5)];
                typeIndex = 2;
                [self getImageURL:videoImage];
            }
            
            
            [self refreshData];
        }
        
    }
    
}

-(void)cellWilldelete:(LMProjectCell *)projectcell
{
    [projectcell.VideoImgView setImage:[UIImage imageNamed:@""]];
    videoUrl = nil;
    projectcell.button.hidden = YES;
}

#pragma mark - 存草稿
- (void)saveDraft {
    NSLog(@"存项目草稿");
    db = [DataBase sharedDataBase];
    NSString *latitudeString;
    NSString *longitudeString;
    if (_latitude ==0 &&_longitude==0) {
        latitudeString = @"";
        longitudeString = @"";
    }else{
        latitudeString = [NSString stringWithFormat:@"%f",_latitude];
        longitudeString =[NSString stringWithFormat:@"%f",_longitude] ;
    }
    NSMutableArray * dataArr = [NSMutableArray new];
    for (; index<cellDataArray.count; index++) {
        NSDictionary *dic=cellDataArray[index];
        NSString *url = @"";
        NSString *cover = @"";
        if (publicTag-100 == index) {
            url = videoUrl;
            cover = coverUrl;
        }else{
            url = @"";
            cover = @"";
        }
        
        NSDictionary * dict = @{@"project_title":dic[@"title"], @"project_dsp":dic[@"content"], @"project_imgs":dic[@"image"], @"videoUrl":url, @"coverUrl":cover};
        [dataArr addObject:dict];
        
    }

    LMNewPublicEventRequest * request = [[LMNewPublicEventRequest alloc]
                                         initWithEvent_name:msgCell.titleTF.text
                                         Contact_phone:msgCell.phoneTF.text
                                         Contact_name:msgCell.nameTF.text
                                         Per_cost:msgCell.freeTF.text
                                         Discount:msgCell.VipFreeTF.text
                                         FranchiseePrice:msgCell.couponTF.text
                                         Address:msgCell.addressButton.textLabel.text
                                         Address_detail:msgCell.dspTF.text
                                         Event_img:_imgURL
                                         Latitude:latitudeString
                                         Longitude:longitudeString
                                         notices:msgCell.applyTextView.text
                                         available:useCounpon
                                         Category:typeStr
                                         Type:@"item"
                                         blend:dataArr];
    
    
    NSString *msgTitle = @"";
    NSString *msgPhone = @"";
    NSString *msgName = @"";
    
    NSString *msgFee = @"";
    NSString *msgVipFee = @"";
    NSString *msgCouponFee = @"";
    
    NSString *msgAddress = @"";
    NSString *msgDetailAddress = @"";
    NSString *msgImgUrl = @"";
    
    NSString *msgLatitude = @"";
    NSString *msgLongitude = @"";
    NSString *msgNotice = @"";
    NSString *msgAvailable = @"";
    
    NSString *msgCategory = @"";
    NSString *msgType = @"";
    
    NSString *videoStr = @"";
    NSString *coverStr = @"";
    
    if (msgCell.titleTF.text) {
        msgTitle = msgCell.titleTF.text;
    }
    if (msgCell.phoneTF.text) {
        msgPhone = msgCell.phoneTF.text;
    }
    if (msgCell.nameTF.text) {
        msgName = msgCell.nameTF.text;
    }
     //////
    if (msgCell.freeTF.text) {
        msgFee = msgCell.freeTF.text;
    }
    if (msgCell.VipFreeTF.text) {
        msgVipFee = msgCell.VipFreeTF.text;
    }
    if (msgCell.couponTF.text) {
        msgCouponFee = msgCell.couponTF.text;
    }
    //////
    
    if (msgCell.addressButton.textLabel.text) {
        msgAddress = msgCell.addressButton.textLabel.text;
    }
    if (msgCell.dspTF.text) {
        msgDetailAddress = msgCell.dspTF.text;
    }
    if (_imgURL) {
        msgImgUrl = _imgURL;
    }
    //////
    if (latitudeString) {
        msgLatitude = latitudeString;
    }
    if (longitudeString) {
        msgLongitude = longitudeString;
    }
    if (msgCell.applyTextView.text) {
        msgNotice = msgCell.applyTextView.text;
    }
    if (useCounpon) {
        msgAvailable = useCounpon;
    }
    if (typeName) {
        msgCategory = typeName;
    }
    if (typeStr) {
        msgType = typeStr;
    }
    if (videoUrl) {
        videoStr = videoUrl;
    }
    if (coverUrl) {
        coverStr = coverUrl;
    }
    NSDictionary *contentDic = @{@"headData":@{@"title":msgTitle,
                                               @"phone":msgPhone,
                                               @"name":msgName,
                                               @"fee":msgFee,
                                               @"vipFee":msgVipFee,
                                               @"couponFee":msgCouponFee,
                                               @"address":msgAddress,
                                               @"detailAddress":msgDetailAddress,
                                               @"imgUrl":msgImgUrl,
                                               @"latitude":msgLatitude,
                                               @"longitude":msgLongitude,
                                               @"notices":msgNotice,
                                               @"available":msgAvailable,
                                               @"category":msgCategory,
                                               @"typeStr":msgType,
                                               @"cellTag":[NSNumber numberWithInteger:cellTag],
                                               @"videoUrl":videoStr,
                                               @"coverUrl":coverStr
                                               },
                                 @"cellData":cellDataArray};
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:contentDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *contentStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd hh:mm";
    NSString *dateStr = [format stringFromDate:[NSDate date]];
    NSDictionary *info = @{@"person_id":[FitUserManager sharedUserManager].uuid, @"title":msgTitle, @"desp":msgNotice, @"category":msgCategory, @"type":@"event", @"content":contentStr, @"time":dateStr};
    NSLog(@"%@", info);
    if (_draftDic) {
        //修改
        if([db updateDraft:_draftDic[@"id"] withInfo:info]) {
            [self textStateHUD:@"保存成功"];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self textStateHUD:@"保存失败,请重试"];
        }
        return;
    }
    if([db addToDraft:info]) {
        [self textStateHUD:@"保存成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self textStateHUD:@"保存失败,请重试"];
    }

}
#pragma mark - 从草稿箱填充数据
- (void)setDataFromDraft {
    if (!_draftDic) {
        return;
    }
    NSString *contentStr = _draftDic[@"content"];
    NSData *contentData = [contentStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *contentDic = [NSJSONSerialization JSONObjectWithData:contentData options:NSJSONReadingMutableContainers error:nil];
    
    NSDictionary *headDic = contentDic[@"headData"];
    
    msgCell.titleTF.text = headDic[@"title"];
    msgCell.phoneTF.text = headDic[@"phone"];
    msgCell.nameTF.text = headDic[@"name"];
    
    msgCell.freeTF.text = headDic[@"fee"];
    msgCell.VipFreeTF.text = headDic[@"vipFee"];
    msgCell.couponTF.text = headDic[@"couponFee"];
    
    
    msgCell.addressButton.textLabel.text = headDic[@"address"];
    msgCell.dspTF.text = headDic[@"detailAddress"];
    
    _imgURL = headDic[@"imgUrl"];
    if (_imgURL && ![_imgURL isEqualToString:@""]) {
        [msgCell.imgView sd_setImageWithURL:[NSURL URLWithString:_imgURL]];
        msgCell.imgView.contentMode = UIViewContentModeScaleAspectFill;
        msgCell.imgView.clipsToBounds = YES;
    }
    
    
    _latitude = [headDic[@"latitude"] doubleValue];
    _longitude = [headDic[@"longitude"] doubleValue];
    
    if (headDic[@"notices"] && ![headDic[@"notices"] isEqualToString:@""]) {
        msgCell.applyTextView.text = headDic[@"notices"];
        msgCell.msgLabel.hidden = YES;
    }
    
    if (headDic[@"category"] && ![headDic[@"category"] isEqualToString:@""]) {
        typeName = headDic[@"category"];
    }
    if (headDic[@"typeStr"] && ![headDic[@"typeStr"] isEqualToString:@""]) {
        typeStr = headDic[@"typeStr"];
    }
    
    
    cellTag = [headDic[@"cellTag"] integerValue];
    publicTag = cellTag;
    videoUrl = headDic[@"videoUrl"];
    coverUrl = headDic[@"coverUrl"];
    if (coverUrl) {
        videoImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:coverUrl]]];
    }
    
    
    useCounpon = headDic[@"available"];
    if ([useCounpon isEqualToString:@"1"]) {
        [self useCounpon];
    } else if ([useCounpon isEqualToString:@"2"]) {
        [self UNuseCounpon];
    }
    
    
    cellDataArray = contentDic[@"cellData"];
    NSLog(@"%@", contentDic);
    NSLog(@"%@", cellDataArray);
    
    for (int i = 0; i < cellDataArray.count; i++) {
        NSDictionary *dic = cellDataArray[i];
        [projectImageArray replaceObjectAtIndex:i withObject:dic[@"image"]];
        
    }
    NSLog(@"=======%@", projectImageArray);
    [self.tableView reloadData];
    
}

@end
