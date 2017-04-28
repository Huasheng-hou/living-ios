//
//  LMWebViewController.m
//  living
//
//  Created by Ding on 2016/10/21.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMWebViewController.h"
#import "FitConsts.h"
#import <WebKit/WebKit.h>
@interface LMWebViewController ()<WKNavigationDelegate>

@end

//http://yaoguo1818.com/living-web/maker-160166.html

@implementation LMWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_titleString) {
        self.navigationItem.title = _titleString;
    }
    NSLog(@"%@",_urlString);
    self.view.backgroundColor = [UIColor whiteColor];
    WKWebView * web = [[WKWebView alloc] initWithFrame:self.view.bounds];
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlString]]];
    web.navigationDelegate = self;
    
    //view.scalesPageToFit = YES;
    //    view.opaque = NO;
    
    if (!_urlString) {
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
        label.center = self.view.center;
        label.text = @"暂无数据";
        label.textColor = MASK_COLOR;
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        [self.view addSubview:label];
        return;
        
    }
    [self.view addSubview:web];
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
    
    NSLog(@"准备加载页面");
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
    NSLog(@"内容开始加载");
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    NSLog(@"页面加载完成");
}
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"页面加载失败");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"内存警告");
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
