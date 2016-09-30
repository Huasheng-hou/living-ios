//
//  LMHomeDetailController.m
//  living
//
//  Created by Ding on 16/9/27.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMHomeDetailController.h"
#import "LMCommentCell.h"
#import "UIView+frame.h"

@interface LMHomeDetailController ()<UITableViewDelegate,
UITableViewDataSource,
UITextViewDelegate
>
{
    UITableView *_tableView;
    UIToolbar *toolBar;
    UITextView *textcView;
    CGFloat contentSize;
    NSInteger _rows;
    CGFloat bgViewY;
    UILabel  *tipLabel;
    UIButton *zanButton;
    
}


@end

@implementation LMHomeDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"首页详情";
    [self creatUI];
    [self getHomeDataRequest];
    [self registerForKeyboardNotifications];
    
}

-(void)creatUI
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-45) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.keyboardDismissMode          = UIScrollViewKeyboardDismissModeOnDrag;
    
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
    zanButton.titleLabel.font = TEXT_FONT_LEVEL_3;
    
    [toolBar addSubview:zanButton];
    
    
    tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, kScreenWidth-60, 30)];
    tipLabel.text = @"说两句吧...";
    tipLabel.textColor =TEXT_COLOR_LEVEL_3;
    tipLabel.font = TEXT_FONT_LEVEL_3;
    [textcView addSubview:tipLabel];
    
    
    
    
    
    [toolBar addSubview:textcView];
}



-(void)getHomeDataRequest
{
    
    
}

