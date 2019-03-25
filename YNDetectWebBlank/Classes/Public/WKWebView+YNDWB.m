//
//  WKWebView+YNDWB.m
//  YNDetectWebBlank
//
//  Created by Wang Ya on 14/3/19.
//  Copyright © 2019 Wang Ya. All rights reserved.
//

#import "WKWebView+YNDWB.h"
#import "UIView+YNDWB.h"

@implementation WKWebView (YNDWB)

- (BOOL)yndwb_detectBlankWithBlock:(YNDetectWebBlankBlock)block error:(NSError**)error
{
    return [super yndwb_detectBlankWithBlock:block error:error];
}

@end
