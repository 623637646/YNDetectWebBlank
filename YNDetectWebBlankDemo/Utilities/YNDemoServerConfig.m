//
//  YNDemoServerConfig.m
//  YNDetectWebBlankDemo
//
//  Created by Wang Ya on 14/3/19.
//  Copyright © 2019 Wang Ya. All rights reserved.
//

#import "YNDemoServerConfig.h"

NSString *const kYNDemoUserDefaultsIPKey = @"kYNDemoUserDefaultsIPKey";

@implementation YNDemoServerConfig
MACRO_SINGLETON_PATTERN_M()

- (void)setIP:(NSString *)IP
{
    [[NSUserDefaults standardUserDefaults] setObject:IP forKey:kYNDemoUserDefaultsIPKey];
}

-(NSString *)IP
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:kYNDemoUserDefaultsIPKey];
}

- (NSString *)serverURL
{
    if (self.IP.length == 0) {
        return nil;
    }
    return [NSString stringWithFormat:@"http://%@:3000", self.IP];
}

@end
