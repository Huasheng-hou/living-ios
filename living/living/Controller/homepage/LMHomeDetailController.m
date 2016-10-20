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
#import "LMArticleBody.h"
#import "LMCommentMessages.h"
#import "LMCommentCell.h"
#import "UIImageView+WebCache.h"
#import "UIView+frame.h"
#import "LMCommentArticleRequest.h"
#import "LMArtcleCommitRequest.h"

@interface LMHomeDetailController ()<UITableViewDelegate,
UITableViewDataSource,
UITextViewDelegate,
LMCommentCellDelegate
>
{
    UIToolbar *toolBar;
    UITextView *textcView;
    CGFloat contentSize;
    NSInteger _rows;
    CGFloat bgViewY;
    UILabel  *tipLabel;
    UIButton *zanButton;
    UILabel *zanLabel;


    LMArticleBody *articleData;
    NSMutableArray *listArray;
    
    UIView *commentsView;
    UITextView *commentText;
    UIView *backView;
    NSString *commitUUid;
    
}


@end

@implementation LMHomeDetailController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"文章详情";
    [self creatUI];
    listArray = [NSMutableArray new];
    [self getHomeDetailDataRequest];
    [self registerForKeyboardNotifications];
    
}

-(void)creatUI
{
    [super createUI];
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-45);
    [self creatFootView];
}

-(void)creatFootView
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
    [textcView setReturnKeyType:UIReturnKeyDone];
    
    zanButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-65, 0, 65, 45)];
    zanButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [zanButton setTitle:@"点赞" forState:UIControlStateNormal];
    [zanButton setTitleColor:TEXT_COLOR_LEVEL_3 forState:UIControlStateNormal];
    [zanButton addTarget:self action:@selector(zanButtonAction:) forControlEvents:UIControlEventTouchUpInside];
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

-(void)zanButtonAction:(id)senser
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



-(void)getarticlePraiseDataResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    if ([[bodyDic objectForKey:@"result"] isEqual:@"0"])
    {
        [self textStateHUD:@"点赞成功"];
        NSInteger zanNum =[zanLabel.text integerValue];
        zanNum = zanNum+1;
        zanLabel.text = [NSString stringWithFormat:@"%ld",zanNum];
        NSArray *indexPaths = @[
                                [NSIndexPath indexPathForRow:1 inSection:0]];
        [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    }else{
        NSString *str = [bodyDic objectForKey:@"description"];
        [self textStateHUD:str];
    }
        
}



