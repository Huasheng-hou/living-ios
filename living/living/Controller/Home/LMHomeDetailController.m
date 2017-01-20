//
//  LMHomeDetailController.m
//  living
//
//  Created by Ding on 16/9/27.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMHomeDetailController.h"
#import "LMHomeDetailRequest.h"
#import "LMArtclePariseRequest.h"
#import "LMCommentPraiseRequest.h"
#import "LMArticleBodyVO.h"
#import "LMActicleCommentVO.h"

#import "LMCommentCell.h"
#import "UIImageView+WebCache.h"
#import "UIView+frame.h"
#import "LMCommentArticleRequest.h"
#import "LMArtcleCommitRequest.h"

#import "SYPhotoBrowser.h"
#import "HBShareView.h"
#import "WXApi.h"
#import "FitThumbImageHelper.h"

#import <TencentOpenAPI/QQApiInterface.h>
#import "LMArticeDeleteRequest.h"
#import "LMArticleCommentDeleteRequest.h"
#import "LMArticeDeleteReplyRequst.h"
#import "LMWriterViewController.h"
#import "LMArtcleFootView.h"
#import "SQMenuShowView.h"
#import "BlendVO.h"
#import "LMContentTableViewCell.h"
#import "LMBlackWriterRequest.h"
#import "LMArtcleTypeViewController.h"


#define Text_size_color [UIColor colorWithRed:16/255.0 green:142/255.0 blue:233/255.0 alpha:1.0]

@interface LMHomeDetailController ()
<
UITableViewDelegate,
UITableViewDataSource,
UITextViewDelegate,
LMCommentCellDelegate,
shareTypeDelegate,
LMContentTableViewCellDelegate
>
{
    UIToolbar *toolBar;
    UITextView *textcView;
    CGFloat contentSize;
    NSInteger _rows;
    CGFloat bgViewY;
    UILabel  *tipLabel;
    UIButton *zanButton;
    LMCommentButton *zanLabel;
    LMArticleBodyVO *articleData;
    NSMutableArray *listArray;
    
    UIView *commentsView;
    UITextView *commentText;
    UIView *backView;
    NSString *commitUUid;
    
    NSInteger  textIndex;
    
    UIImageView *homeImage;
    
    NSMutableArray *imageArray;
    NSMutableArray *hightArray;
    NSDictionary *attributes;
    UILabel *contentLabel;
    NSDictionary *attributes2;
    UILabel *dspLabel;
    NSInteger typeIndex;
    NSString *fakeId;
    UIButton *bigBtn;
    UIButton *midBtn;
    UIButton *smallBtn;
    
    UIView *addView;
    UIView *blackView;
    
    LMArtcleFootView *footView;
    NSMutableArray *clickArr;
    
    NSMutableArray *newImageArray;
    BOOL  isBlend;
    NSString *uesruuid;
}

@property (strong, nonatomic)  SQMenuShowView *showView;
@property (assign, nonatomic)  BOOL  isShow;

@end

@implementation LMHomeDetailController

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [commentText resignFirstResponder];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"文章详情";
    [self creatUI];
    listArray = [NSMutableArray new];
    newImageArray = [NSMutableArray new];
    [self getHomeDetailDataRequest];
    [self registerForKeyboardNotifications];
    clickArr = [NSMutableArray new];
}

- (void)creatUI
{
    self.tableView  = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-45)
                                                   style:UITableViewStyleGrouped];
    
    self.tableView.delegate                 = self;
    self.tableView.dataSource               = self;
    self.tableView.keyboardDismissMode      = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.separatorStyle           = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.tableView];
    
    [self creatFootView];
    [self creatfootView2];
    hightArray = [NSMutableArray new];
    imageArray = [NSMutableArray new];
    
    NSArray *searchArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"typeArr"];
    if (searchArr.count&&searchArr.count>0) {
        for (NSString *str in searchArr) {
            if ([str isEqualToString:@"大"]) {
                typeIndex = 1;
            }
            if ([str isEqualToString:@"中"]) {
                typeIndex = 2;
            }
            if ([str isEqualToString:@"小"]) {
                typeIndex = 3;
            }
        }
    }else{
        typeIndex = 2;
    }
    
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"moreIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(reportAction)];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.navigationItem.hidesBackButton = YES;
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    self.tableView.userInteractionEnabled = YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.showView dismissView];
}



-(void)reportAction
{
    [self dismissSelf];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否屏蔽该作者"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"屏蔽"
                                              style:UIAlertActionStyleDestructive
                                            handler:^(UIAlertAction*action) {
                                                [self shieldWriter];
                                                
                                            }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)shieldWriter
{
    
    if ([[FitUserManager sharedUserManager] isLogin]) {
        LMBlackWriterRequest *request = [[LMBlackWriterRequest alloc] initWithAuthor_uuid:uesruuid];
        HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                               completed:^(NSString *resp, NSStringEncoding encoding) {
                                                   
                                                   [self performSelectorOnMainThread:@selector(getarticleshieldDataResponse:)
                                                                          withObject:resp
                                                                       waitUntilDone:YES];
                                               } failed:^(NSError *error) {
                                                   
                                                   [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                          withObject:@"网络错误"
                                                                       waitUntilDone:YES];
                                               }];
        [proxy start];
    }else{
        [self IsLoginIn];
    }
    
}

- (void)getarticleshieldDataResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    
    if ([[bodyDic objectForKey:@"result"] isEqual:@"0"])
    {
        [self textStateHUD:@"屏蔽作者成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadHomePage" object:nil];
        });
        
    }else{
        NSString *str = [bodyDic objectForKey:@"description"];
        [self textStateHUD:str];
    }
}


- (void)creatFootView
{
    toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, kScreenHeight-45, kScreenWidth, 45)];
    toolBar. barStyle = UIBarButtonItemStylePlain ;
    toolBar.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview :toolBar];
    
    textcView = [[UITextView alloc] initWithFrame:CGRectMake(15, 7.5, kScreenWidth-65, 30)];
    [textcView setDelegate:self];
    textcView.font = TEXT_FONT_LEVEL_2;
    textcView.layer.borderColor = [UIColor colorWithWhite:0.95 alpha:1].CGColor;
    textcView.layer.borderWidth = 1;
    
    textcView.backgroundColor = [UIColor whiteColor];
    textcView.layer.cornerRadius    = 4;
     
    textcView.keyboardType=UIKeyboardTypeDefault;
    [textcView setReturnKeyType:UIReturnKeySend];
    
    zanButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 50, 0, 50, 45)];
    zanButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [zanButton setTitle:@"发送" forState:UIControlStateNormal];
    [zanButton setTitleColor:TEXT_COLOR_LEVEL_3 forState:UIControlStateNormal];
    [zanButton addTarget:self action:@selector(getCommentArticleDataRequest) forControlEvents:UIControlEventTouchUpInside];
    zanButton.titleLabel.font = TEXT_FONT_LEVEL_3;
    
    [toolBar addSubview:zanButton];
    
    
    tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, kScreenWidth-60, 30)];
    tipLabel.text = @"说两句吧...";
    tipLabel.textColor =TEXT_COLOR_LEVEL_3;
    tipLabel.font = TEXT_FONT_LEVEL_3;
    [textcView addSubview:tipLabel];
    
    [toolBar addSubview:textcView];
    
}

