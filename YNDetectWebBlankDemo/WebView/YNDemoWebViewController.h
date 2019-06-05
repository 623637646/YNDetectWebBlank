//
//  YNDemoWebViewController.h
//  YNDetectWebBlankDemo
//
//  Created by Wang Ya on 14/3/19.
//  Copyright © 2019 Wang Ya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YNDemoListViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, YNDemoWebViewControllerType) {
    YNDemoWebViewControllerTypeWK,
    YNDemoWebViewControllerTypeUI
};

@interface YNDemoWebViewController : YNDemoListViewController

- (instancetype)initWithType:(YNDemoWebViewControllerType)type NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
