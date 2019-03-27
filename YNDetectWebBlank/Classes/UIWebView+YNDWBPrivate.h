//
//  UIWebView+YNDWBPrivate.h
//  YNDetectWebBlank
//
//  Created by Wang Ya on 27/3/19.
//  Copyright © 2019 Wang Ya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKWebView+YNDWBPrivate.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIWebView (YNDWBPrivate)

@property (nonatomic, copy, nullable) YNDWBWebViewIsLoadingUpdateBlock yndwb_isLoadingUpdateBlock;

@end

NS_ASSUME_NONNULL_END
