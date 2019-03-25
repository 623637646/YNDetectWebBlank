//
//  YNDetectWebBlankCommon.h
//  YNDetectWebBlank
//
//  Created by Wang Ya on 22/3/19.
//  Copyright © 2019 Wang Ya. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const YNDWBErrorDomin;

typedef enum : NSUInteger {
    YNDWBErrorCodeParameterInvaild,
} YNDWBErrorCode;

typedef NS_ENUM(NSUInteger, YNDetectWebBlankAction) {
    YNDetectWebBlankActionLoaded,
    YNDetectWebBlankActionAppear
};

typedef void (^YNDetectWebBlankBlock)(NSURL *URL, YNDetectWebBlankAction action, double detectionTime);
