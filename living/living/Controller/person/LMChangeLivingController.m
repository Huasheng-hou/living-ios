//
//  LMChangeLivingController.m
//  living
//
//  Created by Ding on 2016/10/27.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMChangeLivingController.h"

@interface LMChangeLivingController ()
{
    UIImageView *chooseView;
}

@end

@implementation LMChangeLivingController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}
-(void)createUI
{
    [super createUI];
    self.title = @"选择生活馆";
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle: @"确定" style:UIBarButtonItemStylePlain target:self action:@selector(besureAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    self.tableView.editing = !self.tableView.editing;
    self.tableView.allowsMultipleSelection = NO;
    
    
}

-(void)besureAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];

    
    UIImageView *headImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
    headImage.backgroundColor = [UIColor lightGrayColor];
    headImage.layer.cornerRadius = 5;
    [cell.contentView addSubview:headImage];
    
    UILabel *nameLabel = [UILabel new];
    nameLabel.text = @"杭州换吧网络科技生活馆";
    nameLabel.textColor = TEXT_COLOR_LEVEL_2;
    nameLabel.font = TEXT_FONT_LEVEL_2;
    [nameLabel sizeToFit];
    nameLabel.frame = CGRectMake(50, 0, nameLabel.bounds.size.width, 50);
    [cell.contentView addSubview:nameLabel];
    
    
    return cell;
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
