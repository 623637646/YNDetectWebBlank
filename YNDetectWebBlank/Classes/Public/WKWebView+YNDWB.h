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

NS_ASSUME_NONNULL_BEGIN

@interface WKWebView (YNDWB)

// Delay interval when webView loaded. default is 200ms.
@property (nonatomic, assign, class) NSTimeInterval yndwb_delayDetectWhenLoaded;

// Detect 
- (BOOL)yndwb_detectBlankWithBlock:(dispatch_block_t)block error:(NSError**)error;

@end

NS_ASSUME_NONNULL_END
