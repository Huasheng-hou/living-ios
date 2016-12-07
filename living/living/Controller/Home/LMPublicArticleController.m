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
LMPAHeadViewCellDelegate
>
{
    UIImagePickerController *pickImage;
    ZYQAssetPickerController *picker;
    NSMutableArray *imageUrlArray;
    NSMutableArray *imageArray;
    NSUInteger imageNum;
    NSInteger deleImageIndex;
    UITextField *titleTF;
    UITextField *discribleTF;
    NSMutableArray *projectImageArray;
    NSInteger addImageIndex;
    NSMutableArray *cellDataArray;
    NSMutableArray *contentArray;
    LMPAHeadViewCell *cell;
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

    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(publishArtcle)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeAction)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    [self createUI];
    
    imageArray    = [NSMutableArray arrayWithCapacity:0];
    imageUrlArray = [NSMutableArray arrayWithCapacity:0];
    cellDataArray = [NSMutableArray new];
    [self projectDataStorageWithArrayIndex:0];
    projectImageArray=[NSMutableArray arrayWithCapacity:10];
    
    for (int i=0; i<10; i++) {
        [projectImageArray addObject:@""];
    }
}

- (void)createUI
{
    self.title = @"发布文章";
    pickImage=[[UIImagePickerController alloc]init];
    
    [pickImage setDelegate:self];
    pickImage.transitioningDelegate  = self;
    pickImage.modalPresentationStyle = UIModalPresentationCustom;

    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,90+10)];
    [bgView setBackgroundColor:[UIColor whiteColor]];
    self.tableView.tableHeaderView =  bgView;
    //
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
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, 49.5+45, kScreenWidth, 0.5)];
    line.backgroundColor = LINE_COLOR;
    [bgView addSubview:line];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
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
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    if (indexPath.section==0) {
        return 260;
    }
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        static NSString *cellId = @"cellId";
        cell  = [[LMPAHeadViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.tag = indexPath.row;
        cell.includeTF.delegate = self;
        [cell.includeTF setTag:indexPath.row];
        cell.delegate = self;
        cell.includeTF.text=cellDataArray[indexPath.row][@"content"];
        
        if ([cellDataArray[indexPath.row][@"content"] isEqualToString:@""]&&cellDataArray[indexPath.row][@"content"]) {
            [cell.textLab setHidden:NO];
        }else{
            [cell.textLab setHidden:YES];
        }
        
        if ([projectImageArray[indexPath.row] isKindOfClass:[UIImage class]]) {
            UIImage *image=(UIImage *)projectImageArray[indexPath.row];
            [cell.imgView setImage:image];
        }else
            if ([projectImageArray[indexPath.row] isKindOfClass:[NSString class]]) {
                [cell.imgView setImage:[UIImage imageNamed:@""]];
            }
        
        if (cellDataArray.count==1) {
            if (indexPath.row==0) {
                [cell.deleteBt setHidden:YES];
            }else{
                [cell.deleteBt setHidden:NO];
            }
        }
        
        [cell.deleteBt addTarget:self action:@selector(closeCell:) forControlEvents:UIControlEventTouchUpInside];
        [cell.deleteBt setTag:indexPath.row];
        
        cell.eventButton=[[UIButton alloc]initWithFrame:[self setupImageFrame:0]];
        

        [cell.eventButton setTag:indexPath.row+10];
        
        
        
        [cell.deleteBt setHidden:NO];
  
        return cell;
    }
        
    if (indexPath.section==1) {
        static NSString *cellId = @"cellId";
        UITableViewCell *addCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];

        addCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 45)];
        textLabel.text = @"添加内容";
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.font = TEXT_FONT_LEVEL_1;
        [addCell.contentView addSubview:textLabel];
        textLabel.backgroundColor = [UIColor whiteColor];
        
        addCell.backgroundColor = [UIColor clearColor];
        return addCell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1) {
        NSInteger length=cellDataArray.count;
        [self projectDataStorageWithArrayIndex:length];
        [self refreshData];
    }
}

#pragma mark ======================活动==项目活动增加图片

- (void)cellWilladdImage:(LMPAHeadViewCell *)cells
{
    addImageIndex=cells.tag;
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"相册", @"拍照",nil];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
    actionSheet = nil;
}


- (void)closeCell:(UIButton *)button
{
    NSInteger row=button.tag;
    
    [cellDataArray removeObjectAtIndex:row];
    
    [projectImageArray removeObjectAtIndex:row];
    
    [self refreshData];
}

