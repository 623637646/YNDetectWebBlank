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

@interface UIView (YNDWBPrivate)

@property (nonatomic, strong) id<AspectToken> yndwb_token;
@property (nonatomic, copy) dispatch_block_t yndwb_block;
@property (nonatomic, assign) NSTimeInterval yndwb_delay;

@end

NS_ASSUME_NONNULL_END
