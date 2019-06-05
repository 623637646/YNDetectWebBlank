//
//  WKWebView+YNDWBPrivate.m
//  YNDetectWebBlank
//
//  Created by Wang Ya on 27/3/19.
//  Copyright © 2019 Wang Ya. All rights reserved.
//

#import "WKWebView+YNDWBPrivate.h"
#import <objc/runtime.h>
#import <KVOController/KVOController.h>

@implementation WKWebView (YNDWBPrivate)

- (void)setYndwb_isLoadingUpdateBlock:(YNDWBWebViewIsLoadingUpdateBlock)yndwb_isLoadingUpdateBlock
{
    objc_setAssociatedObject(self, @selector(yndwb_isLoadingUpdateBlock), yndwb_isLoadingUpdateBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    // TODO: this may have bug, If WKWebView is observed outside, This will cancel it.
    [self.KVOControllerNonRetaining unobserveAll];
    if (yndwb_isLoadingUpdateBlock) {
        [self yndwb_setUpObserve];
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

#pragma mark - private

- (void)yndwb_setUpObserve
{
    __weak typeof(self) wself = self;
    // TODO: Will crash on iOS 10 and below.
    [self.KVOControllerNonRetaining observe:self keyPath:@"loading" options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        __strong typeof(self) self = wself;
        BOOL isLoading = [change[NSKeyValueChangeNewKey] boolValue];
        if (isLoading) {
            self.yndwb_alreadyRequested = YES;
        }
        if (self.yndwb_isLoadingUpdateBlock) {
            self.yndwb_isLoadingUpdateBlock(isLoading);
        }
    }];
}

@end