#pragma mark  --请求详情数据
-(void)getHomeDetailDataRequest
{
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

-(void)getHomeDeatilDataResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    
    if ([[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
        
        articleData = [[LMArticleBody alloc] initWithDictionary:bodyDic[@"article_body"]];
        NSMutableArray *array=bodyDic[@"comment_messages"];
        
        [listArray removeAllObjects];
        for (int i=0; i<array.count; i++) {
            LMCommentMessages *list=[[LMCommentMessages alloc]initWithDictionary:array[i]];
            if (![listArray containsObject:list]) {
                [listArray addObject:list];
            }
        }
        
        [self.tableView reloadData];
    }else{
        NSString *str = [bodyDic objectForKey:@"description"];
        [self textStateHUD:str];
    }
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1) {
        if (listArray.count>0) {
            LMCommentMessages *list = listArray[indexPath.row];
            return [LMCommentCell cellHigth:list.commentContent];
        }
    }
    
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12.0]};
            CGFloat conHigh = [articleData.articleTitle boundingRectWithSize:CGSizeMake(kScreenWidth-30, 100000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size.height;
            return 75+conHigh;
        }
        if (indexPath.row==1) {

            
            NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12.0]};
            CGFloat conHigh = [articleData.describe boundingRectWithSize:CGSizeMake(kScreenWidth-30, 100000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size.height;
            
            NSDictionary *attributes2 = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0]};
            CGFloat conHigh2 = [articleData.articleContent boundingRectWithSize:CGSizeMake(kScreenWidth-30, 100000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes2 context:nil].size.height;
            
            if (!articleData.articleImgs) {
               return 70+conHigh+conHigh2;
            }else{
                return 300+conHigh+conHigh2;
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
        commentLabel.textColor = [UIColor colorWithRed:0/255.0 green:130/255.0 blue:230.0/255.0 alpha:1.0];
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

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==1) {
        return 40;
    }
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
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
            NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16.0]};
            CGFloat conHigh = [titleLabel.text boundingRectWithSize:CGSizeMake(kScreenWidth-30, 100000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size.height;
            [titleLabel sizeToFit];
            titleLabel.frame = CGRectMake(15, 15, kScreenWidth-30, conHigh);
            [cell.contentView addSubview:titleLabel];
            
            UIImageView *headImage = [UIImageView new];
            [headImage sd_setImageWithURL:[NSURL URLWithString:articleData.avatar]];
            headImage.frame = CGRectMake(15, conHigh+30, 20, 20);
            headImage.layer.cornerRadius =10;
            [headImage setClipsToBounds:YES];
            headImage.contentMode = UIViewContentModeScaleToFill;
            [cell.contentView addSubview:headImage];
            
            
            
            UILabel *nameLabel = [UILabel new];
            nameLabel.font = TEXT_FONT_LEVEL_3;
            nameLabel.textColor = TEXT_COLOR_LEVEL_3;
            nameLabel.text = articleData.articleName;
            [nameLabel sizeToFit];
            nameLabel.frame = CGRectMake(40, conHigh+30, nameLabel.bounds.size.width,20);
            [cell.contentView addSubview:nameLabel];
            
            
            UILabel *timeLabel = [UILabel new];
            timeLabel.font = TEXT_FONT_LEVEL_3;
            timeLabel.textColor = TEXT_COLOR_LEVEL_3;
            timeLabel.text = articleData.publishTime;
            [timeLabel sizeToFit];
            timeLabel.frame = CGRectMake(kScreenWidth-timeLabel.bounds.size.width-15, conHigh+30, timeLabel.bounds.size.width,20);
            [cell.contentView addSubview:timeLabel];
            
            UIView *line = [UIView new];
            line.backgroundColor =LINE_COLOR;
            [line sizeToFit];
            line.frame = CGRectMake(15, conHigh+60, kScreenWidth-30, 0.5);
            [cell.contentView addSubview:line];
            
        }
        if (indexPath.row==1) {

            UIImageView *headImage = [UIImageView new];
            [headImage sd_setImageWithURL:[NSURL URLWithString:articleData.articleImgs]];
            
            [headImage setClipsToBounds:YES];
            headImage.contentMode = UIViewContentModeScaleToFill;
            [cell.contentView addSubview:headImage];

            
            
            UILabel *dspLabel = [UILabel new];
            dspLabel.font = TEXT_FONT_LEVEL_3;
            dspLabel.textColor = TEXT_COLOR_LEVEL_3;
            dspLabel.numberOfLines=0;
            dspLabel.text = articleData.describe;
            NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12.0]};
            CGFloat conHigh = [dspLabel.text boundingRectWithSize:CGSizeMake(kScreenWidth-30, 100000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size.height;
            [dspLabel sizeToFit];

            [cell.contentView addSubview:dspLabel];
            
            
            UILabel *contentLabel = [UILabel new];
            contentLabel.font = TEXT_FONT_LEVEL_2;
            contentLabel.textColor = TEXT_COLOR_LEVEL_2;
            contentLabel.numberOfLines=0;
            contentLabel.text = articleData.articleContent;
            NSDictionary *attributes2 = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0]};
            CGFloat conHighs = [contentLabel.text boundingRectWithSize:CGSizeMake(kScreenWidth-30, 100000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes2 context:nil].size.height;
            [contentLabel sizeToFit];

            [cell.contentView addSubview:contentLabel];
            
            
            UILabel *commentLabel = [UILabel new];
            commentLabel.font = TEXT_FONT_LEVEL_3;
            commentLabel.textColor = TEXT_COLOR_LEVEL_3;
            commentLabel.text = [NSString stringWithFormat:@"评论 %.0f",articleData.commentNum];
            [commentLabel sizeToFit];

            [cell.contentView addSubview:commentLabel];
            
            
            
            zanLabel = [UILabel new];
            zanLabel.font = TEXT_FONT_LEVEL_3;
            zanLabel.textColor = TEXT_COLOR_LEVEL_3;
            zanLabel.text = [NSString stringWithFormat:@"点赞 %.0f",articleData.articlePraiseNum];
            [zanLabel sizeToFit];

            [cell.contentView addSubview:zanLabel];
            
            if (articleData.articleImgs) {
                headImage.frame = CGRectMake(15, 15, kScreenWidth-30, 210);
                dspLabel.frame = CGRectMake(15, 20+headImage.bounds.size.height, kScreenWidth-30, conHigh);
                contentLabel.frame = CGRectMake(15, 30+headImage.bounds.size.height +conHigh, kScreenWidth-30, conHighs);
                commentLabel.frame = CGRectMake(15, 45+headImage.bounds.size.height +conHigh+conHighs, commentLabel.bounds.size.width,commentLabel.bounds.size.height);
                zanLabel.frame = CGRectMake(30+commentLabel.bounds.size.width, 45+headImage.bounds.size.height +conHigh+conHighs, zanLabel.bounds.size.width,zanLabel.bounds.size.height);
            }else{
                dspLabel.frame = CGRectMake(15, 10, kScreenWidth-30, conHigh);
                contentLabel.frame = CGRectMake(15, 20 +conHigh, kScreenWidth-30, conHighs);
                commentLabel.frame = CGRectMake(15, 35+conHigh+conHighs, commentLabel.bounds.size.width,commentLabel.bounds.size.height);
                zanLabel.frame = CGRectMake(30+commentLabel.bounds.size.width, 35+conHigh+conHighs, zanLabel.bounds.size.width,zanLabel.bounds.size.height);
            }
            
        }
  
        return cell;
 
    }
    if (indexPath.section==1) {
        static NSString *cellId = @"cellId";
        LMCommentCell *cell = [[LMCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        tableView.separatorStyle = UITableViewCellSelectionStyleDefault;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        LMCommentMessages *list = listArray[indexPath.row];
        cell.delegate = self;
        [cell setValue:list];
        cell.commentUUid = list.commentUuid;
        cell.count = list.praiseCount;

        [cell setXScale:self.xScale yScale:self.yScaleNoTab];
        
        return cell;
    }
    
    
    
    
    return nil;
    
}

#pragma mark - LMCommentCell delegate -评论点赞
- (void)cellWillComment:(LMCommentCell *)cell
{
    
    NSLog(@"%@",cell.commentUUid);
    LMCommentPraiseRequest *request = [[LMCommentPraiseRequest alloc] initWithArticle_uuid:_artcleuuid CommentUUid:cell.commentUUid];
    
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(getPraisecellDataResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"点赞失败"
                                                                   waitUntilDone:YES];
                                           }];
    [proxy start];
    
    
}

