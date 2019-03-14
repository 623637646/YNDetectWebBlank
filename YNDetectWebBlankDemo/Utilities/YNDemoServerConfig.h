//
//  YNDemoServerConfig.h
//  YNDetectWebBlankDemo
//
//  Created by Wang Ya on 14/3/19.
//  Copyright © 2019 Wang Ya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YNDemoMacro.h"

NS_ASSUME_NONNULL_BEGIN

@interface YNDemoServerConfig : NSObject
MACRO_SINGLETON_PATTERN_H

@property (nonatomic, copy, nullable) NSString *IP;
@property (nonatomic, copy, readonly, nullable) NSString *serverURL;

@end

NS_ASSUME_NONNULL_END
