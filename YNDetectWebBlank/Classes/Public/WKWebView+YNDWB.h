//
//  WKWebView+YNDWB.h
//  YNDetectWebBlank
//
//  Created by Wang Ya on 14/3/19.
//  Copyright © 2019 Wang Ya. All rights reserved.
//

#import <WebKit/WebKit.h>

extern NSString *const YNDWBErrorDomin;

typedef enum : NSUInteger {
    YNDWBErrorCodeParameterInvaild,
} YNDWBErrorCode;

typedef NS_ENUM(NSUInteger, YNDetectWebBlankAction) {
    YNDetectWebBlankActionLoaded,
    YNDetectWebBlankActionAppear
};

typedef void (^YNDetectWebBlankBlock)(WKWebView *webView, YNDetectWebBlankAction action);

NS_ASSUME_NONNULL_BEGIN

@interface WKWebView (YNDWB)

// Delay interval when webView loaded. default is 0.2s.
@property (nonatomic, assign, class) NSTimeInterval yndwb_delayDetectWhenLoaded;

// Detect 
- (BOOL)yndwb_detectBlankWithBlock:(YNDetectWebBlankBlock)block error:(NSError**)error;

@end

NS_ASSUME_NONNULL_END
