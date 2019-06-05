//
//  WKWebView+YNDWB.h
//  YNDetectWebBlank
//
//  Created by Wang Ya on 14/3/19.
//  Copyright © 2019 Wang Ya. All rights reserved.
//

#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, YNDetectWebBlankAction) {
    YNDetectWebBlankActionLoaded,
    YNDetectWebBlankActionAppear
};

typedef void (^YNDetectWebBlankBlock)(NSURL *URL, YNDetectWebBlankAction action, double detectionTime);

@interface WKWebView (YNDWB)

// Delay interval when webView loaded. default is 0.2s.
@property (nonatomic, assign, class) NSTimeInterval yndwb_delayDetectWhenLoaded;

// Detect block
@property (nonatomic, copy, nullable) YNDetectWebBlankBlock yndwb_block;

@end

NS_ASSUME_NONNULL_END
