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

#define Text_size_color [UIColor colorWithRed:16/255.0 green:142/255.0 blue:233/255.0 alpha:1.0]

@interface LMHomeDetailController ()
<
UITableViewDelegate,
UITableViewDataSource,
UITextViewDelegate,
LMCommentCellDelegate,
shareTypeDelegate
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
}

@end

@implementation LMHomeDetailController


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
     [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"文章详情";
    [self creatUI];
    listArray = [NSMutableArray new];
    [self getHomeDetailDataRequest];
    [self registerForKeyboardNotifications];
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
    hightArray = [NSMutableArray new];
    imageArray = [NSMutableArray new];
    
    typeIndex = 2;
}

- (void)creatFootView
{
    toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, kScreenHeight-45, kScreenWidth, 45)];
    toolBar. barStyle = UIBarButtonItemStylePlain ;
    
    [self.view addSubview :toolBar];
    
    textcView = [[UITextView alloc] initWithFrame:CGRectMake(15, 7.5, kScreenWidth-65, 30)];
    [textcView setDelegate:self];
    textcView.font = TEXT_FONT_LEVEL_2;
    textcView.layer.borderColor = LINE_COLOR.CGColor;
    textcView.layer.borderWidth =0.5;
    textcView.textColor = [UIColor blackColor];
    textcView.backgroundColor = [UIColor whiteColor];
    textcView.keyboardType=UIKeyboardTypeDefault;
    [textcView setReturnKeyType:UIReturnKeySend];
    
    zanButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-65, 0, 65, 45)];
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

#pragma mark --文章点赞

