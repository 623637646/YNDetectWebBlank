//
//  YNDemoBaseWKWebViewController.m
//  YNDetectWebBlankDemo
//
//  Created by Wang Ya on 14/3/19.
//  Copyright © 2019 Wang Ya. All rights reserved.
//

#import "YNDemoBaseWKWebViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <WebKit/WebKit.h>
#import <YNDetectWebBlank/YNDetectWebBlank.h>

@interface YNDemoBaseWKWebViewController ()<WKNavigationDelegate>

@property (nonatomic, weak) WKWebView *webView;

@end

@implementation YNDemoBaseWKWebViewController

- (void)loadWithURLString:(NSString *)URLString
{
    NSURL *URL = [NSURL URLWithString:URLString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
    request.timeoutInterval = 3;
    [self.webView loadRequest:request];
}

- (void)makeWebViewBlank
{
    [self.webView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    webView.backgroundColor = [UIColor whiteColor];
    webView.navigationDelegate = self;
    NSError *error;
    __weak typeof(self) wself = self;
    [webView yndwb_detectBlankWithBlock:^{
        __strong typeof(self) self = wself;
        self.title = @"Oh! It's Blank!";
    } error:&error];
    NSAssert(!error, @"");
    [self.view addSubview:webView];
    self.webView = webView;
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES].label.text = @"WKWebView loading";
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.label.text = error.localizedDescription;
    HUD.mode = MBProgressHUDModeText;
    [HUD hideAnimated:YES afterDelay:3];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.label.text = error.localizedDescription;
    HUD.mode = MBProgressHUDModeText;
    [HUD hideAnimated:YES afterDelay:3];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    decisionHandler(WKNavigationActionPolicyAllow);
}


- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    decisionHandler(WKNavigationResponsePolicyAllow);
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation
{
    
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler
{
    
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView
{

}

@end
