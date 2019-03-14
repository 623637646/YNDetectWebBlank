//
//  UIWebView+YNDWB.h
//  YNDetectWebBlank
//
//  Created by Wang Ya on 14/3/19.
//  Copyright © 2019 Wang Ya. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIWebView (YNDWB)

- (BOOL)yndwb_detectBlankWithBlock:(dispatch_block_t)block delay:(NSTimeInterval)delay error:(NSError**)error;

@end

NS_ASSUME_NONNULL_END
