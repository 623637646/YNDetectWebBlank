//
//  UIView+YNDWBPrivateDetect.m
//  YNDetectWebBlank
//
//  Created by Wang Ya on 26/3/19.
//  Copyright © 2019 Wang Ya. All rights reserved.
//

#import "UIView+YNDWBDetect.h"
#import <objc/runtime.h>
#import "UIView+YNDWBPrivate.h"
#import "UIWebView+YNDWB.h"
#import "UIWebView+YNDWBPrivate.h"
#import "WKWebView+YNDWB.h"
#import "WKWebView+YNDWBPrivate.h"


@implementation UIView (YNDWBDetect)

#pragma mark - setter getter

- (void)setYndwb_detectedBlankBlock:(YNDetectWebBlankBlock)yndwb_detectedBlankBlock
{
    objc_setAssociatedObject(self, @selector(yndwb_detectedBlankBlock), yndwb_detectedBlankBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    // detect
    if (yndwb_detectedBlankBlock) {
        [self yndwb_setUpDidMoveToWindowBlock];
        [self yndwb_setUpIsLoadingUpdateBlock];
        [self yndwb_setUpDetectWhenEnterForeground];
    } else {
        [self yndwb_removeDidMoveToWindowBlock];
        [self yndwb_removeIsLoadingUpdateBlock];
        [self yndwb_removeDetectWhenEnterForeground];
    }
}

- (YNDetectWebBlankBlock)yndwb_detectedBlankBlock
{
    return objc_getAssociatedObject(self, @selector(yndwb_detectedBlankBlock));
}

- (void)setYndwb_deployDetectionBlock:(dispatch_block_t)yndwb_deployDetectionBlock
{
    objc_setAssociatedObject(self, @selector(yndwb_deployDetectionBlock), yndwb_deployDetectionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (dispatch_block_t)yndwb_deployDetectionBlock
{
    return objc_getAssociatedObject(self, @selector(yndwb_deployDetectionBlock));
}

- (void)setYndwb_haveSetUpDetectWhenEnterForeground:(BOOL)yndwb_haveSetUpDetectWhenEnterForeground
{
    objc_setAssociatedObject(self, @selector(yndwb_haveSetUpDetectWhenEnterForeground), @(yndwb_haveSetUpDetectWhenEnterForeground), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL)yndwb_haveSetUpDetectWhenEnterForeground
{
    return [objc_getAssociatedObject(self, @selector(yndwb_haveSetUpDetectWhenEnterForeground)) boolValue];
}

#pragma mark - detect

- (void)yndwb_requestDetectionWhenAppearInWindow
{
    [self yndwb_setUpDeployDetectionBlockWithAction:YNDetectWebBlankActionAppearInWindow];
    
    // Why here execute block in 0.5 second?
    // Because when webView's view controler will push another view controller, webView's window will be nil first, then it will be the original UIWindow. After animations finished, webView's window will be nil again.
    // So in this case, It should ignore the "animations windows changing".
    // With many testings, I use 0.5s.
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
    dispatch_after(time, dispatch_get_main_queue(), self.yndwb_deployDetectionBlock);
}

- (void)yndwb_requestDetectWhenFinishLoading
{
    [self yndwb_setUpDeployDetectionBlockWithAction:YNDetectWebBlankActionLoaded];
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)([self yndwb_delayDetectWhenLoaded] * NSEC_PER_SEC));
    dispatch_after(time, dispatch_get_main_queue(), self.yndwb_deployDetectionBlock);
}

- (void)yndwb_requestDetectWhenEnterForeground
{
    [self yndwb_setUpDeployDetectionBlockWithAction:YNDetectWebBlankActionEnterForeground];
    
    // Why here execute block in 0.5 second?
    // Because when enter foreground, system has a animation (around 0.5s), If detect before this animation end, it's not fluent.
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
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
        if ([self yndwb_needDetect]) {
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
    NSAssert([self yndwb_needDetect], @"Don't need detect now");
    if (![self yndwb_needDetect]) {
        return;
    }
    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
    BOOL isBlank = [self yndwb_isBlank];
    CFAbsoluteTime detectTime = (CFAbsoluteTimeGetCurrent() - startTime);
    NSLog(@"YNDetectWebBlank detection time: %0.2fms", detectTime * 1000.0);
    if (!isBlank) {
        return;
    }
    self.yndwb_detectedBlankBlock([self yndwb_URL], action, detectTime * 1000.0);
}

#pragma mark - WKWebView UIWebView utilities

- (BOOL)yndwb_needDetect
{
    return self.window && [self yndwb_webViewAlreadyRequested] && ![self yndwb_isLoading];
}

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
    // TODO: When WKWebView or UIWebView is blank, the URL is nil. Expectation is the URL when request. Should swizzle set request method, record the URL.
    if ([self isKindOfClass:WKWebView.class]) {
        return ((WKWebView *)self).URL;
    } else if ([self isKindOfClass:UIWebView.class]){
        return ((UIWebView *)self).request.URL;
    } else {
        NSAssert(NO, @"self is not UIWebView or WKWebView");
    }
    return nil;
}

- (NSTimeInterval)yndwb_delayDetectWhenLoaded
{
    if ([self isKindOfClass:WKWebView.class]) {
        return WKWebView.yndwb_delayDetectWhenLoaded;
    } else if ([self isKindOfClass:UIWebView.class]){
        return UIWebView.yndwb_delayDetectWhenLoaded;
    } else {
        NSAssert(NO, @"self is not UIWebView or WKWebView");
    }
    return 0.2;
}

- (BOOL)yndwb_webViewAlreadyRequested
{
    if ([self isKindOfClass:WKWebView.class]) {
        return ((WKWebView *)self).yndwb_alreadyRequested;
    } else if ([self isKindOfClass:UIWebView.class]){
        return ((UIWebView *)self).yndwb_alreadyRequested;
    } else {
        NSAssert(NO, @"self is not UIWebView or WKWebView");
    }
    return NO;
}

- (void)yndwb_setUpDidMoveToWindowBlock
{
    __weak typeof(self) wself = self;
    self.yndwb_didMoveToWindowBlock = ^(UIWindow *window) {
        __strong typeof(self) self = wself;
        if ([self yndwb_needDetect]) {
            [self yndwb_requestDetectionWhenAppearInWindow];
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
        ((WKWebView *)self).yndwb_loadingStatusUpdatedBlock = ^(BOOL isLoading) {
            __strong typeof(self) self = wself;
            if ([self yndwb_needDetect]) {
                [self yndwb_requestDetectWhenFinishLoading];
            } else {
                [self yndwb_cancelDeployDetectionBlock];
            }
        };
    } else if ([self isKindOfClass:UIWebView.class]){
        ((UIWebView *)self).yndwb_loadingStatusUpdatedBlock = ^(BOOL isLoading) {
            __strong typeof(self) self = wself;
            if ([self yndwb_needDetect]) {
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
        ((WKWebView *)self).yndwb_loadingStatusUpdatedBlock = nil;
    } else if ([self isKindOfClass:UIWebView.class]){
        ((UIWebView *)self).yndwb_loadingStatusUpdatedBlock = nil;
    } else {
        NSAssert(NO, @"self is not UIWebView or WKWebView");
    }
}

- (void)yndwb_setUpDetectWhenEnterForeground
{
    if (self.yndwb_haveSetUpDetectWhenEnterForeground) {
        return;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(yndwb_requestDetectWhenEnterForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    self.yndwb_haveSetUpDetectWhenEnterForeground = YES;
}

- (void)yndwb_removeDetectWhenEnterForeground
{
    // TODO: Will crash on iOS 10 and below when this object dealloc and not remove notification
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    self.yndwb_haveSetUpDetectWhenEnterForeground = NO;
}

@end
