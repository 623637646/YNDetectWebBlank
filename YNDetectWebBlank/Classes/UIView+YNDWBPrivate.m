//
//  UIView+YNDWBPrivate.m
//  YNDetectWebBlank
//
//  Created by Wang Ya on 14/3/19.
//  Copyright © 2019 Wang Ya. All rights reserved.
//

#import "UIView+YNDWBPrivate.h"
#import <objc/runtime.h>

@implementation UIView (YNDWBPrivate)

- (void)setYndwb_token:(id<AspectToken>)yndwb_token
{
    objc_setAssociatedObject(self, @selector(yndwb_token), yndwb_token, OBJC_ASSOCIATION_RETAIN);
}

- (id<AspectToken>)yndwb_token
{
    return objc_getAssociatedObject(self, @selector(yndwb_token));
}


- (void)setYndwb_block:(dispatch_block_t)yndwb_block
{
    objc_setAssociatedObject(self, @selector(yndwb_block), yndwb_block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (dispatch_block_t)yndwb_block
{
    return objc_getAssociatedObject(self, @selector(yndwb_block));
}

- (void)setYndwb_delay:(NSTimeInterval)yndwb_delay
{
    objc_setAssociatedObject(self, @selector(yndwb_delay), @(yndwb_delay), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSTimeInterval)yndwb_delay
{
    return [objc_getAssociatedObject(self, @selector(yndwb_delay)) doubleValue];
}

@end