- (void)creatfootView2
{
    footView = [[LMArtcleFootView alloc] initWithFrame:CGRectMake(0, kScreenHeight-50, kScreenWidth, 50)];
    footView.backgroundColor = [UIColor whiteColor];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0.5, kScreenWidth, 0.5)];
    lineView.backgroundColor = LINE_COLOR;
    [footView addSubview:lineView];
    
    [footView.backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    [footView.commentButton addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchUpInside];
    
    [footView.zanartcle addTarget:self action:@selector(zanButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [footView.shareartcle addTarget:self action:@selector(shareButton) forControlEvents:UIControlEventTouchUpInside];
    
    [footView.moreartcle addTarget:self action:@selector(creatMoreView) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:footView];
}

-(void)backAction
{
    [commentText resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)tapAction
{
    [self dismissSelf];
    [textcView becomeFirstResponder];
}

#pragma mark --文章点赞

- (void)zanButtonAction:(id)senser
{
    [self dismissSelf];
    
    if ([[FitUserManager sharedUserManager] isLogin]) {
        LMArtclePariseRequest *request = [[LMArtclePariseRequest alloc] initWithArticle_uuid:_artcleuuid];
        HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                               completed:^(NSString *resp, NSStringEncoding encoding) {
                                                   
                                                   [self performSelectorOnMainThread:@selector(getarticlePraiseDataResponse:)
                                                                          withObject:resp
                                                                       waitUntilDone:YES];
                                               } failed:^(NSError *error) {
                                                   
                                                   [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                          withObject:@"网络错误"
                                                                       waitUntilDone:YES];
                                               }];
        [proxy start];
    }else{
        [self IsLoginIn];
    }
    
}

- (void)getarticlePraiseDataResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    
    [self logoutAction:resp];
    
    if ([[bodyDic objectForKey:@"result"] isEqual:@"0"])
    {
        [self textStateHUD:@"点赞成功"];
        int zanNum =[zanLabel.titleLabel.text intValue];
        zanNum = zanNum+1;
        zanLabel.titleLabel.text = [NSString stringWithFormat:@"%d",zanNum];
        [self getHomeDetailDataRequest];
        [self.tableView reloadData];
    }else{
        NSString *str = [bodyDic objectForKey:@"description"];
        [self textStateHUD:str];
    }
}

#pragma mark  --请求详情数据
- (void)getHomeDetailDataRequest
{
    [self initStateHud];
    
    LMHomeDetailRequest *request = [[LMHomeDetailRequest alloc] initWithArticle_uuid:_artcleuuid];
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(getHomeDeatilDataResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"获取详情失败"
                                                                   waitUntilDone:YES];
                                           }];
    [proxy start];
}

