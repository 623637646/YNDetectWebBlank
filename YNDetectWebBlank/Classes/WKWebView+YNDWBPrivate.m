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
    [self.KVOControllerNonRetaining unobserveAll];
    if (yndwb_isLoadingUpdateBlock) {
        [self yndwb_setUpObserve];
    }
}

- (YNDWBWebViewIsLoadingUpdateBlock)yndwb_isLoadingUpdateBlock
{
    return objc_getAssociatedObject(self, @selector(yndwb_isLoadingUpdateBlock));
}

#pragma mark - private

- (void)yndwb_setUpObserve
{
    __weak typeof(self) wself = self;
    [self.KVOControllerNonRetaining observe:self keyPath:@"loading" options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        __strong typeof(self) self = wself;
        BOOL isLoading = [change[NSKeyValueChangeNewKey] boolValue];
        if (self.yndwb_isLoadingUpdateBlock) {
            self.yndwb_isLoadingUpdateBlock(isLoading);
        }
    }];
}

@end
