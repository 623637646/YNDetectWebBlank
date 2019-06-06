//
//  UIWebView+YNDWBPrivate.m
//  YNDetectWebBlank
//
//  Created by Wang Ya on 27/3/19.
//  Copyright © 2019 Wang Ya. All rights reserved.
//

#import "UIWebView+YNDWBPrivate.h"
#import <objc/runtime.h>

@implementation YNDWBUIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (self.webView.yndwb_delegate && [self.webView.yndwb_delegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
        return [self.webView.yndwb_delegate webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if (self.webView.yndwb_delegate && [self.webView.yndwb_delegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [self.webView.yndwb_delegate webViewDidStartLoad:webView];
    }
    self.webView.yndwb_alreadyRequested = YES;
    if (self.webView.yndwb_isLoadingUpdateBlock) {
        self.webView.yndwb_isLoadingUpdateBlock(YES);
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (self.webView.yndwb_delegate && [self.webView.yndwb_delegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [self.webView.yndwb_delegate webViewDidFinishLoad:webView];
    }
    if (self.webView.yndwb_isLoadingUpdateBlock) {
        self.webView.yndwb_isLoadingUpdateBlock(NO);
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if (self.webView.yndwb_delegate && [self.webView.yndwb_delegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [self.webView.yndwb_delegate webView:webView didFailLoadWithError:error];
    }
    if (self.webView.yndwb_isLoadingUpdateBlock) {
        self.webView.yndwb_isLoadingUpdateBlock(NO);
    }
}

@end

@implementation UIWebView (YNDWBPrivate)

#pragma mark - setter getter

- (void)setYndwb_isLoadingUpdateBlock:(YNDWBWebViewIsLoadingUpdateBlock)yndwb_isLoadingUpdateBlock
{
    objc_setAssociatedObject(self, @selector(yndwb_isLoadingUpdateBlock), yndwb_isLoadingUpdateBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    if (yndwb_isLoadingUpdateBlock) {
        [self yndwb_setUpDelegateHook];
    } else {
        [self yndwb_cleanDelegateHook];
    }
}

- (YNDWBWebViewIsLoadingUpdateBlock)yndwb_isLoadingUpdateBlock
{
    return objc_getAssociatedObject(self, @selector(yndwb_isLoadingUpdateBlock));
}

- (void)setYndwb_alreadyRequested:(BOOL)yndwb_alreadyRequested
{
    objc_setAssociatedObject(self, @selector(yndwb_alreadyRequested), @(yndwb_alreadyRequested), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL)yndwb_alreadyRequested
{
    return [objc_getAssociatedObject(self, @selector(yndwb_alreadyRequested)) boolValue];
}

- (void)setYndwb_delegate:(id<UIWebViewDelegate>)yndwb_delegate
{
    objc_setAssociatedObject(self, @selector(yndwb_delegate), yndwb_delegate, OBJC_ASSOCIATION_ASSIGN);
}

- (id<UIWebViewDelegate>)yndwb_delegate
{
    return objc_getAssociatedObject(self, @selector(yndwb_delegate));
}

- (void)setYndwb_delegateToken:(id<AspectToken>)yndwb_delegateToken
{
    objc_setAssociatedObject(self, @selector(yndwb_delegateToken), yndwb_delegateToken, OBJC_ASSOCIATION_RETAIN);
}

- (id<AspectToken>)yndwb_delegateToken
{
    return objc_getAssociatedObject(self, @selector(yndwb_delegateToken));
}

- (void)setYndwb_trueDelegate:(YNDWBUIWebViewDelegate *)yndwb_trueDelegate
{
    objc_setAssociatedObject(self, @selector(yndwb_trueDelegate), yndwb_trueDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (YNDWBUIWebViewDelegate *)yndwb_trueDelegate
{
    return objc_getAssociatedObject(self, @selector(yndwb_trueDelegate));
}

#pragma mark - hook

- (void)yndwb_setUpDelegateHook
{
    // true delegate
    self.yndwb_trueDelegate = [[YNDWBUIWebViewDelegate alloc] init];
    self.yndwb_trueDelegate.webView = self;
    
    // delegate
    self.yndwb_delegate = self.delegate;
    self.delegate = self.yndwb_trueDelegate;
    
    // token
    // TODO: Should also hook "get delegate" method. otherwise others set a delegate and get a different delegate.
    if (!self.yndwb_delegateToken) {
        __weak typeof(self) wself = self;
        NSError *error = nil;
        self.yndwb_delegateToken = [self aspect_hookSelector:@selector(setDelegate:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
            __strong typeof(self) self = wself;
            self.yndwb_delegate = self.delegate;
            self.delegate = self.yndwb_trueDelegate;
        } error:&error];
        NSAssert(!error, @"%@", error);
    }
}

- (void)yndwb_cleanDelegateHook
{
    // true delegate
    self.yndwb_trueDelegate = nil;
    
    // delegate
    self.delegate = self.yndwb_delegate;
    self.yndwb_delegate = nil;
    
    // token
    if (self.yndwb_delegateToken) {
        BOOL removed = [self.yndwb_delegateToken remove];
        NSAssert(removed, @"not removed");
        self.yndwb_delegateToken = nil;
    }
}


@end
