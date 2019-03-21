//
//  YNDemoBaseWKWebViewController.h
//  YNDetectWebBlankDemo
//
//  Created by Wang Ya on 14/3/19.
//  Copyright © 2019 Wang Ya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YNDemoBaseWKWebViewController : UIViewController

@property (nonatomic, weak, readonly) WKWebView *webView;

- (void)loadWithURLString:(NSString *)URLString;

- (void)makeWebViewBlank;

@end

NS_ASSUME_NONNULL_END
