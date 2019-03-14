//
//  UIView+YNDWB.m
//  YNDetectWebBlank
//
//  Created by Wang Ya on 14/3/19.
//  Copyright © 2019 Wang Ya. All rights reserved.
//

#import "UIView+YNDWB.h"
#import "UIImage+YNDWB.h"

NSString *const YNDWBErrorDomin = @"com.shopee.yanni.YNDetectWebBlank";

@implementation UIView (YNDWB)

- (UIImage *)yndwb_takeSnapshot
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    
    // old style [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (BOOL)yndwb_isBlank
{
    UIImage *image = [self yndwb_takeSnapshot];
    return [image yndwb_isBlank];
}

@end
