//
//  LMExpertListController.m
//  living
//
//  Created by hxm on 2017/3/10.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMExpertListController.h"
#import "LMAllExpertListCell.h"
#import "LMExpertDetailController.h"
@interface LMExpertListController ()

@end

@implementation LMExpertListController

- (instancetype)init{
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        
    }
    return self;
}




- (void)viewDidLoad {
    [super viewDidLoad];

    [self createUI];


}

- (void)createUI{
    [super createUI];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LMAllExpertListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[LMAllExpertListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LMExpertDetailController * vc = [[LMExpertDetailController alloc] init];
    vc.title = @"李莺莺的空间";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:nil];
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
