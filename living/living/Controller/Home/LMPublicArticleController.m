//
//  LMPublicArticleController.m
//  living
//
//  Created by Ding on 2016/10/25.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMPublicArticleController.h"
#import "FirUploadImageRequest.h"
#import "ZYQAssetPickerController.h"
#import "FitNavigationController.h"
#import "LMPublicArticleRequest.h"
#import "ImageHelpTool.h"
#import "UIView+frame.h"
#import "LMPAHeadViewCell.h"
#import "EditImageView.h"
#import "LMTypeListViewController.h"

@interface LMPublicArticleController ()
<
UITextFieldDelegate,
UITextViewDelegate,
UIActionSheetDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
UIScrollViewDelegate,
UIAlertViewDelegate,
ZYQAssetPickerControllerDelegate,
UIViewControllerTransitioningDelegate,
LMPAHeadViewCellDelegate,
editViewDelegate,
LMTypeListProtocol
>
{
    UIImagePickerController *pickImage;
    ZYQAssetPickerController *picker;
    NSMutableArray *imageArray;
    NSUInteger imageNum;
    NSInteger deleImageIndex;
    UITextField *titleTF;
    UITextField *discribleTF;
    NSMutableArray *projectImageArray;
    NSInteger addImageIndex;
    NSInteger addViewIndex;
    NSMutableArray *cellDataArray;
    NSMutableArray *contentArray;
    LMPAHeadViewCell *cell;
    
    NSMutableArray *imageViewArray;
    UILabel *typeLabel;
    NSString *typeString;
    NSInteger  type;
}

@end

@implementation LMPublicArticleController

static NSMutableArray *cellDataArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView  = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)
                                                   style:UITableViewStyleGrouped];
    
    self.tableView.delegate                 = self;
    self.tableView.dataSource               = self;
    self.tableView.keyboardDismissMode      = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.separatorStyle           = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.tableView];
    
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"发布"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(publishArtcle)];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeAction)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    [self createUI];
    
    type = 1;
    imageArray      = [NSMutableArray arrayWithCapacity:0];
    imageViewArray  = [NSMutableArray new];
    cellDataArray   = [NSMutableArray new];
    
    [self projectDataStorageWithArrayIndex:0];
    projectImageArray   = [NSMutableArray arrayWithCapacity:10];
    
    for (int i = 0; i < 10; i++) {
     
        [projectImageArray addObject:@""];
    }
}

- (void)createUI
{
    self.title = @"发布文章";
    pickImage   =[[UIImagePickerController alloc]init];
    
    [pickImage setDelegate:self];
    pickImage.transitioningDelegate     = self;
    pickImage.modalPresentationStyle    = UIModalPresentationCustom;
    
    
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,90+10)];
    [bgView setBackgroundColor:[UIColor whiteColor]];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 49.5, kScreenWidth, 0.5)];
    lineView.backgroundColor = LINE_COLOR;
    [bgView addSubview:lineView];
    
    //标题
    titleTF = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, kScreenWidth-20, 44.5)];
    titleTF.placeholder = @"请输入标题";
    [titleTF setValue:TEXT_COLOR_LEVEL_4 forKeyPath:@"_placeholderLabel.textColor"];
    titleTF.delegate = self;
    [titleTF setReturnKeyType:UIReturnKeyDone];
    titleTF.keyboardType = UIKeyboardTypeDefault;//键盘类型
    titleTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    titleTF.font = TEXT_FONT_LEVEL_2;
    [bgView addSubview:titleTF];
    
    //描述
    discribleTF = [[UITextField alloc] initWithFrame:CGRectMake(10, 50, kScreenWidth-20, 44.5)];
    discribleTF.placeholder = @"请输入描述内容";
    discribleTF.delegate = self;
    [discribleTF setValue:TEXT_COLOR_LEVEL_4 forKeyPath:@"_placeholderLabel.textColor"];
    [discribleTF setReturnKeyType:UIReturnKeyDone];
    discribleTF.keyboardType    = UIKeyboardTypeDefault;//键盘类型
    discribleTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    discribleTF.font = TEXT_FONT_LEVEL_2;
    [bgView addSubview:discribleTF];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(10, 49.5+45, kScreenWidth, 0.5)];
    line2.backgroundColor = LINE_COLOR;
    [bgView addSubview:line2];
    
    self.tableView.tableHeaderView = bgView;
}

