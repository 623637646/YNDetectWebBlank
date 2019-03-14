//
//  YNDemoWKWebNormalViewController.m
//  YNDetectWebBlankDemo
//
//  Created by Wang Ya on 14/3/19.
//  Copyright © 2019 Wang Ya. All rights reserved.
//

#import "YNDemoWKWebNormalViewController.h"
#import <WebKit/WebKit.h>

@interface YNDemoWKWebNormalViewController ()

@end

@implementation YNDemoWKWebNormalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    [webView loadRequest:({
        NSURL *url = [NSURL URLWithString:@"https://www.google.com"];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        request;
    })];
    [self.view addSubview:webView];
}

@end
