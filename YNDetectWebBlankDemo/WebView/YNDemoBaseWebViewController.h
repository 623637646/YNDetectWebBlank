//
//  YNDemoBaseWebViewController.h
//  YNDetectWebBlankDemo
//
//  Created by Wang Ya on 14/3/19.
//  Copyright © 2019 Wang Ya. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, YNDemoBaseWebViewType) {
    YNDemoBaseWebViewTypeWK,
    YNDemoBaseWebViewTypeUI
};

@interface YNDemoBaseWebViewController : UIViewController

@property (nonatomic, weak, readonly) UIView *webView;

- (instancetype)initWithType:(YNDemoBaseWebViewType)type NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

- (void)loadWithURLString:(NSString *)URLString;

- (void)makeWebViewBlank;

@end

NS_ASSUME_NONNULL_END
