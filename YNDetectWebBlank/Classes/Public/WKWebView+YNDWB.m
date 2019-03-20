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

NSString *const YNDWBErrorDomin = @"com.shopee.yanni.YNDetectWebBlank";

@interface WKWebView (YNDWBPrivate)

@property (nonatomic, strong) id<AspectToken> yndwb_didMoveToWindowToken;
@property (nonatomic, strong) id<AspectToken> yndwb_isLoadingToken;
@property (nonatomic, copy) dispatch_block_t yndwb_block;

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

- (void)setYndwb_isLoadingToken:(id<AspectToken>)yndwb_isLoadingToken
{
    objc_setAssociatedObject(self, @selector(yndwb_isLoadingToken), yndwb_isLoadingToken, OBJC_ASSOCIATION_RETAIN);
}

- (id<AspectToken>)yndwb_isLoadingToken
{
    return objc_getAssociatedObject(self, @selector(yndwb_isLoadingToken));
}

- (void)setYndwb_block:(dispatch_block_t)yndwb_block
{
    objc_setAssociatedObject(self, @selector(yndwb_block), yndwb_block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (dispatch_block_t)yndwb_block
{
    return objc_getAssociatedObject(self, @selector(yndwb_block));
}

@end

@implementation WKWebView (YNDWB)

- (BOOL)yndwb_detectBlankWithBlock:(dispatch_block_t)block error:(NSError**)error
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
    if (self.yndwb_didMoveToWindowToken == nil) {
        __weak typeof(self) wself = self;
        self.yndwb_didMoveToWindowToken = [self aspect_hookSelector:@selector(didMoveToWindow) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
            __strong typeof(self) self = wself;
            
        } error:error];
        if (*error != nil) {
            return NO;
        }
    }
    if (self.yndwb_isLoadingToken == nil) {
        __weak typeof(self) wself = self;
        self.yndwb_isLoadingToken = [self aspect_hookSelector:@selector(setLoadingToken) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
            __strong typeof(self) self = wself;
            
        } error:error];
        if (*error != nil) {
            return NO;
        }
    }
    return YES;
}

- (void)yndwb_detect
{
    if (self.window == nil) {
        return;
    }
    if (self.isLoading) {
        return;
    }
    if (![self yndwb_isBlank]) {
        return;
    }
    self.yndwb_block();
}

#pragma mark - getter setter

+ (void)setYndwb_delayDetectWhenLoaded:(NSTimeInterval)yndwb_delayDetectWhenLoaded
{
    objc_setAssociatedObject(self, @selector(yndwb_delayDetectWhenLoaded), @(yndwb_delayDetectWhenLoaded), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

+ (NSTimeInterval)yndwb_delayDetectWhenLoaded
{
    return [objc_getAssociatedObject(self, @selector(yndwb_delayDetectWhenLoaded)) doubleValue];
}

@end