- (void)zanButtonAction:(id)senser
{
    LMArtclePariseRequest *request = [[LMArtclePariseRequest alloc] initWithArticle_uuid:_artcleuuid];
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(getarticlePraiseDataResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"点赞失败"
                                                                   waitUntilDone:YES];
                                           }];
    [proxy start];
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
        NSArray *indexPaths = @[[NSIndexPath indexPathForRow:1 inSection:0]];
        [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
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
    
    [self logoutAction:resp];
    
    if ([[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
        
        [self hideStateHud];
        if (listArray.count>0) {
           [listArray removeAllObjects];
        }
        
        
        articleData = [[LMArticleBodyVO alloc] initWithDictionary:bodyDic[@"article_body"]];
        
        if ([articleData.userUuid isEqualToString:[FitUserManager sharedUserManager].uuid]) {
         
            UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"删除"
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(deleteActivityRequest:)];
            
            self.navigationItem.rightBarButtonItem = rightItem;
        }
        
        fakeId = [NSString stringWithFormat:@"%d",articleData.fakaid];
        
        NSMutableArray *array=bodyDic[@"comment_messages"];

        
        for (int i =0; i<array.count; i++) {

            LMActicleCommentVO *list = [[LMActicleCommentVO alloc] initWithDictionary:array[i]];
            [listArray addObject:list];
        }
        if (listArray.count>0) {
            
            [homeImage removeFromSuperview];
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
    if (indexPath.section==1) {
        
        if (listArray.count > indexPath.row) {

            LMActicleCommentVO *list = listArray[indexPath.row];
            
            if (list && [list isKindOfClass:[LMActicleCommentVO class]]) {
                
                return [LMCommentCell cellHigth:list.commentContent];
            }
        }
    }
    
    if (indexPath.section==0) {
        if (indexPath.row==0) {

            NSDictionary *attributes5 = @{NSFontAttributeName:[UIFont systemFontOfSize:16.0]};
            
            CGFloat conHigh = [articleData.articleTitle boundingRectWithSize:CGSizeMake(kScreenWidth-30, 100000)
                                                                     options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                  attributes:attributes5
                                                                     context:nil].size.height;
            return 65 + conHigh;
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

            CGFloat conHigh = [articleData.describe boundingRectWithSize:CGSizeMake(kScreenWidth-30, 100000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size.height;
            

            CGFloat conHigh2 = [contentLabel.text boundingRectWithSize:CGSizeMake(kScreenWidth-30, 100000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes2 context:nil].size.height;
            
            if (!articleData.articleImgs) {
               return 110+conHigh+conHigh2;
            }else{
                NSArray *arr = articleData.articleImgs;
                for (int i = 0; i<arr.count; i++) {
                    
                    NSDictionary *dic = arr[i];
                    
                    CGFloat imageVH = [dic[@"height"] floatValue];
                    CGFloat imageVW = [dic[@"width"] floatValue];
                    
                    CGFloat imageViewH = kScreenWidth*imageVH/imageVW;
                    CGFloat hight = 0;
                    NSString *string = [NSString stringWithFormat:@"%f",imageViewH+hight];
                    
                    [hightArray addObject:string];
                    if (i>0) {
                        hight =[hightArray[i-1] floatValue] +10;
                    }else{
                        hight = 0;
                    }
  
                }
                
                NSInteger index =  arr.count-1;
                
                return 110+conHigh+conHigh2 +10 + [hightArray[index] floatValue] ;
            }
            
        }
    }
    
    return 0;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==1) {
        
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
        line.backgroundColor =[UIColor colorWithRed:0/255.0 green:130/255.0 blue:230.0/255.0 alpha:1.0];
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
    if (section==1) {
        return 40;
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 2;
    }
    if (section==1) {
        return listArray.count;
    }
    return 7;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        
        static NSString *cellId = @"cellId";
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row==0) {
            UILabel *titleLabel = [UILabel new];
            titleLabel.font = TEXT_FONT_LEVEL_1;
            titleLabel.numberOfLines=0;
            titleLabel.text = articleData.articleTitle;
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
            
        }
        if (indexPath.row==1) {

            dspLabel = [UILabel new];
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

            dspLabel.textColor = LIVING_REDCOLOR;
            dspLabel.numberOfLines=0;
            dspLabel.text = articleData.describe;
            

            CGFloat conHigh = [dspLabel.text boundingRectWithSize:CGSizeMake(kScreenWidth-30, 100000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size.height;
            [dspLabel sizeToFit];

            [cell.contentView addSubview:dspLabel];
            
            
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
            }
            if (typeIndex==2) {
                contentLabel.font = TEXT_FONT_LEVEL_1;
                attributes2 = @{NSFontAttributeName:[UIFont systemFontOfSize:16.0],NSParagraphStyleAttributeName:paragraphStyle};
            }
            if (typeIndex==3) {
                contentLabel.font = [UIFont systemFontOfSize:14.0];
                attributes2 = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0],NSParagraphStyleAttributeName:paragraphStyle};
            }
            

            
            CGFloat conHighs = [contentLabel.text boundingRectWithSize:CGSizeMake(kScreenWidth-30, 100000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes2 context:nil].size.height;
            [contentLabel sizeToFit];

            [cell.contentView addSubview:contentLabel];
            
            
            
            zanLabel = [LMCommentButton new];
            
            if (articleData.hasPraised == YES) {
                zanLabel.headImage.image = [UIImage imageNamed:@"zanIcon-click"];
            }else{
                zanLabel.headImage.image = [UIImage imageNamed:@"zanIcon"];
            }
            zanLabel.textLabel.text = [NSString stringWithFormat:@"%d",articleData.articlePraiseNum];
            zanLabel.textLabel.textColor = TEXT_COLOR_LEVEL_3;
            
            
            [zanLabel.textLabel sizeToFit];
            zanLabel.textLabel.frame = CGRectMake(15, 5, zanLabel.textLabel.bounds.size.width, zanLabel.textLabel.bounds.size.height);
            [zanLabel sizeToFit];
            
            [cell.contentView addSubview:zanLabel];
            [zanLabel addTarget:self action:@selector(zanButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            
            LMCommentButton *commentLabel = [[LMCommentButton alloc] init];
        
            commentLabel.headImage.image = [UIImage imageNamed:@"reply-click"];
            commentLabel.textLabel.text = [NSString stringWithFormat:@"%d",articleData.commentNum];
            [commentLabel.textLabel sizeToFit];
            commentLabel.textLabel.frame = CGRectMake(15, 5, commentLabel.textLabel.bounds.size.width, commentLabel.textLabel.bounds.size.height);
            [commentLabel.headImage sizeToFit];
            commentLabel.headImage.frame = CGRectMake(0, 6, 12, 12);
            commentLabel.textLabel.textColor = TEXT_COLOR_LEVEL_3;
            [commentLabel sizeToFit];
            [commentLabel addTarget:self action:@selector(replyAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:commentLabel];
            
            
            UILabel *type = [UILabel new];
            type.text = @"字号：";
            type.font = TEXT_FONT_LEVEL_2;
            type.textColor =Text_size_color;
            type.textAlignment = NSTextAlignmentCenter;
            type.layer.cornerRadius = 3;
            type.layer.borderColor =Text_size_color.CGColor;
            type.layer.borderWidth = 0.5;
            [type sizeToFit];
            [cell.contentView addSubview:type];
            
            UIButton *bigBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [bigBtn setTitle:@"大" forState:UIControlStateNormal];
            [bigBtn setTitleColor:Text_size_color forState:UIControlStateNormal];
            bigBtn.titleLabel.font = TEXT_FONT_LEVEL_2;
            bigBtn.layer.cornerRadius = 3;
            bigBtn.layer.borderColor =Text_size_color.CGColor;
            bigBtn.layer.borderWidth = 0.5;
            [bigBtn sizeToFit];
            [cell.contentView addSubview:bigBtn];
            [bigBtn addTarget:self action:@selector(bigBtnButton) forControlEvents:UIControlEventTouchUpInside];
            
            
            
            UIButton *midBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [midBtn setTitle:@"中" forState:UIControlStateNormal];
            [midBtn setTitleColor:Text_size_color forState:UIControlStateNormal];
            midBtn.titleLabel.font = TEXT_FONT_LEVEL_2;
            midBtn.layer.cornerRadius = 3;
            midBtn.layer.borderColor =Text_size_color.CGColor;
            midBtn.layer.borderWidth = 0.5;
            [midBtn sizeToFit];
            [cell.contentView addSubview:midBtn];
            [midBtn addTarget:self action:@selector(midBtnButton) forControlEvents:UIControlEventTouchUpInside];
            
            UIButton *smallBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [smallBtn setTitle:@"小" forState:UIControlStateNormal];
            [smallBtn setTitleColor:Text_size_color forState:UIControlStateNormal];
            smallBtn.titleLabel.font = TEXT_FONT_LEVEL_2;
            smallBtn.layer.cornerRadius = 3;
            smallBtn.layer.borderColor =Text_size_color.CGColor;
            smallBtn.layer.borderWidth = 0.5;
            [smallBtn sizeToFit];
            [cell.contentView addSubview:smallBtn];
            [smallBtn addTarget:self action:@selector(smallBtnButton) forControlEvents:UIControlEventTouchUpInside];
            
            
   
            
            UIButton *button=[UIButton new];
            [button addTarget:self action:@selector(shareButton) forControlEvents:UIControlEventTouchUpInside];
            [button setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
            button.layer.cornerRadius = 3;
            button.layer.borderColor =LIVING_COLOR.CGColor;
            button.layer.borderWidth = 0.5;
            [cell.contentView addSubview:button];
            

            if (articleData.articleImgs) {
                
                NSArray *arr =articleData.articleImgs;
                hightArray = [NSMutableArray new];
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
                
                type.frame = CGRectMake(15, 20+[hightArray[arr.count-1] floatValue], type.bounds.size.width+10, 30);
                bigBtn.frame = CGRectMake(30+type.bounds.size.width, 20+[hightArray[arr.count-1] floatValue], 40, 30);
                midBtn.frame =CGRectMake(80+type.bounds.size.width, 20+[hightArray[arr.count-1] floatValue], 40, 30);
                smallBtn.frame =CGRectMake(130+type.bounds.size.width, 20+[hightArray[arr.count-1] floatValue], 40, 30);
                
                
                dspLabel.frame = CGRectMake(15, 60+[hightArray[arr.count-1] floatValue], kScreenWidth-30, conHigh);
                contentLabel.frame = CGRectMake(15, 70+[hightArray[arr.count-1] floatValue] +conHigh, kScreenWidth-30, conHighs);
                commentLabel.frame = CGRectMake(15, 85+[hightArray[arr.count-1] floatValue]  +conHigh+conHighs, commentLabel.textLabel.bounds.size.width+20,commentLabel.bounds.size.height);
                zanLabel.frame = CGRectMake(30+commentLabel.bounds.size.width, 85+[hightArray[arr.count-1] floatValue]  +conHigh+conHighs, zanLabel.textLabel.bounds.size.width+20,zanLabel.bounds.size.height);


                [button setFrame:CGRectMake(kScreenWidth-88, 20+[hightArray[arr.count-1] floatValue] , 80, 30)];
                
            }else{
                type.frame = CGRectMake(15, 20, type.bounds.size.width+10, 30);
                
                bigBtn.frame = CGRectMake(30+type.bounds.size.width, 20, 40, 30);
                midBtn.frame =CGRectMake(80+type.bounds.size.width, 20, 40, 30);
                smallBtn.frame =CGRectMake(130+type.bounds.size.width, 20 , 40, 30);
                
                dspLabel.frame = CGRectMake(15, 50, kScreenWidth-30, conHigh);
                contentLabel.frame = CGRectMake(15, 60 +conHigh, kScreenWidth-30, conHighs);
                commentLabel.frame = CGRectMake(15, 75+conHigh+conHighs,  commentLabel.textLabel.bounds.size.width+20,commentLabel.bounds.size.height);
                zanLabel.frame = CGRectMake(30+commentLabel.bounds.size.width, 75+conHigh+conHighs, zanLabel.textLabel.bounds.size.width+20,zanLabel.bounds.size.height);

                [button setFrame:CGRectMake(kScreenWidth-88, 10, 80, 30)];
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
    
    return nil;
    
}

#pragma mark 分享按钮

-(void)shareButton
{
    HBShareView *shareView=[[HBShareView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    shareView.delegate=self;
    [self.view addSubview:shareView];
}
-(void)bigBtnButton
{
    typeIndex = 1;
    NSArray *indexPaths = @[[NSIndexPath indexPathForRow:1 inSection:0]];
    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];

}

-(void)midBtnButton
{
    typeIndex = 2;
    NSArray *indexPaths = @[[NSIndexPath indexPathForRow:1 inSection:0]];
    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];

}

-(void)smallBtnButton
{
    typeIndex = 3;
    NSArray *indexPaths = @[[NSIndexPath indexPathForRow:1 inSection:0]];
    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];

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
    NSString *urlString = @"http://115.159.118.160:8080/living-web/apparticle/article?fakeId=";
    
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

#pragma mark - LMCommentCell delegate -评论点赞
- (void)cellWillComment:(LMCommentCell *)cell
{
    
    NSLog(@"%@",cell.commentUUid);
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
    NSLog(@"**********回复");
    
    textIndex = 1;
    
    commitUUid =cell.commentUUid;
    [UIView  beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.75];
    self.tableView.userInteractionEnabled = NO;
    [self showCommentText];
    [UIView commitAnimations];
}

- (void)showCommentText
{
    [self createCommentsView];
    [commentText becomeFirstResponder];//再次让textView成为第一响应者（第二次）这次键盘才成功显示
}

- (void)createCommentsView
{
    if (!commentsView) {
        commentsView = [[UIView alloc] initWithFrame:CGRectMake(0.0, kScreenHeight - 180 - 180.0, kScreenWidth, 180.0)];
        commentsView.backgroundColor = [UIColor whiteColor];
        commentText = [[UITextView alloc] initWithFrame:CGRectInset(commentsView.bounds, 5.0, 20.0)];
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
        sureButton.frame = CGRectMake(kScreenWidth-90, 160-60, 72, 24);
        sureButton.layer.cornerRadius = 5;
        [sureButton setTitle:@"确认" forState:UIControlStateNormal];
        sureButton.backgroundColor = BLUE_COLOR;
        sureButton.tintColor = [UIColor whiteColor];
        [sureButton addTarget:self action:@selector(sendComment) forControlEvents:UIControlEventTouchUpInside];
        [commentText addSubview:sureButton];
        [commentsView addSubview:commentText];
    }
    [[UIApplication sharedApplication].keyWindow addSubview:commentsView];//添加到window上或者其他视图也行，只要在视图以外就好了
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

        [self getHomeDetailDataRequest];
        [self.tableView reloadData];
        
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
            NSLog(@"******bgViewY**%f",bgViewY);
            
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
                
                NSLog(@"****keyboardWasShown****%@",toolBar);
                
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
    // keyboardWasShown = NO;
    [UIView animateWithDuration:0.1f animations:^{
        [toolBar setFrame:CGRectMake(0, kScreenHeight-45, kScreenWidth, 45)];
        NSLog(@"***keyboardWasHidden*%@",toolBar);
    }];
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
        if ([textcView isEqual:commentText]) {
            [commentText resignFirstResponder];
            [self sendComment];
        }
        

        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}

#pragma mark  --评论文章
-(void)getCommentArticleDataRequest
{
    
    [self initStateHud];
    if (textcView.text.length<=0) {
        [self textStateHUD:@"请输入评论内容"];
        return;
    }
    
    NSString *string    = [textcView.text stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    NSLog(@"************%@",textcView.text);
    LMCommentArticleRequest *request = [[LMCommentArticleRequest alloc] initWithArticle_uuid:_artcleuuid Commentcontent:string];
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(getCommentArticleDataResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"评论失败"
                                                                   waitUntilDone:YES];
                                           }];
    [proxy start];

    
}

-(void)getCommentArticleDataResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    [self logoutAction:resp];
    if ([[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
        [self textStateHUD:@"评论成功"];
        [self getHomeDetailDataRequest];
        [self hideStateHud];
        textcView.text = @"";
        tipLabel.hidden=NO;
        [textcView resignFirstResponder];
        
        
    }else{
        NSString *str = [bodyDic objectForKey:@"description"];
        [self textStateHUD:str];
    }

    
}

-(void)replyAction:(id)sender
{
    NSLog(@"*********");
    [textcView becomeFirstResponder];
}



#pragma mark 删除文章
-(void)deleteActivityRequest:(NSString *)article_uuid
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

-(void)getDeleteRequest
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


-(void)deleteActivityResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    [self logoutAction:resp];
    
    if ([[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
        
        NSLog(@"==================删除文章bodyDic：%@",bodyDic);
        
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
-(void)deletCellAction:(UILongPressGestureRecognizer *)tap
{
    NSLog(@"**********%ld",tap.view.tag);
    NSInteger index = tap.view.tag;
    


         LMActicleCommentVO *list= listArray[index];
    if (![list.userUuid isEqual:[FitUserManager sharedUserManager].uuid]) {
        return;
        
    }else{
   
    
        
        if (tap.state == UIGestureRecognizerStateEnded) {
            NSLog(@"***********3333******");
            NSLog(@"************%@",list.type);
            
            if ([list.type isEqual:@"comment"]){
                
                NSLog(@"%@",list.commentUuid);
            
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
                
                NSLog(@"%@",list.replyUuid);
  
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
                                                                      withObject:@"删除评论失败"
                                                                   waitUntilDone:YES];
                                           }];
    [proxy start];
}

- (void)getdeleteArticlecommentResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    
    [self logoutAction:resp];
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
    
    [self logoutAction:resp];
  
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

-(void)WriterVC
{
    LMWriterViewController *VC = [[LMWriterViewController alloc] initWithUUid:articleData.userUuid];
    VC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:VC animated:YES];
    
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [self.view endEditing:YES];
    return YES;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


@end