- (void)typeChoose
{
    LMTypeListViewController    *typeVC     = [[LMTypeListViewController alloc] init];
    typeVC.delegate     = self;
    
    [self.navigationController pushViewController:typeVC animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
      
        return cellDataArray.count;
    }
    
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
       return 45;
    }
    
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        UIView  *bgView     = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,45)];
        [bgView setBackgroundColor:[UIColor whiteColor]];
        
        //描述
        typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth-20, 44.5)];
        typeLabel.textColor = TEXT_COLOR_LEVEL_4;
        
        if (type == 1) {
            
            typeLabel.text = @"请选择文章分类";
        } else {
            
            typeLabel.text = typeString;
            typeLabel.textColor = TEXT_COLOR_LEVEL_2;
        }

        typeLabel.font = TEXT_FONT_LEVEL_2;
        typeLabel.userInteractionEnabled = YES;
        [bgView addSubview:typeLabel];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(typeChoose)];
        [typeLabel addGestureRecognizer:tap];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, 44.5, kScreenWidth, 0.5)];
        line.backgroundColor = LINE_COLOR;
        [bgView addSubview:line];
        
        return bgView;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    if (indexPath.section == 0) {
        
        NSArray *array = [NSArray new];
        
        if (projectImageArray.count > indexPath.row && [projectImageArray[indexPath.row] isKindOfClass:[NSArray class]]) {
            
            array = projectImageArray[indexPath.row];
        
        } else if ([projectImageArray[indexPath.row] isKindOfClass:[NSString class]]) {
          
            array = nil;
        }
        
        NSInteger margin        = 10;//图片之间的间隔
        NSInteger imageWidth    = (kScreenWidth - margin*5) / 4;//图片的宽度，固定一行只放置4个图片

        NSInteger rowNum        = array.count/4 + 1;
        
        return 190 + rowNum*(imageWidth + margin);
    }
    
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        static NSString *cellId = @"cellId";
        
        cell    = [[LMPAHeadViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        
        cell.selectionStyle     = UITableViewCellSelectionStyleNone;
        cell.backgroundColor    = [UIColor clearColor];
        cell.tag                = indexPath.row;
        
        cell.includeTF.delegate = self;
        
        [cell.includeTF setTag:indexPath.row];
        cell.delegate = self;
        
        cell.includeTF.text     = cellDataArray[indexPath.row][@"content"];
        
        if ([cellDataArray[indexPath.row][@"content"] isEqualToString:@""] && cellDataArray[indexPath.row][@"content"]) {
            
            [cell.textLab setHidden:NO];
        } else {
            
            [cell.textLab setHidden:YES];
        }
        
        if (cellDataArray.count == 1) {
            
            if (indexPath.row==0) {
            
                [cell.deleteBt setHidden:YES];
            } else {
                
                [cell.deleteBt setHidden:NO];
            }
        }
        
        
        [cell.deleteBt addTarget:self action:@selector(closeCell:) forControlEvents:UIControlEventTouchUpInside];
        [cell.deleteBt setTag:indexPath.row];

        cell.imageV.delegate = self;
        
        if (projectImageArray && projectImageArray.count > 0) {
        
            cell.array  = projectImageArray[indexPath.row];
        }
        
        
        if (projectImageArray.count > indexPath.row && [projectImageArray[indexPath.row] isKindOfClass:[NSArray class]]) {
           
            cell.array  = projectImageArray[indexPath.row];
        
        } else if (projectImageArray.count > indexPath.row && [projectImageArray[indexPath.row] isKindOfClass:[NSString class]]) {
        
            cell.array  = nil;
        } else {
            
            cell.array  = nil;
        }
        
        [cell.imageV setTag:indexPath.row];
  
        return cell;
    }
        
    if (indexPath.section == 1) {
        
        static NSString *cellId     = @"cellId";
        
        UITableViewCell *addCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];

        addCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 45)];
        
        textLabel.text              = @"添加内容";
        textLabel.textAlignment     = NSTextAlignmentCenter;
        textLabel.font              = TEXT_FONT_LEVEL_1;
        [addCell.contentView addSubview:textLabel];
        textLabel.backgroundColor   = [UIColor whiteColor];
        addCell.backgroundColor     = [UIColor clearColor];
        
        return addCell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        
        NSInteger length    = cellDataArray.count;
        
        if (length >= 10) {
            
            [self textStateHUD:@"提交已达上限"];
            return;
        }
        
        [self projectDataStorageWithArrayIndex:length];
        [self refreshData];
    }
}

- (void)closeCell:(UIButton *)button
{
    NSInteger row   = button.tag;
    
    [cellDataArray removeObjectAtIndex:row];
    
    [projectImageArray removeObjectAtIndex:row];
    
    [self refreshData];
}

