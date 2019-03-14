//
//  YNDemoBaseUIWebViewController.h
//  YNDetectWebBlankDemo
//
//  Created by Wang Ya on 14/3/19.
//  Copyright © 2019 Wang Ya. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YNDemoBaseUIWebViewController : UIViewController

- (void)loadWithURLString:(NSString *)URLString;

- (void)removeAllSubviewsForWebView;

@end

NS_ASSUME_NONNULL_END
