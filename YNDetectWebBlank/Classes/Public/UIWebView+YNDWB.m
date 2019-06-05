//
//  UIWebView+YNDWB.m
//  YNDetectWebBlank
//
//  Created by Wang Ya on 14/3/19.
//  Copyright © 2019 Wang Ya. All rights reserved.
//

#import "UIWebView+YNDWB.h"
#import "UIView+YNDWBDetect.h"
#import <objc/runtime.h>

@implementation UIWebView (YNDWB)

+ (void)setYndwb_delayDetectWhenLoaded:(NSTimeInterval)yndwb_delayDetectWhenLoaded
{
    NSParameterAssert(yndwb_delayDetectWhenLoaded > 0);
    if (yndwb_delayDetectWhenLoaded <= 0) {
        return;
    }
    objc_setAssociatedObject(self, @selector(yndwb_delayDetectWhenLoaded), @(yndwb_delayDetectWhenLoaded), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

+ (NSTimeInterval)yndwb_delayDetectWhenLoaded
{
    id value = objc_getAssociatedObject(self, @selector(yndwb_delayDetectWhenLoaded));
    if (!value) {
        return 0.2;
    }
    return [value doubleValue];
}

@end