#pragma mark UIImagePickerController代理函数

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [pickImage dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary<NSString *,id> *)editingInfo
{
    [imageViewArray addObject:image];
    
    [projectImageArray replaceObjectAtIndex:addImageIndex withObject:imageViewArray];


    [self getImageURL:imageViewArray];
    
    [self refreshData];

    [pickImage dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ZYQAssetPickerController Delegate

- (void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    for (int i = 0; i < assets.count; i++) {
  
        imageNum++;
        
        ALAsset *asset=assets[i];
        UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        
        [imageArray addObject:tempImg];
        
        [imageViewArray addObject:tempImg];
    }
    
    [projectImageArray replaceObjectAtIndex:addImageIndex withObject:imageViewArray];
    
    [self getImageURL:projectImageArray[addImageIndex]];
    [self refreshData];
}

- (void)addViewTag:(NSInteger)viewTag
{
    addImageIndex   = viewTag;
    imageViewArray  = [NSMutableArray arrayWithCapacity:0];
    
    if (projectImageArray.count > viewTag && [projectImageArray[viewTag] isKindOfClass:[NSArray class]]) {
        
        [imageViewArray addObjectsFromArray:projectImageArray[viewTag]];

        if ([projectImageArray[viewTag] count] >= 10) {
            
            [self textStateHUD:@"最多10张"];
            return;
        }
    }
    
    if (imageNum > 100) {
        
        [self textStateHUD:@"总图片数已达上限"];
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

#pragma mark 获取头像的url

- (void)getImageURL:(NSMutableArray*)imgArr
{
    if (![CheckUtils isLink]) {
        
        [self textStateHUD:@"无网络连接"];
        return;
    }
    
    [self textStateHUD:@"上传中..."];
    [self initStateHud];
    
    NSMutableArray *urlArray = [NSMutableArray new];

    for (int i = 0; i < imgArr.count; i++) {
        
        FirUploadImageRequest   *request    = [[FirUploadImageRequest alloc] initWithFileName:@"file"];
        
        UIImage *headImage  = [ImageHelpTool scaleImage:imgArr[i]];
        request.imageData   = UIImageJPEGRepresentation(headImage, 1);
        
        HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                               completed:^(NSString *resp, NSStringEncoding encoding){
                                                   
                                                   [self performSelectorOnMainThread:@selector(hideStateHud)
                                                                          withObject:nil
                                                                       waitUntilDone:YES];
                                                   
                                                   NSDictionary     *bodyDict   = [VOUtil parseBody:resp];
                                                   NSString         *result     = [bodyDict objectForKey:@"result"];
                                                   
                                                   if (result && [result isKindOfClass:[NSString class]]
                                                       && [result isEqualToString:@"0"]) {
                                                       
                                                       NSString    *imgUrl = [bodyDict objectForKey:@"attachment_url"];
                                                       
                                                       if (imgUrl && [imgUrl isKindOfClass:[NSString class]]) {
                                                           
                                                           [urlArray addObject:imgUrl];
                                                       }
                                                       
                                                       if (urlArray.count == imgArr.count) {
                                                        
                                                           [self modifyCellDataImage:addImageIndex andImageUrl:urlArray];
                                                       }
                                                   } else {
                                                       
                                                       
                                                   }
                                               } failed:^(NSError *error) {
        
                                                   [self hideStateHud];
                                               }];
        
        [proxy start];
    }
}

#pragma mark 编辑单元格项目活动图片

- (void)modifyCellDataImage:(NSInteger)row andImageUrl:(NSMutableArray *)imageUrl
{
    NSMutableDictionary *dic=cellDataArray[row];
    
    if (imageUrl) {
 
        [dic setObject:imageUrl forKey:@"image"];
    } else {
        
        [dic setObject:@[@""] forKey:@"image"];
    }
}

#pragma mark 编辑单元格项目介绍

- (void)modifyCellDataContent:(NSInteger)row andText:(NSString *)text
{
    NSMutableDictionary *dic=cellDataArray[row];
    
    if ([text isEqualToString:@""]) {
        
        [dic setObject:@"" forKey:@"content"];
    }else{
        [dic setObject:text forKey:@"content"];
    }
    
    [self refreshData];
}

#pragma mark 单元格刚创建后的数据

- (void)projectDataStorageWithArrayIndex:(NSInteger)index
{
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:0];
    [dic setObject:@"" forKey:@"content"];
    [dic setObject:@"" forKey:@"image"];
    
    [cellDataArray insertObject:dic atIndex:index];
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    NSInteger row   = textView.tag;
    [self modifyCellDataContent:row andText:textView.text];
    
    return YES;
}

#pragma mark UIActionSheet 代理函数

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {//图库
        NSInteger   imgNumber   = 0;
        
        if (projectImageArray.count > actionSheet.tag && [projectImageArray[actionSheet.tag] isKindOfClass:[NSArray class]]) {
            
            imgNumber   = [projectImageArray[actionSheet.tag] count];
        }
        
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
}

#pragma mark 发布成功后等待跳转的页面

- (void)publishArtcle
{
    [self.view endEditing:YES];
    
    if (titleTF.text.length ==0) {
        [self textStateHUD:@"请输入标题"];
        return;
    }
    
    if (discribleTF.text.length ==0) {
        [self textStateHUD:@"请输入描述内容"];
        return;
    }
    
    if (imageArray.count < 1) {
        [self textStateHUD:@"至少上传一张图片"];
        return;
    }
    
    [self publishAction];
}

#pragma mark 删除图片EditImageViewDelegate

- (void)deleteViewTag:(NSInteger)viewTag andSubViewTag:(NSInteger)tag
{
    NSMutableArray *newArray = projectImageArray[viewTag];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否删除图片"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                              style:UIAlertActionStyleDestructive
                                            handler:^(UIAlertAction*action) {
                                                
                                                [newArray removeObjectAtIndex:tag];
                                                [imageArray removeObjectAtIndex:tag];
                                                [self refreshData];
                                                
                                            }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark 发布文章

- (void)publishAction
{
    if (![CheckUtils isLink]) {
        
        [self textStateHUD:@"无网络"];
        return;
    }
    
    [self initStateHud];
    
    NSLog(@"%@",cellDataArray);
    NSDictionary *dic = [NSDictionary new];
    
    NSMutableArray *new = [NSMutableArray new];
    
    for (int i = 1; i < cellDataArray.count; i++) {

        NSMutableDictionary  *dict = [NSMutableDictionary new];
        
        dic = cellDataArray[i];
        
        NSString *string    = [dic objectForKey:@"content"];
        NSArray  *arr       = [dic objectForKey:@"image"];
        
        [dict setObject:string forKey:@"content"];
        [dict setObject:arr forKey:@"images"];
        
        [new addObject:dict];
    }

    NSDictionary *contentDic = cellDataArray[0];
    
    NSString *cont = [contentDic objectForKey:@"content"];
    NSArray *array = [contentDic objectForKey:@"image"];
    
    if (cont.length < 1) {
        
        [self textStateHUD:@"第一个正文需要输入文字"];
        return;
    }
    if (array.count < 1) {
        
        [self textStateHUD:@"第一个正文需要添加图片"];
        return;
    }
 
    self.navigationItem.rightBarButtonItem.enabled  = NO;
    
    LMPublicArticleRequest  *request    = [[LMPublicArticleRequest alloc] initWithArticlecontent:cont
                                                                                   Article_title:titleTF.text
                                                                                      Descrition:discribleTF.text
                                                                                     andImageURL:array
                                                                                         andType:typeString
                                                                                           blend:new];
    
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(publishResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                               
                                           } failed:^(NSError *error) {
                                               
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                  
                                                   [self textStateHUD:@"网络错误"];
                                                   self.navigationItem.rightBarButtonItem.enabled   = YES;
                                               });
                                           }];
    
    [proxy start];
}

