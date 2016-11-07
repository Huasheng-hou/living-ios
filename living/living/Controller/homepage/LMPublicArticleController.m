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



@interface LMPublicArticleController ()
<
UITextFieldDelegate,
UITextViewDelegate,
UIActionSheetDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
UINavigationControllerDelegate,
UIScrollViewDelegate,
UIAlertViewDelegate,
ZYQAssetPickerControllerDelegate,
UIViewControllerTransitioningDelegate
>
{
    UIImagePickerController *pickImage;
    ZYQAssetPickerController *picker;
    
    
    UIView *viewScroll;
    
    UIButton *addImageBt;
    
    UILabel *tip;
    UITextView * textView;
    
    NSMutableArray *imageUrlArray;
    NSMutableArray *imageArray;
    NSUInteger imageNum;
    
    NSInteger deleImageIndex;
    
    UIView *grayView1;
    
    UIView *grayView2;
    UIButton *publish;
    
    UITextField *titleTF;
    UITextField *discribleTF;
    
}

@end

@implementation LMPublicArticleController

+ (void)presentInViewController:(UIViewController *)viewController Animated:(BOOL)animated
{
    if (!viewController) {
        return;
    }
    
    LMPublicArticleController      *publicVC    = [[LMPublicArticleController alloc] init];
    FitNavigationController *navVC      = [[FitNavigationController alloc] initWithRootViewController:publicVC];
    
    [viewController presentViewController:navVC animated:animated completion:^{
        
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(publicAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(publicAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    [self createUI];
    
    imageArray      = [NSMutableArray arrayWithCapacity:0];
    imageUrlArray = [NSMutableArray arrayWithCapacity:0];
}

- (void)createUI
{
    [super createUI];
    [self.tableView setBackgroundColor:BG_GRAY_COLOR];
    self.title = @"发布文章";
//    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    pickImage=[[UIImagePickerController alloc]init];
    
    [pickImage setDelegate:self];
    pickImage.transitioningDelegate  = self;
    pickImage.modalPresentationStyle = UIModalPresentationCustom;
    [pickImage setAllowsEditing:YES];
    
    UIScrollView *scroll=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [scroll setBackgroundColor:BG_GRAY_COLOR];
    [scroll setContentSize:CGSizeMake(kScreenWidth, 800)];
    [scroll setDelegate:self];
    [self.tableView addSubview:scroll];
    
    //
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight/2+50+45)];
    [bgView setBackgroundColor:[UIColor whiteColor]];
    [scroll addSubview:bgView];
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
    titleTF.font = TEXT_FONT_LEVEL_2;
    [bgView addSubview:titleTF];
    
    //描述
    discribleTF = [[UITextField alloc] initWithFrame:CGRectMake(10, 50, kScreenWidth-20, 44.5)];
    discribleTF.placeholder = @"请输入描述内容";
    discribleTF.delegate = self;
    [discribleTF setValue:TEXT_COLOR_LEVEL_4 forKeyPath:@"_placeholderLabel.textColor"];
    [discribleTF setReturnKeyType:UIReturnKeyDone];
    discribleTF.keyboardType = UIKeyboardTypeDefault;//键盘类型
    discribleTF.font = TEXT_FONT_LEVEL_2;
    [bgView addSubview:discribleTF];

    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5+45, kScreenWidth, 0.5)];
    line.backgroundColor = LINE_COLOR;
    [bgView addSubview:line];
    
    //正文
    textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 95, kScreenWidth-20, bgView.frame.size.height/2-45)];
    [textView setDelegate:self];
    [textView setBackgroundColor:[UIColor whiteColor]];
    textView.font = TEXT_FONT_LEVEL_2;//设置字体名字和字体大小
    textView.delegate = self;//设置它的委托方法
    
