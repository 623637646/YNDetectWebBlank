//
//  UIWebView+YNDWB.h
//  YNDetectWebBlank
//
//  Created by Wang Ya on 14/3/19.
//  Copyright © 2019 Wang Ya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YNDetectWebBlankDefinition.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIWebView (YNDWB)

// Delay interval when webView loaded. default is 0.2s.
@property (nonatomic, assign, class) NSTimeInterval yndwb_delayDetectWhenLoaded;

// Detect block
@property (nonatomic, copy, nullable) YNDetectWebBlankBlock yndwb_block;

@end

NS_ASSUME_NONNULL_END
