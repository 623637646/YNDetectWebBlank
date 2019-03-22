//
//  WKWebView+YNDWB.m
//  YNDetectWebBlank
//
//  Created by Wang Ya on 14/3/19.
//  Copyright © 2019 Wang Ya. All rights reserved.
//

#import "WKWebView+YNDWB.h"
#import <Aspects/Aspects.h>
#import <objc/runtime.h>
#import "UIView+YNDWB.h"
#import <KVOController/KVOController.h>

NSString *const YNDWBErrorDomin = @"com.shopee.yanni.YNDetectWebBlank";

@interface WKWebView (YNDWBPrivate)

@property (nonatomic, strong) id<AspectToken> yndwb_didMoveToWindowToken;
@property (nonatomic, copy) YNDetectWebBlankBlock yndwb_block;
@property (nonatomic, copy) dispatch_block_t yndwb_deployDetectionBlock;
@end

@implementation WKWebView (YNDWBPrivate)

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

@end

@implementation WKWebView (YNDWB)

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
    
    // aspect
    if (!self.yndwb_didMoveToWindowToken) {
        __weak typeof(self) wself = self;
        self.yndwb_didMoveToWindowToken = [self aspect_hookSelector:@selector(didMoveToWindow) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
            __strong typeof(self) self = wself;
            if (self.window && !self.isLoading) {
                // TODO How about non-URL request
                [self yndwb_requestDetectWhenBack];
            } else {
                [self yndwb_cancelDeployDetectionBlock];
            }
        } error:error];
        if (*error != nil) {
            return NO;
        }
        
        // TODO cycle retain?
        [self.KVOController observe:self keyPath:@"loading" options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
            __strong typeof(self) self = wself;
            BOOL isLoading = [change[NSKeyValueChangeNewKey] boolValue];
            if (self.window && !isLoading) {
                [self yndwb_requestDetectWhenFinishLoading];
            }
        }];
    }
    return YES;
}

#pragma mark - Detect

- (void)yndwb_requestDetectWhenBack
{
    [self yndwb_setUpDeployDetectionBlockWithAction:YNDetectWebBlankActionAppear];
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
    dispatch_after(time, dispatch_get_main_queue(), self.yndwb_deployDetectionBlock);
}

- (void)yndwb_requestDetectWhenFinishLoading
{
    [self yndwb_setUpDeployDetectionBlockWithAction:YNDetectWebBlankActionLoaded];
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(WKWebView.yndwb_delayDetectWhenLoaded * NSEC_PER_SEC));
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
        if (self.window && !self.isLoading) {
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
    NSAssert(!self.isLoading, @"yndwb_detect: Is loading");
    if (!self.window) {
        return;
    }
    if (self.isLoading) {
        return;
    }
    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
    BOOL isBlank = [self yndwb_isBlank];
    CFAbsoluteTime detectTime = (CFAbsoluteTimeGetCurrent() - startTime);
    NSLog(@"YNDetectWebBlank detection time: %0.2fms", detectTime * 1000.0);
    if (!isBlank) {
        return;
    }
    self.yndwb_block(self, action, detectTime * 1000.0);
}

#pragma mark - getter setter

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