//    [textView setReturnKeyType:UIReturnKeyDone];
    textView.keyboardType = UIKeyboardTypeDefault;//键盘类型
    textView.scrollEnabled = YES;//是否可以拖动
    textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
    [bgView addSubview: textView];//加入到整个页面中
    
    //textView的提示文字
    tip=[[UILabel alloc]initWithFrame:CGRectMake(12, 57+45, kScreenWidth-20, 25)];
    tip.text = @"请输入正文";//设置它显示的内容
    tip.textColor = TEXT_COLOR_LEVEL_4;//设置textview里面的字体颜色
    tip.font = TEXT_FONT_LEVEL_2;//设置字体名字和字体大小
    [bgView addSubview:tip];
    
    //加载图片，父视图是scroll
    viewScroll=[[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight/4+50+45, kScreenWidth, bgView.frame.size.height/2+50)];
    [viewScroll setBackgroundColor:[UIColor whiteColor]];
    
    addImageBt=[[UIButton alloc]initWithFrame:[self setupImageFrame:0]];
    
    [addImageBt setBackgroundImage:[UIImage imageNamed:@"addImage"] forState:UIControlStateNormal];
    [addImageBt addTarget:self action:@selector(selectImage) forControlEvents:UIControlEventTouchUpInside];
    [viewScroll addSubview:addImageBt];
    [scroll addSubview:viewScroll];
    
    //按钮上边的灰色部分
    grayView1=[[UIView alloc]initWithFrame:CGRectMake(0, viewScroll.frame.size.height-45-45, kScreenWidth, 45)];
    [grayView1 setBackgroundColor:BG_GRAY_COLOR];
    [viewScroll addSubview:grayView1];
   
    //和按钮同一y轴
    grayView2=[[UIView alloc]initWithFrame:CGRectMake(0, viewScroll.frame.size.height-45+45, kScreenWidth, 45)];
    [grayView2 setBackgroundColor:BG_GRAY_COLOR];
    [viewScroll addSubview:grayView2];
    
    //发布按钮
    publish=[[UIButton alloc]initWithFrame:CGRectMake(10, viewScroll.frame.size.height-45, kScreenWidth-20, 45)];
    [publish setBackgroundColor:LIVING_COLOR];
    
    [publish.layer setCornerRadius:5.0f];
    [publish.layer setMasksToBounds:YES];
    [publish setTitle:@"发布" forState:UIControlStateNormal];
    [publish addTarget:self action:@selector(publishQuestion) forControlEvents:UIControlEventTouchUpInside];
    [viewScroll addSubview:publish];
}

-(void)selectImage
{
    [self.view endEditing:YES];
    if (imageNum>=15) {
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

#pragma mark - ZYQAssetPickerController Delegate

-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    
    for (int i=0; i<assets.count; i++) {
        imageNum++;
        ALAsset *asset=assets[i];
        UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        
        [self addImageViewFrame:[self setupImageFrame:imageNum-1] andImage:tempImg];
    }
    [addImageBt setFrame:[self setupImageFrame:imageNum]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i=0; i<assets.count; i++) {
            ALAsset *asset=assets[i];
            UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
            
            [imageArray addObject:tempImg];
        }
    });
    
    [self setViewScrollViewHeight:imageNum];
}


#pragma mark 设置白板的高度

-(void)setViewScrollViewHeight:(NSInteger)num
{
    CGFloat startX=15;
    CGFloat space=10;
    CGFloat buttonW=(kScreenWidth-startX*2-space*3)/4;
    CGFloat height=100+45;
    
    if (imageNum<4) {
        NSLog(@".count<=4");
        
        [viewScroll setFrame:CGRectMake(0, kScreenHeight/4+45+45, kScreenWidth,height+buttonW+space*2)];
        
    }else if(imageNum<8) {
        NSLog(@".count<count<=8");
        [viewScroll setFrame:CGRectMake(0, kScreenHeight/4+45+45, kScreenWidth,height+buttonW*2+space*3)];
    }else if(imageNum<12){
        NSLog(@".count----else");
        viewScroll.frame = CGRectMake(0, kScreenHeight/4+45+45, kScreenWidth, height+buttonW*3+space*4);
    }else
    {
        viewScroll.frame = CGRectMake(0, kScreenHeight/4+45+45, kScreenWidth, height+buttonW*4+space*5);
    }
    
    
    
    [grayView1 setFrame:CGRectMake(0, viewScroll.frame.size.height-45-45, kScreenWidth, 45)];
    
    [grayView2 setFrame:CGRectMake(0, viewScroll.frame.size.height-45, kScreenWidth, 45)];
    
    [publish setFrame:CGRectMake(10, viewScroll.frame.size.height-45, kScreenWidth-20, 45)];
}


