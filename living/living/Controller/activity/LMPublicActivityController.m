//
//  LMPublicActivityController.m
//  living
//
//  Created by Ding on 16/10/8.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMPublicActivityController.h"
#import "LMPublicMsgCell.h"
#import "LMTimeButton.h"

@interface LMPublicActivityController ()<UITableViewDelegate,UITableViewDataSource,
UITextFieldDelegate>
{
    UITableView *_tableView;
    LMPublicMsgCell *msgCell;
}

@end

@implementation LMPublicActivityController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatUI];
}

-(void)creatUI
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.keyboardDismissMode          = UIScrollViewKeyboardDismissModeOnDrag;
    

    
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }
    if (section==1) {
        return 2;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 400;
    }
    if (indexPath.section==1) {
        return 300;
    }
    return 0;
}



-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 35)];
        
        UIView *commentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 35)];
        commentView.backgroundColor = [UIColor whiteColor];
        [headView addSubview:commentView];
        
        UILabel *commentLabel = [UILabel new];
        commentLabel.font = [UIFont systemFontOfSize:13.f];
        commentLabel.textColor = [UIColor colorWithRed:0/255.0 green:130/255.0 blue:230.0/255.0 alpha:1.0];
        commentLabel.text = @"活动信息";
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
    
    
    if (section==1) {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        
        UIView *commentView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, kScreenWidth, 35)];
        commentView.backgroundColor = [UIColor whiteColor];
        [headView addSubview:commentView];
        
        UILabel *commentLabel = [UILabel new];
        commentLabel.font = [UIFont systemFontOfSize:13.f];
        commentLabel.textColor = [UIColor colorWithRed:0/255.0 green:130/255.0 blue:230.0/255.0 alpha:1.0];
        commentLabel.text = @"活动介绍";
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
    if (section==0) {
        return 35;
    }
    if (section==1) {
        return 40;
    }
    return 0;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    if (indexPath.section==0) {
        msgCell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!msgCell) {
            msgCell = [[LMPublicMsgCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        msgCell.selectionStyle = UITableViewCellSelectionStyleNone;
        msgCell.titleTF.delegate = self;
        msgCell.phoneTF.delegate = self;
        msgCell.nameTF.delegate = self;
        msgCell.freeTF.delegate =self;
        msgCell.dspTF.delegate = self;
        
        [msgCell.dateButton addTarget:self action:@selector(beginDateAction:) forControlEvents:UIControlEventTouchUpInside];
        [msgCell.timeButton addTarget:self action:@selector(beginTimeAction:) forControlEvents:UIControlEventTouchUpInside];
        [msgCell.endDateButton addTarget:self action:@selector(endDateAction:) forControlEvents:UIControlEventTouchUpInside];
        [msgCell.endTimeButton addTarget:self action:@selector(endTimeAction:) forControlEvents:UIControlEventTouchUpInside];
        [msgCell.addressButton addTarget:self action:@selector(addressAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
         return msgCell;
    }
    if (indexPath.section==1) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        return cell;
    }
    return nil;
}


-(void)beginDateAction:(id)sender
{
    NSLog(@"************beginDateAction");
}
-(void)beginTimeAction:(id)sender
{
    NSLog(@"************beginTimeAction");
}
-(void)endDateAction:(id)sender
{
    NSLog(@"************endDateAction");
}
-(void)endTimeAction:(id)sender
{
    NSLog(@"************endTimeAction");
}
-(void)addressAction:(id)sender
{
    NSLog(@"************addressAction");
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
