//
//  WKWebView+YNDWBPrivate.h
//  YNDetectWebBlank
//
//  Created by Wang Ya on 27/3/19.
//  Copyright © 2019 Wang Ya. All rights reserved.
//

#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^YNDWBWebViewIsLoadingUpdateBlock)(BOOL isLoading);

@interface WKWebView (YNDWBPrivate)

@property (nonatomic, copy, nullable) YNDWBWebViewIsLoadingUpdateBlock yndwb_isLoadingUpdateBlock;
@property (nonatomic, assign) BOOL yndwb_alreadyRequested;

@end

NS_ASSUME_NONNULL_END
