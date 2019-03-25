//
//  YNDemoBaseWebViewController.m
//  YNDetectWebBlankDemo
//
//  Created by Wang Ya on 14/3/19.
//  Copyright © 2019 Wang Ya. All rights reserved.
//

#import "YNDemoBaseWebViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <YNDetectWebBlank/YNDetectWebBlank.h>
#import <WebKit/WebKit.h>

@interface YNDemoBaseWebViewController ()<WKNavigationDelegate, UIWebViewDelegate>

@property (nonatomic, assign) YNDemoBaseWebViewType type;
@property (nonatomic, weak) UIView *webView;
@property (nonatomic, weak) MBProgressHUD *loadingHUD;
@property (nonatomic, weak) MBProgressHUD *toastHUD;

@end

@implementation YNDemoBaseWebViewController

- (instancetype)initWithType:(YNDemoBaseWebViewType)type
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.type = type;
    }
    return self;
}

- (void)loadWithURLString:(NSString *)URLString
{
    NSURL *URL = [NSURL URLWithString:URLString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
    request.timeoutInterval = 3;
    if ([self.webView isKindOfClass:WKWebView.class]) {
        [((WKWebView *)self.webView) loadRequest:request];
    } else if ([self.webView isKindOfClass:UIWebView.class]){
        [((UIWebView *)self.webView) loadRequest:request];
    } else {
        NSAssert(NO, @"self is not UIWebView or WKWebView");
    }
}

- (void)makeWebViewBlank
{
    [self.webView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    switch (self.type) {
        case YNDemoBaseWebViewTypeWK:{
            WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
            webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            webView.backgroundColor = [UIColor whiteColor];
            webView.navigationDelegate = self;
            NSError *error;
            __weak typeof(self) wself = self;
            [webView yndwb_detectBlankWithBlock:^(NSURL *URL, YNDetectWebBlankAction action, double detectionTime) {
                __strong typeof(self) self = wself;
                NSString *actionString = action == YNDetectWebBlankActionLoaded ? @"loaded" : @"appear";
                NSString *toast = [NSString stringWithFormat:@"Blank when %@(used %0.2fms).\n URL: %@",actionString, detectionTime, URL];
                [self showToast:toast];
            } error:&error];
            NSAssert(!error, @"");
            [self.view addSubview:webView];
            self.webView = webView;
            break;
        }
        case YNDemoBaseWebViewTypeUI:{
            UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
            webView.backgroundColor = [UIColor whiteColor];
            webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            webView.delegate = self;
            [self.view addSubview:webView];
            self.webView = webView;
        }
        default:
            break;
    }
}

#pragma mark - utilities

- (void)showLoading
{
    NSAssert(!self.loadingHUD, @"Is loading, can't show again!");
    [self hideToastIfNeed];
    self.loadingHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.loadingHUD.label.text = @"WKWebView loading";
}

- (void)hideLoading
{
    NSAssert(self.loadingHUD, @"Is not loading, can't hide");
    [self.loadingHUD hideAnimated:YES];
}

- (void)showToast:(NSString *)text
{
    [self hideToastIfNeed];
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.label.text = text;
    HUD.label.numberOfLines = 0;
    HUD.offset = CGPointMake(0, 100);
    HUD.mode = MBProgressHUDModeText;
}

- (void)hideToastIfNeed
{
    if (self.toastHUD) {
        [self.toastHUD hideAnimated:YES];
        self.toastHUD = nil;
    }
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    [self showLoading];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    [self hideLoading];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    [self hideLoading];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    [self hideLoading];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
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

//- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler
//{
//    
//}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView
{

}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self showLoading];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hideLoading];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self hideLoading];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
