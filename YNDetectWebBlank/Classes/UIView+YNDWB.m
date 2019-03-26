//
//  UIView+YNDWB.m
//  YNDetectWebBlank
//
//  Created by Wang Ya on 14/3/19.
//  Copyright © 2019 Wang Ya. All rights reserved.
//

#import "UIView+YNDWB.h"
#import "UIImage+YNDWB.h"

@implementation UIView (YNDWB)

#pragma mark - utilities

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