- (void)getHomeDeatilDataResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    
    if ([[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
        
        [self hideStateHud];
        if (listArray.count>0) {
            [listArray removeAllObjects];
        }
 
        articleData = [[LMArticleBodyVO alloc] initWithDictionary:bodyDic[@"article_body"]];
        uesruuid = articleData.userUuid;
        if (articleData.hasPraised ==YES) {
            [footView.zanartcle setImage:[UIImage imageNamed:@"zan-red"] forState:UIControlStateNormal];
        }
        
        footView.comentcount.text = [NSString stringWithFormat:@"%d",articleData.commentNum];
        [footView.comentcount sizeToFit];
        footView.comentcount.frame = CGRectMake(footView.commentButton.imageView.frame.origin.x+footView.commentButton.imageView.frame.size.width/2+1, footView.commentButton.imageView.frame.origin.y-5, footView.comentcount.bounds.size.width, 10);
        footView.zanCount.text = [NSString stringWithFormat:@"%d",articleData.articlePraiseNum];
        [footView.zanCount sizeToFit];
        footView.zanCount.frame = CGRectMake(footView.zanartcle.imageView.frame.origin.x+footView.zanartcle.imageView.frame.size.width/2+6,footView.zanartcle.imageView.frame.origin.y-5, footView.zanCount.bounds.size.width, 10);
        if (articleData.commentNum&&articleData.commentNum!=0 ) {
            [footView.commentButton setImage:[UIImage imageNamed:@"comment-red"] forState:UIControlStateNormal];
        }else{
            [footView.commentButton setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
        }
        if ([articleData.userUuid isEqual:[FitUserManager sharedUserManager].uuid]) {
            
            UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"删除"
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(deleteActivityRequest:)];
            
            self.navigationItem.rightBarButtonItem = rightItem;
        }
        
        fakeId = [NSString stringWithFormat:@"%d",articleData.fakaid];
        
        NSMutableArray *array=bodyDic[@"comment_messages"];
        
        if (bodyDic[@"blend"]) {
            
            isBlend = YES;
            
            newImageArray   = [NSMutableArray arrayWithArray:[BlendVO BlendVOListWithArray:[bodyDic objectForKey:@"blend"]]];
        } else {
            
            isBlend = NO;
        }
   
        for (int i =0; i<array.count; i++) {
            
            LMActicleCommentVO *list = [[LMActicleCommentVO alloc] initWithDictionary:array[i]];
            [listArray addObject:list];
        }
        if (listArray.count>0) {
            
            [homeImage removeFromSuperview];
            homeImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
            self.tableView.tableFooterView = homeImage;
        }else{
            homeImage = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2-60, 0, 100, 160)];
            
            UIImageView *homeImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 70, 91)];
            homeImg.image = [UIImage imageNamed:@"NO-article"];
            [homeImage addSubview:homeImg];
            UILabel *imageLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 111, 100,30)];
            imageLb.text = @"没有评论";
            imageLb.textColor = TEXT_COLOR_LEVEL_3;
            imageLb.textAlignment = NSTextAlignmentCenter;
            [homeImage addSubview:imageLb];
            
            self.tableView.tableFooterView = homeImage;
        }
        
        [self.tableView reloadData];
    } else {
        
        NSString *str = [bodyDic objectForKey:@"description"];
        [self textStateHUD:str];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isBlend ==YES) {
        if (indexPath.section==2) {
            
            if (listArray.count > indexPath.row) {
                
                LMActicleCommentVO *list = listArray[indexPath.row];
                
                if (list && [list isKindOfClass:[LMActicleCommentVO class]]) {
                    
                    return [LMCommentCell cellHigth:list.commentContent];
                }
            }
        }
        contentLabel.text =articleData.articleContent;
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        if (contentLabel.text!=nil) {
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:contentLabel.text];
            
            [paragraphStyle setLineSpacing:7];
            [paragraphStyle setParagraphSpacing:10];
            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, contentLabel.text.length)];
            contentLabel.attributedText = attributedString;
        }
        
        if (typeIndex ==1) {
            
            attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16.0]};
            attributes2 = @{NSFontAttributeName:[UIFont systemFontOfSize:18.0],NSParagraphStyleAttributeName:paragraphStyle};
            
        }
        if (typeIndex ==2) {
            
            attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0]};
            attributes2 = @{NSFontAttributeName:[UIFont systemFontOfSize:16.0],NSParagraphStyleAttributeName:paragraphStyle};
        }
        if (typeIndex ==3) {
            
            attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12.0]};
            attributes2 = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0],NSParagraphStyleAttributeName:paragraphStyle};
        }
        
        if (indexPath.section==0) {
            
            
            NSDictionary *attributes5 = @{NSFontAttributeName:[UIFont systemFontOfSize:16.0]};
            
            NSString *string = [NSString stringWithFormat:@"#%@#%@",articleData.type,articleData.articleTitle];
            
            if (!articleData.type || ![articleData.type isKindOfClass:[NSString class]] || [articleData.type isEqualToString:@""]) {
                
                string  = articleData.articleTitle;
            }
            
            CGFloat conHigh = [string boundingRectWithSize:CGSizeMake(kScreenWidth-30, 100000)
                                                   options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                attributes:attributes5
                                                   context:nil].size.height;
            
            CGFloat conHigh2 = [articleData.describe boundingRectWithSize:CGSizeMake(kScreenWidth-30, 100000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size.height+5;
            
            return 65 + conHigh +conHigh2+10;
        }
        if (indexPath.section==1) {
            
            if (newImageArray&&newImageArray.count>0) {
                BlendVO *vo = newImageArray[indexPath.row];
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
                if (vo.content!=nil) {
                    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:vo.content];
                    
                    [paragraphStyle setLineSpacing:7];
                    [paragraphStyle setParagraphSpacing:10];
                    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, vo.content.length)];
                }
                
                if (typeIndex ==1) {
                    
                    attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16.0]};
                    attributes2 = @{NSFontAttributeName:[UIFont systemFontOfSize:18.0],NSParagraphStyleAttributeName:paragraphStyle};
                    
                }
                if (typeIndex ==2) {
                    
                    attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0]};
                    attributes2 = @{NSFontAttributeName:[UIFont systemFontOfSize:16.0],NSParagraphStyleAttributeName:paragraphStyle};
                }
                if (typeIndex ==3) {
                    
                    attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12.0]};
                    attributes2 = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0],NSParagraphStyleAttributeName:paragraphStyle};
                }
                
                CGFloat conHigh2 = [vo.content boundingRectWithSize:CGSizeMake(kScreenWidth-30, 100000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes2 context:nil].size.height+5;
                
                if (!vo.images) {
                    return 20+conHigh2;
                }else{
                    NSMutableArray *imageHArray = [NSMutableArray new];
                    NSArray *arr = vo.images;
                    for (int i = 0; i<arr.count; i++) {
                        
                        NSDictionary *dic = arr[i];
                        CGFloat imageVH = [dic[@"height"] floatValue];
                        CGFloat imageVW = [dic[@"width"] floatValue];
                        
                        CGFloat imageViewH = kScreenWidth*imageVH/imageVW;
                        NSString *string = [NSString stringWithFormat:@"%f",imageViewH+10];
                        [imageHArray addObject:string];
                    }
                    
                    NSInteger index =  arr.count-1;
                    
                    if (index<0) {
                        if (indexPath.row==newImageArray.count-1) {
                           return 20+conHigh2;
                        }else{
                            return 10+conHigh2;
                        }
                        
                        
                    }else{

                        NSNumber *sum = [imageHArray valueForKeyPath:@"@sum.floatValue"];
                        CGFloat hight = [sum floatValue];
                        if (indexPath.row==newImageArray.count-1) {
                            return 20+conHigh2 + hight;
                        }else{
                            return 10+conHigh2 + hight;
                        }
                       
                    }
                }
                
            }
            
            
        }
 
    }else{
        if (indexPath.section==1) {
            
            if (listArray.count > indexPath.row) {
                
                LMActicleCommentVO *list = listArray[indexPath.row];
                
                if (list && [list isKindOfClass:[LMActicleCommentVO class]]) {
                    
                    return [LMCommentCell cellHigth:list.commentContent];
                }
            }
        }
        
        if (indexPath.section==0) {
            contentLabel.text =articleData.articleContent;
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            if (contentLabel.text!=nil) {
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:contentLabel.text];
                
                [paragraphStyle setLineSpacing:7];
                [paragraphStyle setParagraphSpacing:10];
                [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, contentLabel.text.length)];
                contentLabel.attributedText = attributedString;
            }
            
            if (typeIndex ==1) {
                
                attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16.0]};
                attributes2 = @{NSFontAttributeName:[UIFont systemFontOfSize:18.0],NSParagraphStyleAttributeName:paragraphStyle};
                
            }
            if (typeIndex ==2) {
                
                attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0]};
                attributes2 = @{NSFontAttributeName:[UIFont systemFontOfSize:16.0],NSParagraphStyleAttributeName:paragraphStyle};
            }
            if (typeIndex ==3) {
                
                attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12.0]};
                attributes2 = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0],NSParagraphStyleAttributeName:paragraphStyle};
            }
            
            if (indexPath.row==0) {
                
                
                NSDictionary *attributes5 = @{NSFontAttributeName:[UIFont systemFontOfSize:16.0]};
                
                NSString *string = [NSString stringWithFormat:@"#%@#%@",articleData.type,articleData.articleTitle];
                
                if (!articleData.type || ![articleData.type isKindOfClass:[NSString class]] || [articleData.type isEqualToString:@""]) {
                    
                    string  = articleData.articleTitle;
                }
                
                CGFloat conHigh = [string boundingRectWithSize:CGSizeMake(kScreenWidth-30, 100000)
                                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                    attributes:attributes5
                                                       context:nil].size.height;
                
                CGFloat conHigh2 = [articleData.describe boundingRectWithSize:CGSizeMake(kScreenWidth-30, 100000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size.height;
                
                return 65 + conHigh +conHigh2+10;
            }
            }
            if (indexPath.row==1) {
                
                contentLabel.text =articleData.articleContent;
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
                if (contentLabel.text!=nil) {
                    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:contentLabel.text];
                    
                    [paragraphStyle setLineSpacing:7];
                    [paragraphStyle setParagraphSpacing:10];
                    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, contentLabel.text.length)];
                    contentLabel.attributedText = attributedString;
                }
                
                if (typeIndex ==1) {
                    
                    attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16.0]};
                    attributes2 = @{NSFontAttributeName:[UIFont systemFontOfSize:18.0],NSParagraphStyleAttributeName:paragraphStyle};
                    
                }
                if (typeIndex ==2) {
                    
                    attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0]};
                    attributes2 = @{NSFontAttributeName:[UIFont systemFontOfSize:16.0],NSParagraphStyleAttributeName:paragraphStyle};
                }
                if (typeIndex ==3) {
                    
                    attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12.0]};
                    attributes2 = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0],NSParagraphStyleAttributeName:paragraphStyle};
                }
                
                CGFloat conHigh2 = [contentLabel.text boundingRectWithSize:CGSizeMake(kScreenWidth-30, 100000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes2 context:nil].size.height+10;
                
                if (!articleData.articleImgs) {
                    return 20+conHigh2;
                }else{
                    
                    NSMutableArray *newHight = [NSMutableArray new];
                    NSArray *arr = articleData.articleImgs;
                    for (int i = 0; i<arr.count; i++) {
                        
                        NSDictionary *dic = arr[i];
                        CGFloat imageVH = [dic[@"height"] floatValue];
                        CGFloat imageVW = [dic[@"width"] floatValue];
                        
                        CGFloat imageViewH = kScreenWidth*imageVH/imageVW;
                        NSString *string = [NSString stringWithFormat:@"%f",imageViewH+10];
                        
                        [newHight addObject:string];
                        
                    }
                    NSInteger index =  arr.count-1;
                    
                    if (index<0) {
                        return 20+conHigh2;
                    }else{
                        
                        NSNumber *sum = [newHight valueForKeyPath:@"@sum.floatValue"];
                        CGFloat hight = [sum floatValue];
                        return 20+conHigh2 +10 + hight;
                    }

                }
                
            }
        }
    
    
        return 0;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSInteger index;
    if (isBlend ==YES) {
        index = 2;
    }
    else{
        index = 1;
    }
    
    if (section==index) {
        
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        
        UIView *commentView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, kScreenWidth, 35)];
        commentView.backgroundColor = [UIColor whiteColor];
        [headView addSubview:commentView];
        
        UILabel *commentLabel = [UILabel new];
        commentLabel.font = [UIFont systemFontOfSize:13.f];
        commentLabel.textColor = LIVING_COLOR;
        commentLabel.text = @"评论列表";
        [commentLabel sizeToFit];
        commentLabel.frame = CGRectMake(15, 10, commentLabel.bounds.size.width, commentLabel.bounds.size.height);
        [commentView addSubview:commentLabel];
        
        
        UIView *line = [UIView new];
        line.backgroundColor =LIVING_COLOR;
        [line sizeToFit];
        line.frame =CGRectMake(0, 10+1, 3.f, commentLabel.bounds.size.height-2);
        [commentView addSubview:line];
        
        headView.backgroundColor = [UIColor clearColor];
        return headView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (isBlend ==YES) {
        if (section==2) {
            return 40;
        }
    }else{
        if (section==1) {
            return 40;
        }
    }

    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (isBlend ==YES) {
        return 3;
    }else{
       return 2;
    }
    
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isBlend==YES) {
        if (section==0) {
            return 1;
        }
        if (section==1) {
            return newImageArray.count;
        }
        if (section==2) {
            
            return listArray.count;
            
        }
    }else{
        if (section==0) {
            return 2;
        }
        if (section==1) {
            return listArray.count;
        }
    }
    

    return 7;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (typeIndex==1) {
        dspLabel.font = TEXT_FONT_LEVEL_1;
        attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16.0]};
    }
    if (typeIndex==2) {
        dspLabel.font = TEXT_FONT_LEVEL_2;
        attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0]};
    }
    if (typeIndex==3) {
        dspLabel.font = [UIFont systemFontOfSize:12.0];
        attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12.0]};
    }
    
    if (isBlend==NO) {
        if (indexPath.section==0) {
            
            static NSString *cellId = @"cellId";
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (indexPath.row==0) {
                UILabel *titleLabel = [UILabel new];
                titleLabel.font = TEXT_FONT_LEVEL_1;
                titleLabel.numberOfLines=0;
                if (articleData.type&&![articleData.type isEqual:@""]) {
                    
                    titleLabel.text = [NSString stringWithFormat:@"#%@#%@",articleData.type,articleData.articleTitle];
                    
                    NSInteger lenth = articleData.type.length;
                    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:titleLabel.text];
                    [str addAttribute:NSForegroundColorAttributeName value:LIVING_COLOR range:NSMakeRange(0,lenth+2)];
                    titleLabel.attributedText = str;
                    titleLabel.userInteractionEnabled = YES;
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleClick)];
                    [titleLabel addGestureRecognizer:tap];
                    
                }else{
                    titleLabel.text = articleData.articleTitle;
                }
                NSDictionary *attributes4 = @{NSFontAttributeName:[UIFont systemFontOfSize:16.0]};
                CGFloat conHigh = [titleLabel.text boundingRectWithSize:CGSizeMake(kScreenWidth-30, 100000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes4 context:nil].size.height;
                [titleLabel sizeToFit];
                titleLabel.frame = CGRectMake(15, 15, kScreenWidth-30, conHigh);
                [cell.contentView addSubview:titleLabel];
                
                UIImageView *headImage = [UIImageView new];
                [headImage sd_setImageWithURL:[NSURL URLWithString:articleData.avatar] placeholderImage:[UIImage imageNamed:@"headIcon"]];
                headImage.frame = CGRectMake(15, conHigh+25, 20, 20);
                headImage.layer.cornerRadius =10;
                [headImage setClipsToBounds:YES];
                headImage.contentMode = UIViewContentModeScaleToFill;
                [cell.contentView addSubview:headImage];
                headImage.userInteractionEnabled = YES;
                UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(WriterVC)];
                [headImage addGestureRecognizer:tapImage];
                
                
                UILabel *nameLabel = [UILabel new];
                nameLabel.font = TEXT_FONT_LEVEL_3;
                nameLabel.textColor = LIVING_COLOR;
                if (!articleData.articleName||articleData.articleName ==nil) {
                    nameLabel.text = @"匿名用户";
                }else{
                    nameLabel.text = articleData.articleName;
                }
                
                [nameLabel sizeToFit];
                nameLabel.frame = CGRectMake(40, conHigh+25, nameLabel.bounds.size.width,20);
                [cell.contentView addSubview:nameLabel];
                nameLabel.userInteractionEnabled = YES;
                
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(WriterVC)];
                [nameLabel addGestureRecognizer:tap];
                
                UILabel *timeLabel = [UILabel new];
                timeLabel.font = TEXT_FONT_LEVEL_3;
                timeLabel.textColor = TEXT_COLOR_LEVEL_3;
                
                NSDateFormatter *formatter  = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
                timeLabel.text = [formatter stringFromDate:articleData.publishTime];;
                [timeLabel sizeToFit];
                timeLabel.frame = CGRectMake(kScreenWidth-timeLabel.bounds.size.width-15, conHigh+25, timeLabel.bounds.size.width,20);
                [cell.contentView addSubview:timeLabel];
                
                UIView *line = [UIView new];
                line.backgroundColor =LINE_COLOR;
                [line sizeToFit];
                line.frame = CGRectMake(15, conHigh+60, kScreenWidth-30, 0.5);
                [cell.contentView addSubview:line];
                
                dspLabel = [UILabel new];
                dspLabel.textColor      = LIVING_COLOR;
                dspLabel.numberOfLines  =0;
                dspLabel.text           = articleData.describe;
                
                CGFloat conHigh2 = [dspLabel.text boundingRectWithSize:CGSizeMake(kScreenWidth-30, 100000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size.height;
                
                dspLabel.frame = CGRectMake(15, conHigh + 72, kScreenWidth - 30, conHigh2);

                if (typeIndex == 1) {
                    
                    dspLabel.font = TEXT_FONT_LEVEL_1;
                }
                if (typeIndex == 2) {
                    
                    dspLabel.font = TEXT_FONT_LEVEL_2;
                }
                if (typeIndex == 3) {
                    
                    dspLabel.font = [UIFont systemFontOfSize:12.0];
                }
                
                [cell.contentView addSubview:dspLabel];
                
            }
            if (indexPath.row==1) {
                contentLabel = [UILabel new];
                contentLabel.textColor = TEXT_COLOR_LEVEL_2;
                contentLabel.numberOfLines=0;
                contentLabel.text = articleData.articleContent;
                
                contentLabel.text = [articleData.articleContent stringByReplacingOccurrencesOfString:@"\\" withString:@""];
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
                if (contentLabel.text!=nil) {
                    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:contentLabel.text];
                    
                    [paragraphStyle setLineSpacing:7];
                    [paragraphStyle setParagraphSpacing:10];
                    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, contentLabel.text.length)];
                    contentLabel.attributedText = attributedString;
                }
                if (typeIndex==1) {
                    contentLabel.font = [UIFont systemFontOfSize:18.0];
                    attributes2 = @{NSFontAttributeName:[UIFont systemFontOfSize:18.0],NSParagraphStyleAttributeName:paragraphStyle};
                    [bigBtn setTitleColor:LIVING_COLOR forState:UIControlStateNormal];
                    [midBtn setTitleColor:TEXT_COLOR_LEVEL_3 forState:UIControlStateNormal];
                    [smallBtn setTitleColor:TEXT_COLOR_LEVEL_3 forState:UIControlStateNormal];
                }
                if (typeIndex==2) {
                    contentLabel.font = TEXT_FONT_LEVEL_1;
                    attributes2 = @{NSFontAttributeName:[UIFont systemFontOfSize:16.0],NSParagraphStyleAttributeName:paragraphStyle};
                    [midBtn setTitleColor:LIVING_COLOR forState:UIControlStateNormal];
                    [bigBtn setTitleColor:TEXT_COLOR_LEVEL_3 forState:UIControlStateNormal];
                    [smallBtn setTitleColor:TEXT_COLOR_LEVEL_3 forState:UIControlStateNormal];
                }
                if (typeIndex==3) {
                    contentLabel.font = [UIFont systemFontOfSize:14.0];
                    attributes2 = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0],NSParagraphStyleAttributeName:paragraphStyle};
                    [smallBtn setTitleColor:LIVING_COLOR forState:UIControlStateNormal];
                    [midBtn setTitleColor:TEXT_COLOR_LEVEL_3 forState:UIControlStateNormal];
                    [bigBtn setTitleColor:TEXT_COLOR_LEVEL_3 forState:UIControlStateNormal];
                }
                
                CGFloat conHighs = [contentLabel.text boundingRectWithSize:CGSizeMake(kScreenWidth-30, 100000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes2 context:nil].size.height+15;
                [contentLabel sizeToFit];
                
                [cell.contentView addSubview:contentLabel];
                
                
                if (articleData.articleImgs) {
                    
                    NSArray *arr =articleData.articleImgs;
                    hightArray = [NSMutableArray new];
                    
                    imageArray = [NSMutableArray new];
                    for (int i = 0; i<arr.count; i++) {
                        
                        NSDictionary *dic = arr[i];
                        
                        CGFloat imageVH = [dic[@"height"] floatValue];
                        CGFloat imageVW = [dic[@"width"] floatValue];
                        CGFloat imageViewH = kScreenWidth*imageVH/imageVW;
                        
                        [imageArray addObject:[dic objectForKey:@"url"]];
                        UIImageView *headImage = [UIImageView new];
                        [headImage sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"url"]] placeholderImage:[UIImage imageNamed:@"BackImage"]];
                        headImage.backgroundColor = BG_GRAY_COLOR;
                        
                        headImage.contentMode = UIViewContentModeScaleAspectFill;
                        [headImage setClipsToBounds:YES];
                        
                        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapimageAction:)];
                        headImage.tag = i;
                        [headImage addGestureRecognizer:tap];
                        headImage.userInteractionEnabled = YES;
                        if (i>0) {
                            headImage.frame = CGRectMake(15, 10 + [hightArray[i-1] floatValue], kScreenWidth-30, imageViewH);
                        }else{
                            headImage.frame = CGRectMake(15, 10, kScreenWidth-30, imageViewH);
                        }
                        
                        NSString *string = [NSString stringWithFormat:@"%f",imageViewH+headImage.origin.y];
                        
                        [hightArray addObject:string];
                        
                        [cell.contentView addSubview:headImage];
                        
                    }
                    contentLabel.frame = CGRectMake(15, 10+[hightArray[arr.count-1] floatValue], kScreenWidth-30, conHighs);
                    
                }else{
                    contentLabel.frame = CGRectMake(15, 10 , kScreenWidth-30, conHighs);
                }
                    
                
                
            }
            
            return cell;
            
        }
        if (indexPath.section==1) {
            static NSString *cellId = @"cellId";
            LMCommentCell *cell = [[LMCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            LMActicleCommentVO *list = listArray[indexPath.row];
            [cell setValue:list];
            cell.delegate = self;
            [cell setXScale:self.xScale yScale:self.yScaleNoTab];
            
            UILongPressGestureRecognizer *tap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(deletCellAction:)];
            
            tap.minimumPressDuration = 1.0;
            cell.contentView.tag = indexPath.row;
            [cell.contentView addGestureRecognizer:tap];
            
            
            return cell;
        }
    }else{
    if (indexPath.section==0) {
        
        static NSString *cellId = @"cellId";
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *titleLabel = [UILabel new];
        titleLabel.font = TEXT_FONT_LEVEL_1;
        titleLabel.numberOfLines=0;
        if (articleData.type&&![articleData.type isEqual:@""]) {
            
            titleLabel.text = [NSString stringWithFormat:@"#%@#%@",articleData.type,articleData.articleTitle];
            
            NSInteger lenth = articleData.type.length;
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:titleLabel.text];
            [str addAttribute:NSForegroundColorAttributeName value:LIVING_COLOR range:NSMakeRange(0,lenth+2)];
            titleLabel.attributedText = str;
            
            titleLabel.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleClick)];
            [titleLabel addGestureRecognizer:tap];
            
        }else{
            titleLabel.text = articleData.articleTitle;
        }
        
        NSDictionary *attributes4 = @{NSFontAttributeName:[UIFont systemFontOfSize:16.0]};
        CGFloat conHigh = [titleLabel.text boundingRectWithSize:CGSizeMake(kScreenWidth-30, 100000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes4 context:nil].size.height;
        [titleLabel sizeToFit];
        titleLabel.frame = CGRectMake(15, 15, kScreenWidth-30, conHigh);
        [cell.contentView addSubview:titleLabel];
        
        UIImageView *headImage = [UIImageView new];
        [headImage sd_setImageWithURL:[NSURL URLWithString:articleData.avatar] placeholderImage:[UIImage imageNamed:@"headIcon"]];
        headImage.frame = CGRectMake(15, conHigh+25, 20, 20);
        headImage.layer.cornerRadius =10;
        [headImage setClipsToBounds:YES];
        headImage.contentMode = UIViewContentModeScaleToFill;
        [cell.contentView addSubview:headImage];
        headImage.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(WriterVC)];
        [headImage addGestureRecognizer:tapImage];
        
        
        UILabel *nameLabel = [UILabel new];
        nameLabel.font = TEXT_FONT_LEVEL_3;
        nameLabel.textColor = LIVING_COLOR;
        if (!articleData.articleName||articleData.articleName ==nil) {
            nameLabel.text = @"匿名用户";
        }else{
            nameLabel.text = articleData.articleName;
        }
        
        [nameLabel sizeToFit];
        nameLabel.frame = CGRectMake(40, conHigh+25, nameLabel.bounds.size.width,20);
        [cell.contentView addSubview:nameLabel];
        nameLabel.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(WriterVC)];
        [nameLabel addGestureRecognizer:tap];
        
        UILabel *timeLabel = [UILabel new];
        timeLabel.font = TEXT_FONT_LEVEL_3;
        timeLabel.textColor = TEXT_COLOR_LEVEL_3;
        
        NSDateFormatter *formatter  = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        timeLabel.text = [formatter stringFromDate:articleData.publishTime];;
        [timeLabel sizeToFit];
        timeLabel.frame = CGRectMake(kScreenWidth-timeLabel.bounds.size.width-15, conHigh+25, timeLabel.bounds.size.width,20);
        [cell.contentView addSubview:timeLabel];
        
        UIView *line = [UIView new];
        line.backgroundColor =LINE_COLOR;
        [line sizeToFit];
        line.frame = CGRectMake(15, conHigh+60, kScreenWidth-30, 0.5);
        [cell.contentView addSubview:line];
        

        dspLabel = [UILabel new];
        dspLabel.textColor = LIVING_COLOR;
        dspLabel.numberOfLines=0;
        dspLabel.text = articleData.describe;

        CGFloat conHigh2 = [dspLabel.text boundingRectWithSize:CGSizeMake(kScreenWidth-30, 100000)
                                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                    attributes:attributes
                                                       context:nil].size.height;
        
        dspLabel.frame = CGRectMake(15, conHigh + 72, kScreenWidth-30, conHigh2);
        
        if (typeIndex == 1) {
            
            dspLabel.font = TEXT_FONT_LEVEL_1;
        }
        if (typeIndex == 2) {
            
            dspLabel.font = TEXT_FONT_LEVEL_2;
        }
        if (typeIndex == 3) {
            
            dspLabel.font = [UIFont systemFontOfSize:12.0];
        }
        
        [cell.contentView addSubview:dspLabel];
        
        return cell;
    }
    if (indexPath.section==1) {
        
        static NSString *cellId = @"cellId";
        LMContentTableViewCell *cell = [[LMContentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.typeIndex = typeIndex;
        BlendVO *list = newImageArray[indexPath.row];
        cell.delegate = self;
        cell.tag = indexPath.row;
        [cell setValue:list];

        return cell;
        
    }
    if (indexPath.section==2) {
        static NSString *cellId = @"cellId";
        LMCommentCell *cell = [[LMCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (listArray&&listArray.count>0) {
            LMActicleCommentVO *list = listArray[indexPath.row];
            [cell setValue:list];
            cell.delegate = self;
            [cell setXScale:self.xScale yScale:self.yScaleNoTab];
        }

        
        UILongPressGestureRecognizer *tap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(deletCellAction:)];
        
        tap.minimumPressDuration = 1.0;
        cell.contentView.tag = indexPath.row;
        [cell.contentView addGestureRecognizer:tap];
        
        
        return cell;
    }
    
    
    }
    return nil;
    
}

#pragma mark 分享按钮

-(void)shareButton
{
    [self dismissSelf];
    
    HBShareView *shareView=[[HBShareView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    shareView.delegate=self;
    [self.view addSubview:shareView];
}
-(void)bigBtnButton
{
    typeIndex = 1;
    
    [bigBtn setTitleColor:LIVING_COLOR forState:UIControlStateNormal];
    [midBtn setTitleColor:TEXT_COLOR_LEVEL_3 forState:UIControlStateNormal];
    [smallBtn setTitleColor:TEXT_COLOR_LEVEL_3 forState:UIControlStateNormal];
    
    [self.tableView reloadData];
    
    NSMutableArray *mutArr = [[NSMutableArray alloc]initWithObjects:@"大", nil];
    
    //存入数组并同步
    
    [[NSUserDefaults standardUserDefaults] setObject:mutArr forKey:@"typeArr"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

-(void)midBtnButton
{
    typeIndex = 2;
    

    [self.tableView reloadData];
    [midBtn setTitleColor:LIVING_COLOR forState:UIControlStateNormal];
    [bigBtn setTitleColor:TEXT_COLOR_LEVEL_3 forState:UIControlStateNormal];
    [smallBtn setTitleColor:TEXT_COLOR_LEVEL_3 forState:UIControlStateNormal];
    
    NSMutableArray *mutArr = [[NSMutableArray alloc]initWithObjects:@"中", nil];
    
    //存入数组并同步
    
    [[NSUserDefaults standardUserDefaults] setObject:mutArr forKey:@"typeArr"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)smallBtnButton
{
    typeIndex = 3;
    
    [self.tableView reloadData];
    [smallBtn setTitleColor:LIVING_COLOR forState:UIControlStateNormal];
    [midBtn setTitleColor:TEXT_COLOR_LEVEL_3 forState:UIControlStateNormal];
    [bigBtn setTitleColor:TEXT_COLOR_LEVEL_3 forState:UIControlStateNormal];
    
    NSMutableArray *mutArr = [[NSMutableArray alloc]initWithObjects:@"小", nil];
    
    //存入数组并同步
    
    [[NSUserDefaults standardUserDefaults] setObject:mutArr forKey:@"typeArr"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark 对图片尺寸进行压缩
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)shareType:(NSInteger)type
{
    NSString *urlString = @"http://yaoguo1818.com/living-web/apparticle/article?fakeId=";
    
    switch (type) {
        case 1://微信好友
        {
            WXMediaMessage *message=[WXMediaMessage message];
            message.title=articleData.articleTitle;
            message.description=articleData.describe;
            
            if (imageArray.count==0) {
                [message setThumbImage:[UIImage imageNamed:@"editMsg"]];
            }else{
                
                UIImageView *images = [UIImageView new];
                [images sd_setImageWithURL:[NSURL URLWithString:imageArray[0]]];
                
                UIImage *iconImage=[self imageWithImage:images.image scaledToSize:CGSizeMake(kScreenWidth/3, kScreenWidth/3)];
                
                [message setThumbImage:iconImage];
            }
            
            WXWebpageObject *web=[WXWebpageObject object];
            web.webpageUrl=[NSString stringWithFormat:@"%@%@",urlString,fakeId];
            message.mediaObject=web;
            
            SendMessageToWXReq *req=[[SendMessageToWXReq alloc]init];
            req.bText=NO;
            req.message=message;
            req.scene=WXSceneSession;//好友
            [WXApi sendReq:req];
        }
            break;
        case 2://微信朋友圈
        {
            WXMediaMessage *message=[WXMediaMessage message];
            message.title=articleData.articleTitle;
            message.description=articleData.describe;
            
            
            if (imageArray.count==0) {
                [message setThumbImage:[UIImage imageNamed:@"editMsg"]];
            }else{
                
                UIImageView *images = [UIImageView new];
                [images sd_setImageWithURL:[NSURL URLWithString:imageArray[0]]];
                
                UIImage *iconImage=[self imageWithImage:images.image scaledToSize:CGSizeMake(kScreenWidth/3, kScreenWidth/3)];
                [message setThumbImage:iconImage];
            }
            
            WXWebpageObject *web=[WXWebpageObject object];
            web.webpageUrl=[NSString stringWithFormat:@"%@%@",urlString,fakeId];
            message.mediaObject=web;
            
            SendMessageToWXReq *req=[[SendMessageToWXReq alloc]init];
            req.bText=NO;
            req.message=message;
            req.scene=WXSceneTimeline;//朋友圈
            [WXApi sendReq:req];
        }
            break;
        case 3://qq好友
        {
            NSString *imageUrl;
            
            if (imageArray.count==0) {
                
                imageUrl=@"http://living-2016.oss-cn-hangzhou.aliyuncs.com/1eac8bd3b16fd9bb1a3323f43b336bd7.jpg";
            } else {
                
                imageUrl=imageArray[0];
            }
            
            QQApiNewsObject *txtObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",urlString,fakeId]] title:articleData.articleTitle description:articleData.describe previewImageURL:[NSURL URLWithString:imageUrl]];
            SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:txtObj];
            //将内容分享到qq
            [QQApiInterface sendReq:req];
        }
            break;
        case 4://qq空间
        {
            NSString *imageUrl;
            if (imageArray.count==0) {
                imageUrl=@"http://living-2016.oss-cn-hangzhou.aliyuncs.com/1eac8bd3b16fd9bb1a3323f43b336bd7.jpg";
            }else{
                imageUrl=imageArray[0];
            }
            
            QQApiNewsObject *txtObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",urlString,fakeId]] title:articleData.articleTitle description:articleData.describe previewImageURL:[NSURL URLWithString:imageUrl]];
            SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:txtObj];
            //将内容分享到qq空间
            [QQApiInterface SendReqToQZone:req];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark  --点击图片放大
- (void)tapimageAction:(UITapGestureRecognizer *)tap
{
    SYPhotoBrowser *photoBrowser = [[SYPhotoBrowser alloc] initWithImageSourceArray:imageArray delegate:self];
    
    photoBrowser.initialPageIndex = tap.view.tag;
    [self presentViewController:photoBrowser animated:YES completion:nil];
}

#pragma mark  --点击图片放大
- (void)clickViewTag:(NSInteger)viewTag andSubViewTag:(NSInteger)tag
{
    NSMutableArray *new = [NSMutableArray new];
    for (BlendVO *vo in newImageArray) {
        NSArray *imgArray;
        imgArray = vo.images;
        for (NSDictionary *dic in imgArray) {
            NSString *string = dic[@"url"];
            [new addObject:string];
        }
        NSLog(@"%@",new);
    }
    NSLog(@"********%@",new);
    NSMutableArray *countArray = [NSMutableArray new];
    if (viewTag>0) {
        for (int i = 0; i<viewTag; i++) {
            BlendVO *vo = newImageArray[i];
            NSArray *imgArray = vo.images;
            for (NSDictionary *dic in imgArray) {
                NSString *string = dic[@"url"];
                [countArray addObject:string];
            }
        }
    }
    
    SYPhotoBrowser *photoBrowser = [[SYPhotoBrowser alloc] initWithImageSourceArray:new delegate:self];
    if (viewTag>0) {
       photoBrowser.initialPageIndex = tag+countArray.count;
    }else{
        photoBrowser.initialPageIndex = tag;
    }
    
    [self presentViewController:photoBrowser animated:YES completion:nil];
}

#pragma mark - LMCommentCell delegate -评论点赞
- (void)cellWillComment:(LMCommentCell *)cell
{
    
    if ([[FitUserManager sharedUserManager] isLogin]){
        LMCommentPraiseRequest *request = [[LMCommentPraiseRequest alloc] initWithArticle_uuid:_artcleuuid CommentUUid:cell.commentUUid];
        HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                               completed:^(NSString *resp, NSStringEncoding encoding) {
                                                   
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       NSDictionary *bodyDic = [VOUtil parseBody:resp];
                                                       [self logoutAction:resp];
                                                       if (!bodyDic) {
                                                           [self textStateHUD:@"点赞失败"];
                                                       }else{
                                                           
                                                           
                                                           if ([[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
                                                               [self textStateHUD:@"点赞成功"];
                                                               [self getHomeDetailDataRequest];
                                                               
                                                               
                                                           }else{
                                                               NSString *str = [bodyDic objectForKey:@"description"];
                                                               [self textStateHUD:str];
                                                           }
                                                       }
                                                   });
                                                   
                                               } failed:^(NSError *error) {
                                                   
                                                   [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                          withObject:@"点赞失败"
                                                                       waitUntilDone:YES];
                                               }];
        [proxy start];
        
    }else{
        [self IsLoginIn];
    }
    
    
    
}

- (void)getPraisecellDataResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    [self logoutAction:resp];
    if (!bodyDic) {
        [self textStateHUD:@"点赞失败"];
        return;
    }
    if ([[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
        [self textStateHUD:@"点赞成功"];
        [self getHomeDetailDataRequest];
        
    }else{
        NSString *str = [bodyDic objectForKey:@"description"];
        [self textStateHUD:str];
    }
}

//回复
- (void)cellWillReply:(LMCommentCell *)cell
{
    if ([[FitUserManager sharedUserManager] isLogin]){

        textIndex = 1;
        commitUUid =cell.commentUUid;

        self.tableView.userInteractionEnabled = NO;
        [self showCommentText];

    } else {
        
        [self IsLoginIn];
    }
}

- (void)showCommentText
{
    [self createCommentsView];
    [commentText becomeFirstResponder];//再次让textView成为第一响应者（第二次）这次键盘才成功显示
}

- (void)createCommentsView
{
    if (!commentsView) {
        commentsView = [[UIView alloc] initWithFrame:CGRectMake(0.0, kScreenHeight - 180 - 200.0, kScreenWidth, 200.0)];
        commentsView.layer.borderColor = LINE_COLOR.CGColor;
        commentsView.layer.borderWidth= 0.5;
        commentsView.backgroundColor = BG_GRAY_COLOR;
        commentText = [[UITextView alloc] initWithFrame:CGRectInset(commentsView.bounds, 5.0, 40.0)];
        commentText.layer.borderWidth   = 0.5;
        commentText.layer.borderColor   = LINE_COLOR.CGColor;
        commentText.layer.cornerRadius  = 5.0;
        commentText.layer.masksToBounds = YES;
        commentText.inputAccessoryView  = commentsView;
        commentText.backgroundColor     = [UIColor whiteColor];
        commentText.returnKeyType       = UIReturnKeySend;
        commentText.delegate	        = self;
        commentText.font		        = [UIFont systemFontOfSize:15.0];
        
        UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        sureButton.frame = CGRectMake(kScreenWidth - 80, 160-70, 62, 24);
        sureButton.layer.cornerRadius   = 4;
        sureButton.layer.borderWidth    = .5;
        sureButton.layer.borderColor    = LIVING_COLOR.CGColor;
        
        [sureButton setTitle:@"确认" forState:UIControlStateNormal];
        [sureButton setTitleColor:LIVING_COLOR forState:UIControlStateNormal];
        
        sureButton.tintColor = [UIColor whiteColor];
        [sureButton addTarget:self action:@selector(sendComment) forControlEvents:UIControlEventTouchUpInside];
        [commentText addSubview:sureButton];
        
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        closeButton.frame = CGRectMake(kScreenWidth-38, 9, 22, 22);
        closeButton.layer.cornerRadius = 5;
        
        [closeButton setImage:[ImageHelpTool imageWithColor:LIVING_COLOR andImage:[UIImage imageNamed:@"close"]]
                     forState:UIControlStateNormal];
        
        closeButton.tintColor = LIVING_COLOR;
        [closeButton addTarget:self action:@selector(closeComment) forControlEvents:UIControlEventTouchUpInside];
        [commentsView addSubview:closeButton];
        
        
        
        [commentsView addSubview:commentText];
    }
    [self.view.window addSubview:commentsView];//添加到window上或者其他视图也行，只要在视图以外就好了
    [commentText becomeFirstResponder];//让textView成为第一响应者（第一次）这次键盘并未显示出来
}

- (void)sendComment
{
    if ([commentText.text isEqualToString:@""]) {
        [self textStateHUD:@"回复内容不能为空"];
        return;
    }
    [self commitDataRequest];
    [commentText resignFirstResponder];
    self.tableView.userInteractionEnabled = YES;
}

-(void)commitDataRequest
{
    NSString *string    = [commentText.text stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    LMArtcleCommitRequest *request = [[LMArtcleCommitRequest alloc] initWithArticle_uuid:_artcleuuid CommentUUid:commitUUid Reply_content:string];
    
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(getEventcommitResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"回复失败"
                                                                   waitUntilDone:YES];
                                           }];
    [proxy start];
}

- (void)getEventcommitResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    [self logoutAction:resp];
    
    if (!bodyDic) {
        
        [self textStateHUD:@"回复失败"];
    }
    if ([[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
        
        [self textStateHUD:@"回复成功"];
        
        commentText.text    = @"";
        [self getHomeDetailDataRequest];
        
    } else {
        
        NSString *str = [bodyDic objectForKey:@"description"];
        [self textStateHUD:str];
    }
}

#pragma mark 键盘部分

- (void) registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self
                                              selector:@selector(keyboardWasHidden:)
                                                  name:UIKeyboardWillHideNotification
                                                object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardChangeFrame:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
}

- (void)keyboardChangeFrame:(NSNotification *)notifi
{
    CGRect keyboardFrame = [notifi.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    float duration = [notifi.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    if (textIndex!=1) {
        [UIView animateWithDuration:duration animations:^{
            toolBar.transform = CGAffineTransformMakeTranslation(0, keyboardFrame.origin.y - kScreenHeight);
            bgViewY = toolBar.frame.origin.y;
            
        }];
    }
}

- (void) keyboardWasShown:(NSNotification *) notif
{
    CGFloat curkeyBoardHeight = [[[notif userInfo] objectForKey:@"UIKeyboardBoundsUserInfoKey"] CGRectValue].size.height;
    CGRect begin = [[[notif userInfo] objectForKey:@"UIKeyboardFrameBeginUserInfoKey"] CGRectValue];
    CGRect end = [[[notif userInfo] objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    // 第三方键盘回调三次问题，监听仅执行最后一次
    if (textIndex!=1) {
        if(begin.size.height>0 && (begin.origin.y-end.origin.y>0)){
            [UIView animateWithDuration:0.1f animations:^{
                [toolBar setFrame:CGRectMake(0, kScreenHeight-(curkeyBoardHeight+toolBar.height+contentSize), kScreenWidth, toolBar.height+contentSize)];
                
            }];
        }
    }
}

- (void) keyboardWasHidden:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    NSLog(@"keyboardWasHidden keyBoard:%f", keyboardSize.height);
    if (textIndex!=1) {
        [UIView animateWithDuration:0.1f animations:^{
            [toolBar setFrame:CGRectMake(0, kScreenHeight-45, kScreenWidth, 45)];
            NSLog(@"***keyboardWasHidden*%@",toolBar);
        }];
    }
    
}

#pragma mark UITextFieldDelegate

//获取textView高度

- (void)textViewDidChange:(UITextView *)textView{
    
    if ([textView isEqual:textcView]) {
        if (textView.text.length==0) {
            tipLabel.hidden=NO;
        }else{
            tipLabel.hidden=YES;
        }
        
        // numberlines用来控制输入的行数
        NSInteger numberLines = textView.contentSize.height / textView.font.lineHeight;
        if (numberLines != _rows) {
            NSLog(@"text = %@", textcView.text);
            _rows = numberLines;
            if  (_rows < 5){
                [self changeFrame:textView.contentSize.height];
            }else{
                textcView.scrollEnabled = YES;
            }
            
            [textView setContentOffset:CGPointZero animated:YES];
        }
    }
}

- (void)changeFrame:(CGFloat)height
{
    CGRect originalFrame = toolBar.frame;
    originalFrame.size.height = 30 + height ;
    originalFrame.origin.y = bgViewY - height + 30;
    CGRect textViewFrame = textcView.frame;
    textViewFrame.size.height = height;
    
    [UIView animateWithDuration:0.3 animations:^{
        toolBar.frame = originalFrame;
        textcView.frame = textViewFrame;
        contentSize = height-30;
    }];
}

//修改textView return键

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        if ([textView isEqual:textcView]) {
            [textcView resignFirstResponder];
            [self getCommentArticleDataRequest];
        }
        if ([textView isEqual:commentText]) {
            self.tableView.userInteractionEnabled = YES;
            [commentText resignFirstResponder];
            [self sendComment];
        }
        
        
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}

#pragma mark  --评论文章
- (void)getCommentArticleDataRequest
{
    if ([[FitUserManager sharedUserManager] isLogin]){
  
        [self initStateHud];
        
        if (textcView.text.length <= 0) {
        
            [self textStateHUD:@"请输入评论内容"];
            return;
        }
        
        NSString *string    = [textcView.text stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        
        LMCommentArticleRequest *request = [[LMCommentArticleRequest alloc] initWithArticle_uuid:_artcleuuid Commentcontent:string];
        
        HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                               completed:^(NSString *resp, NSStringEncoding encoding) {
                                                   
                                                   [self performSelectorOnMainThread:@selector(getCommentArticleDataResponse:)
                                                                          withObject:resp
                                                                       waitUntilDone:YES];
                                               } failed:^(NSError *error) {
                                                   
                                                   [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                          withObject:@"网络错误"
                                                                       waitUntilDone:YES];
                                               }];
        [proxy start];
        
    } else {
     
        [self IsLoginIn];
    }
}

- (void)getCommentArticleDataResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    [self logoutAction:resp];
    
    if ([[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
    
        [self textStateHUD:@"评论成功"];
        [self getHomeDetailDataRequest];
        
        textcView.text  = @"";
        tipLabel.hidden =NO;
        [textcView resignFirstResponder];
        
    } else {
        
        NSString *str = [bodyDic objectForKey:@"description"];
        
        if (str && ![str isEqual:[NSNull null]] && [str isKindOfClass:[NSString class]]) {
            
            [self textStateHUD:str];
        } else {
            
            [self textStateHUD:@"发布失败"];
        }
    }
}

- (void)replyAction:(id)sender
{
    NSLog(@"*********");
    [textcView becomeFirstResponder];
}

#pragma mark 删除文章
- (void)deleteActivityRequest:(NSString *)article_uuid
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:@"是否删除"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                              style:UIAlertActionStyleDestructive
                                            handler:^(UIAlertAction*action) {
                                                [self getDeleteRequest];
                                            }]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)getDeleteRequest
{
    LMArticeDeleteRequest *request = [[LMArticeDeleteRequest alloc] initWithArticle_uuid:_artcleuuid];
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(deleteActivityResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"删除失败"
                                                                   waitUntilDone:YES];
                                               
                                           }];
    [proxy start];
}


- (void)deleteActivityResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    [self logoutAction:resp];
    
    if ([[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
        
        [self textStateHUD:@"删除成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadlist" object:nil];
        });
        
    }else{
        NSString *str = [bodyDic objectForKey:@"description"];
        [self textStateHUD:str];
    }
    
}

#pragma mark --删除评论
- (void)deletCellAction:(UILongPressGestureRecognizer *)tap
{
    NSInteger index = tap.view.tag;
    LMActicleCommentVO *list= listArray[index];
    if (![list.userUuid isEqual:[FitUserManager sharedUserManager].uuid]) {
        return;
        
    }else{
        if (tap.state == UIGestureRecognizerStateEnded) {
            
            if ([list.type isEqual:@"comment"]){
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否删除您的评论"
                                                                               message:nil
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                                          style:UIAlertActionStyleCancel
                                                        handler:nil]];
                [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                                          style:UIAlertActionStyleDestructive
                                                        handler:^(UIAlertAction*action) {
                                                            NSLog(@"*****删除");
                                                            
                                                            [self deleteCommentdata:list.commentUuid];
                                                            
                                                            
                                                        }]];
                
                [self presentViewController:alert animated:YES completion:nil];
            }
            if ([list.type isEqual:@"reply"]) {
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否删除您的回复"
                                                                               message:nil
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                                          style:UIAlertActionStyleCancel
                                                        handler:nil]];
                [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                                          style:UIAlertActionStyleDestructive
                                                        handler:^(UIAlertAction*action) {
                                                            NSLog(@"*****删除");
                                                            
                                                            [self deleteArticleReply:list.replyUuid];
                                                            
                                                            
                                                        }]];
                
                [self presentViewController:alert animated:YES completion:nil];
                
                
            }
        } else {
            NSLog(@"failed");
        }
    }
}

