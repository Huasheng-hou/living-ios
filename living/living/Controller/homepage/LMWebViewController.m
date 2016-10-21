//
//  LMWebViewController.m
//  living
//
//  Created by Ding on 2016/10/21.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMWebViewController.h"

@interface LMWebViewController ()

@end

@implementation LMWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = _titleString;
    self.view.backgroundColor = [UIColor whiteColor];
    UIWebView * view = [[UIWebView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, kScreenWidth, kScreenHeight)];
    [view loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlString]]];
    NSLog(@"%@",_urlString);
    
    view.scalesPageToFit = YES;
    //    view.opaque = NO;
    [self.view addSubview:view];
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
