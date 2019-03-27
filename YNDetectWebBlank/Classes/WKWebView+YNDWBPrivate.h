//
//  WKWebView+YNDWBPrivate.h
//  YNDetectWebBlank
//
//  Created by Wang Ya on 27/3/19.
//  Copyright © 2019 Wang Ya. All rights reserved.
//

#import <WebKit/WebKit.h>

typedef void (^YNDWBWebViewIsLoadingUpdateBlock)(BOOL isLoading);

NS_ASSUME_NONNULL_BEGIN

@interface WKWebView (YNDWBPrivate)

@property (nonatomic, copy, nullable) YNDWBWebViewIsLoadingUpdateBlock yndwb_isLoadingUpdateBlock;

@end

NS_ASSUME_NONNULL_END