- (void)deleteCommentdata:(NSString *)uuid
{
    LMArticleCommentDeleteRequest *request = [[LMArticleCommentDeleteRequest alloc] initWithCommentUUid:uuid];
    
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(getdeleteArticlecommentResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"网络错误"
                                                                   waitUntilDone:YES];
                                           }];
    [proxy start];
}

- (void)getdeleteArticlecommentResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    
    if (!bodyDic) {
        [self textStateHUD:@"删除失败请重试"];
    }else{
        if ([[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
            [self textStateHUD:@"删除成功"];
            
            [self getHomeDetailDataRequest];
        }else{
            [self textStateHUD:[bodyDic objectForKey:@"description"]];
        }
    }
}

- (void)deleteArticleReply:(NSString *)uuid
{
    
    LMArticeDeleteReplyRequst *request = [[LMArticeDeleteReplyRequst alloc] initWithArticle_uuid:uuid];
    
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(getdeleteArticlereplyResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"删除回复失败"
                                                                   waitUntilDone:YES];
                                           }];
    [proxy start];
}

- (void)getdeleteArticlereplyResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    
    if (!bodyDic) {
        
        [self textStateHUD:@"删除失败请重试"];
    } else {
        
        if ([[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
            
            [self textStateHUD:@"删除成功"];
            [self getHomeDetailDataRequest];
        } else {
            
            [self textStateHUD:[bodyDic objectForKey:@"description"]];
        }
    }
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

#pragma mark --跳转writerVC

- (void)WriterVC
{
    [self dismissSelf];
    LMWriterViewController *VC = [[LMWriterViewController alloc] initWithUUid:articleData.userUuid];
    VC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:VC animated:YES];
    
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [self.view endEditing:YES];
    self.tableView.userInteractionEnabled = YES;
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([textView isEqual:textcView]) {
        textIndex = 2;
    }
    if ([textView isEqual:commentText]) {
        textIndex = 1;
    }
    return YES;
}


-(void)closeComment
{
    [commentText resignFirstResponder];
    self.tableView.userInteractionEnabled = YES;
}

#pragma mark --更多按钮

- (void)creatMoreView
{
    if (footView.moreartcle.selected == NO) {
        [clickArr addObject:@"1"];
        
    }
    if (clickArr.count%2 == 1) {
        blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-50)];
        blackView.backgroundColor = [UIColor blackColor];
        blackView.alpha = 0.5;
        [self.view addSubview:blackView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissSelf)];
        [blackView addGestureRecognizer:tap];
        
        
        addView =[[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight/3)];
        addView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:addView];
        
        [UIView animateWithDuration:0.3f animations:^{
            [addView setFrame:CGRectMake(0, kScreenHeight*2/3-45, kScreenWidth, kScreenHeight/3)];
        }];
        
        
        UILabel *type = [UILabel new];
        type.text = @"字号大小";
        type.font = TEXT_FONT_LEVEL_1;
        type.textColor =TEXT_COLOR_LEVEL_1;
        type.textAlignment = NSTextAlignmentCenter;
        [type sizeToFit];
        [addView addSubview:type];
        
        bigBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [bigBtn setTitle:@"大" forState:UIControlStateNormal];
        bigBtn.titleLabel.font = TEXT_FONT_LEVEL_2;
        [bigBtn sizeToFit];
        [addView addSubview:bigBtn];
        [bigBtn addTarget:self action:@selector(bigBtnButton) forControlEvents:UIControlEventTouchUpInside];
        
        
        midBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [midBtn setTitle:@"中" forState:UIControlStateNormal];
        midBtn.titleLabel.font = TEXT_FONT_LEVEL_2;
        [midBtn sizeToFit];
        [addView addSubview:midBtn];
        [midBtn addTarget:self action:@selector(midBtnButton) forControlEvents:UIControlEventTouchUpInside];
        
        smallBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [smallBtn setTitle:@"小" forState:UIControlStateNormal];
        smallBtn.titleLabel.font = TEXT_FONT_LEVEL_2;
        [smallBtn sizeToFit];
        [addView addSubview:smallBtn];
        [smallBtn addTarget:self action:@selector(smallBtnButton) forControlEvents:UIControlEventTouchUpInside];
        
        
        type.frame = CGRectMake(15, 0, type.bounds.size.width, 45);
        smallBtn.frame = CGRectMake(kScreenWidth/2, 0, kScreenWidth/6, 45);
        midBtn.frame = CGRectMake(kScreenWidth*2/3, 0, kScreenWidth/6, 45);
        bigBtn.frame = CGRectMake(kScreenWidth*5/6, 0, kScreenWidth/6, 45);
        
        if (typeIndex ==1) {
            [bigBtn setTitleColor:LIVING_COLOR forState:UIControlStateNormal];
            [midBtn setTitleColor:TEXT_COLOR_LEVEL_3 forState:UIControlStateNormal];
            [smallBtn setTitleColor:TEXT_COLOR_LEVEL_3 forState:UIControlStateNormal];
        }
        if (typeIndex ==2) {
            [midBtn setTitleColor:LIVING_COLOR forState:UIControlStateNormal];
            [bigBtn setTitleColor:TEXT_COLOR_LEVEL_3 forState:UIControlStateNormal];
            [smallBtn setTitleColor:TEXT_COLOR_LEVEL_3 forState:UIControlStateNormal];
        }
        if (typeIndex ==3) {
            [smallBtn setTitleColor:LIVING_COLOR forState:UIControlStateNormal];
            [bigBtn setTitleColor:TEXT_COLOR_LEVEL_3 forState:UIControlStateNormal];
            [midBtn setTitleColor:TEXT_COLOR_LEVEL_3 forState:UIControlStateNormal];
        }
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 45, kScreenWidth, 0.5)];
        lineView.backgroundColor = LINE_COLOR;
        [addView addSubview:lineView];
        
        UIButton *writeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [writeButton setTitle:@"作者文章空间" forState:UIControlStateNormal];
        writeButton.titleLabel.font = TEXT_FONT_LEVEL_1;
        [writeButton setTitleColor:LIVING_COLOR forState:UIControlStateNormal];
        [writeButton sizeToFit];
        writeButton.frame = CGRectMake(kScreenWidth/2-80, addView.bounds.size.height/2, 160, 45);
        
        writeButton.layer.cornerRadius = 22.5;
        writeButton.layer.borderColor = LIVING_COLOR.CGColor;
        writeButton.layer.borderWidth = 0.5;
        
        [addView addSubview:writeButton];
        [writeButton addTarget:self action:@selector(WriterVC) forControlEvents:UIControlEventTouchUpInside];
        
        
    }else{
        [self dismissSelf];
    }
    
    
}

- (void)dismissSelf
{
    [UIView animateWithDuration:0.3f animations:^{
        blackView.alpha = 0;
        [addView setFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight/3)];
    } completion:^(BOOL finished) {
        
        [blackView removeFromSuperview];
        [addView removeFromSuperview];
        
    }];
}

- (void)confirmItemPressed
{
    [backView removeFromSuperview];
    [addView removeFromSuperview];
}

- (void)titleClick
{
    LMArtcleTypeViewController *writerVC = [[LMArtcleTypeViewController alloc] initWithType:articleData.type];
    writerVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:writerVC animated:YES];
}


@end