-(void)getPraisecellDataResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
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
-(void)cellWillReply:(LMCommentCell *)cell
{
    NSLog(@"**********回复");
    
    cell.commentUUid = commitUUid;
    [UIView  beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.75];
    [self showCommentText];
    [UIView commitAnimations];

}
- (void)showCommentText {
    [self createCommentsView];
    [commentText becomeFirstResponder];//再次让textView成为第一响应者（第二次）这次键盘才成功显示
}
- (void)createCommentsView {
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
    [self.view.window addSubview:commentsView];//添加到window上或者其他视图也行，只要在视图以外就好了
    [commentText becomeFirstResponder];//让textView成为第一响应者（第一次）这次键盘并未显示出来
}

-(void)sendComment
{
    NSLog(@"************");
    if ([commentText.text isEqualToString:@""]) {
        [self textStateHUD:@"回答内容不能为空"];
        return;
    }
    [self commitDataRequest];
    
    
    [commentText resignFirstResponder];
    self.tableView.userInteractionEnabled = YES;
}

-(void)commitDataRequest
{
    LMArtcleCommitRequest *request = [[LMArtcleCommitRequest alloc] initWithArticle_uuid:_artcleuuid CommentUUid:commitUUid Reply_content:commentText.text];
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
-(void)getEventcommitResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    if (!bodyDic) {
        [self textStateHUD:@"回复失败"];
    }
    if ([[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
        [self textStateHUD:@"回复成功"];
        toolBar.hidden = NO;
        [self getHomeDetailDataRequest];
        
    }else{
        NSString *str = [bodyDic objectForKey:@"description"];
        [self textStateHUD:str];
    }
    
}





#pragma mark 键盘部分

- (void) registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)keyboardChangeFrame:(NSNotification *)notifi{
    CGRect keyboardFrame = [notifi.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    float duration = [notifi.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:duration animations:^{
        toolBar.transform = CGAffineTransformMakeTranslation(0, keyboardFrame.origin.y - kScreenHeight);
        bgViewY = toolBar.frame.origin.y;
    }];
}


- (void) keyboardWasShown:(NSNotification *) notif
{
    CGFloat curkeyBoardHeight = [[[notif userInfo] objectForKey:@"UIKeyboardBoundsUserInfoKey"] CGRectValue].size.height;
    CGRect begin = [[[notif userInfo] objectForKey:@"UIKeyboardFrameBeginUserInfoKey"] CGRectValue];
    CGRect end = [[[notif userInfo] objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    // 第三方键盘回调三次问题，监听仅执行最后一次
    if(begin.size.height>0 && (begin.origin.y-end.origin.y>0)){
        [UIView animateWithDuration:0.1f animations:^{
            [toolBar setFrame:CGRectMake(0, kScreenHeight-(curkeyBoardHeight+toolBar.height+contentSize), kScreenWidth, toolBar.height+contentSize)];
            
        }];
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
    }];
}

#pragma mark UITextFieldDelegate

//获取textView高度

- (void)textViewDidChange:(UITextView *)textView{
    
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


- (void)changeFrame:(CGFloat)height{
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
        [textcView resignFirstResponder];
        [self getCommentArticleDataRequest];
        textView.text=@"说两句吧...";
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}

#pragma mark  --评论文章
-(void)getCommentArticleDataRequest
{
    LMCommentArticleRequest *request = [[LMCommentArticleRequest alloc] initWithArticle_uuid:_artcleuuid Commentcontent:textcView.text];
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
    if ([[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
        [self textStateHUD:@"评论成功"];
        [self.tableView reloadData];
        
    }else{
        NSString *str = [bodyDic objectForKey:@"description"];
        [self textStateHUD:str];
    }

    
}





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
