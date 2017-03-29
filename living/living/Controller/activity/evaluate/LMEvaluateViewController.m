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

#import "LMItemCommentRequest.h"
#import "FirUploadImageRequest.h"


@interface LMEvaluateViewController ()<LMEvaluateStarDelegate,editViewDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,ZYQAssetPickerControllerDelegate,UIViewControllerTransitioningDelegate>
{
    NSInteger addImageIndex; // 添加图片的位置
    NSUInteger imageNum;  // 所有选择的图片数目
    ZYQAssetPickerController * _picker;  // 照片列表VC
    UIImagePickerController *pickImage;  // 照片选择VC
    NSMutableArray *imageArray;  // 图片数组
    
    NSInteger starValue;
    NSString * _content;
    
    NSMutableArray * _imageUrlArray;
    
}
@end

@implementation LMEvaluateViewController

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        _imageUrlArray = [NSMutableArray new];
        imageArray = [NSMutableArray new];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createUI];
}
- (void)createUI
{
    [super createUI];
    self.title = @"活动评价";
    imageArray      = [NSMutableArray arrayWithCapacity:0];
    
    self.navigationController.navigationBar.hidden = NO;
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    
    if (indexPath.section == 0) {
        
        static NSString *evaluateHeaderCellId = @"EvaluateHeaderCell";
        LMEvaluateHeaderCell * cell = [tableView dequeueReusableCellWithIdentifier:evaluateHeaderCellId];
        if (!cell) {
            cell = [[LMEvaluateHeaderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:evaluateHeaderCellId];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (_eventVO) {
            [cell setData:_eventVO];
        }
        return cell;
    }
    else if (indexPath.section == 1) {
        static NSString *evaluateStarCellId = @"EvaluateStarCell";
        LMEvaluateStarCell * cell = [tableView dequeueReusableCellWithIdentifier:evaluateStarCellId];
        
        if (!cell) {
            cell = [[LMEvaluateStarCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:evaluateStarCellId];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.imageV.delegate = self;
        cell.array = imageArray;
        cell.imageV.tag = indexPath.row;

        return cell;
    }

    else if (indexPath.section == 2) {
        static NSString *evaluateSubmitCellId = @"WvaluateSubmitCell";
        LMEvaluateSubmitCell * cell = [tableView dequeueReusableCellWithIdentifier:evaluateSubmitCellId];
        
        if (!cell) {
            cell = [[LMEvaluateSubmitCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:evaluateSubmitCellId];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.submitBtn addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    
    return nil;
}

#pragma mark - 获取星级代理
- (void)getStarValue:(NSInteger)value{
    
    starValue = value;
}
#pragma mark - 获取评论内容
- (void)getCommentText:(NSString *)content{
    
    _content = content;
}
#pragma mark - 提交评价
- (void)submit:(UIButton *)btn{
    
    if (starValue == 0) {
        [self textStateHUD:@"请选择星级"];
        return;
    }
    if ([_content isEqualToString:@""]) {
        [self textStateHUD:@"请输入评价内容"];
        return;
    }
    
    [self doCommentRequest];
    
}
#pragma mark - 评价请求
- (void)doCommentRequest{
    
    
    [self initStateHud];
    LMItemCommentRequest * request = [[LMItemCommentRequest alloc] initWithEventUuid:_eventVO.eventUuid andContent:_content andStar:[NSString stringWithFormat:@"%d", starValue] andPhotos:_imageUrlArray];
    
    HTTPProxy * proxy = [HTTPProxy loadWithRequest:request
                                         completed:^(NSString *resp, NSStringEncoding encoding) {
                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                 [self getCommentResponse:resp];
                                             });
                                         }
                                            failed:^(NSError *error) {
                                                NSLog(@"%@", error.localizedDescription);
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    [self textStateHUD:@"网络错误"];
                                                });
                                            }];
    [proxy start];
}
- (void)getCommentResponse:(NSString *)resp{
    
    NSData * respData = [resp dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * respDic = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
    NSDictionary * headDic = [respDic objectForKey:@"head"];
    if (![headDic[@"returnCode"] isEqualToString:@"000"]) {
        [self textStateHUD:@"验证失败"];
        return;
    }
    
    NSDictionary * bodyDic = [VOUtil parseBody:resp];
    if (![bodyDic[@"result"] isEqualToString:@"0"]) {
        [self textStateHUD:@"请求数据失败"];
        return;
    }
    [self hideStateHud];
    LMEvaluateSuccessViewController * successVC = [[LMEvaluateSuccessViewController alloc] init];
    
    [self.navigationController pushViewController:successVC animated:YES];
    
}
#pragma mark - 获取图片URL
- (void)getImageURL:(UIImage*)image
{
    if (![CheckUtils isLink]) {
        
        [self textStateHUD:@"无网络连接"];
        return;
    }
    
    
    FirUploadImageRequest   *request    = [[FirUploadImageRequest alloc] initWithFileName:@"file"];
    request.imageData   = UIImageJPEGRepresentation(image, 1);
    [self initStateHud];
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding){
                                               
                                               NSDictionary    *bodyDict   = [VOUtil parseBody:resp];
                                               
                                               NSString    *result = [bodyDict objectForKey:@"result"];
                                               
                                               if (result && [result isKindOfClass:[NSString class]]
                                                   && [result isEqualToString:@"0"]) {
                                                   NSString    *imgUrl = [bodyDict objectForKey:@"attachment_url"];
                                                   NSString * imgUuid = [bodyDict objectForKey:@"attachment_uuid"];
                                                   if (imgUrl && [imgUrl isKindOfClass:[NSString class]]) {
                                                 
                                                        [self performSelectorOnMainThread:@selector(hideStateHud)
                                                                                withObject:nil
                                                                            waitUntilDone:YES];
                                                       
                                                       [_imageUrlArray addObject:imgUrl];
                                                   }
                                               }
                                           } failed:^(NSError *error) {
                                               [self hideStateHud];
                                           }];
    [proxy start];
    
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

#pragma mark - 删除图片EditImageViewDelegate

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
                                                    [_imageUrlArray removeObjectAtIndex:tag];
                                                }
                                                [self refreshData];
                                                
                                            }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UIActionSheet 代理函数

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {//图库
        NSInteger   imgNumber   = 0;
        _picker = [[ZYQAssetPickerController alloc] init];
        _picker.maximumNumberOfSelection     = 10 - imgNumber;
        _picker.assetsFilter     = [ALAssetsFilter allPhotos];
        _picker.showEmptyGroups  = NO;
        _picker.delegate         = self;
        
        _picker.transitioningDelegate    = self;//覆盖原代理  另外需要遵循一个协议
        _picker.modalPresentationStyle   = UIModalPresentationCustom;
        _picker.selectionFilter          = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            
            if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
                
                NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
                return duration >= 5;
            } else {
                
                return YES;
            }
        }];
        
        [self presentViewController:_picker animated:YES completion:NULL];
    }
    if (buttonIndex == 1)
    {//摄像头
        
        if (!pickImage) {
            pickImage = [[UIImagePickerController alloc] init];
            pickImage.sourceType = UIImagePickerControllerSourceTypeCamera;
            pickImage.allowsEditing = YES;
            pickImage.delegate = self;
        }
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
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage * image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [imageArray addObject:image];
    imageNum++;
    [self getImageURL:image];
    [self refreshData];
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
            
            [self getImageURL:tempImg];
        }
        
        [self refreshData];
    }
}


@end
