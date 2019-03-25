//
//  UIView+YNDWB.m
//  YNDetectWebBlank
//
//  Created by Wang Ya on 14/3/19.
//  Copyright © 2019 Wang Ya. All rights reserved.
//

#import "UIView+YNDWB.h"
#import "UIImage+YNDWB.h"
#import <objc/runtime.h>
#import <KVOController/KVOController.h>
#import <WebKit/WebKit.h>

@implementation UIView (YNDWB)

#pragma mark - public

- (BOOL)yndwb_detectBlankWithBlock:(YNDetectWebBlankBlock)block error:(NSError**)error
{
    // check parameter
    NSParameterAssert(block != nil);
    NSParameterAssert(*error == nil);
    if (block == nil || *error != nil) {
        *error = [NSError errorWithDomain:YNDWBErrorDomin code:YNDWBErrorCodeParameterInvaild userInfo:nil];
        return NO;
    }
    
    // property
    self.yndwb_block = block;
    
    // hook
    if (![self yndwb_hookDidMoveToWindowIfNeed:error]) {
        return NO;
    }
    if (![self yndwb_hookLoadingIfNeed:error]) {
        return NO;
    }
    
    return YES;
}

#pragma mark - hook

- (BOOL)yndwb_hookDidMoveToWindowIfNeed:(NSError**)error
{
    if (!self.yndwb_didMoveToWindowToken) {
        __weak typeof(self) wself = self;
        self.yndwb_didMoveToWindowToken = [self aspect_hookSelector:@selector(didMoveToWindow) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
            __strong typeof(self) self = wself;
            if (self.window && ![self yndwb_isLoading]) {
                // TODO How about non-URL request
                [self yndwb_requestDetectWhenBack];
            } else {
                [self yndwb_cancelDeployDetectionBlock];
            }
        } error:error];
        if (*error != nil) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)yndwb_hookLoadingIfNeed:(NSError**)error
{
    if ([self isKindOfClass:WKWebView.class]) {
        if (![self yndwb_hookLoadingForWKIfNeed:error]) {
            return NO;
        } else {
            return YES;
        }
    } else if ([self isKindOfClass:UIWebView.class]){
        if (![self yndwb_hookLoadingForUIIfNeed:error]) {
            return NO;
        } else {
            return YES;
        }
    } else {
        NSAssert(NO, @"self is not UIWebView or WKWebView");
    }
    return NO;
}

- (BOOL)yndwb_hookLoadingForWKIfNeed:(NSError**)error
{
    __weak typeof(self) wself = self;
    [self.KVOControllerNonRetaining observe:self keyPath:@"loading" options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        __strong typeof(self) self = wself;
        BOOL isLoading = [change[NSKeyValueChangeNewKey] boolValue];
        if (self.window && !isLoading) {
            [self yndwb_requestDetectWhenFinishLoading];
        }
    }];
    return YES;
}

- (BOOL)yndwb_hookLoadingForUIIfNeed:(NSError**)error
{
    return NO;
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

#pragma mark - private

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

#pragma mark - getter setter

- (void)setYndwb_didMoveToWindowToken:(id<AspectToken>)yndwb_didMoveToWindowToken
{
    objc_setAssociatedObject(self, @selector(yndwb_didMoveToWindowToken), yndwb_didMoveToWindowToken, OBJC_ASSOCIATION_RETAIN);
}

- (id<AspectToken>)yndwb_didMoveToWindowToken
{
    return objc_getAssociatedObject(self, @selector(yndwb_didMoveToWindowToken));
}

- (void)setYndwb_block:(YNDetectWebBlankBlock)yndwb_block
{
    objc_setAssociatedObject(self, @selector(yndwb_block), yndwb_block, OBJC_ASSOCIATION_COPY_NONATOMIC);
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

#pragma mark - utilities

- (UIImage *)yndwb_takeSnapshot
{
    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
    
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    
    // old style [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CFAbsoluteTime detectTime = (CFAbsoluteTimeGetCurrent() - startTime);
    NSLog(@"YNDetectWebBlank UIView yndwb_takeSnapshot time: %0.2fms", detectTime * 1000.0);
    return image;
}

- (BOOL)yndwb_isBlank
{
    UIImage *image = [self yndwb_takeSnapshot];
    return [image yndwb_isBlank];
}

@end
