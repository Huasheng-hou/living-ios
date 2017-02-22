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
#import "KZVideoViewController.h"
#import "UIImageView+WebCache.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ZYQAssetPickerController.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import <MediaPlayer/MediaPlayer.h>
#import "PlayerViewController.h"
#import <Photos/Photos.h>
#import "FirUploadVideoRequest.h"

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
LMTypeListProtocol,
KZVideoViewControllerDelegate
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
    NSMutableArray *imageURLArray;
    NSData *videoData;
    NSString *typeIndex;
    NSString *videoUrl;
    
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
    typeIndex = nil;
    type = 1;
    imageArray      = [NSMutableArray arrayWithCapacity:0];
    imageViewArray  = [NSMutableArray new];
    cellDataArray   = [NSMutableArray new];
    
    [self projectDataStorageWithArrayIndex:0];
    projectImageArray   = [NSMutableArray arrayWithCapacity:10];
    imageURLArray = [NSMutableArray new];
    
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
        
        } else if (projectImageArray.count > indexPath.row && [projectImageArray[indexPath.row] isKindOfClass:[NSString class]]) {
          
            array   = nil;
            
        } else {
            
            array   = nil;
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
        
        if (projectImageArray && projectImageArray.count > indexPath.row) {
        
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
        
//        if (length >= 10) {
//            
//            [self textStateHUD:@"提交已达上限"];
//            return;
//        }
        
        [self projectDataStorageWithArrayIndex:length];
        [self refreshData];
    }
}

- (void)closeCell:(UIButton *)button
{
    button.enabled  = NO;
    
    NSInteger row   = button.tag;
    
    NSLog(@"Currently closed cell is:%ld", row);
    
    if (cellDataArray.count > row) {
        
        [cellDataArray removeObjectAtIndex:row];
    }
    
    if (projectImageArray.count > row) {
        
        [projectImageArray replaceObjectAtIndex:row withObject:@""];
    }
    
    [self refreshData];
}

