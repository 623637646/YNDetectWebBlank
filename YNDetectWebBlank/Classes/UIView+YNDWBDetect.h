//
//  UIView+YNDWBPrivateDetect.h
//  YNDetectWebBlank
//
//  Created by Wang Ya on 26/3/19.
//  Copyright © 2019 Wang Ya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YNDetectWebBlankDefinition.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIView (YNDWBDetect)

#pragma project

// Detect block
@property (nonatomic, copy, nullable) YNDetectWebBlankBlock yndwb_block;

#pragma mark - private
@property (nonatomic, copy, nullable) dispatch_block_t yndwb_deployDetectionBlock;

@end

NS_ASSUME_NONNULL_END