-(void)getHomeDataResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    
    if ([[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
        NSLog(@"%@",bodyDic);
        
        
        
        [_tableView reloadData];
    }else{
        NSString *str = [bodyDic objectForKey:@"description"];
        [self textStateHUD:str];
    }
    
    
}





-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1) {
        return [LMCommentCell cellHigth:@"果然我问问我吩咐我跟我玩嗡嗡图文无关的身份和她和热稳定"];
    }
    
    if (indexPath.section==0) {
        if (indexPath.row==1) {
            NSString *string = @"这是描述这是描述这是描述这是描述这是描述这是描述这是描述这是描述这是描述这是描述这是描述这是描述这是描述这是描述这是描述这是描述";
            NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12.0]};
            CGFloat conHigh = [string boundingRectWithSize:CGSizeMake(kScreenWidth-30, 100000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size.height;
            
            NSString *string2 = @"这是正文这是正文这是正文这是正文这是正文这是正文这是正文这是正文这是正文这是正文这是正文这是正文这是正文这是正文这是正文这是正文这是正文这是正文这是正文这是正文这是正文这是正文这是正文这是正文这是正文这是正文这是正文这是正文这是正文";
            NSDictionary *attributes2 = @{NSFontAttributeName:[UIFont systemFontOfSize:12.0]};
            CGFloat conHigh2 = [string2 boundingRectWithSize:CGSizeMake(kScreenWidth-30, 100000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes2 context:nil].size.height;
            
            
            return 300+conHigh+conHigh2;
        }
    }
    
    return 130;
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
            titleLabel.text = @"首页详情这是标题标题首页详情这是标题标题首页详情这是标题标题首页详情这是标题标题";
            NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16.0]};
            CGFloat conHigh = [titleLabel.text boundingRectWithSize:CGSizeMake(kScreenWidth-30, 100000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size.height;
            [titleLabel sizeToFit];
            titleLabel.frame = CGRectMake(15, 15, kScreenWidth-30, conHigh);
            [cell.contentView addSubview:titleLabel];
            
            UIImageView *headImage = [UIImageView new];
            headImage.image = [UIImage imageNamed:@"112"];
            headImage.frame = CGRectMake(15, conHigh+30, 20, 20);
            headImage.layer.cornerRadius =10;
            [headImage setClipsToBounds:YES];
            headImage.contentMode = UIViewContentModeScaleToFill;
            [cell.contentView addSubview:headImage];
            
            
            
            UILabel *nameLabel = [UILabel new];
            nameLabel.font = TEXT_FONT_LEVEL_3;
            nameLabel.textColor = TEXT_COLOR_LEVEL_3;
            nameLabel.text = @"作者名";
            [nameLabel sizeToFit];
            nameLabel.frame = CGRectMake(40, conHigh+30, nameLabel.bounds.size.width,20);
            [cell.contentView addSubview:nameLabel];
            
            
            UILabel *timeLabel = [UILabel new];
            timeLabel.font = TEXT_FONT_LEVEL_3;
            timeLabel.textColor = TEXT_COLOR_LEVEL_3;
            timeLabel.text = @"09-12 18:26";
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
            headImage.image = [UIImage imageNamed:@"112"];
            headImage.frame = CGRectMake(15, 15, kScreenWidth-30, 210);
            [headImage setClipsToBounds:YES];
            headImage.contentMode = UIViewContentModeScaleToFill;
            [cell.contentView addSubview:headImage];
            
            UILabel *dspLabel = [UILabel new];
            dspLabel.font = TEXT_FONT_LEVEL_3;
            dspLabel.textColor = TEXT_COLOR_LEVEL_3;
            dspLabel.numberOfLines=0;
            dspLabel.text = @"这是描述这是描述这是描述这是描述这是描述这是描述这是描述这是描述这是描述这是描述这是描述这是描述这是描述这是描述这是描述这是描述";
            NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12.0]};
            CGFloat conHigh = [dspLabel.text boundingRectWithSize:CGSizeMake(kScreenWidth-30, 100000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size.height;
            [dspLabel sizeToFit];
            dspLabel.frame = CGRectMake(15, 20+headImage.bounds.size.height, kScreenWidth-30, conHigh);
            [cell.contentView addSubview:dspLabel];
            
            
            UILabel *contentLabel = [UILabel new];
            contentLabel.font = TEXT_FONT_LEVEL_2;
            contentLabel.textColor = TEXT_COLOR_LEVEL_2;
            contentLabel.numberOfLines=0;
            contentLabel.text = @"这是正文这是正文这是正文这是正文这是正文这是正文这是正文这是正文这是正文这是正文这是正文这是正文这是正文这是正文这是正文这是正文这是正文这是正文这是正文这是正文这是正文这是正文这是正文这是正文这是正文这是正文这是正文这是正文这是正文";
            NSDictionary *attributes2 = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0]};
            CGFloat conHighs = [contentLabel.text boundingRectWithSize:CGSizeMake(kScreenWidth-30, 100000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes2 context:nil].size.height;
            [contentLabel sizeToFit];
            contentLabel.frame = CGRectMake(15, 30+headImage.bounds.size.height +conHigh, kScreenWidth-30, conHighs);
            [cell.contentView addSubview:contentLabel];
            
            
            UILabel *commentLabel = [UILabel new];
            commentLabel.font = TEXT_FONT_LEVEL_3;
            commentLabel.textColor = TEXT_COLOR_LEVEL_3;
            commentLabel.text = @"评论 264";
            [commentLabel sizeToFit];
            commentLabel.frame = CGRectMake(15, 45+headImage.bounds.size.height +conHigh+conHighs, commentLabel.bounds.size.width,commentLabel.bounds.size.height);
            [cell.contentView addSubview:commentLabel];
            
            
            
            UILabel *zanLabel = [UILabel new];
            zanLabel.font = TEXT_FONT_LEVEL_3;
            zanLabel.textColor = TEXT_COLOR_LEVEL_3;
            zanLabel.text = @"点赞 264";
            [zanLabel sizeToFit];
            zanLabel.frame = CGRectMake(30+commentLabel.bounds.size.width, 45+headImage.bounds.size.height +conHigh+conHighs, zanLabel.bounds.size.width,zanLabel.bounds.size.height);
            [cell.contentView addSubview:zanLabel];
            
            
            
        }
        
        
        
        return cell;
 
    }
    if (indexPath.section==1) {
        static NSString *cellId = @"cellId";
        LMCommentCell *cell = [[LMCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        tableView.separatorStyle = UITableViewCellSelectionStyleDefault;

        
        [cell setXScale:self.xScale yScale:self.yScaleNoTab];
        
        [cell setTitleString:@"果然我问问我吩咐我跟我玩嗡嗡图文无关的身份和她和热稳定"];
        return cell;
    }
    
    
    
    
    return nil;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
        textcView.text=@"";
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
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