#pragma mark UIImagePickerController代理函数

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [pickImage dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - ZYQAssetPickerController Delegate

- (void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    
    NSMutableArray *updateImageArray = [NSMutableArray new];
    typeIndex = nil;
    if (assets.count > 0) {
        
        for (int i = 0; i < assets.count; i++) {
            
            imageNum++;
            
            ALAsset *asset=assets[i];
            NSLog(@"%@",[asset valueForProperty:ALAssetPropertyType]);
            if ([[asset valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
                typeIndex =[NSString stringWithFormat:@"%ld",imageNum];
                
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
                
                    UIImage *VideoImage = [UIImage imageWithCGImage:[asset aspectRatioThumbnail]];
                    [imageArray addObject:VideoImage];
                    
                    [imageViewArray addObject:VideoImage];
                [updateImageArray addObject:VideoImage];
 
            }else if ([[asset valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypePhoto]){
                UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
                [imageArray addObject:tempImg];
                
                [imageViewArray addObject:tempImg];
                [updateImageArray addObject:tempImg];
                
            }
            
            [projectImageArray replaceObjectAtIndex:addImageIndex withObject:imageViewArray];
            
            
            [self refreshData];
        }
        [self getImageURL:updateImageArray];
    }



    
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
                                  otherButtonTitles:@"相册", @"拍照",@"录制小视频",@"本地选取小视频",nil];
    
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
    
    NSLog(@"*******imgArr*****  %@",imgArr);
    
    [self textStateHUD:@"上传中..."];
    [self initStateHud];
    
    NSMutableArray *urlArray = [NSMutableArray new];

    for (int i = 0; i < imgArr.count; i++) {
        
        FirUploadImageRequest   *request    = [[FirUploadImageRequest alloc] initWithFileName:@"file"];
        
        UIImage *headImage  = [ImageHelpTool scaleImage:imgArr[i]];
        request.imageData   = UIImageJPEGRepresentation(headImage, 1);
        
        HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                               completed:^(NSString *resp, NSStringEncoding encoding){
                                                   
                                                   NSDictionary     *bodyDict   = [VOUtil parseBody:resp];
                                                   NSString         *result     = [bodyDict objectForKey:@"result"];
                                                   
                                                   if (result && [result isKindOfClass:[NSString class]]
                                                       && [result isEqualToString:@"0"]) {
                                                    
                                                       
                                                       NSString    *imgUrl = [bodyDict objectForKey:@"attachment_url"];
                                                       
                                                       if (imgUrl && [imgUrl isKindOfClass:[NSString class]]) {
                                                           
                                                           [urlArray addObject:imgUrl];
                                                           
                                                           NSLog(@"****^^^^^^^^1   %@",urlArray);
                                                           
                                                           
                                                       } else {
                                                           
                                                           [urlArray addObject:@""];
                                                           NSLog(@"****^^^^^^^^2   %@",urlArray);
                                                       }
                                                      
                                                   } else {
                                                       
                                                       [urlArray addObject:@""];
                                                       NSLog(@"****^^^^^^^^3   %@",urlArray);
                                                   }
                                                   NSLog(@"****^^^^^^^^4   %@",urlArray);
                                                   
                                                   if (urlArray.count == imgArr.count) {
                                                       dispatch_async(dispatch_get_main_queue(), ^{
                                                           NSLog(@"****^^^^^^^^5   %@",urlArray);
                                                           
                                                           if (typeIndex&&![typeIndex isEqual:@""]) {
                                                               [self sendVideo:videoData andArray:urlArray];
                                                           }else{
                                                                [self performSelector:@selector(hideStateHud) withObject:nil afterDelay:0];
                                                               [self modifyCellDataImage:addImageIndex andImageUrl:urlArray];
                                                           }
                                                           
                                                          
                                                       });

                                                       
                                                   }
                                                   
                                               } failed:^(NSError *error) {
                                                   
                                                   [urlArray addObject:@""];
                                                   
                                                   if (urlArray.count == imgArr.count) {

                                                       dispatch_async(dispatch_get_main_queue(), ^{
                                                           NSLog(@"****^^^^^^^^6   %@",urlArray);

                                                           
                                                           if (typeIndex&&![typeIndex isEqual:@""]) {
                                                               [self sendVideo:videoData andArray:urlArray];
                                                           }else{
                                                               
                                                                [self performSelector:@selector(hideStateHud) withObject:nil afterDelay:0];
                                                               [self modifyCellDataImage:addImageIndex andImageUrl:urlArray];
                                                           }

                                                       });

                                                   }
                                               }];
        
        [proxy start];
    }
}

#pragma mark 编辑单元格项目活动图片

- (void)modifyCellDataImage:(NSInteger)row andImageUrl:(NSMutableArray *)imageUrl
{
    NSLog(@"%@",typeIndex);
    NSMutableDictionary *newDic=cellDataArray[row];

    NSMutableArray  *newArray= newDic[@"images"];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    for (int i = 0; i<imageUrl.count; i++) {
        if (typeIndex&&i == ([typeIndex intValue] -1)) {
            
            [dic setObject:imageUrl[i] forKey:@"coverUrl"];
            [dic setObject:@"video" forKey:@"type"];
            if (videoUrl&&![videoUrl isEqual:@""]) {
                [dic setObject:videoUrl forKey:@"videoUrl"];
                
            }
            
        }else{
            if (imageUrl) {
                
                [dic setObject:imageUrl[i] forKey:@"pictureUrl"];
                [dic setObject:@"picture" forKey:@"type"];
            } else {
                
                [dic setObject:@[@""] forKey:@"pictureUrl"];
            }
        }
        [newArray addObject:dic];
        
    }

    
}

#pragma mark 编辑单元格项目介绍

- (void)modifyCellDataContent:(NSInteger)row andText:(NSString *)text
{
    if (cellDataArray.count > row){
        
        NSMutableDictionary     *dic    = cellDataArray[row];
        
        if ([text isEqualToString:@""]) {
            
            [dic setObject:@"" forKey:@"content"];
            
        } else {
            
            [dic setObject:text forKey:@"content"];
        }
        
        [self refreshData];
    }
}

#pragma mark 单元格刚创建后的数据

- (void)projectDataStorageWithArrayIndex:(NSInteger)index
{
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:0];
    NSMutableArray *array = [NSMutableArray new];
    [dic setObject:@"" forKey:@"content"];
    [dic setObject:array forKey:@"images"];
    
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
    if (buttonIndex == 2) {
        NSLog(@"小视频~~~~~");
        KZVideoViewController *videoVC = [[KZVideoViewController alloc] init];
        videoVC.delegate = self;
        [videoVC startAnimationWithType:KZVideoViewShowTypeSingle];
    }
    if (buttonIndex == 3) {
        NSLog(@"小视频~~~~~");
        ZYQAssetPickerController *pickerV = [[ZYQAssetPickerController alloc] init];
        pickerV.maximumNumberOfSelection = 1;
        pickerV.assetsFilter = [ALAssetsFilter allVideos];
        pickerV.showEmptyGroups=NO;
        pickerV.delegate=self;
        
        pickerV.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
                NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
                return duration < 10;
            } else {
                return YES;
            }
        }];
        
        [self presentViewController:pickerV animated:YES completion:NULL];
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
    NSMutableArray *urlArray = [NSMutableArray new];
    urlArray = [cellDataArray[viewTag] objectForKey:@"image"];
    NSLog(@"*****^^^^^^^^^^%@",urlArray);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否删除图片"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                              style:UIAlertActionStyleDestructive
                                            handler:^(UIAlertAction*action) {
                                                
                                                if (newArray.count > tag) {
                                                    
                                                    [newArray removeObjectAtIndex:tag];
                                                    if ([urlArray isKindOfClass:[NSArray class]]&& urlArray.count > tag) {
                                                        [urlArray removeObjectAtIndex:tag];
                                                        NSLog(@"*****^^^^^^^^^^%@",urlArray);
                                                        [cellDataArray[viewTag] setObject:urlArray forKey:@"image"];
                                                        
                                                        NSLog(@"***#*#*#*#**#*#*#**#%@",cellDataArray[viewTag]);
                                                    }

                                                }
                                                
                                                if (imageArray.count > tag) {
                                                    
                                                    [imageArray removeObjectAtIndex:tag];

                                                }
                                            
                                                
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
    
    NSDictionary *dic = [NSDictionary new];
    
    // * 将从第二个图文区起的图文信息存入新增的图文数组里
    //
    NSMutableArray *new = [NSMutableArray new];
    
    for (int i = 1; i < cellDataArray.count; i++) {

        NSMutableDictionary  *dict = [NSMutableDictionary new];
        
        dic = cellDataArray[i];
        
        NSString *string    = [dic objectForKey:@"content"];
        NSArray  *arr       = [dic objectForKey:@"image"];
        
        if (string && [string isKindOfClass:[NSString class]]) {
            
            [dict setObject:string forKey:@"content"];
        }
        
        if (arr && [arr isKindOfClass:[NSArray class]]) {
            
            [dict setObject:arr forKey:@"images"];
        }
        
        [new addObject:dict];
    }

    // * 取出第一个文字、图片区域的文本和图片，传给旧的图文字段
    //
    NSDictionary *contentDic = cellDataArray[0];
    
    NSString *cont = [contentDic objectForKey:@"content"];
    NSArray *array = [contentDic objectForKey:@"image"];
    
    if (!cont || cont.length < 1) {
        
        [self textStateHUD:@"第一个正文需要输入文字"];
        return;
    }
    if (!array || ![array isKindOfClass:[NSArray class]] || array.count < 1) {
        
        if (projectImageArray.count > 0 && [projectImageArray[0] isKindOfClass:[NSArray class]]) {
            
            NSInteger   imgNumber   = [projectImageArray[0] count];
            
            if (imgNumber > 0) {
                
                int random = rand() % 100;
                
                if (random > 50) {
                    
                    [self textStateHUD:@"您的图片有点多哦，请等待上传完毕~"];
                } else {
                    
                    [self textStateHUD:@"等一下再点哦，还在上传图片~"];
                }
                
                return;
            }
        }
        
        [self textStateHUD:@"第一个正文需要添加图片"];
        return;
    }
 
    self.navigationItem.rightBarButtonItem.enabled  = NO;
    
    NSLog(@"***********imageUrl**********%@",array);
    
    
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


#pragma mark  视频录制或选择后回调
- (void)videoViewController:(KZVideoViewController *)videoController didRecordVideo:(KZVideoModel *)videoModel{
    
    
    NSURL* videoUrl = [NSURL URLWithString:videoModel.videoAbsolutePath];
    
    NSURL* imageUrl = [NSURL URLWithString:videoModel.thumAbsolutePath];
    
    UIImageView *imageV = [UIImageView new];
    [imageV sd_setImageWithURL:imageUrl];
    
    
    UIImage *image =[UIImage new];
    
    image = imageV.image;
    
    NSMutableArray *newImageArray = [NSMutableArray new];
    [newImageArray addObject:image];

    [self getImageURL:newImageArray];
    
    [self movFileTransformToMP4WithSourceUrl:videoUrl completion:^(NSString *Mp4FilePath) {
    
        videoModel.videoAbsolutePath = Mp4FilePath;
    }];
    
//    _videoModel = videoModel;
    
//    [self playerVideo:videoModel];
    
    
}

#pragma mark  mov格式转MP4
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

#pragma mark  --上传视频

- (void)sendVideo:(NSData *)data andArray:(NSMutableArray *)array
{
    [self initStateHud];
    [self textStateHUD:@"上传中..."];
    if (![CheckUtils isLink]) {
        
        [self textStateHUD:@"无网络连接"];
        return;
    }
    
    
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
                                                       

                                                        [self modifyCellDataImage:addImageIndex andImageUrl:array];
 
                                                       
                                                   }
                                               }
                                               
                                           } failed:^(NSError *error) {
                                               
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"网络错误"
                                                                   waitUntilDone:YES];
                                           }];
    [proxy start];
}


@end
