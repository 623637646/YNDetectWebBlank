//
//  UIWebView+YNDWB.m
//  YNDetectWebBlank
//
//  Created by Wang Ya on 14/3/19.
//  Copyright © 2019 Wang Ya. All rights reserved.
//

#import "UIWebView+YNDWB.h"
#import "UIView+YNDWBPrivate.h"
#import "UIView+YNDWB.h"

@implementation UIWebView (YNDWB)

- (BOOL)yndwb_detectBlankWithBlock:(dispatch_block_t)block delay:(NSTimeInterval)delay error:(NSError**)error
{
    // check parameter
    NSParameterAssert(block != nil);
    NSParameterAssert(delay >= 0);
    NSParameterAssert(*error == nil);
    if (block == nil || delay < 0 || *error != nil) {
        *error = [NSError errorWithDomain:YNDWBErrorDomin code:YNDWBErrorCodeParameterInvaild userInfo:nil];
        return NO;
    }
    
    // property
    self.yndwb_block = block;
    self.yndwb_delay = delay;
    
    // aspect
    if (self.yndwb_token == nil) {
        __weak typeof(self) wself = self;
        self.yndwb_token = [self aspect_hookSelector:@selector(didMoveToWindow) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
            __strong typeof(self) self = wself;
//            if (self.window == nil) {
//                [[YNExposureManager sharedInstance] removeView:self];
//            } else {
//                [[YNExposureManager sharedInstance] addView:self];
//            }
        } error:error];
        if (*error != nil) {
            return NO;
        }
    }
    
    
    
    
    
    
//    __weak typeof(self) wself = self;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay)), dispatch_get_main_queue(), ^{
//        __strong typeof(self) self = wself;
//        if (!self) {
//            return;
//        }
//    });
    return YES;
}

@end