- (void)publishResponse:(NSString *)resp
{
    NSDictionary    *bodyDict   = [VOUtil parseBody:resp];
    [self logoutAction:resp];
    
    if (!bodyDict) {
        
        [self textStateHUD:@"发布失败"];
        self.navigationItem.rightBarButtonItem.enabled  = YES;
        
        return;
    }
    
    if (bodyDict && [bodyDict objectForKey:@"result"]
        && [[bodyDict objectForKey:@"result"] isKindOfClass:[NSString class]]){
        
        if ([[bodyDict objectForKey:@"result"] isEqualToString:@"0"]){
            
            [self textStateHUD:@"发布成功"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
                [self.navigationController popViewControllerAnimated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadHomePage" object:nil];
            });
            
        } else {
            
            [self textStateHUD:@"发布失败"];
            self.navigationItem.rightBarButtonItem.enabled      = YES;
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == titleTF || textField == discribleTF) {
        
        [textField resignFirstResponder];
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    for (UIView *view in textView.subviews) {
        
        if ([view isKindOfClass:[UILabel class]]) {
        
            if (textView.text.length > 0) {
            
                [view setHidden:YES];
            } else {
                
                [view setHidden:NO];
            }
        }
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self scrollEditingRectToVisible:textView.frame EditingView:textView];
}

- (void)closeAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)refreshData
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.tableView reloadData];
    });
}

- (void)backLiveName:(NSString *)liveRoom
{
    type = 2;
    typeString  = liveRoom;
  
    [self.tableView reloadData];
}

@end
