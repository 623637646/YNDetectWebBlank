//
//  UIView+YNDWB.h
//  YNDetectWebBlank
//
//  Created by Wang Ya on 14/3/19.
//  Copyright © 2019 Wang Ya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Aspects/Aspects.h>
#import "YNDetectWebBlankCommon.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIView (YNDWB)

#pragma mark - public
// Delay interval when webView loaded. default is 0.2s.
@property (nonatomic, assign, class) NSTimeInterval yndwb_delayDetectWhenLoaded;

// Detect
- (BOOL)yndwb_detectBlankWithBlock:(YNDetectWebBlankBlock)block error:(NSError**)error;

#pragma mark - private
@property (nonatomic, strong, nullable) id<AspectToken> yndwb_didMoveToWindowToken;
@property (nonatomic, copy, nullable) YNDetectWebBlankBlock yndwb_block;
@property (nonatomic, copy, nullable) dispatch_block_t yndwb_deployDetectionBlock;

#pragma mark - utilities
- (UIImage *)yndwb_takeSnapshot;
- (BOOL)yndwb_isBlank;

@end

NS_ASSUME_NONNULL_END
