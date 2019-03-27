//
//  UIWebView+YNDWBPrivate.m
//  YNDetectWebBlank
//
//  Created by Wang Ya on 27/3/19.
//  Copyright © 2019 Wang Ya. All rights reserved.
//

#import "UIWebView+YNDWBPrivate.h"
#import <objc/runtime.h>

@implementation UIWebView (YNDWBPrivate)

- (void)setYndwb_isLoadingUpdateBlock:(YNDWBWebViewIsLoadingUpdateBlock)yndwb_isLoadingUpdateBlock
{
    objc_setAssociatedObject(self, @selector(yndwb_isLoadingUpdateBlock), yndwb_isLoadingUpdateBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
//    // TODO not finish
//    __weak typeof(self) wself = self;
//    [self.KVOControllerNonRetaining observe:self keyPath:@"delegate" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
//        __strong typeof(self) self = wself;
//        id oldDelegate = change[NSKeyValueChangeOldKey];
//        if (oldDelegate) {
//            id<AspectToken> token = objc_getAssociatedObject(oldDelegate, @selector(yndwb_hookLoadingForUIIfNeed:));
//            if (token) {
//                BOOL removeSuccess = [token remove];
//                NSAssert(removeSuccess, @"AspectToken remove not success");
//            }
//        }
//        id newDelegate = change[NSKeyValueChangeNewKey];
//        if (newDelegate) {
//            id<AspectToken> token = objc_getAssociatedObject(newDelegate, @selector(yndwb_hookLoadingForUIIfNeed:));
//            NSAssert(token == nil, @"AspectToken is not nil");
//            token = [newDelegate aspect_hookSelector:@selector(webViewDidFinishLoad:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
//                __strong typeof(self) self = wself;
//                
//            } error:NULL];
//        }
//    }];
}

- (YNDWBWebViewIsLoadingUpdateBlock)yndwb_isLoadingUpdateBlock
{
    return objc_getAssociatedObject(self, @selector(yndwb_isLoadingUpdateBlock));
}

@end
