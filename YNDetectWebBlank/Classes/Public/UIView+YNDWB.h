//
//  UIView+YNDWB.h
//  YNDetectWebBlank
//
//  Created by Wang Ya on 14/3/19.
//  Copyright © 2019 Wang Ya. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString *const YNDWBErrorDomin;

typedef enum : NSUInteger {
    YNDWBErrorCodeParameterInvaild,
} YNDWBErrorCode;


@interface UIView (YNDWB)

- (UIImage *)yndwb_takeSnapshot;

- (BOOL)yndwb_isBlank;

@end

NS_ASSUME_NONNULL_END