-(void)selectImage
{
    [self.view endEditing:YES];
    if (imageNum>=10) {
        [self textStateHUD:@"您上传的图片数已达上限"];
        return;
    }
    
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

#pragma mark UIImagePickerController代理函数

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [pickImage dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 获取头像的url

- (void)getImageURL:(NSMutableArray*)imgArr
{
    if (![CheckUtils isLink]) {
        
        [self textStateHUD:@"无网络连接"];
        return;
    }
        [self initStateHud];
    NSMutableArray *urlArray = [NSMutableArray new];
        

    for (int i =0; i<imgArr.count; i++) {
        FirUploadImageRequest   *request    = [[FirUploadImageRequest alloc] initWithFileName:@"file"];
        UIImage *headImage = [ImageHelpTool scaleImage:imgArr[i]];
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
                                                           
                                                           [urlArray addObject:imgUrl];
                                                           
                                                        
                                                       }
                                                   }
                                               } failed:^(NSError *error) {
                                                   [self hideStateHud];
                                               }];
        [proxy start];
  
    }
       [self modifyCellDataImage:addImageIndex andImageUrl:urlArray];
    
    
}

#pragma mark 编辑单元格项目活动图片

-(void)modifyCellDataImage:(NSInteger)row andImageUrl:(NSMutableArray *)imageUrl{
    
    NSMutableDictionary *dic=cellDataArray[row];
    
    if (imageUrl) {
        [dic setObject:imageUrl forKey:@"image"];
    }else{
        [dic setObject:@[@""] forKey:@"image"];
    }
}



#pragma mark - ZYQAssetPickerController Delegate

-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    
    for (int i=0; i<assets.count; i++) {
        imageNum++;
        ALAsset *asset=assets[i];
        UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        
        [self addImageViewFrame:[self setupImageFrame:imageNum-1] andImage:tempImg];
        
        [projectImageArray replaceObjectAtIndex:addImageIndex withObject:tempImg];
        
        [self refreshData];
        
        
        [imageArray addObject:tempImg];
        [self getImageURL:imageArray];
        
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i=0; i<assets.count; i++) {
            ALAsset *asset=assets[i];
            UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
            
            [imageArray addObject:tempImg];
        }
    });
    
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
    
    NSInteger row=textView.tag;
    [self modifyCellDataContent:row andText:textView.text];
    
    
    return YES;
}


#pragma mark UIActionSheet 代理函数

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex==0)
    {//图库
        picker = [[ZYQAssetPickerController alloc] init];
        picker.maximumNumberOfSelection = 15-imageNum;
        picker.assetsFilter = [ALAssetsFilter allPhotos];
        picker.showEmptyGroups=NO;
        picker.delegate=self;
        picker.transitioningDelegate  = self;//覆盖原代理  另外需要遵循一个协议
        picker.modalPresentationStyle = UIModalPresentationCustom;
        picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
                NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
                return duration >= 5;
            } else {
                return YES;
            }
        }];
        
        [self presentViewController:picker animated:YES completion:NULL];
        
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
    
    
    if (imageArray.count<1) {
        [self textStateHUD:@"至少上传一张图片"];
        return;
    }
    
    self.navigationItem.rightBarButtonItem.enabled  = NO;
    
//    if (imageArray.count>0) {
//        [self performSelectorOnMainThread:@selector(getImageURL) withObject:nil waitUntilDone:YES];
//    }else{
//        [self publishAction];
//    }
}


#pragma mark 设置图片位置

- (CGRect)setupImageFrame:(NSInteger)num
{
    CGFloat startX=15;
    CGFloat space=10;
    CGFloat buttonW=(kScreenWidth-startX*2-space*3)/4;
    CGRect rect;
    if (num<4) {
        rect=CGRectMake(startX+num%4*(buttonW+space), space+num/4, buttonW, buttonW);
    }else
        if (num<8) {
            rect=CGRectMake(startX+num%4*(buttonW+space), space*2+buttonW+num/4, buttonW, buttonW);
        }
        else if(num <12){
            rect=CGRectMake(startX+num%4*(buttonW+space), space*3+buttonW*2+num/4, buttonW, buttonW);
        }else{
            rect=CGRectMake(startX+num%4*(buttonW+space), space*4+buttonW*3+num/4, buttonW, buttonW);
        }
    return rect;
}

#pragma mark scroll加载图片

- (void)addImageViewFrame:(CGRect)rect andImage:(UIImage *)imag;
{
    UIImageView *image=[[UIImageView alloc]initWithFrame:rect];
    image.contentMode = UIViewContentModeScaleAspectFill;
    image.clipsToBounds = YES;
    [image setImage:imag];
    [image setTag:imageNum-1];
    [image setUserInteractionEnabled:YES];
    [cell.backView addSubview:image];
    
    UITapGestureRecognizer      *tap    = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lookBigImage:)];
    [image addGestureRecognizer:tap];
    
    
    UIButton *icon=[[UIButton alloc]initWithFrame:CGRectMake(image.frame.size.width*3/4, 0, image.frame.size.width/4, image.frame.size.height/4)];
    [icon setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    [icon addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
    [icon setTag:image.tag];
    [image addSubview:icon];
    
    [self refreshData];
    
}

#pragma mark 查看大图

- (void)lookBigImage:(UITapGestureRecognizer*)guesture
{
    UIImageView *image= (UIImageView *)guesture.view;
    
    if (image.image) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        [ImageHelpTool showImage:image];
    }else{
        return;
    }
    
}

