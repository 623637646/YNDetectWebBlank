//
//  YNDemoWebBlankWhenEnterForegroundViewController.m
//  YNDetectWebBlankDemo
//
//  Created by Wang Ya on 5/6/19.
//  Copyright © 2019 Wang Ya. All rights reserved.
//

#import "YNDemoWebBlankWhenEnterForegroundViewController.h"
#import "YNDemoServerConfig.h"

@implementation YNDemoWebBlankWhenEnterForegroundViewController

- (instancetype)initWithType:(YNDemoBaseWebViewType)type
{
    self = [super initWithType:type];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(makeWebViewBlank)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadWithURLString:[NSString stringWithFormat:@"%@/normal", [YNDemoServerConfig sharedInstance].serverURL]];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}

@end
