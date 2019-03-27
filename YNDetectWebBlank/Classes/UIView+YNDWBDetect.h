//
//  UIView+YNDWBPrivateDetect.h
//  YNDetectWebBlank
//
//  Created by Wang Ya on 26/3/19.
//  Copyright © 2019 Wang Ya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKWebView+YNDWB.h"
#import "WKWebView+YNDWBPrivate.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIView (YNDWBDetect)

#pragma project
// Delay interval when webView loaded. default is 0.2s.
@property (nonatomic, assign, class) NSTimeInterval yndwb_delayDetectWhenLoaded;

// Detect block
@property (nonatomic, copy, nullable) YNDetectWebBlankBlock yndwb_block;

#pragma mark - private
@property (nonatomic, copy, nullable) dispatch_block_t yndwb_deployDetectionBlock;

@end

NS_ASSUME_NONNULL_END
