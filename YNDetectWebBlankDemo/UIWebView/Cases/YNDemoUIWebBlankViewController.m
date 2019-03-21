//
//  YNDemoUIWebBlankViewController.m
//  YNDetectWebBlankDemo
//
//  Created by Wang Ya on 14/3/19.
//  Copyright © 2019 Wang Ya. All rights reserved.
//

#import "YNDemoUIWebBlankViewController.h"
#import "YNDemoServerConfig.h"

@implementation YNDemoUIWebBlankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadWithURLString:[NSString stringWithFormat:@"%@/blank", [YNDemoServerConfig sharedInstance].serverURL]];
}

@end
