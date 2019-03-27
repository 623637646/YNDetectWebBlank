//
//  UIView+YNDWBPrivateDetect.m
//  YNDetectWebBlank
//
//  Created by Wang Ya on 26/3/19.
//  Copyright © 2019 Wang Ya. All rights reserved.
//

#import "UIView+YNDWBDetect.h"
#import <WebKit/WebKit.h>
#import "UIView+YNDWBPrivate.h"
#import "UIWebView+YNDWBPrivate.h"
#import <objc/runtime.h>

@implementation UIView (YNDWBDetect)

#pragma mark - setter getter

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

- (void)setYndwb_block:(YNDetectWebBlankBlock)yndwb_block
{
    objc_setAssociatedObject(self, @selector(yndwb_block), yndwb_block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    // detect
    if (yndwb_block) {
        [self yndwb_setUpDidMoveToWindowBlock];
        [self yndwb_setUpIsLoadingUpdateBlock];
    } else {
        [self yndwb_removeDidMoveToWindowBlock];
        [self yndwb_removeIsLoadingUpdateBlock];
    }
}

- (YNDetectWebBlankBlock)yndwb_block
{
    return objc_getAssociatedObject(self, @selector(yndwb_block));
}

- (void)setYndwb_deployDetectionBlock:(dispatch_block_t)yndwb_deployDetectionBlock
{
    objc_setAssociatedObject(self, @selector(yndwb_deployDetectionBlock), yndwb_deployDetectionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (dispatch_block_t)yndwb_deployDetectionBlock
{
    return objc_getAssociatedObject(self, @selector(yndwb_deployDetectionBlock));
}

#pragma mark - detect

- (void)yndwb_requestDetectWhenBack
{
    [self yndwb_setUpDeployDetectionBlockWithAction:YNDetectWebBlankActionAppear];
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
    dispatch_after(time, dispatch_get_main_queue(), self.yndwb_deployDetectionBlock);
}

- (void)yndwb_requestDetectWhenFinishLoading
{
    [self yndwb_setUpDeployDetectionBlockWithAction:YNDetectWebBlankActionLoaded];
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(UIView.yndwb_delayDetectWhenLoaded * NSEC_PER_SEC));
    dispatch_after(time, dispatch_get_main_queue(), self.yndwb_deployDetectionBlock);
}

- (void)yndwb_setUpDeployDetectionBlockWithAction:(YNDetectWebBlankAction)action
{
    [self yndwb_cancelDeployDetectionBlock];
    __weak typeof(self) wself = self;
    self.yndwb_deployDetectionBlock = dispatch_block_create(0, ^{
        __strong typeof(self) self = wself;
        if (!self) {
            return;
        }
        if (self.window && ![self yndwb_isLoading]) {
            [self yndwb_detectWithAction:action];
        }
        self.yndwb_deployDetectionBlock = nil;
    });
}

- (void)yndwb_cancelDeployDetectionBlock
{
    if (self.yndwb_deployDetectionBlock) {
        dispatch_block_cancel(self.yndwb_deployDetectionBlock);
        self.yndwb_deployDetectionBlock = nil;
    }
}

- (void)yndwb_detectWithAction:(YNDetectWebBlankAction)action
{
    NSAssert(self.window, @"yndwb_detect: Window is nil");
    NSAssert(![self yndwb_isLoading], @"yndwb_detect: Is loading");
    if (!self.window) {
        return;
    }
    if ([self yndwb_isLoading]) {
        return;
    }
    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
    BOOL isBlank = [self yndwb_isBlank];
    CFAbsoluteTime detectTime = (CFAbsoluteTimeGetCurrent() - startTime);
    NSLog(@"YNDetectWebBlank detection time: %0.2fms", detectTime * 1000.0);
    if (!isBlank) {
        return;
    }
    self.yndwb_block([self yndwb_URL], action, detectTime * 1000.0);
}

#pragma mark - WKWebView UIWebView utilities

- (BOOL)yndwb_isLoading
{
    if ([self isKindOfClass:WKWebView.class]) {
        return ((WKWebView *)self).isLoading;
    } else if ([self isKindOfClass:UIWebView.class]){
        return ((UIWebView *)self).isLoading;
    } else {
        NSAssert(NO, @"self is not UIWebView or WKWebView");
    }
    return NO;
}

- (NSURL *)yndwb_URL
{
    if ([self isKindOfClass:WKWebView.class]) {
        return ((WKWebView *)self).URL;
    } else if ([self isKindOfClass:UIWebView.class]){
        return ((UIWebView *)self).request.URL;
    } else {
        NSAssert(NO, @"self is not UIWebView or WKWebView");
    }
    return nil;
}

- (void)yndwb_setUpDidMoveToWindowBlock
{
    __weak typeof(self) wself = self;
    self.yndwb_didMoveToWindowBlock = ^(UIWindow *window) {
        __strong typeof(self) self = wself;
        if (window && ![self yndwb_isLoading]) {
            // TODO How about non-URL request
            [self yndwb_requestDetectWhenBack];
        } else {
            [self yndwb_cancelDeployDetectionBlock];
        }
    };
}

- (void)yndwb_removeDidMoveToWindowBlock
{
    self.yndwb_didMoveToWindowBlock = nil;
}

- (void)yndwb_setUpIsLoadingUpdateBlock
{
    __weak typeof(self) wself = self;
    if ([self isKindOfClass:WKWebView.class]) {
        ((WKWebView *)self).yndwb_isLoadingUpdateBlock = ^(BOOL isLoading) {
            __strong typeof(self) self = wself;
            if (self.window && !isLoading) {
                [self yndwb_requestDetectWhenFinishLoading];
            } else {
                [self yndwb_cancelDeployDetectionBlock];
            }
        };
    } else if ([self isKindOfClass:UIWebView.class]){
        ((UIWebView *)self).yndwb_isLoadingUpdateBlock = ^(BOOL isLoading) {
            __strong typeof(self) self = wself;
            if (self.window && !isLoading) {
                [self yndwb_requestDetectWhenFinishLoading];
            } else {
                [self yndwb_cancelDeployDetectionBlock];
            }
        };
    } else {
        NSAssert(NO, @"self is not UIWebView or WKWebView");
    }
}

- (void)yndwb_removeIsLoadingUpdateBlock
{
    if ([self isKindOfClass:WKWebView.class]) {
        ((WKWebView *)self).yndwb_isLoadingUpdateBlock = nil;
    } else if ([self isKindOfClass:UIWebView.class]){
        ((UIWebView *)self).yndwb_isLoadingUpdateBlock = nil;
    } else {
        NSAssert(NO, @"self is not UIWebView or WKWebView");
    }
}

@end