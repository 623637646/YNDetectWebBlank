//
//  UIImage+YNDWB.m
//  YNDetectWebBlank
//
//  Created by Wang Ya on 14/3/19.
//  Copyright © 2019 Wang Ya. All rights reserved.
//

#import "UIImage+YNDWB.h"

@implementation UIImage (YNDWB)

- (BOOL)yndwb_isBlank
{
    UIColor *color = [UIColor colorWithPatternImage:self];
    return [color isEqual:[UIColor whiteColor]];
}

@end
