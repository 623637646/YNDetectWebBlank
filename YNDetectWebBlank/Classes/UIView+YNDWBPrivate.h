//
//  UIView+YNDWBPrivate.h
//  YNDetectWebBlank
//
//  Created by Wang Ya on 14/3/19.
//  Copyright © 2019 Wang Ya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Aspects/Aspects.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^YNDWBDidMoveToWindowBlock)(UIWindow *window);

@interface UIView (YNDWBPrivate)

#pragma mark - public

@property (nonatomic, copy, nullable) YNDWBDidMoveToWindowBlock yndwb_didMoveToWindowBlock;

#pragma mark - private

@property (nonatomic, strong, nullable) id<AspectToken> yndwb_didMoveToWindowToken;
- (UIImage *)yndwb_takeSnapshot;
- (BOOL)yndwb_isBlank;

@end

NS_ASSUME_NONNULL_END
