//
//  YNDetectWebBlankDefinition.h
//  YNDetectWebBlank
//
//  Created by Wang Ya on 5/6/19.
//  Copyright © 2019 Wang Ya. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, YNDetectWebBlankAction) {
    YNDetectWebBlankActionLoaded,
    YNDetectWebBlankActionAppearInWindow,
    YNDetectWebBlankActionEnterForeground
};

typedef void (^YNDetectWebBlankBlock)(NSURL *URL, YNDetectWebBlankAction action, double detectionTime);

NS_ASSUME_NONNULL_END