#pragma mark 删除图片

- (void)deleteImage:(UIButton*)sender
{
    deleImageIndex=sender.tag;
    for (UIImageView *iconImage in sender.subviews) {
        [iconImage setHidden:NO];
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"确定删除图片"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
    [alert show];
}

#pragma mark alertView的点击事件

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        
        [imageArray removeObjectAtIndex:deleImageIndex];
        
        for (UIView *view in cell.subviews) {
            if ([view isKindOfClass:[UIImageView class]]) {
                UIImageView *image=(UIImageView *)view;
                [image removeFromSuperview];
            }
        }
        
        imageNum=0;
        for (int i=0; i<imageArray.count; i++) {
            imageNum++;
            UIImage *image=(UIImage *)imageArray[i];
            [self addImageViewFrame:[self setupImageFrame:imageNum-1] andImage:image];
        }
        [cell.eventButton setFrame:[self setupImageFrame:imageNum]];
    }else{
        
        for (UIView *view in cell.subviews) {
            if ([view isKindOfClass:[UIImageView class]]) {
                
                UIImageView *imageV=(UIImageView *)[view viewWithTag:deleImageIndex];
                for (UIView *view in imageV.subviews) {
                    if ([view isKindOfClass:[UIButton class]]) {
                        UIButton *button=(UIButton *)view;
                        [button removeFromSuperview];
                    }
                }
            }
        }
    }
    
    
}

#pragma mark 获取图片的url

- (void)getImageURL
{
    
    if (![CheckUtils isLink]) {
        
        [self textStateHUD:@"无网络连接"];
        return;
    }
    
    [self initStateHud];
    imageUrlArray = [NSMutableArray arrayWithCapacity:imageArray.count];
    
    for (int j = 0; j<imageArray.count; j++) {
        [imageUrlArray addObject:@""];
    }
    
    for (int i=0; i<imageArray.count; i++) {
        
        FirUploadImageRequest   *request    = [[FirUploadImageRequest alloc] initWithFileName:@"file"];
        UIImage *image = [ImageHelpTool scaleImage:imageArray[i]];
        request.imageData   = UIImageJPEGRepresentation(image, 1);
        
        HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                               completed:^(NSString *resp, NSStringEncoding encoding){
                                                   
                                                   NSDictionary    *bodyDict   = [VOUtil parseBody:resp];
                                                   
                                                   NSString    *result = [bodyDict objectForKey:@"result"];
                                                   
                                                   if (result && [result isKindOfClass:[NSString class]]
                                                       && [result isEqualToString:@"0"]) {
                                                       
                                                       
                                                       NSString    *imgUrl = [bodyDict objectForKey:@"attachment_url"];
                                                       
                                                       if (imgUrl && [imgUrl isKindOfClass:[NSString class]]) {
                                                           imageUrlArray[i] =imgUrl;
                                                           
                                                           if (![imageUrlArray containsObject:@""]) {
                                                               [self performSelectorOnMainThread:@selector(hideStateHud) withObject:nil waitUntilDone:YES];
 
                                                           }
                                                       }
                                                   }else{
                                                       [self textStateHUD:bodyDict[@"description"]];
                                                   }
                                                   
                                               } failed:^(NSError *error) {
                                                   
                                                   [self performSelectorOnMainThread:@selector(hideStateHud)
                                                                          withObject:nil
                                                                       waitUntilDone:YES];
                                               }];
        [proxy start];
    }
}

#pragma mark 发布问题

- (void)publishAction
{
    if (![CheckUtils isLink]) {
        
        [self textStateHUD:@"无网络"];
        return;
    }
    
    [self initStateHud];
    
    NSMutableArray *new = [NSMutableArray new];
    
    [new setValue:@"人个人和维护" forKey:@"article_content"];
    
    
    LMPublicArticleRequest *request  = [[LMPublicArticleRequest alloc] initWithArticlecontent:@"ryewrw"
                                        
                                                                                Article_title:titleTF.text
                                                                                      Descrition:discribleTF.text
                                                                                     andImageURL:imageUrlArray
                                                                                      andType:@"生活"
                                                                                        blend:new];
    
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(publishResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               
                                               [self textStateHUD:@"网络错误"];
                                           }];
    [proxy start];
}

- (void)publishResponse:(NSString *)resp
{
    NSDictionary    *bodyDict   = [VOUtil parseBody:resp];
    [self logoutAction:resp];
    
    if (!bodyDict) {
        [self textStateHUD:@"发布失败"];
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
            
            
        }else{
            [self textStateHUD:@"发布失败"];
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
            if (textView.text.length>0) {
                [view setHidden:YES];
            }else{
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

@end