#pragma mark UIImagePickerController代理函数

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [pickImage dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    imageNum++;
    [self addImageViewFrame:[self setupImageFrame:imageNum-1] andImage:image];
    
    [imageArray addObject:image];
    
    [addImageBt setFrame:[self setupImageFrame:imageNum]];
    
    [self setViewScrollViewHeight:imageArray.count];
    
    [pickImage dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UIActionSheet 代理函数

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
//    pickImage=[[UIImagePickerController alloc]init];
//    
//    [pickImage setDelegate:self];
    //    [pickImage setAllowsEditing:YES];

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

-(void)publishQuestion
{
    NSLog(@"=======publishQuestion=========");
    
    [self.view endEditing:YES];
    
    if (titleTF.text.length ==0) {
        [self textStateHUD:@"请输入标题"];
        return;
    }

    if (discribleTF.text.length ==0) {
        [self textStateHUD:@"请输入描述内容"];
        return;
    }
    
    if (textView.text.length ==0) {
        [self textStateHUD:@"请输入正文！"];
        return;
    }
    NSString *string = [textView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([string isEqual:@""]) {
        [self textStateHUD:@"请输入文字信息！"];
        return;
    }
    
    if (imageArray.count<1) {
        [self textStateHUD:@"至少上传一张图片"];
        return;
    }

    if (imageArray.count>0) {
        [self performSelectorOnMainThread:@selector(getImageURL) withObject:nil waitUntilDone:YES];
    }else{
        [self publishAction];
    }
}

-(BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}

#pragma mark UITextViewDelegate



-(void)textViewDidBeginEditing:(UITextView *)textV
{
    [tip setHidden:YES];
}

-(void)textViewDidEndEditing:(UITextView *)textV
{
    if (textView.text.length==0) {
        [tip setHidden:NO];
    }
}



#pragma mark 设置图片位置

-(CGRect)setupImageFrame:(NSInteger)num
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

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}


#pragma mark scroll加载图片

-(void)addImageViewFrame:(CGRect)rect andImage:(UIImage *)imag;
{
    UIImageView *image=[[UIImageView alloc]initWithFrame:rect];
    image.contentMode = UIViewContentModeScaleAspectFill;
    image.clipsToBounds = YES;
    
    
    [image setImage:imag];
    [image setTag:imageNum-1];
    [image setUserInteractionEnabled:YES];
    [viewScroll addSubview:image];
    
    UITapGestureRecognizer      *tap    = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lookBigImage:)];
    [image addGestureRecognizer:tap];
    
    
    UIButton *icon=[[UIButton alloc]initWithFrame:CGRectMake(image.frame.size.width*3/4, 0, image.frame.size.width/4, image.frame.size.height/4)];
    [icon setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    [icon addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
    [icon setTag:image.tag];
    [image addSubview:icon];
    
}

#pragma mark 查看大图

-(void)lookBigImage:(UITapGestureRecognizer*)guesture
{
    UIImageView *image= (UIImageView *)guesture.view;
    [ImageHelpTool showImage:image];
}



#pragma mark 删除图片

-(void)deleteImage:(UIButton*)sender
{
    NSLog(@"------------image--tag:%ld",(long)sender.tag);
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
        
        for (UIView *view in viewScroll.subviews) {
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
        [addImageBt setFrame:[self setupImageFrame:imageArray.count]];
    }else{
        
        for (UIView *view in viewScroll.subviews) {
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
    
    [self setViewScrollViewHeight:imageNum];
}

#pragma mark 获取图片的url

- (void)getImageURL
{
    NSLog(@"======获取图片的url========");
    
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
                                                   
                                                   [self logoutAction:resp];
                                                   
                                                   
                                                   NSString    *result = [bodyDict objectForKey:@"result"];
                                                   
                                                   if (result && [result isKindOfClass:[NSString class]]
                                                       && [result isEqualToString:@"0"]) {
                                                       
                                                       
                                                       NSString    *imgUrl = [bodyDict objectForKey:@"attachment_url"];
                                                       
                                                       if (imgUrl && [imgUrl isKindOfClass:[NSString class]]) {
                                                           imageUrlArray[i] =imgUrl;
                                                           
                                                           NSLog(@"--------_imgURL--------%@",imgUrl);
                                                           if (![imageUrlArray containsObject:@""]) {
                                                               [self performSelectorOnMainThread:@selector(hideStateHud) withObject:nil waitUntilDone:YES];
                                                               //发布问题
                                                               [self performSelectorOnMainThread:@selector(publishAction) withObject:nil waitUntilDone:YES];
                                                           }
                                                       }
                                                   }else{
                                                       [self textStateHUD:bodyDict[@"description"]];
                                                   }
                                                   
                                               } failed:^(NSError *error) {
                                                   [self performSelectorOnMainThread:@selector(hideStateHud)
                                                                          withObject:nil
                                                                       waitUntilDone:YES];
                                                   
//                                                   [imageUrlArray addObject:@"fail"];
                                               }];
        
        
        [proxy start];
    }
}

#pragma mark 发布问题

-(void)publishAction
{
    if (![CheckUtils isLink]) {
        
        [self textStateHUD:@"无网络连接"];
        return;
    }
    
    [self initStateHud];
    
    NSLog(@"----------发布问题-----图片地址数组---------%@",imageUrlArray);
    
    LMPublicArticleRequest *request  = [[LMPublicArticleRequest alloc] initWithArticlecontent:textView.text Article_title:titleTF.text Descrition:discribleTF.text andImageURL:imageUrlArray];
    
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(publishResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               [self textStateHUD:@"发布失败"];
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


-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [self resignCurrentFirstResponder];
    return YES;
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self scrollEditingRectToVisible:textField.frame EditingView:textField];
}




@end
