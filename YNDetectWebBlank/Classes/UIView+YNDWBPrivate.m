//
//  UIView+YNDWBPrivate.m
//  YNDetectWebBlank
//
//  Created by Wang Ya on 14/3/19.
//  Copyright © 2019 Wang Ya. All rights reserved.
//

#import "UIView+YNDWBPrivate.h"
#import "UIImage+YNDWBPrivate.h"
#import <objc/runtime.h>

@implementation UIView (YNDWBPrivate)

#pragma mark - public

- (YNDWBDidMoveToWindowBlock)yndwb_didMoveToWindowBlock
{
    return objc_getAssociatedObject(self, @selector(yndwb_didMoveToWindowBlock));
}

- (void)setYndwb_didMoveToWindowBlock:(YNDWBDidMoveToWindowBlock)yndwb_didMoveToWindowBlock
{
    objc_setAssociatedObject(self, @selector(yndwb_didMoveToWindowBlock), yndwb_didMoveToWindowBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    if (yndwb_didMoveToWindowBlock) {
        if (!self.yndwb_didMoveToWindowToken) {
            __weak typeof(self) wself = self;
            NSError *error = nil;
            self.yndwb_didMoveToWindowToken = [self aspect_hookSelector:@selector(didMoveToWindow) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
                __strong typeof(self) self = wself;
                self.yndwb_didMoveToWindowBlock(self.window);
            } error:&error];
            NSAssert(!error, @"%@", error);
        }
    } else {
        if (self.yndwb_didMoveToWindowToken) {
            BOOL removed = [self.yndwb_didMoveToWindowToken remove];
            NSAssert(removed, @"not removed");
            self.yndwb_didMoveToWindowToken = nil;
        }
    }
}

#pragma mark - private

- (void)setYndwb_didMoveToWindowToken:(id<AspectToken>)yndwb_didMoveToWindowToken
{
    objc_setAssociatedObject(self, @selector(yndwb_didMoveToWindowToken), yndwb_didMoveToWindowToken, OBJC_ASSOCIATION_RETAIN);
}

- (id<AspectToken>)yndwb_didMoveToWindowToken
{
    return objc_getAssociatedObject(self, @selector(yndwb_didMoveToWindowToken));
}

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
