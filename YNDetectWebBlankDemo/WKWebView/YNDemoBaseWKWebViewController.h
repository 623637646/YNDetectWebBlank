//
//  YNDemoBaseWKWebViewController.h
//  YNDetectWebBlankDemo
//
//  Created by Wang Ya on 14/3/19.
//  Copyright © 2019 Wang Ya. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YNDemoBaseWebViewType) {
    YNDemoBaseWebViewTypeWK,
    YNDemoBaseWebViewTypeUI
};

NS_ASSUME_NONNULL_BEGIN

@interface YNDemoBaseWKWebViewController : UIViewController

@property (nonatomic, weak, readonly) UIView *webView;

- (instancetype)initWithType:(YNDemoBaseWebViewType)type;

- (void)loadWithURLString:(NSString *)URLString;

- (void)makeWebViewBlank;

@end

NS_ASSUME_NONNULL_END
