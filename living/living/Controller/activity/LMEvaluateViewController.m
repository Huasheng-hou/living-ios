//
//  LMEvaluateViewController.m
//  living
//
//  Created by WangShengquan on 2017/2/24.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMEvaluateViewController.h"
#import "FitConsts.h"
#import "LMEvaluateHeaderCell.h"
#import "LMEvaluateStarCell.h"
#import "LMEvaluateSubmitCell.h"
#import "LMEvaluateSuccessViewController.h"
#import "ZYQAssetPickerController.h"


@interface LMEvaluateViewController ()<LMEvaluateStarCellDelegate,editViewDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,ZYQAssetPickerControllerDelegate,UIViewControllerTransitioningDelegate>
{
    NSInteger addImageIndex; // 添加图片的位置
    NSUInteger imageNum;  // 所有选择的图片数目
    ZYQAssetPickerController *picker;  // 照片列表VC
    UIImagePickerController *pickImage;  // 照片选择VC
    NSMutableArray *imageArray;  // 图片数组
}
@end

@implementation LMEvaluateViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:self.tableView];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"活动评价";
    [self createUI];
    
    imageArray      = [NSMutableArray arrayWithCapacity:0];
}

- (void)createUI
{
}

#pragma  mark - tableView DataSource Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
    switch (indexPath.section) {
        case 0:
            height = kScreenWidth * 0.3;
            break;
        case 1:
        {
            NSInteger margin        = 10;//图片之间的间隔
            NSInteger imageWidth    = (kScreenWidth - margin*5) / 4;//图片的宽度，固定一行只放置4个图片
            
            NSInteger rowNum        = imageArray.count/4 + 1;
            
            height = 190 + rowNum*(imageWidth + margin);
            break;
        }
        case 2:{
            height = 60;
            break;
        }
            
        default:
            break;
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    __weak __block LMEvaluateViewController *copy_self = self;
    
    if (cell == nil) {
        switch (indexPath.section) {
            case 0:
            {
                static NSString *evaluateHeaderCellId = @"EvaluateHeaderCell";
                LMEvaluateHeaderCell *evaluateHeaderCell = [[LMEvaluateHeaderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:evaluateHeaderCellId];
                cell = evaluateHeaderCell;
                break;
            }
            case 1:
            {
                static NSString *evaluateStarCellId = @"EvaluateStarCell";
                LMEvaluateStarCell *evaluateStarCell = [[LMEvaluateStarCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:evaluateStarCellId];
                evaluateStarCell.selectionStyle = UITableViewCellSelectionStyleNone;
                evaluateStarCell.delegate = self;
                evaluateStarCell.imageV.delegate =self;
                evaluateStarCell.array = imageArray;               
                [evaluateStarCell.imageV setTag:indexPath.row];

                cell = evaluateStarCell;
                break;
            }
            case 2:
            {
                static NSString *evaluateSubmitCellId = @"WvaluateSubmitCell";
                LMEvaluateSubmitCell *evaluateSubmitCell = [[LMEvaluateSubmitCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:evaluateSubmitCellId];
                evaluateSubmitCell.submitSelectedBlock = ^(){
                    LMEvaluateSuccessViewController *vc = [[LMEvaluateSuccessViewController alloc]init];
                    [copy_self.navigationController pushViewController:vc animated:YES];
                };
                cell = evaluateSubmitCell;
                break;
            }
                
            default:
                break;
        }
    }
    
    return cell;
}

#pragma mark - editViewDelegate 添加图片
- (void)addViewTag:(NSInteger)viewTag
{
    addImageIndex   = viewTag;
    
    if (imageArray.count >= 10) {
        
        [self textStateHUD:@"最多10张"];
        return;
    }
    
    [self.view endEditing:YES];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"相册", @"拍照",nil];
    
    actionSheet.actionSheetStyle    = UIActionSheetStyleBlackOpaque;
    actionSheet.tag                 = viewTag;
    
    [actionSheet showInView:self.view];
    
    actionSheet = nil;
}

#pragma mark 删除图片EditImageViewDelegate

- (void)deleteViewTag:(NSInteger)viewTag andSubViewTag:(NSInteger)tag
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否删除图片"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                              style:UIAlertActionStyleDestructive
                                            handler:^(UIAlertAction*action) {
                                                if (imageArray.count > tag) {
                                                    
                                                    [imageArray removeObjectAtIndex:tag];
                                                }
                                                [self refreshData];
                                                
                                            }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark UIActionSheet 代理函数

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {//图库
        NSInteger   imgNumber   = 0;
        picker = [[ZYQAssetPickerController alloc] init];
        picker.maximumNumberOfSelection     = 10 - imgNumber;
        picker.assetsFilter     = [ALAssetsFilter allPhotos];
        picker.showEmptyGroups  = NO;
        picker.delegate         = self;
        
        picker.transitioningDelegate    = self;//覆盖原代理  另外需要遵循一个协议
        picker.modalPresentationStyle   = UIModalPresentationCustom;
        picker.selectionFilter          = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            
            if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
                
                NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
                return duration >= 5;
            } else {
                
                return YES;
            }
        }];
        
        [self presentViewController:picker animated:YES completion:NULL];
    }
    if (buttonIndex == 1)
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
    if (buttonIndex == 2) {
//        NSLog(@"小视频~~~~~");
//        KZVideoViewController *videoVC = [[KZVideoViewController alloc] init];
//        videoVC.delegate = self;
//        [videoVC startAnimationWithType:KZVideoViewShowTypeSingle];
    }
}

#pragma mark - ZYQAssetPickerController Delegate

- (void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    if (assets.count > 0) {
        
        for (int i = 0; i < assets.count; i++) {
            
            imageNum++;
            
            ALAsset *asset=assets[i];
            UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
            
            [imageArray addObject:tempImg];
        }
        
        [self refreshData];
    }
}

#pragma mark 获取头像的url

- (void)getImageURL:(NSMutableArray*)imgArr
{
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
